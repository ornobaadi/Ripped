import 'package:drift/drift.dart' show DatabaseConnection, Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripped/core/catalog/catalog_repository.dart';
import 'package:ripped/core/db/app_database.dart';
import 'package:ripped/core/sync/sync_service.dart';
import 'package:ripped/domain/plan/plan_generator.dart';
import 'package:ripped/domain/plan/profile.dart';
import 'package:ripped/features/plan/data/program_repository.dart';
import 'package:ripped/features/workout/data/workout_repository.dart';

import '../helpers/catalog.dart';

/// In-memory stand-in for Supabase with the same rules as the SQL
/// migration: last write wins by updated_at, server-assigned synced_at.
class FakeServer implements SyncRemote {
  final _tables = <String, Map<String, Map<String, Object?>>>{};
  var _clock = 0;
  int upserts = 0;

  /// Simulates going offline.
  bool online = true;

  String _tick() =>
      DateTime.utc(2030)
          .add(Duration(milliseconds: ++_clock))
          .toIso8601String();

  @override
  Future<void> upsert(String table, List<Map<String, Object?>> rows) async {
    if (!online) throw Exception('offline');
    upserts++;
    final t = _tables.putIfAbsent(table, () => {});
    for (final row in rows) {
      final id = row['id']! as String;
      final existing = t[id];
      if (existing != null &&
          DateTime.parse(row['updated_at']! as String)
              .isBefore(DateTime.parse(existing['updated_at']! as String))) {
        continue;
      }
      t[id] = {...row, 'synced_at': _tick()};
    }
  }

  @override
  Future<List<Map<String, Object?>>> pull(
    String table, {
    required String? since,
    required int limit,
  }) async {
    if (!online) throw Exception('offline');
    final rows =
        (_tables[table]?.values ?? const <Map<String, Object?>>[])
            .where(
              (r) =>
                  since == null ||
                  (r['synced_at']! as String).compareTo(since) > 0,
            )
            .toList()
          ..sort(
            (a, b) => (a['synced_at']! as String).compareTo(
              b['synced_at']! as String,
            ),
          );
    return rows.take(limit).toList();
  }

  int count(String table) => _tables[table]?.length ?? 0;
}

class Phone {
  new(this.server)
    : db = AppDatabase(DatabaseConnection(NativeDatabase.memory())) {
    sync = SyncService(db, server);
    programs = ProgramRepository(db);
    workouts = WorkoutRepository(db, catalog);
  }

  static final catalog = CatalogRepository(realCatalog());
  final FakeServer server;
  final AppDatabase db;
  late final SyncService sync;
  late final ProgramRepository programs;
  late final WorkoutRepository workouts;

  Future<SyncReport> syncAs(String user) => sync.sync(userId: user);

  Future<void> onboard() async {
    const profile = TrainingProfile();
    await programs.saveProfile(profile, onboardingDone: true);
    await programs.saveProgram(PlanGenerator(catalog.all).generate(profile));
  }

  /// Logs every set of the first exercise at [kg] x [reps] and finishes.
  Future<String> train(double kg, int reps) async {
    final program = (await programs.activeProgram())!;
    final id = await workouts.startWorkout(program.days.first);
    final w = (await workouts.workout(id))!;
    for (final s in w.exercises.first.sets) {
      await workouts.editSet(s.id, weightKg: kg, reps: reps, log: true);
    }
    await workouts.finishWorkout(id, units: Units.kg);
    return id;
  }

  Future<int> completedWorkouts() async =>
      (await workouts.watchCompleted().first).length;

  Future<int> loggedSets() async {
    final rows = await db
        .customSelect(
          'SELECT COUNT(*) AS n FROM workout_sets '
          'WHERE completed_at IS NOT NULL AND deleted_at IS NULL',
        )
        .getSingle();
    return rows.read<int>('n');
  }

  Future<void> close() => db.close();
}

void main() {
  late FakeServer server;
  late Phone a;
  late Phone b;
  const user = 'user-1';

  setUp(() {
    server = FakeServer();
    a = Phone(server);
    b = Phone(server);
  });

  tearDown(() async {
    await a.close();
    await b.close();
  });

  test('first sign-in uploads everything made before it', () async {
    await a.onboard();
    await a.train(60, 10);
    final report = await a.syncAs(user);
    expect(report.outcome, SyncOutcome.ok);
    expect(report.pushed, greaterThan(10));
    expect(server.count('workouts'), 1);
    expect(server.count('profiles'), 1);
    expect(server.count('xp_events'), greaterThan(0));
  });

  test('a second phone restores the full history', () async {
    await a.onboard();
    await a.train(60, 10);
    await a.syncAs(user);

    await b.syncAs(user);
    expect(await b.completedWorkouts(), 1);
    expect(await b.loggedSets(), await a.loggedSets());
    expect(await b.programs.profile(), isNotNull);
    expect(
      await b.workouts.watchTotalXp().first,
      await a.workouts.watchTotalXp().first,
    );
  });

  test('offline edits on two phones converge with no lost sets', () async {
    await a.onboard();
    await a.syncAs(user);
    await b.syncAs(user);

    // Both train while offline.
    server.online = false;
    await a.train(60, 10);
    await b.train(50, 12);
    await b.train(52.5, 12);
    await expectLater(a.syncAs(user), throwsException);

    // Back online: everyone syncs twice (push, then pick up the others).
    server.online = true;
    for (var i = 0; i < 2; i++) {
      await a.syncAs(user);
      await b.syncAs(user);
    }

    expect(await a.completedWorkouts(), 3);
    expect(await b.completedWorkouts(), 3);
    expect(await a.loggedSets(), await b.loggedSets());
    expect(await a.loggedSets(), greaterThan(0));
  });

  test('pulled rows are not uploaded again', () async {
    await a.onboard();
    await a.train(60, 10);
    await a.syncAs(user);
    await b.syncAs(user);
    final outbox = await b.db.select(b.db.syncOutbox).get();
    expect(outbox, isEmpty);
  });

  test('last write wins per row', () async {
    await a.onboard();
    await a.syncAs(user);
    await b.syncAs(user);

    await a.programs.setUnits(Units.lb);
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await b.programs.setUnits(Units.kg); // later edit wins
    await a.syncAs(user);
    await b.syncAs(user);
    await a.syncAs(user);
    expect((await a.programs.profile())!.units, Units.kg);
    expect((await b.programs.profile())!.units, Units.kg);
  });

  test('deletes sync as soft deletes', () async {
    await a.onboard();
    final program = (await a.programs.activeProgram())!;
    final id = await a.workouts.startWorkout(program.days.first);
    final w = (await a.workouts.workout(id))!;
    final sets = w.exercises.first.sets.length;
    await a.workouts.removeSet(w.exercises.first.id);
    await a.syncAs(user);
    await b.syncAs(user);
    final onB = (await b.workouts.workout(id))!;
    expect(onB.exercises.first.sets, hasLength(sets - 1));
  });

  test('another account on this phone is refused, nothing is sent', () async {
    await a.onboard();
    await a.syncAs(user);
    final before = server.upserts;
    final report = await a.syncAs('someone-else');
    expect(report.outcome, SyncOutcome.otherAccount);
    expect(server.upserts, before);
  });

  test('progression state from two phones keeps the newest', () async {
    await a.onboard();
    await b.onboard();
    await a.train(60, 10);
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await b.train(70, 10);
    await a.syncAs(user);
    await b.syncAs(user);
    await a.syncAs(user);

    Future<double?> squat(Phone p) async =>
        (await (p.db.select(p.db.exerciseStates)
                  ..where((s) => s.exerciseId.equals('barbell_back_squat')))
                .getSingle())
            .currentWeightKg;
    expect(await squat(a), 70);
    expect(await squat(b), 70);
  });

  test('reset forgets the owner so a fresh account can sync', () async {
    await a.onboard();
    await a.syncAs(user);
    await a.sync.reset();
    final report = await a.syncAs('new-user');
    expect(report.outcome, SyncOutcome.ok);
  });

  test('rows written locally keep updated_at for conflict checks', () async {
    await a.onboard();
    await a.db
        .into(a.db.xpEvents)
        .insert(
          XpEventsCompanion.insert(
            source: 'set',
            amount: 10,
            occurredAt: DateTime.now(),
            sourceId: const Value(null),
          ),
        );
    await a.syncAs(user);
    expect(server.count('xp_events'), 1);
  });
}

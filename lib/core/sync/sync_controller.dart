import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripped/app/providers.dart';
import 'package:ripped/core/sync/sync_service.dart';

enum SyncStatus { idle, syncing, failed, otherAccount }

@immutable
class SyncState {
  const new({this.status = SyncStatus.idle, this.lastSyncedAt});

  final SyncStatus status;
  final DateTime? lastSyncedAt;

  SyncState copyWith({SyncStatus? status, DateTime? lastSyncedAt}) => SyncState(
    status: status ?? this.status,
    lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
  );
}

/// Null until the backend is ready, and when no backend is configured.
final syncRemoteProvider = Provider<SyncRemote?>(
  (ref) => ref.watch(backendProvider).value?.remote,
);

final syncServiceProvider = Provider<SyncService?>((ref) {
  final remote = ref.watch(syncRemoteProvider);
  return remote == null
      ? null
      : SyncService(ref.watch(databaseProvider), remote);
});

final syncControllerProvider = NotifierProvider<SyncController, SyncState>(
  SyncController.new,
);

/// Runs sync in the background: after sign-in, on app resume and after a
/// workout. Never blocks the UI; failures wait for the next trigger.
class SyncController extends Notifier<SyncState> {
  bool _again = false;

  @override
  SyncState build() {
    ref.listen(currentUserProvider, (previous, next) {
      final before = previous?.value?.id;
      final now = next.value?.id;
      if (now != null && now != before) unawaited(requestSync());
    });
    return const SyncState();
  }

  /// Safe to call often: concurrent requests collapse into one extra run.
  Future<void> requestSync() async {
    final service = ref.read(syncServiceProvider);
    final user = ref.read(authServiceProvider).currentUser;
    if (service == null || user == null) return;
    if (state.status == SyncStatus.syncing) {
      _again = true;
      return;
    }
    state = state.copyWith(status: SyncStatus.syncing);
    try {
      do {
        _again = false;
        final report = await service.sync(userId: user.id);
        if (report.outcome == SyncOutcome.otherAccount) {
          state = state.copyWith(status: SyncStatus.otherAccount);
          return;
        }
      } while (_again);
      state = SyncState(lastSyncedAt: DateTime.now());
    } on Object catch (e) {
      // Usually just offline. Never log row contents (CLAUDE.md rule 7).
      debugPrint('Sync failed: ${e.runtimeType}');
      state = state.copyWith(status: SyncStatus.failed);
    }
  }
}

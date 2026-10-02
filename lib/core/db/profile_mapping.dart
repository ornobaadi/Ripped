import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:ripped/core/db/app_database.dart';
import 'package:ripped/domain/catalog/exercise.dart';
import 'package:ripped/domain/plan/profile.dart';

/// Converts between the domain profile and its table row.
extension ProfileRowX on Profile {
  TrainingProfile toDomain() => TrainingProfile(
    goal: Goal.values.byName(goal),
    experience: Experience.values.byName(experience),
    equipment: {
      for (final e in jsonDecode(equipment) as List)
        Equipment.values.byName(e as String),
    },
    daysPerWeek: daysPerWeek,
    preferredDays: {
      for (final d in jsonDecode(preferredDays) as List) d as int,
    },
    sessionMinutes: sessionMinutes,
    avoid: {
      for (final j in jsonDecode(avoid) as List)
        Joint.values.byName(j as String),
    },
    units: Units.values.byName(units),
  );
}

extension TrainingProfileX on TrainingProfile {
  ProfilesCompanion toCompanion() => ProfilesCompanion(
    goal: Value(goal.name),
    experience: Value(experience.name),
    equipment: Value(jsonEncode([for (final e in equipment) e.name])),
    daysPerWeek: Value(daysPerWeek),
    preferredDays: Value(jsonEncode(preferredDays.toList()..sort())),
    sessionMinutes: Value(sessionMinutes),
    avoid: Value(jsonEncode([for (final j in avoid) j.name])),
    units: Value(units.name),
    updatedAt: Value(DateTime.now()),
  );
}

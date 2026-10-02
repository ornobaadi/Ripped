// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _goalMeta = const VerificationMeta('goal');
  @override
  late final GeneratedColumn<String> goal = GeneratedColumn<String>(
    'goal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _experienceMeta = const VerificationMeta(
    'experience',
  );
  @override
  late final GeneratedColumn<String> experience = GeneratedColumn<String>(
    'experience',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _equipmentMeta = const VerificationMeta(
    'equipment',
  );
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
    'equipment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _daysPerWeekMeta = const VerificationMeta(
    'daysPerWeek',
  );
  @override
  late final GeneratedColumn<int> daysPerWeek = GeneratedColumn<int>(
    'days_per_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _preferredDaysMeta = const VerificationMeta(
    'preferredDays',
  );
  @override
  late final GeneratedColumn<String> preferredDays = GeneratedColumn<String>(
    'preferred_days',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionMinutesMeta = const VerificationMeta(
    'sessionMinutes',
  );
  @override
  late final GeneratedColumn<int> sessionMinutes = GeneratedColumn<int>(
    'session_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avoidMeta = const VerificationMeta('avoid');
  @override
  late final GeneratedColumn<String> avoid = GeneratedColumn<String>(
    'avoid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitsMeta = const VerificationMeta('units');
  @override
  late final GeneratedColumn<String> units = GeneratedColumn<String>(
    'units',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _onboardingDoneAtMeta = const VerificationMeta(
    'onboardingDoneAt',
  );
  @override
  late final GeneratedColumn<DateTime> onboardingDoneAt =
      GeneratedColumn<DateTime>(
        'onboarding_done_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _disclaimerAcceptedAtMeta =
      const VerificationMeta('disclaimerAcceptedAt');
  @override
  late final GeneratedColumn<DateTime> disclaimerAcceptedAt =
      GeneratedColumn<DateTime>(
        'disclaimer_accepted_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
    goal,
    experience,
    equipment,
    daysPerWeek,
    preferredDays,
    sessionMinutes,
    avoid,
    units,
    onboardingDoneAt,
    disclaimerAcceptedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('goal')) {
      context.handle(
        _goalMeta,
        goal.isAcceptableOrUnknown(data['goal']!, _goalMeta),
      );
    } else if (isInserting) {
      context.missing(_goalMeta);
    }
    if (data.containsKey('experience')) {
      context.handle(
        _experienceMeta,
        experience.isAcceptableOrUnknown(data['experience']!, _experienceMeta),
      );
    } else if (isInserting) {
      context.missing(_experienceMeta);
    }
    if (data.containsKey('equipment')) {
      context.handle(
        _equipmentMeta,
        equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta),
      );
    } else if (isInserting) {
      context.missing(_equipmentMeta);
    }
    if (data.containsKey('days_per_week')) {
      context.handle(
        _daysPerWeekMeta,
        daysPerWeek.isAcceptableOrUnknown(
          data['days_per_week']!,
          _daysPerWeekMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_daysPerWeekMeta);
    }
    if (data.containsKey('preferred_days')) {
      context.handle(
        _preferredDaysMeta,
        preferredDays.isAcceptableOrUnknown(
          data['preferred_days']!,
          _preferredDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_preferredDaysMeta);
    }
    if (data.containsKey('session_minutes')) {
      context.handle(
        _sessionMinutesMeta,
        sessionMinutes.isAcceptableOrUnknown(
          data['session_minutes']!,
          _sessionMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionMinutesMeta);
    }
    if (data.containsKey('avoid')) {
      context.handle(
        _avoidMeta,
        avoid.isAcceptableOrUnknown(data['avoid']!, _avoidMeta),
      );
    } else if (isInserting) {
      context.missing(_avoidMeta);
    }
    if (data.containsKey('units')) {
      context.handle(
        _unitsMeta,
        units.isAcceptableOrUnknown(data['units']!, _unitsMeta),
      );
    } else if (isInserting) {
      context.missing(_unitsMeta);
    }
    if (data.containsKey('onboarding_done_at')) {
      context.handle(
        _onboardingDoneAtMeta,
        onboardingDoneAt.isAcceptableOrUnknown(
          data['onboarding_done_at']!,
          _onboardingDoneAtMeta,
        ),
      );
    }
    if (data.containsKey('disclaimer_accepted_at')) {
      context.handle(
        _disclaimerAcceptedAtMeta,
        disclaimerAcceptedAt.isAcceptableOrUnknown(
          data['disclaimer_accepted_at']!,
          _disclaimerAcceptedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      goal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal'],
      )!,
      experience: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}experience'],
      )!,
      equipment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment'],
      )!,
      daysPerWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}days_per_week'],
      )!,
      preferredDays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_days'],
      )!,
      sessionMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_minutes'],
      )!,
      avoid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avoid'],
      )!,
      units: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}units'],
      )!,
      onboardingDoneAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}onboarding_done_at'],
      ),
      disclaimerAcceptedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}disclaimer_accepted_at'],
      ),
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final String id;

  /// Null until the user signs in (Phase 3).
  final String? userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String goal;
  final String experience;

  /// JSON list of Equipment names.
  final String equipment;
  final int daysPerWeek;

  /// JSON list of ISO weekdays.
  final String preferredDays;
  final int sessionMinutes;

  /// JSON list of Joint names.
  final String avoid;
  final String units;
  final DateTime? onboardingDoneAt;
  final DateTime? disclaimerAcceptedAt;
  const Profile({
    required this.id,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.goal,
    required this.experience,
    required this.equipment,
    required this.daysPerWeek,
    required this.preferredDays,
    required this.sessionMinutes,
    required this.avoid,
    required this.units,
    this.onboardingDoneAt,
    this.disclaimerAcceptedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['goal'] = Variable<String>(goal);
    map['experience'] = Variable<String>(experience);
    map['equipment'] = Variable<String>(equipment);
    map['days_per_week'] = Variable<int>(daysPerWeek);
    map['preferred_days'] = Variable<String>(preferredDays);
    map['session_minutes'] = Variable<int>(sessionMinutes);
    map['avoid'] = Variable<String>(avoid);
    map['units'] = Variable<String>(units);
    if (!nullToAbsent || onboardingDoneAt != null) {
      map['onboarding_done_at'] = Variable<DateTime>(onboardingDoneAt);
    }
    if (!nullToAbsent || disclaimerAcceptedAt != null) {
      map['disclaimer_accepted_at'] = Variable<DateTime>(disclaimerAcceptedAt);
    }
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      goal: Value(goal),
      experience: Value(experience),
      equipment: Value(equipment),
      daysPerWeek: Value(daysPerWeek),
      preferredDays: Value(preferredDays),
      sessionMinutes: Value(sessionMinutes),
      avoid: Value(avoid),
      units: Value(units),
      onboardingDoneAt: onboardingDoneAt == null && nullToAbsent
          ? const Value.absent()
          : Value(onboardingDoneAt),
      disclaimerAcceptedAt: disclaimerAcceptedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(disclaimerAcceptedAt),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      goal: serializer.fromJson<String>(json['goal']),
      experience: serializer.fromJson<String>(json['experience']),
      equipment: serializer.fromJson<String>(json['equipment']),
      daysPerWeek: serializer.fromJson<int>(json['daysPerWeek']),
      preferredDays: serializer.fromJson<String>(json['preferredDays']),
      sessionMinutes: serializer.fromJson<int>(json['sessionMinutes']),
      avoid: serializer.fromJson<String>(json['avoid']),
      units: serializer.fromJson<String>(json['units']),
      onboardingDoneAt: serializer.fromJson<DateTime?>(
        json['onboardingDoneAt'],
      ),
      disclaimerAcceptedAt: serializer.fromJson<DateTime?>(
        json['disclaimerAcceptedAt'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'goal': serializer.toJson<String>(goal),
      'experience': serializer.toJson<String>(experience),
      'equipment': serializer.toJson<String>(equipment),
      'daysPerWeek': serializer.toJson<int>(daysPerWeek),
      'preferredDays': serializer.toJson<String>(preferredDays),
      'sessionMinutes': serializer.toJson<int>(sessionMinutes),
      'avoid': serializer.toJson<String>(avoid),
      'units': serializer.toJson<String>(units),
      'onboardingDoneAt': serializer.toJson<DateTime?>(onboardingDoneAt),
      'disclaimerAcceptedAt': serializer.toJson<DateTime?>(
        disclaimerAcceptedAt,
      ),
    };
  }

  Profile copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? goal,
    String? experience,
    String? equipment,
    int? daysPerWeek,
    String? preferredDays,
    int? sessionMinutes,
    String? avoid,
    String? units,
    Value<DateTime?> onboardingDoneAt = const Value.absent(),
    Value<DateTime?> disclaimerAcceptedAt = const Value.absent(),
  }) => Profile(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    goal: goal ?? this.goal,
    experience: experience ?? this.experience,
    equipment: equipment ?? this.equipment,
    daysPerWeek: daysPerWeek ?? this.daysPerWeek,
    preferredDays: preferredDays ?? this.preferredDays,
    sessionMinutes: sessionMinutes ?? this.sessionMinutes,
    avoid: avoid ?? this.avoid,
    units: units ?? this.units,
    onboardingDoneAt: onboardingDoneAt.present
        ? onboardingDoneAt.value
        : this.onboardingDoneAt,
    disclaimerAcceptedAt: disclaimerAcceptedAt.present
        ? disclaimerAcceptedAt.value
        : this.disclaimerAcceptedAt,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      goal: data.goal.present ? data.goal.value : this.goal,
      experience: data.experience.present
          ? data.experience.value
          : this.experience,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      daysPerWeek: data.daysPerWeek.present
          ? data.daysPerWeek.value
          : this.daysPerWeek,
      preferredDays: data.preferredDays.present
          ? data.preferredDays.value
          : this.preferredDays,
      sessionMinutes: data.sessionMinutes.present
          ? data.sessionMinutes.value
          : this.sessionMinutes,
      avoid: data.avoid.present ? data.avoid.value : this.avoid,
      units: data.units.present ? data.units.value : this.units,
      onboardingDoneAt: data.onboardingDoneAt.present
          ? data.onboardingDoneAt.value
          : this.onboardingDoneAt,
      disclaimerAcceptedAt: data.disclaimerAcceptedAt.present
          ? data.disclaimerAcceptedAt.value
          : this.disclaimerAcceptedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('goal: $goal, ')
          ..write('experience: $experience, ')
          ..write('equipment: $equipment, ')
          ..write('daysPerWeek: $daysPerWeek, ')
          ..write('preferredDays: $preferredDays, ')
          ..write('sessionMinutes: $sessionMinutes, ')
          ..write('avoid: $avoid, ')
          ..write('units: $units, ')
          ..write('onboardingDoneAt: $onboardingDoneAt, ')
          ..write('disclaimerAcceptedAt: $disclaimerAcceptedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
    goal,
    experience,
    equipment,
    daysPerWeek,
    preferredDays,
    sessionMinutes,
    avoid,
    units,
    onboardingDoneAt,
    disclaimerAcceptedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.goal == this.goal &&
          other.experience == this.experience &&
          other.equipment == this.equipment &&
          other.daysPerWeek == this.daysPerWeek &&
          other.preferredDays == this.preferredDays &&
          other.sessionMinutes == this.sessionMinutes &&
          other.avoid == this.avoid &&
          other.units == this.units &&
          other.onboardingDoneAt == this.onboardingDoneAt &&
          other.disclaimerAcceptedAt == this.disclaimerAcceptedAt);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> goal;
  final Value<String> experience;
  final Value<String> equipment;
  final Value<int> daysPerWeek;
  final Value<String> preferredDays;
  final Value<int> sessionMinutes;
  final Value<String> avoid;
  final Value<String> units;
  final Value<DateTime?> onboardingDoneAt;
  final Value<DateTime?> disclaimerAcceptedAt;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.goal = const Value.absent(),
    this.experience = const Value.absent(),
    this.equipment = const Value.absent(),
    this.daysPerWeek = const Value.absent(),
    this.preferredDays = const Value.absent(),
    this.sessionMinutes = const Value.absent(),
    this.avoid = const Value.absent(),
    this.units = const Value.absent(),
    this.onboardingDoneAt = const Value.absent(),
    this.disclaimerAcceptedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String goal,
    required String experience,
    required String equipment,
    required int daysPerWeek,
    required String preferredDays,
    required int sessionMinutes,
    required String avoid,
    required String units,
    this.onboardingDoneAt = const Value.absent(),
    this.disclaimerAcceptedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : goal = Value(goal),
       experience = Value(experience),
       equipment = Value(equipment),
       daysPerWeek = Value(daysPerWeek),
       preferredDays = Value(preferredDays),
       sessionMinutes = Value(sessionMinutes),
       avoid = Value(avoid),
       units = Value(units);
  static Insertable<Profile> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? goal,
    Expression<String>? experience,
    Expression<String>? equipment,
    Expression<int>? daysPerWeek,
    Expression<String>? preferredDays,
    Expression<int>? sessionMinutes,
    Expression<String>? avoid,
    Expression<String>? units,
    Expression<DateTime>? onboardingDoneAt,
    Expression<DateTime>? disclaimerAcceptedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (goal != null) 'goal': goal,
      if (experience != null) 'experience': experience,
      if (equipment != null) 'equipment': equipment,
      if (daysPerWeek != null) 'days_per_week': daysPerWeek,
      if (preferredDays != null) 'preferred_days': preferredDays,
      if (sessionMinutes != null) 'session_minutes': sessionMinutes,
      if (avoid != null) 'avoid': avoid,
      if (units != null) 'units': units,
      if (onboardingDoneAt != null) 'onboarding_done_at': onboardingDoneAt,
      if (disclaimerAcceptedAt != null)
        'disclaimer_accepted_at': disclaimerAcceptedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? goal,
    Value<String>? experience,
    Value<String>? equipment,
    Value<int>? daysPerWeek,
    Value<String>? preferredDays,
    Value<int>? sessionMinutes,
    Value<String>? avoid,
    Value<String>? units,
    Value<DateTime?>? onboardingDoneAt,
    Value<DateTime?>? disclaimerAcceptedAt,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      goal: goal ?? this.goal,
      experience: experience ?? this.experience,
      equipment: equipment ?? this.equipment,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      preferredDays: preferredDays ?? this.preferredDays,
      sessionMinutes: sessionMinutes ?? this.sessionMinutes,
      avoid: avoid ?? this.avoid,
      units: units ?? this.units,
      onboardingDoneAt: onboardingDoneAt ?? this.onboardingDoneAt,
      disclaimerAcceptedAt: disclaimerAcceptedAt ?? this.disclaimerAcceptedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (goal.present) {
      map['goal'] = Variable<String>(goal.value);
    }
    if (experience.present) {
      map['experience'] = Variable<String>(experience.value);
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    if (daysPerWeek.present) {
      map['days_per_week'] = Variable<int>(daysPerWeek.value);
    }
    if (preferredDays.present) {
      map['preferred_days'] = Variable<String>(preferredDays.value);
    }
    if (sessionMinutes.present) {
      map['session_minutes'] = Variable<int>(sessionMinutes.value);
    }
    if (avoid.present) {
      map['avoid'] = Variable<String>(avoid.value);
    }
    if (units.present) {
      map['units'] = Variable<String>(units.value);
    }
    if (onboardingDoneAt.present) {
      map['onboarding_done_at'] = Variable<DateTime>(onboardingDoneAt.value);
    }
    if (disclaimerAcceptedAt.present) {
      map['disclaimer_accepted_at'] = Variable<DateTime>(
        disclaimerAcceptedAt.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('goal: $goal, ')
          ..write('experience: $experience, ')
          ..write('equipment: $equipment, ')
          ..write('daysPerWeek: $daysPerWeek, ')
          ..write('preferredDays: $preferredDays, ')
          ..write('sessionMinutes: $sessionMinutes, ')
          ..write('avoid: $avoid, ')
          ..write('units: $units, ')
          ..write('onboardingDoneAt: $onboardingDoneAt, ')
          ..write('disclaimerAcceptedAt: $disclaimerAcceptedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgramsTable extends Programs with TableInfo<$ProgramsTable, Program> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgramsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _splitTypeMeta = const VerificationMeta(
    'splitType',
  );
  @override
  late final GeneratedColumn<String> splitType = GeneratedColumn<String>(
    'split_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _generatedByVersionMeta =
      const VerificationMeta('generatedByVersion');
  @override
  late final GeneratedColumn<int> generatedByVersion = GeneratedColumn<int>(
    'generated_by_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
    name,
    splitType,
    generatedByVersion,
    active,
    startedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'programs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Program> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('split_type')) {
      context.handle(
        _splitTypeMeta,
        splitType.isAcceptableOrUnknown(data['split_type']!, _splitTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_splitTypeMeta);
    }
    if (data.containsKey('generated_by_version')) {
      context.handle(
        _generatedByVersionMeta,
        generatedByVersion.isAcceptableOrUnknown(
          data['generated_by_version']!,
          _generatedByVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_generatedByVersionMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Program map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Program(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      splitType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}split_type'],
      )!,
      generatedByVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}generated_by_version'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
    );
  }

  @override
  $ProgramsTable createAlias(String alias) {
    return $ProgramsTable(attachedDatabase, alias);
  }
}

class Program extends DataClass implements Insertable<Program> {
  final String id;

  /// Null until the user signs in (Phase 3).
  final String? userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;
  final String splitType;
  final int generatedByVersion;
  final bool active;
  final DateTime startedAt;
  const Program({
    required this.id,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    required this.splitType,
    required this.generatedByVersion,
    required this.active,
    required this.startedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    map['split_type'] = Variable<String>(splitType);
    map['generated_by_version'] = Variable<int>(generatedByVersion);
    map['active'] = Variable<bool>(active);
    map['started_at'] = Variable<DateTime>(startedAt);
    return map;
  }

  ProgramsCompanion toCompanion(bool nullToAbsent) {
    return ProgramsCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      name: Value(name),
      splitType: Value(splitType),
      generatedByVersion: Value(generatedByVersion),
      active: Value(active),
      startedAt: Value(startedAt),
    );
  }

  factory Program.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Program(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      splitType: serializer.fromJson<String>(json['splitType']),
      generatedByVersion: serializer.fromJson<int>(json['generatedByVersion']),
      active: serializer.fromJson<bool>(json['active']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
      'splitType': serializer.toJson<String>(splitType),
      'generatedByVersion': serializer.toJson<int>(generatedByVersion),
      'active': serializer.toJson<bool>(active),
      'startedAt': serializer.toJson<DateTime>(startedAt),
    };
  }

  Program copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    String? splitType,
    int? generatedByVersion,
    bool? active,
    DateTime? startedAt,
  }) => Program(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    splitType: splitType ?? this.splitType,
    generatedByVersion: generatedByVersion ?? this.generatedByVersion,
    active: active ?? this.active,
    startedAt: startedAt ?? this.startedAt,
  );
  Program copyWithCompanion(ProgramsCompanion data) {
    return Program(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      splitType: data.splitType.present ? data.splitType.value : this.splitType,
      generatedByVersion: data.generatedByVersion.present
          ? data.generatedByVersion.value
          : this.generatedByVersion,
      active: data.active.present ? data.active.value : this.active,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Program(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('splitType: $splitType, ')
          ..write('generatedByVersion: $generatedByVersion, ')
          ..write('active: $active, ')
          ..write('startedAt: $startedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
    name,
    splitType,
    generatedByVersion,
    active,
    startedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Program &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.splitType == this.splitType &&
          other.generatedByVersion == this.generatedByVersion &&
          other.active == this.active &&
          other.startedAt == this.startedAt);
}

class ProgramsCompanion extends UpdateCompanion<Program> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<String> splitType;
  final Value<int> generatedByVersion;
  final Value<bool> active;
  final Value<DateTime> startedAt;
  final Value<int> rowid;
  const ProgramsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.splitType = const Value.absent(),
    this.generatedByVersion = const Value.absent(),
    this.active = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgramsCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String name,
    required String splitType,
    required int generatedByVersion,
    this.active = const Value.absent(),
    required DateTime startedAt,
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       splitType = Value(splitType),
       generatedByVersion = Value(generatedByVersion),
       startedAt = Value(startedAt);
  static Insertable<Program> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<String>? splitType,
    Expression<int>? generatedByVersion,
    Expression<bool>? active,
    Expression<DateTime>? startedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (splitType != null) 'split_type': splitType,
      if (generatedByVersion != null)
        'generated_by_version': generatedByVersion,
      if (active != null) 'active': active,
      if (startedAt != null) 'started_at': startedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgramsCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<String>? splitType,
    Value<int>? generatedByVersion,
    Value<bool>? active,
    Value<DateTime>? startedAt,
    Value<int>? rowid,
  }) {
    return ProgramsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      splitType: splitType ?? this.splitType,
      generatedByVersion: generatedByVersion ?? this.generatedByVersion,
      active: active ?? this.active,
      startedAt: startedAt ?? this.startedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (splitType.present) {
      map['split_type'] = Variable<String>(splitType.value);
    }
    if (generatedByVersion.present) {
      map['generated_by_version'] = Variable<int>(generatedByVersion.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgramsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('splitType: $splitType, ')
          ..write('generatedByVersion: $generatedByVersion, ')
          ..write('active: $active, ')
          ..write('startedAt: $startedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgramDaysTable extends ProgramDays
    with TableInfo<$ProgramDaysTable, ProgramDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgramDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _programIdMeta = const VerificationMeta(
    'programId',
  );
  @override
  late final GeneratedColumn<String> programId = GeneratedColumn<String>(
    'program_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES programs (id)',
    ),
  );
  static const VerificationMeta _dayIndexMeta = const VerificationMeta(
    'dayIndex',
  );
  @override
  late final GeneratedColumn<int> dayIndex = GeneratedColumn<int>(
    'day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
    programId,
    dayIndex,
    name,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'program_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProgramDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('program_id')) {
      context.handle(
        _programIdMeta,
        programId.isAcceptableOrUnknown(data['program_id']!, _programIdMeta),
      );
    } else if (isInserting) {
      context.missing(_programIdMeta);
    }
    if (data.containsKey('day_index')) {
      context.handle(
        _dayIndexMeta,
        dayIndex.isAcceptableOrUnknown(data['day_index']!, _dayIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_dayIndexMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgramDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgramDay(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      programId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}program_id'],
      )!,
      dayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_index'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $ProgramDaysTable createAlias(String alias) {
    return $ProgramDaysTable(attachedDatabase, alias);
  }
}

class ProgramDay extends DataClass implements Insertable<ProgramDay> {
  final String id;

  /// Null until the user signs in (Phase 3).
  final String? userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String programId;
  final int dayIndex;
  final String name;
  const ProgramDay({
    required this.id,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.programId,
    required this.dayIndex,
    required this.name,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['program_id'] = Variable<String>(programId);
    map['day_index'] = Variable<int>(dayIndex);
    map['name'] = Variable<String>(name);
    return map;
  }

  ProgramDaysCompanion toCompanion(bool nullToAbsent) {
    return ProgramDaysCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      programId: Value(programId),
      dayIndex: Value(dayIndex),
      name: Value(name),
    );
  }

  factory ProgramDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgramDay(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      programId: serializer.fromJson<String>(json['programId']),
      dayIndex: serializer.fromJson<int>(json['dayIndex']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'programId': serializer.toJson<String>(programId),
      'dayIndex': serializer.toJson<int>(dayIndex),
      'name': serializer.toJson<String>(name),
    };
  }

  ProgramDay copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? programId,
    int? dayIndex,
    String? name,
  }) => ProgramDay(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    programId: programId ?? this.programId,
    dayIndex: dayIndex ?? this.dayIndex,
    name: name ?? this.name,
  );
  ProgramDay copyWithCompanion(ProgramDaysCompanion data) {
    return ProgramDay(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      programId: data.programId.present ? data.programId.value : this.programId,
      dayIndex: data.dayIndex.present ? data.dayIndex.value : this.dayIndex,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgramDay(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('programId: $programId, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
    programId,
    dayIndex,
    name,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgramDay &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.programId == this.programId &&
          other.dayIndex == this.dayIndex &&
          other.name == this.name);
}

class ProgramDaysCompanion extends UpdateCompanion<ProgramDay> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> programId;
  final Value<int> dayIndex;
  final Value<String> name;
  final Value<int> rowid;
  const ProgramDaysCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.programId = const Value.absent(),
    this.dayIndex = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgramDaysCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String programId,
    required int dayIndex,
    required String name,
    this.rowid = const Value.absent(),
  }) : programId = Value(programId),
       dayIndex = Value(dayIndex),
       name = Value(name);
  static Insertable<ProgramDay> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? programId,
    Expression<int>? dayIndex,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (programId != null) 'program_id': programId,
      if (dayIndex != null) 'day_index': dayIndex,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgramDaysCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? programId,
    Value<int>? dayIndex,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return ProgramDaysCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      programId: programId ?? this.programId,
      dayIndex: dayIndex ?? this.dayIndex,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (programId.present) {
      map['program_id'] = Variable<String>(programId.value);
    }
    if (dayIndex.present) {
      map['day_index'] = Variable<int>(dayIndex.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgramDaysCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('programId: $programId, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgramExercisesTable extends ProgramExercises
    with TableInfo<$ProgramExercisesTable, ProgramExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgramExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _programDayIdMeta = const VerificationMeta(
    'programDayId',
  );
  @override
  late final GeneratedColumn<String> programDayId = GeneratedColumn<String>(
    'program_day_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES program_days (id)',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setsMeta = const VerificationMeta('sets');
  @override
  late final GeneratedColumn<int> sets = GeneratedColumn<int>(
    'sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repMinMeta = const VerificationMeta('repMin');
  @override
  late final GeneratedColumn<int> repMin = GeneratedColumn<int>(
    'rep_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repMaxMeta = const VerificationMeta('repMax');
  @override
  late final GeneratedColumn<int> repMax = GeneratedColumn<int>(
    'rep_max',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _restSecondsMeta = const VerificationMeta(
    'restSeconds',
  );
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
    'rest_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
    programDayId,
    exerciseId,
    sortOrder,
    sets,
    repMin,
    repMax,
    restSeconds,
    reason,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'program_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProgramExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('program_day_id')) {
      context.handle(
        _programDayIdMeta,
        programDayId.isAcceptableOrUnknown(
          data['program_day_id']!,
          _programDayIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_programDayIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('sets')) {
      context.handle(
        _setsMeta,
        sets.isAcceptableOrUnknown(data['sets']!, _setsMeta),
      );
    } else if (isInserting) {
      context.missing(_setsMeta);
    }
    if (data.containsKey('rep_min')) {
      context.handle(
        _repMinMeta,
        repMin.isAcceptableOrUnknown(data['rep_min']!, _repMinMeta),
      );
    } else if (isInserting) {
      context.missing(_repMinMeta);
    }
    if (data.containsKey('rep_max')) {
      context.handle(
        _repMaxMeta,
        repMax.isAcceptableOrUnknown(data['rep_max']!, _repMaxMeta),
      );
    } else if (isInserting) {
      context.missing(_repMaxMeta);
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
        _restSecondsMeta,
        restSeconds.isAcceptableOrUnknown(
          data['rest_seconds']!,
          _restSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_restSecondsMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgramExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgramExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      programDayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}program_day_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      sets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sets'],
      )!,
      repMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rep_min'],
      )!,
      repMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rep_max'],
      )!,
      restSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_seconds'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
    );
  }

  @override
  $ProgramExercisesTable createAlias(String alias) {
    return $ProgramExercisesTable(attachedDatabase, alias);
  }
}

class ProgramExercise extends DataClass implements Insertable<ProgramExercise> {
  final String id;

  /// Null until the user signs in (Phase 3).
  final String? userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String programDayId;

  /// Catalog exercise id (stable across catalog versions).
  final String exerciseId;
  final int sortOrder;
  final int sets;
  final int repMin;
  final int repMax;
  final int restSeconds;
  final String reason;
  const ProgramExercise({
    required this.id,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.programDayId,
    required this.exerciseId,
    required this.sortOrder,
    required this.sets,
    required this.repMin,
    required this.repMax,
    required this.restSeconds,
    required this.reason,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['program_day_id'] = Variable<String>(programDayId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['sort_order'] = Variable<int>(sortOrder);
    map['sets'] = Variable<int>(sets);
    map['rep_min'] = Variable<int>(repMin);
    map['rep_max'] = Variable<int>(repMax);
    map['rest_seconds'] = Variable<int>(restSeconds);
    map['reason'] = Variable<String>(reason);
    return map;
  }

  ProgramExercisesCompanion toCompanion(bool nullToAbsent) {
    return ProgramExercisesCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      programDayId: Value(programDayId),
      exerciseId: Value(exerciseId),
      sortOrder: Value(sortOrder),
      sets: Value(sets),
      repMin: Value(repMin),
      repMax: Value(repMax),
      restSeconds: Value(restSeconds),
      reason: Value(reason),
    );
  }

  factory ProgramExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgramExercise(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      programDayId: serializer.fromJson<String>(json['programDayId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      sets: serializer.fromJson<int>(json['sets']),
      repMin: serializer.fromJson<int>(json['repMin']),
      repMax: serializer.fromJson<int>(json['repMax']),
      restSeconds: serializer.fromJson<int>(json['restSeconds']),
      reason: serializer.fromJson<String>(json['reason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'programDayId': serializer.toJson<String>(programDayId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'sets': serializer.toJson<int>(sets),
      'repMin': serializer.toJson<int>(repMin),
      'repMax': serializer.toJson<int>(repMax),
      'restSeconds': serializer.toJson<int>(restSeconds),
      'reason': serializer.toJson<String>(reason),
    };
  }

  ProgramExercise copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? programDayId,
    String? exerciseId,
    int? sortOrder,
    int? sets,
    int? repMin,
    int? repMax,
    int? restSeconds,
    String? reason,
  }) => ProgramExercise(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    programDayId: programDayId ?? this.programDayId,
    exerciseId: exerciseId ?? this.exerciseId,
    sortOrder: sortOrder ?? this.sortOrder,
    sets: sets ?? this.sets,
    repMin: repMin ?? this.repMin,
    repMax: repMax ?? this.repMax,
    restSeconds: restSeconds ?? this.restSeconds,
    reason: reason ?? this.reason,
  );
  ProgramExercise copyWithCompanion(ProgramExercisesCompanion data) {
    return ProgramExercise(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      programDayId: data.programDayId.present
          ? data.programDayId.value
          : this.programDayId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      sets: data.sets.present ? data.sets.value : this.sets,
      repMin: data.repMin.present ? data.repMin.value : this.repMin,
      repMax: data.repMax.present ? data.repMax.value : this.repMax,
      restSeconds: data.restSeconds.present
          ? data.restSeconds.value
          : this.restSeconds,
      reason: data.reason.present ? data.reason.value : this.reason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgramExercise(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('programDayId: $programDayId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('sets: $sets, ')
          ..write('repMin: $repMin, ')
          ..write('repMax: $repMax, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('reason: $reason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
    programDayId,
    exerciseId,
    sortOrder,
    sets,
    repMin,
    repMax,
    restSeconds,
    reason,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgramExercise &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.programDayId == this.programDayId &&
          other.exerciseId == this.exerciseId &&
          other.sortOrder == this.sortOrder &&
          other.sets == this.sets &&
          other.repMin == this.repMin &&
          other.repMax == this.repMax &&
          other.restSeconds == this.restSeconds &&
          other.reason == this.reason);
}

class ProgramExercisesCompanion extends UpdateCompanion<ProgramExercise> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> programDayId;
  final Value<String> exerciseId;
  final Value<int> sortOrder;
  final Value<int> sets;
  final Value<int> repMin;
  final Value<int> repMax;
  final Value<int> restSeconds;
  final Value<String> reason;
  final Value<int> rowid;
  const ProgramExercisesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.programDayId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.sets = const Value.absent(),
    this.repMin = const Value.absent(),
    this.repMax = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.reason = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgramExercisesCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String programDayId,
    required String exerciseId,
    required int sortOrder,
    required int sets,
    required int repMin,
    required int repMax,
    required int restSeconds,
    required String reason,
    this.rowid = const Value.absent(),
  }) : programDayId = Value(programDayId),
       exerciseId = Value(exerciseId),
       sortOrder = Value(sortOrder),
       sets = Value(sets),
       repMin = Value(repMin),
       repMax = Value(repMax),
       restSeconds = Value(restSeconds),
       reason = Value(reason);
  static Insertable<ProgramExercise> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? programDayId,
    Expression<String>? exerciseId,
    Expression<int>? sortOrder,
    Expression<int>? sets,
    Expression<int>? repMin,
    Expression<int>? repMax,
    Expression<int>? restSeconds,
    Expression<String>? reason,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (programDayId != null) 'program_day_id': programDayId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (sets != null) 'sets': sets,
      if (repMin != null) 'rep_min': repMin,
      if (repMax != null) 'rep_max': repMax,
      if (restSeconds != null) 'rest_seconds': restSeconds,
      if (reason != null) 'reason': reason,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgramExercisesCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? programDayId,
    Value<String>? exerciseId,
    Value<int>? sortOrder,
    Value<int>? sets,
    Value<int>? repMin,
    Value<int>? repMax,
    Value<int>? restSeconds,
    Value<String>? reason,
    Value<int>? rowid,
  }) {
    return ProgramExercisesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      programDayId: programDayId ?? this.programDayId,
      exerciseId: exerciseId ?? this.exerciseId,
      sortOrder: sortOrder ?? this.sortOrder,
      sets: sets ?? this.sets,
      repMin: repMin ?? this.repMin,
      repMax: repMax ?? this.repMax,
      restSeconds: restSeconds ?? this.restSeconds,
      reason: reason ?? this.reason,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (programDayId.present) {
      map['program_day_id'] = Variable<String>(programDayId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (sets.present) {
      map['sets'] = Variable<int>(sets.value);
    }
    if (repMin.present) {
      map['rep_min'] = Variable<int>(repMin.value);
    }
    if (repMax.present) {
      map['rep_max'] = Variable<int>(repMax.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgramExercisesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('programDayId: $programDayId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('sets: $sets, ')
          ..write('repMin: $repMin, ')
          ..write('repMax: $repMax, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('reason: $reason, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutsTable extends Workouts with TableInfo<$WorkoutsTable, Workout> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _programDayIdMeta = const VerificationMeta(
    'programDayId',
  );
  @override
  late final GeneratedColumn<String> programDayId = GeneratedColumn<String>(
    'program_day_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES program_days (id)',
    ),
  );
  static const VerificationMeta _dayIndexMeta = const VerificationMeta(
    'dayIndex',
  );
  @override
  late final GeneratedColumn<int> dayIndex = GeneratedColumn<int>(
    'day_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSMeta = const VerificationMeta(
    'durationS',
  );
  @override
  late final GeneratedColumn<int> durationS = GeneratedColumn<int>(
    'duration_s',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _feelingMeta = const VerificationMeta(
    'feeling',
  );
  @override
  late final GeneratedColumn<String> feeling = GeneratedColumn<String>(
    'feeling',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WorkoutStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<WorkoutStatus>($WorkoutsTable.$converterstatus);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
    programDayId,
    dayIndex,
    name,
    startedAt,
    finishedAt,
    durationS,
    feeling,
    notes,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workouts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Workout> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('program_day_id')) {
      context.handle(
        _programDayIdMeta,
        programDayId.isAcceptableOrUnknown(
          data['program_day_id']!,
          _programDayIdMeta,
        ),
      );
    }
    if (data.containsKey('day_index')) {
      context.handle(
        _dayIndexMeta,
        dayIndex.isAcceptableOrUnknown(data['day_index']!, _dayIndexMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    }
    if (data.containsKey('duration_s')) {
      context.handle(
        _durationSMeta,
        durationS.isAcceptableOrUnknown(data['duration_s']!, _durationSMeta),
      );
    }
    if (data.containsKey('feeling')) {
      context.handle(
        _feelingMeta,
        feeling.isAcceptableOrUnknown(data['feeling']!, _feelingMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Workout map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Workout(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      programDayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}program_day_id'],
      ),
      dayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_index'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      ),
      durationS: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_s'],
      ),
      feeling: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feeling'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      status: $WorkoutsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
    );
  }

  @override
  $WorkoutsTable createAlias(String alias) {
    return $WorkoutsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WorkoutStatus, String, String> $converterstatus =
      const EnumNameConverter<WorkoutStatus>(WorkoutStatus.values);
}

class Workout extends DataClass implements Insertable<Workout> {
  final String id;

  /// Null until the user signs in (Phase 3).
  final String? userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? programDayId;

  /// Program day index at the time, for the rotation.
  final int? dayIndex;
  final String name;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final int? durationS;
  final String? feeling;
  final String? notes;
  final WorkoutStatus status;
  const Workout({
    required this.id,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.programDayId,
    this.dayIndex,
    required this.name,
    required this.startedAt,
    this.finishedAt,
    this.durationS,
    this.feeling,
    this.notes,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || programDayId != null) {
      map['program_day_id'] = Variable<String>(programDayId);
    }
    if (!nullToAbsent || dayIndex != null) {
      map['day_index'] = Variable<int>(dayIndex);
    }
    map['name'] = Variable<String>(name);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    if (!nullToAbsent || durationS != null) {
      map['duration_s'] = Variable<int>(durationS);
    }
    if (!nullToAbsent || feeling != null) {
      map['feeling'] = Variable<String>(feeling);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    {
      map['status'] = Variable<String>(
        $WorkoutsTable.$converterstatus.toSql(status),
      );
    }
    return map;
  }

  WorkoutsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutsCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      programDayId: programDayId == null && nullToAbsent
          ? const Value.absent()
          : Value(programDayId),
      dayIndex: dayIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(dayIndex),
      name: Value(name),
      startedAt: Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
      durationS: durationS == null && nullToAbsent
          ? const Value.absent()
          : Value(durationS),
      feeling: feeling == null && nullToAbsent
          ? const Value.absent()
          : Value(feeling),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      status: Value(status),
    );
  }

  factory Workout.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Workout(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      programDayId: serializer.fromJson<String?>(json['programDayId']),
      dayIndex: serializer.fromJson<int?>(json['dayIndex']),
      name: serializer.fromJson<String>(json['name']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
      durationS: serializer.fromJson<int?>(json['durationS']),
      feeling: serializer.fromJson<String?>(json['feeling']),
      notes: serializer.fromJson<String?>(json['notes']),
      status: $WorkoutsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'programDayId': serializer.toJson<String?>(programDayId),
      'dayIndex': serializer.toJson<int?>(dayIndex),
      'name': serializer.toJson<String>(name),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
      'durationS': serializer.toJson<int?>(durationS),
      'feeling': serializer.toJson<String?>(feeling),
      'notes': serializer.toJson<String?>(notes),
      'status': serializer.toJson<String>(
        $WorkoutsTable.$converterstatus.toJson(status),
      ),
    };
  }

  Workout copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> programDayId = const Value.absent(),
    Value<int?> dayIndex = const Value.absent(),
    String? name,
    DateTime? startedAt,
    Value<DateTime?> finishedAt = const Value.absent(),
    Value<int?> durationS = const Value.absent(),
    Value<String?> feeling = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    WorkoutStatus? status,
  }) => Workout(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    programDayId: programDayId.present ? programDayId.value : this.programDayId,
    dayIndex: dayIndex.present ? dayIndex.value : this.dayIndex,
    name: name ?? this.name,
    startedAt: startedAt ?? this.startedAt,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
    durationS: durationS.present ? durationS.value : this.durationS,
    feeling: feeling.present ? feeling.value : this.feeling,
    notes: notes.present ? notes.value : this.notes,
    status: status ?? this.status,
  );
  Workout copyWithCompanion(WorkoutsCompanion data) {
    return Workout(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      programDayId: data.programDayId.present
          ? data.programDayId.value
          : this.programDayId,
      dayIndex: data.dayIndex.present ? data.dayIndex.value : this.dayIndex,
      name: data.name.present ? data.name.value : this.name,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
      durationS: data.durationS.present ? data.durationS.value : this.durationS,
      feeling: data.feeling.present ? data.feeling.value : this.feeling,
      notes: data.notes.present ? data.notes.value : this.notes,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Workout(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('programDayId: $programDayId, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('name: $name, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('durationS: $durationS, ')
          ..write('feeling: $feeling, ')
          ..write('notes: $notes, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
    programDayId,
    dayIndex,
    name,
    startedAt,
    finishedAt,
    durationS,
    feeling,
    notes,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Workout &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.programDayId == this.programDayId &&
          other.dayIndex == this.dayIndex &&
          other.name == this.name &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.durationS == this.durationS &&
          other.feeling == this.feeling &&
          other.notes == this.notes &&
          other.status == this.status);
}

class WorkoutsCompanion extends UpdateCompanion<Workout> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> programDayId;
  final Value<int?> dayIndex;
  final Value<String> name;
  final Value<DateTime> startedAt;
  final Value<DateTime?> finishedAt;
  final Value<int?> durationS;
  final Value<String?> feeling;
  final Value<String?> notes;
  final Value<WorkoutStatus> status;
  final Value<int> rowid;
  const WorkoutsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.programDayId = const Value.absent(),
    this.dayIndex = const Value.absent(),
    this.name = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.durationS = const Value.absent(),
    this.feeling = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutsCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.programDayId = const Value.absent(),
    this.dayIndex = const Value.absent(),
    required String name,
    required DateTime startedAt,
    this.finishedAt = const Value.absent(),
    this.durationS = const Value.absent(),
    this.feeling = const Value.absent(),
    this.notes = const Value.absent(),
    required WorkoutStatus status,
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       startedAt = Value(startedAt),
       status = Value(status);
  static Insertable<Workout> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? programDayId,
    Expression<int>? dayIndex,
    Expression<String>? name,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<int>? durationS,
    Expression<String>? feeling,
    Expression<String>? notes,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (programDayId != null) 'program_day_id': programDayId,
      if (dayIndex != null) 'day_index': dayIndex,
      if (name != null) 'name': name,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (durationS != null) 'duration_s': durationS,
      if (feeling != null) 'feeling': feeling,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutsCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? programDayId,
    Value<int?>? dayIndex,
    Value<String>? name,
    Value<DateTime>? startedAt,
    Value<DateTime?>? finishedAt,
    Value<int?>? durationS,
    Value<String?>? feeling,
    Value<String?>? notes,
    Value<WorkoutStatus>? status,
    Value<int>? rowid,
  }) {
    return WorkoutsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      programDayId: programDayId ?? this.programDayId,
      dayIndex: dayIndex ?? this.dayIndex,
      name: name ?? this.name,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      durationS: durationS ?? this.durationS,
      feeling: feeling ?? this.feeling,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (programDayId.present) {
      map['program_day_id'] = Variable<String>(programDayId.value);
    }
    if (dayIndex.present) {
      map['day_index'] = Variable<int>(dayIndex.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (durationS.present) {
      map['duration_s'] = Variable<int>(durationS.value);
    }
    if (feeling.present) {
      map['feeling'] = Variable<String>(feeling.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $WorkoutsTable.$converterstatus.toSql(status.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('programDayId: $programDayId, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('name: $name, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('durationS: $durationS, ')
          ..write('feeling: $feeling, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutExercisesTable extends WorkoutExercises
    with TableInfo<$WorkoutExercisesTable, WorkoutExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<String> workoutId = GeneratedColumn<String>(
    'workout_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workouts (id)',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repMinMeta = const VerificationMeta('repMin');
  @override
  late final GeneratedColumn<int> repMin = GeneratedColumn<int>(
    'rep_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repMaxMeta = const VerificationMeta('repMax');
  @override
  late final GeneratedColumn<int> repMax = GeneratedColumn<int>(
    'rep_max',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _restSecondsMeta = const VerificationMeta(
    'restSeconds',
  );
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
    'rest_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skippedMeta = const VerificationMeta(
    'skipped',
  );
  @override
  late final GeneratedColumn<bool> skipped = GeneratedColumn<bool>(
    'skipped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("skipped" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
    workoutId,
    exerciseId,
    sortOrder,
    repMin,
    repMax,
    restSeconds,
    skipped,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('rep_min')) {
      context.handle(
        _repMinMeta,
        repMin.isAcceptableOrUnknown(data['rep_min']!, _repMinMeta),
      );
    } else if (isInserting) {
      context.missing(_repMinMeta);
    }
    if (data.containsKey('rep_max')) {
      context.handle(
        _repMaxMeta,
        repMax.isAcceptableOrUnknown(data['rep_max']!, _repMaxMeta),
      );
    } else if (isInserting) {
      context.missing(_repMaxMeta);
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
        _restSecondsMeta,
        restSeconds.isAcceptableOrUnknown(
          data['rest_seconds']!,
          _restSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_restSecondsMeta);
    }
    if (data.containsKey('skipped')) {
      context.handle(
        _skippedMeta,
        skipped.isAcceptableOrUnknown(data['skipped']!, _skippedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      repMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rep_min'],
      )!,
      repMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rep_max'],
      )!,
      restSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_seconds'],
      )!,
      skipped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}skipped'],
      )!,
    );
  }

  @override
  $WorkoutExercisesTable createAlias(String alias) {
    return $WorkoutExercisesTable(attachedDatabase, alias);
  }
}

class WorkoutExercise extends DataClass implements Insertable<WorkoutExercise> {
  final String id;

  /// Null until the user signs in (Phase 3).
  final String? userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String workoutId;
  final String exerciseId;
  final int sortOrder;
  final int repMin;
  final int repMax;
  final int restSeconds;
  final bool skipped;
  const WorkoutExercise({
    required this.id,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.workoutId,
    required this.exerciseId,
    required this.sortOrder,
    required this.repMin,
    required this.repMax,
    required this.restSeconds,
    required this.skipped,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['workout_id'] = Variable<String>(workoutId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['sort_order'] = Variable<int>(sortOrder);
    map['rep_min'] = Variable<int>(repMin);
    map['rep_max'] = Variable<int>(repMax);
    map['rest_seconds'] = Variable<int>(restSeconds);
    map['skipped'] = Variable<bool>(skipped);
    return map;
  }

  WorkoutExercisesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutExercisesCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      workoutId: Value(workoutId),
      exerciseId: Value(exerciseId),
      sortOrder: Value(sortOrder),
      repMin: Value(repMin),
      repMax: Value(repMax),
      restSeconds: Value(restSeconds),
      skipped: Value(skipped),
    );
  }

  factory WorkoutExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutExercise(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      workoutId: serializer.fromJson<String>(json['workoutId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      repMin: serializer.fromJson<int>(json['repMin']),
      repMax: serializer.fromJson<int>(json['repMax']),
      restSeconds: serializer.fromJson<int>(json['restSeconds']),
      skipped: serializer.fromJson<bool>(json['skipped']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'workoutId': serializer.toJson<String>(workoutId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'repMin': serializer.toJson<int>(repMin),
      'repMax': serializer.toJson<int>(repMax),
      'restSeconds': serializer.toJson<int>(restSeconds),
      'skipped': serializer.toJson<bool>(skipped),
    };
  }

  WorkoutExercise copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? workoutId,
    String? exerciseId,
    int? sortOrder,
    int? repMin,
    int? repMax,
    int? restSeconds,
    bool? skipped,
  }) => WorkoutExercise(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    workoutId: workoutId ?? this.workoutId,
    exerciseId: exerciseId ?? this.exerciseId,
    sortOrder: sortOrder ?? this.sortOrder,
    repMin: repMin ?? this.repMin,
    repMax: repMax ?? this.repMax,
    restSeconds: restSeconds ?? this.restSeconds,
    skipped: skipped ?? this.skipped,
  );
  WorkoutExercise copyWithCompanion(WorkoutExercisesCompanion data) {
    return WorkoutExercise(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      repMin: data.repMin.present ? data.repMin.value : this.repMin,
      repMax: data.repMax.present ? data.repMax.value : this.repMax,
      restSeconds: data.restSeconds.present
          ? data.restSeconds.value
          : this.restSeconds,
      skipped: data.skipped.present ? data.skipped.value : this.skipped,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExercise(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('repMin: $repMin, ')
          ..write('repMax: $repMax, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('skipped: $skipped')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
    workoutId,
    exerciseId,
    sortOrder,
    repMin,
    repMax,
    restSeconds,
    skipped,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutExercise &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.workoutId == this.workoutId &&
          other.exerciseId == this.exerciseId &&
          other.sortOrder == this.sortOrder &&
          other.repMin == this.repMin &&
          other.repMax == this.repMax &&
          other.restSeconds == this.restSeconds &&
          other.skipped == this.skipped);
}

class WorkoutExercisesCompanion extends UpdateCompanion<WorkoutExercise> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> workoutId;
  final Value<String> exerciseId;
  final Value<int> sortOrder;
  final Value<int> repMin;
  final Value<int> repMax;
  final Value<int> restSeconds;
  final Value<bool> skipped;
  final Value<int> rowid;
  const WorkoutExercisesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.repMin = const Value.absent(),
    this.repMax = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.skipped = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutExercisesCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String workoutId,
    required String exerciseId,
    required int sortOrder,
    required int repMin,
    required int repMax,
    required int restSeconds,
    this.skipped = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : workoutId = Value(workoutId),
       exerciseId = Value(exerciseId),
       sortOrder = Value(sortOrder),
       repMin = Value(repMin),
       repMax = Value(repMax),
       restSeconds = Value(restSeconds);
  static Insertable<WorkoutExercise> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? workoutId,
    Expression<String>? exerciseId,
    Expression<int>? sortOrder,
    Expression<int>? repMin,
    Expression<int>? repMax,
    Expression<int>? restSeconds,
    Expression<bool>? skipped,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (workoutId != null) 'workout_id': workoutId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (repMin != null) 'rep_min': repMin,
      if (repMax != null) 'rep_max': repMax,
      if (restSeconds != null) 'rest_seconds': restSeconds,
      if (skipped != null) 'skipped': skipped,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutExercisesCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? workoutId,
    Value<String>? exerciseId,
    Value<int>? sortOrder,
    Value<int>? repMin,
    Value<int>? repMax,
    Value<int>? restSeconds,
    Value<bool>? skipped,
    Value<int>? rowid,
  }) {
    return WorkoutExercisesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      workoutId: workoutId ?? this.workoutId,
      exerciseId: exerciseId ?? this.exerciseId,
      sortOrder: sortOrder ?? this.sortOrder,
      repMin: repMin ?? this.repMin,
      repMax: repMax ?? this.repMax,
      restSeconds: restSeconds ?? this.restSeconds,
      skipped: skipped ?? this.skipped,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<String>(workoutId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (repMin.present) {
      map['rep_min'] = Variable<int>(repMin.value);
    }
    if (repMax.present) {
      map['rep_max'] = Variable<int>(repMax.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    if (skipped.present) {
      map['skipped'] = Variable<bool>(skipped.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExercisesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('repMin: $repMin, ')
          ..write('repMax: $repMax, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('skipped: $skipped, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetsTable extends WorkoutSets
    with TableInfo<$WorkoutSetsTable, WorkoutSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workoutExerciseIdMeta = const VerificationMeta(
    'workoutExerciseId',
  );
  @override
  late final GeneratedColumn<String> workoutExerciseId =
      GeneratedColumn<String>(
        'workout_exercise_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workout_exercises (id)',
        ),
      );
  static const VerificationMeta _setIndexMeta = const VerificationMeta(
    'setIndex',
  );
  @override
  late final GeneratedColumn<int> setIndex = GeneratedColumn<int>(
    'set_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetRepsMeta = const VerificationMeta(
    'targetReps',
  );
  @override
  late final GeneratedColumn<int> targetReps = GeneratedColumn<int>(
    'target_reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rpeMeta = const VerificationMeta('rpe');
  @override
  late final GeneratedColumn<int> rpe = GeneratedColumn<int>(
    'rpe',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isWarmupMeta = const VerificationMeta(
    'isWarmup',
  );
  @override
  late final GeneratedColumn<bool> isWarmup = GeneratedColumn<bool>(
    'is_warmup',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_warmup" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
    workoutExerciseId,
    setIndex,
    weightKg,
    reps,
    targetReps,
    rpe,
    isWarmup,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('workout_exercise_id')) {
      context.handle(
        _workoutExerciseIdMeta,
        workoutExerciseId.isAcceptableOrUnknown(
          data['workout_exercise_id']!,
          _workoutExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workoutExerciseIdMeta);
    }
    if (data.containsKey('set_index')) {
      context.handle(
        _setIndexMeta,
        setIndex.isAcceptableOrUnknown(data['set_index']!, _setIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_setIndexMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('target_reps')) {
      context.handle(
        _targetRepsMeta,
        targetReps.isAcceptableOrUnknown(data['target_reps']!, _targetRepsMeta),
      );
    } else if (isInserting) {
      context.missing(_targetRepsMeta);
    }
    if (data.containsKey('rpe')) {
      context.handle(
        _rpeMeta,
        rpe.isAcceptableOrUnknown(data['rpe']!, _rpeMeta),
      );
    }
    if (data.containsKey('is_warmup')) {
      context.handle(
        _isWarmupMeta,
        isWarmup.isAcceptableOrUnknown(data['is_warmup']!, _isWarmupMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      workoutExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_exercise_id'],
      )!,
      setIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_index'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      targetReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_reps'],
      )!,
      rpe: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rpe'],
      ),
      isWarmup: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_warmup'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $WorkoutSetsTable createAlias(String alias) {
    return $WorkoutSetsTable(attachedDatabase, alias);
  }
}

class WorkoutSet extends DataClass implements Insertable<WorkoutSet> {
  final String id;

  /// Null until the user signs in (Phase 3).
  final String? userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String workoutExerciseId;
  final int setIndex;

  /// Always kg; null for unloaded work.
  final double? weightKg;

  /// Reps, or seconds for timed exercises.
  final int reps;
  final int targetReps;
  final int? rpe;
  final bool isWarmup;
  final DateTime? completedAt;
  const WorkoutSet({
    required this.id,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.workoutExerciseId,
    required this.setIndex,
    this.weightKg,
    required this.reps,
    required this.targetReps,
    this.rpe,
    required this.isWarmup,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['workout_exercise_id'] = Variable<String>(workoutExerciseId);
    map['set_index'] = Variable<int>(setIndex);
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    map['reps'] = Variable<int>(reps);
    map['target_reps'] = Variable<int>(targetReps);
    if (!nullToAbsent || rpe != null) {
      map['rpe'] = Variable<int>(rpe);
    }
    map['is_warmup'] = Variable<bool>(isWarmup);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  WorkoutSetsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetsCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      workoutExerciseId: Value(workoutExerciseId),
      setIndex: Value(setIndex),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      reps: Value(reps),
      targetReps: Value(targetReps),
      rpe: rpe == null && nullToAbsent ? const Value.absent() : Value(rpe),
      isWarmup: Value(isWarmup),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory WorkoutSet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSet(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      workoutExerciseId: serializer.fromJson<String>(json['workoutExerciseId']),
      setIndex: serializer.fromJson<int>(json['setIndex']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      reps: serializer.fromJson<int>(json['reps']),
      targetReps: serializer.fromJson<int>(json['targetReps']),
      rpe: serializer.fromJson<int?>(json['rpe']),
      isWarmup: serializer.fromJson<bool>(json['isWarmup']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'workoutExerciseId': serializer.toJson<String>(workoutExerciseId),
      'setIndex': serializer.toJson<int>(setIndex),
      'weightKg': serializer.toJson<double?>(weightKg),
      'reps': serializer.toJson<int>(reps),
      'targetReps': serializer.toJson<int>(targetReps),
      'rpe': serializer.toJson<int?>(rpe),
      'isWarmup': serializer.toJson<bool>(isWarmup),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  WorkoutSet copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? workoutExerciseId,
    int? setIndex,
    Value<double?> weightKg = const Value.absent(),
    int? reps,
    int? targetReps,
    Value<int?> rpe = const Value.absent(),
    bool? isWarmup,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => WorkoutSet(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
    setIndex: setIndex ?? this.setIndex,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    reps: reps ?? this.reps,
    targetReps: targetReps ?? this.targetReps,
    rpe: rpe.present ? rpe.value : this.rpe,
    isWarmup: isWarmup ?? this.isWarmup,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  WorkoutSet copyWithCompanion(WorkoutSetsCompanion data) {
    return WorkoutSet(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      workoutExerciseId: data.workoutExerciseId.present
          ? data.workoutExerciseId.value
          : this.workoutExerciseId,
      setIndex: data.setIndex.present ? data.setIndex.value : this.setIndex,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      reps: data.reps.present ? data.reps.value : this.reps,
      targetReps: data.targetReps.present
          ? data.targetReps.value
          : this.targetReps,
      rpe: data.rpe.present ? data.rpe.value : this.rpe,
      isWarmup: data.isWarmup.present ? data.isWarmup.value : this.isWarmup,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSet(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('workoutExerciseId: $workoutExerciseId, ')
          ..write('setIndex: $setIndex, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('targetReps: $targetReps, ')
          ..write('rpe: $rpe, ')
          ..write('isWarmup: $isWarmup, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
    workoutExerciseId,
    setIndex,
    weightKg,
    reps,
    targetReps,
    rpe,
    isWarmup,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSet &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.workoutExerciseId == this.workoutExerciseId &&
          other.setIndex == this.setIndex &&
          other.weightKg == this.weightKg &&
          other.reps == this.reps &&
          other.targetReps == this.targetReps &&
          other.rpe == this.rpe &&
          other.isWarmup == this.isWarmup &&
          other.completedAt == this.completedAt);
}

class WorkoutSetsCompanion extends UpdateCompanion<WorkoutSet> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> workoutExerciseId;
  final Value<int> setIndex;
  final Value<double?> weightKg;
  final Value<int> reps;
  final Value<int> targetReps;
  final Value<int?> rpe;
  final Value<bool> isWarmup;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const WorkoutSetsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.workoutExerciseId = const Value.absent(),
    this.setIndex = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.reps = const Value.absent(),
    this.targetReps = const Value.absent(),
    this.rpe = const Value.absent(),
    this.isWarmup = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSetsCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String workoutExerciseId,
    required int setIndex,
    this.weightKg = const Value.absent(),
    required int reps,
    required int targetReps,
    this.rpe = const Value.absent(),
    this.isWarmup = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : workoutExerciseId = Value(workoutExerciseId),
       setIndex = Value(setIndex),
       reps = Value(reps),
       targetReps = Value(targetReps);
  static Insertable<WorkoutSet> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? workoutExerciseId,
    Expression<int>? setIndex,
    Expression<double>? weightKg,
    Expression<int>? reps,
    Expression<int>? targetReps,
    Expression<int>? rpe,
    Expression<bool>? isWarmup,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (workoutExerciseId != null) 'workout_exercise_id': workoutExerciseId,
      if (setIndex != null) 'set_index': setIndex,
      if (weightKg != null) 'weight_kg': weightKg,
      if (reps != null) 'reps': reps,
      if (targetReps != null) 'target_reps': targetReps,
      if (rpe != null) 'rpe': rpe,
      if (isWarmup != null) 'is_warmup': isWarmup,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSetsCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? workoutExerciseId,
    Value<int>? setIndex,
    Value<double?>? weightKg,
    Value<int>? reps,
    Value<int>? targetReps,
    Value<int?>? rpe,
    Value<bool>? isWarmup,
    Value<DateTime?>? completedAt,
    Value<int>? rowid,
  }) {
    return WorkoutSetsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
      setIndex: setIndex ?? this.setIndex,
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      targetReps: targetReps ?? this.targetReps,
      rpe: rpe ?? this.rpe,
      isWarmup: isWarmup ?? this.isWarmup,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (workoutExerciseId.present) {
      map['workout_exercise_id'] = Variable<String>(workoutExerciseId.value);
    }
    if (setIndex.present) {
      map['set_index'] = Variable<int>(setIndex.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (targetReps.present) {
      map['target_reps'] = Variable<int>(targetReps.value);
    }
    if (rpe.present) {
      map['rpe'] = Variable<int>(rpe.value);
    }
    if (isWarmup.present) {
      map['is_warmup'] = Variable<bool>(isWarmup.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('workoutExerciseId: $workoutExerciseId, ')
          ..write('setIndex: $setIndex, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('targetReps: $targetReps, ')
          ..write('rpe: $rpe, ')
          ..write('isWarmup: $isWarmup, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExerciseStatesTable extends ExerciseStates
    with TableInfo<$ExerciseStatesTable, ExerciseState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _currentWeightKgMeta = const VerificationMeta(
    'currentWeightKg',
  );
  @override
  late final GeneratedColumn<double> currentWeightKg = GeneratedColumn<double>(
    'current_weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentRepTargetMeta = const VerificationMeta(
    'currentRepTarget',
  );
  @override
  late final GeneratedColumn<int> currentRepTarget = GeneratedColumn<int>(
    'current_rep_target',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stallCountMeta = const VerificationMeta(
    'stallCount',
  );
  @override
  late final GeneratedColumn<int> stallCount = GeneratedColumn<int>(
    'stall_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastTotalRepsMeta = const VerificationMeta(
    'lastTotalReps',
  );
  @override
  late final GeneratedColumn<int> lastTotalReps = GeneratedColumn<int>(
    'last_total_reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastDecisionMeta = const VerificationMeta(
    'lastDecision',
  );
  @override
  late final GeneratedColumn<String> lastDecision = GeneratedColumn<String>(
    'last_decision',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastProgressedAtMeta = const VerificationMeta(
    'lastProgressedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastProgressedAt =
      GeneratedColumn<DateTime>(
        'last_progressed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
    exerciseId,
    currentWeightKg,
    currentRepTarget,
    stallCount,
    lastTotalReps,
    lastDecision,
    lastProgressedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('current_weight_kg')) {
      context.handle(
        _currentWeightKgMeta,
        currentWeightKg.isAcceptableOrUnknown(
          data['current_weight_kg']!,
          _currentWeightKgMeta,
        ),
      );
    }
    if (data.containsKey('current_rep_target')) {
      context.handle(
        _currentRepTargetMeta,
        currentRepTarget.isAcceptableOrUnknown(
          data['current_rep_target']!,
          _currentRepTargetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentRepTargetMeta);
    }
    if (data.containsKey('stall_count')) {
      context.handle(
        _stallCountMeta,
        stallCount.isAcceptableOrUnknown(data['stall_count']!, _stallCountMeta),
      );
    }
    if (data.containsKey('last_total_reps')) {
      context.handle(
        _lastTotalRepsMeta,
        lastTotalReps.isAcceptableOrUnknown(
          data['last_total_reps']!,
          _lastTotalRepsMeta,
        ),
      );
    }
    if (data.containsKey('last_decision')) {
      context.handle(
        _lastDecisionMeta,
        lastDecision.isAcceptableOrUnknown(
          data['last_decision']!,
          _lastDecisionMeta,
        ),
      );
    }
    if (data.containsKey('last_progressed_at')) {
      context.handle(
        _lastProgressedAtMeta,
        lastProgressedAt.isAcceptableOrUnknown(
          data['last_progressed_at']!,
          _lastProgressedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseState(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      currentWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_weight_kg'],
      ),
      currentRepTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_rep_target'],
      )!,
      stallCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stall_count'],
      )!,
      lastTotalReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_total_reps'],
      )!,
      lastDecision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_decision'],
      ),
      lastProgressedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_progressed_at'],
      ),
    );
  }

  @override
  $ExerciseStatesTable createAlias(String alias) {
    return $ExerciseStatesTable(attachedDatabase, alias);
  }
}

class ExerciseState extends DataClass implements Insertable<ExerciseState> {
  final String id;

  /// Null until the user signs in (Phase 3).
  final String? userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String exerciseId;
  final double? currentWeightKg;
  final int currentRepTarget;
  final int stallCount;
  final int lastTotalReps;
  final String? lastDecision;
  final DateTime? lastProgressedAt;
  const ExerciseState({
    required this.id,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.exerciseId,
    this.currentWeightKg,
    required this.currentRepTarget,
    required this.stallCount,
    required this.lastTotalReps,
    this.lastDecision,
    this.lastProgressedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['exercise_id'] = Variable<String>(exerciseId);
    if (!nullToAbsent || currentWeightKg != null) {
      map['current_weight_kg'] = Variable<double>(currentWeightKg);
    }
    map['current_rep_target'] = Variable<int>(currentRepTarget);
    map['stall_count'] = Variable<int>(stallCount);
    map['last_total_reps'] = Variable<int>(lastTotalReps);
    if (!nullToAbsent || lastDecision != null) {
      map['last_decision'] = Variable<String>(lastDecision);
    }
    if (!nullToAbsent || lastProgressedAt != null) {
      map['last_progressed_at'] = Variable<DateTime>(lastProgressedAt);
    }
    return map;
  }

  ExerciseStatesCompanion toCompanion(bool nullToAbsent) {
    return ExerciseStatesCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      exerciseId: Value(exerciseId),
      currentWeightKg: currentWeightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(currentWeightKg),
      currentRepTarget: Value(currentRepTarget),
      stallCount: Value(stallCount),
      lastTotalReps: Value(lastTotalReps),
      lastDecision: lastDecision == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDecision),
      lastProgressedAt: lastProgressedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastProgressedAt),
    );
  }

  factory ExerciseState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseState(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      currentWeightKg: serializer.fromJson<double?>(json['currentWeightKg']),
      currentRepTarget: serializer.fromJson<int>(json['currentRepTarget']),
      stallCount: serializer.fromJson<int>(json['stallCount']),
      lastTotalReps: serializer.fromJson<int>(json['lastTotalReps']),
      lastDecision: serializer.fromJson<String?>(json['lastDecision']),
      lastProgressedAt: serializer.fromJson<DateTime?>(
        json['lastProgressedAt'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'currentWeightKg': serializer.toJson<double?>(currentWeightKg),
      'currentRepTarget': serializer.toJson<int>(currentRepTarget),
      'stallCount': serializer.toJson<int>(stallCount),
      'lastTotalReps': serializer.toJson<int>(lastTotalReps),
      'lastDecision': serializer.toJson<String?>(lastDecision),
      'lastProgressedAt': serializer.toJson<DateTime?>(lastProgressedAt),
    };
  }

  ExerciseState copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? exerciseId,
    Value<double?> currentWeightKg = const Value.absent(),
    int? currentRepTarget,
    int? stallCount,
    int? lastTotalReps,
    Value<String?> lastDecision = const Value.absent(),
    Value<DateTime?> lastProgressedAt = const Value.absent(),
  }) => ExerciseState(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    exerciseId: exerciseId ?? this.exerciseId,
    currentWeightKg: currentWeightKg.present
        ? currentWeightKg.value
        : this.currentWeightKg,
    currentRepTarget: currentRepTarget ?? this.currentRepTarget,
    stallCount: stallCount ?? this.stallCount,
    lastTotalReps: lastTotalReps ?? this.lastTotalReps,
    lastDecision: lastDecision.present ? lastDecision.value : this.lastDecision,
    lastProgressedAt: lastProgressedAt.present
        ? lastProgressedAt.value
        : this.lastProgressedAt,
  );
  ExerciseState copyWithCompanion(ExerciseStatesCompanion data) {
    return ExerciseState(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      currentWeightKg: data.currentWeightKg.present
          ? data.currentWeightKg.value
          : this.currentWeightKg,
      currentRepTarget: data.currentRepTarget.present
          ? data.currentRepTarget.value
          : this.currentRepTarget,
      stallCount: data.stallCount.present
          ? data.stallCount.value
          : this.stallCount,
      lastTotalReps: data.lastTotalReps.present
          ? data.lastTotalReps.value
          : this.lastTotalReps,
      lastDecision: data.lastDecision.present
          ? data.lastDecision.value
          : this.lastDecision,
      lastProgressedAt: data.lastProgressedAt.present
          ? data.lastProgressedAt.value
          : this.lastProgressedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseState(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('currentWeightKg: $currentWeightKg, ')
          ..write('currentRepTarget: $currentRepTarget, ')
          ..write('stallCount: $stallCount, ')
          ..write('lastTotalReps: $lastTotalReps, ')
          ..write('lastDecision: $lastDecision, ')
          ..write('lastProgressedAt: $lastProgressedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    createdAt,
    updatedAt,
    deletedAt,
    exerciseId,
    currentWeightKg,
    currentRepTarget,
    stallCount,
    lastTotalReps,
    lastDecision,
    lastProgressedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseState &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.exerciseId == this.exerciseId &&
          other.currentWeightKg == this.currentWeightKg &&
          other.currentRepTarget == this.currentRepTarget &&
          other.stallCount == this.stallCount &&
          other.lastTotalReps == this.lastTotalReps &&
          other.lastDecision == this.lastDecision &&
          other.lastProgressedAt == this.lastProgressedAt);
}

class ExerciseStatesCompanion extends UpdateCompanion<ExerciseState> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> exerciseId;
  final Value<double?> currentWeightKg;
  final Value<int> currentRepTarget;
  final Value<int> stallCount;
  final Value<int> lastTotalReps;
  final Value<String?> lastDecision;
  final Value<DateTime?> lastProgressedAt;
  final Value<int> rowid;
  const ExerciseStatesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.currentWeightKg = const Value.absent(),
    this.currentRepTarget = const Value.absent(),
    this.stallCount = const Value.absent(),
    this.lastTotalReps = const Value.absent(),
    this.lastDecision = const Value.absent(),
    this.lastProgressedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExerciseStatesCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String exerciseId,
    this.currentWeightKg = const Value.absent(),
    required int currentRepTarget,
    this.stallCount = const Value.absent(),
    this.lastTotalReps = const Value.absent(),
    this.lastDecision = const Value.absent(),
    this.lastProgressedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : exerciseId = Value(exerciseId),
       currentRepTarget = Value(currentRepTarget);
  static Insertable<ExerciseState> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? exerciseId,
    Expression<double>? currentWeightKg,
    Expression<int>? currentRepTarget,
    Expression<int>? stallCount,
    Expression<int>? lastTotalReps,
    Expression<String>? lastDecision,
    Expression<DateTime>? lastProgressedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (currentWeightKg != null) 'current_weight_kg': currentWeightKg,
      if (currentRepTarget != null) 'current_rep_target': currentRepTarget,
      if (stallCount != null) 'stall_count': stallCount,
      if (lastTotalReps != null) 'last_total_reps': lastTotalReps,
      if (lastDecision != null) 'last_decision': lastDecision,
      if (lastProgressedAt != null) 'last_progressed_at': lastProgressedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExerciseStatesCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? exerciseId,
    Value<double?>? currentWeightKg,
    Value<int>? currentRepTarget,
    Value<int>? stallCount,
    Value<int>? lastTotalReps,
    Value<String?>? lastDecision,
    Value<DateTime?>? lastProgressedAt,
    Value<int>? rowid,
  }) {
    return ExerciseStatesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      exerciseId: exerciseId ?? this.exerciseId,
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      currentRepTarget: currentRepTarget ?? this.currentRepTarget,
      stallCount: stallCount ?? this.stallCount,
      lastTotalReps: lastTotalReps ?? this.lastTotalReps,
      lastDecision: lastDecision ?? this.lastDecision,
      lastProgressedAt: lastProgressedAt ?? this.lastProgressedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (currentWeightKg.present) {
      map['current_weight_kg'] = Variable<double>(currentWeightKg.value);
    }
    if (currentRepTarget.present) {
      map['current_rep_target'] = Variable<int>(currentRepTarget.value);
    }
    if (stallCount.present) {
      map['stall_count'] = Variable<int>(stallCount.value);
    }
    if (lastTotalReps.present) {
      map['last_total_reps'] = Variable<int>(lastTotalReps.value);
    }
    if (lastDecision.present) {
      map['last_decision'] = Variable<String>(lastDecision.value);
    }
    if (lastProgressedAt.present) {
      map['last_progressed_at'] = Variable<DateTime>(lastProgressedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseStatesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('currentWeightKg: $currentWeightKg, ')
          ..write('currentRepTarget: $currentRepTarget, ')
          ..write('stallCount: $stallCount, ')
          ..write('lastTotalReps: $lastTotalReps, ')
          ..write('lastDecision: $lastDecision, ')
          ..write('lastProgressedAt: $lastProgressedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $ProgramsTable programs = $ProgramsTable(this);
  late final $ProgramDaysTable programDays = $ProgramDaysTable(this);
  late final $ProgramExercisesTable programExercises = $ProgramExercisesTable(
    this,
  );
  late final $WorkoutsTable workouts = $WorkoutsTable(this);
  late final $WorkoutExercisesTable workoutExercises = $WorkoutExercisesTable(
    this,
  );
  late final $WorkoutSetsTable workoutSets = $WorkoutSetsTable(this);
  late final $ExerciseStatesTable exerciseStates = $ExerciseStatesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    programs,
    programDays,
    programExercises,
    workouts,
    workoutExercises,
    workoutSets,
    exerciseStates,
    settings,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  Value<String> id,
  Value<String?> userId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String goal,
  required String experience,
  required String equipment,
  required int daysPerWeek,
  required String preferredDays,
  required int sessionMinutes,
  required String avoid,
  required String units,
  Value<DateTime?> onboardingDoneAt,
  Value<DateTime?> disclaimerAcceptedAt,
  Value<int> rowid,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<String> id,
  Value<String?> userId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> goal,
  Value<String> experience,
  Value<String> equipment,
  Value<int> daysPerWeek,
  Value<String> preferredDays,
  Value<int> sessionMinutes,
  Value<String> avoid,
  Value<String> units,
  Value<DateTime?> onboardingDoneAt,
  Value<DateTime?> disclaimerAcceptedAt,
  Value<int> rowid,
});

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get experience => $composableBuilder(
    column: $table.experience,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get daysPerWeek => $composableBuilder(
    column: $table.daysPerWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredDays => $composableBuilder(
    column: $table.preferredDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sessionMinutes => $composableBuilder(
    column: $table.sessionMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avoid => $composableBuilder(
    column: $table.avoid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get units => $composableBuilder(
    column: $table.units,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get onboardingDoneAt => $composableBuilder(
    column: $table.onboardingDoneAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get disclaimerAcceptedAt => $composableBuilder(
    column: $table.disclaimerAcceptedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get experience => $composableBuilder(
    column: $table.experience,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get daysPerWeek => $composableBuilder(
    column: $table.daysPerWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredDays => $composableBuilder(
    column: $table.preferredDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessionMinutes => $composableBuilder(
    column: $table.sessionMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avoid => $composableBuilder(
    column: $table.avoid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get units => $composableBuilder(
    column: $table.units,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get onboardingDoneAt => $composableBuilder(
    column: $table.onboardingDoneAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get disclaimerAcceptedAt => $composableBuilder(
    column: $table.disclaimerAcceptedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get goal =>
      $composableBuilder(column: $table.goal, builder: (column) => column);

  GeneratedColumn<String> get experience => $composableBuilder(
    column: $table.experience,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<int> get daysPerWeek => $composableBuilder(
    column: $table.daysPerWeek,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preferredDays => $composableBuilder(
    column: $table.preferredDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sessionMinutes => $composableBuilder(
    column: $table.sessionMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get avoid =>
      $composableBuilder(column: $table.avoid, builder: (column) => column);

  GeneratedColumn<String> get units =>
      $composableBuilder(column: $table.units, builder: (column) => column);

  GeneratedColumn<DateTime> get onboardingDoneAt => $composableBuilder(
    column: $table.onboardingDoneAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get disclaimerAcceptedAt => $composableBuilder(
    column: $table.disclaimerAcceptedAt,
    builder: (column) => column,
  );
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
          Profile,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> goal = const Value.absent(),
                Value<String> experience = const Value.absent(),
                Value<String> equipment = const Value.absent(),
                Value<int> daysPerWeek = const Value.absent(),
                Value<String> preferredDays = const Value.absent(),
                Value<int> sessionMinutes = const Value.absent(),
                Value<String> avoid = const Value.absent(),
                Value<String> units = const Value.absent(),
                Value<DateTime?> onboardingDoneAt = const Value.absent(),
                Value<DateTime?> disclaimerAcceptedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                goal: goal,
                experience: experience,
                equipment: equipment,
                daysPerWeek: daysPerWeek,
                preferredDays: preferredDays,
                sessionMinutes: sessionMinutes,
                avoid: avoid,
                units: units,
                onboardingDoneAt: onboardingDoneAt,
                disclaimerAcceptedAt: disclaimerAcceptedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String goal,
                required String experience,
                required String equipment,
                required int daysPerWeek,
                required String preferredDays,
                required int sessionMinutes,
                required String avoid,
                required String units,
                Value<DateTime?> onboardingDoneAt = const Value.absent(),
                Value<DateTime?> disclaimerAcceptedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                goal: goal,
                experience: experience,
                equipment: equipment,
                daysPerWeek: daysPerWeek,
                preferredDays: preferredDays,
                sessionMinutes: sessionMinutes,
                avoid: avoid,
                units: units,
                onboardingDoneAt: onboardingDoneAt,
                disclaimerAcceptedAt: disclaimerAcceptedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfilesTable, Profile>(table),
                  BaseReferences<_$AppDatabase, $ProfilesTable, Profile>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
      Profile,
      PrefetchHooks Function()
    >;
typedef $$ProgramsTableCreateCompanionBuilder = ProgramsCompanion Function({
  Value<String> id,
  Value<String?> userId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String name,
  required String splitType,
  required int generatedByVersion,
  Value<bool> active,
  required DateTime startedAt,
  Value<int> rowid,
});
typedef $$ProgramsTableUpdateCompanionBuilder = ProgramsCompanion Function({
  Value<String> id,
  Value<String?> userId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> name,
  Value<String> splitType,
  Value<int> generatedByVersion,
  Value<bool> active,
  Value<DateTime> startedAt,
  Value<int> rowid,
});

final class $$ProgramsTableReferences
    extends BaseReferences<_$AppDatabase, $ProgramsTable, Program> {
  $$ProgramsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProgramDaysTable, List<ProgramDay>>
  _programDaysRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.programDays,
    aliasName: 'programs__id__program_days__program_id',
  );

  $$ProgramDaysTableProcessedTableManager get programDaysRefs {
    final manager = $$ProgramDaysTableTableManager(
      $_db,
      $_db.programDays,
    ).filter((f) => f.programId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_programDaysRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProgramsTableFilterComposer
    extends Composer<_$AppDatabase, $ProgramsTable> {
  $$ProgramsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get splitType => $composableBuilder(
    column: $table.splitType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get generatedByVersion => $composableBuilder(
    column: $table.generatedByVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> programDaysRefs(
    Expression<bool> Function($$ProgramDaysTableFilterComposer f) f,
  ) {
    final $$ProgramDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.programId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableFilterComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProgramsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgramsTable> {
  $$ProgramsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get splitType => $composableBuilder(
    column: $table.splitType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get generatedByVersion => $composableBuilder(
    column: $table.generatedByVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProgramsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgramsTable> {
  $$ProgramsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get splitType =>
      $composableBuilder(column: $table.splitType, builder: (column) => column);

  GeneratedColumn<int> get generatedByVersion => $composableBuilder(
    column: $table.generatedByVersion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  Expression<T> programDaysRefs<T extends Object>(
    Expression<T> Function($$ProgramDaysTableAnnotationComposer a) f,
  ) {
    final $$ProgramDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.programId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProgramsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgramsTable,
          Program,
          $$ProgramsTableFilterComposer,
          $$ProgramsTableOrderingComposer,
          $$ProgramsTableAnnotationComposer,
          $$ProgramsTableCreateCompanionBuilder,
          $$ProgramsTableUpdateCompanionBuilder,
          (Program, $$ProgramsTableReferences),
          Program,
          PrefetchHooks Function({bool programDaysRefs})
        > {
  $$ProgramsTableTableManager(_$AppDatabase db, $ProgramsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgramsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgramsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgramsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> splitType = const Value.absent(),
                Value<int> generatedByVersion = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgramsCompanion(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                splitType: splitType,
                generatedByVersion: generatedByVersion,
                active: active,
                startedAt: startedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String name,
                required String splitType,
                required int generatedByVersion,
                Value<bool> active = const Value.absent(),
                required DateTime startedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProgramsCompanion.insert(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                splitType: splitType,
                generatedByVersion: generatedByVersion,
                active: active,
                startedAt: startedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProgramsTable, Program>(table),
                  $$ProgramsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({programDaysRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (programDaysRefs) db.programDays],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (programDaysRefs)
                    await $_getPrefetchedData<
                      Program,
                      $ProgramsTable,
                      ProgramDay
                    >(
                      currentTable: table,
                      referencedTable: $$ProgramsTableReferences
                          ._programDaysRefsTable(db),
                      managerFromTypedResult: (p0) => $$ProgramsTableReferences(
                        db,
                        table,
                        p0,
                      ).programDaysRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.programId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProgramsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgramsTable,
      Program,
      $$ProgramsTableFilterComposer,
      $$ProgramsTableOrderingComposer,
      $$ProgramsTableAnnotationComposer,
      $$ProgramsTableCreateCompanionBuilder,
      $$ProgramsTableUpdateCompanionBuilder,
      (Program, $$ProgramsTableReferences),
      Program,
      PrefetchHooks Function({bool programDaysRefs})
    >;
typedef $$ProgramDaysTableCreateCompanionBuilder =
    ProgramDaysCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String programId,
      required int dayIndex,
      required String name,
      Value<int> rowid,
    });
typedef $$ProgramDaysTableUpdateCompanionBuilder =
    ProgramDaysCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> programId,
      Value<int> dayIndex,
      Value<String> name,
      Value<int> rowid,
    });

final class $$ProgramDaysTableReferences
    extends BaseReferences<_$AppDatabase, $ProgramDaysTable, ProgramDay> {
  $$ProgramDaysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProgramsTable _programIdTable(_$AppDatabase db) =>
      db.programs.createAlias('program_days__program_id__programs__id');

  $$ProgramsTableProcessedTableManager get programId {
    final $_column = $_itemColumn<String>('program_id')!;

    final manager = $$ProgramsTableTableManager(
      $_db,
      $_db.programs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_programIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ProgramExercisesTable, List<ProgramExercise>>
  _programExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.programExercises,
    aliasName: 'program_days__id__program_exercises__program_day_id',
  );

  $$ProgramExercisesTableProcessedTableManager get programExercisesRefs {
    final manager = $$ProgramExercisesTableTableManager(
      $_db,
      $_db.programExercises,
    ).filter((f) => f.programDayId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _programExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WorkoutsTable, List<Workout>> _workoutsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.workouts,
    aliasName: 'program_days__id__workouts__program_day_id',
  );

  $$WorkoutsTableProcessedTableManager get workoutsRefs {
    final manager = $$WorkoutsTableTableManager(
      $_db,
      $_db.workouts,
    ).filter((f) => f.programDayId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProgramDaysTableFilterComposer
    extends Composer<_$AppDatabase, $ProgramDaysTable> {
  $$ProgramDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  $$ProgramsTableFilterComposer get programId {
    final $$ProgramsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programId,
      referencedTable: $db.programs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramsTableFilterComposer(
            $db: $db,
            $table: $db.programs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> programExercisesRefs(
    Expression<bool> Function($$ProgramExercisesTableFilterComposer f) f,
  ) {
    final $$ProgramExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.programExercises,
      getReferencedColumn: (t) => t.programDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramExercisesTableFilterComposer(
            $db: $db,
            $table: $db.programExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> workoutsRefs(
    Expression<bool> Function($$WorkoutsTableFilterComposer f) f,
  ) {
    final $$WorkoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.programDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableFilterComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProgramDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgramDaysTable> {
  $$ProgramDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProgramsTableOrderingComposer get programId {
    final $$ProgramsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programId,
      referencedTable: $db.programs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramsTableOrderingComposer(
            $db: $db,
            $table: $db.programs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProgramDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgramDaysTable> {
  $$ProgramDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get dayIndex =>
      $composableBuilder(column: $table.dayIndex, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  $$ProgramsTableAnnotationComposer get programId {
    final $$ProgramsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programId,
      referencedTable: $db.programs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramsTableAnnotationComposer(
            $db: $db,
            $table: $db.programs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> programExercisesRefs<T extends Object>(
    Expression<T> Function($$ProgramExercisesTableAnnotationComposer a) f,
  ) {
    final $$ProgramExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.programExercises,
      getReferencedColumn: (t) => t.programDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.programExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> workoutsRefs<T extends Object>(
    Expression<T> Function($$WorkoutsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.programDayId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProgramDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgramDaysTable,
          ProgramDay,
          $$ProgramDaysTableFilterComposer,
          $$ProgramDaysTableOrderingComposer,
          $$ProgramDaysTableAnnotationComposer,
          $$ProgramDaysTableCreateCompanionBuilder,
          $$ProgramDaysTableUpdateCompanionBuilder,
          (ProgramDay, $$ProgramDaysTableReferences),
          ProgramDay,
          PrefetchHooks Function({
            bool programId,
            bool programExercisesRefs,
            bool workoutsRefs,
          })
        > {
  $$ProgramDaysTableTableManager(_$AppDatabase db, $ProgramDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgramDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgramDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgramDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> programId = const Value.absent(),
                Value<int> dayIndex = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgramDaysCompanion(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                programId: programId,
                dayIndex: dayIndex,
                name: name,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String programId,
                required int dayIndex,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => ProgramDaysCompanion.insert(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                programId: programId,
                dayIndex: dayIndex,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProgramDaysTable, ProgramDay>(table),
                  $$ProgramDaysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                programId = false,
                programExercisesRefs = false,
                workoutsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (programExercisesRefs) db.programExercises,
                    if (workoutsRefs) db.workouts,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (programId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.programId,
                            referencedTable: $$ProgramDaysTableReferences
                                ._programIdTable(db),
                            referencedColumn: $$ProgramDaysTableReferences
                                ._programIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (programExercisesRefs)
                        await $_getPrefetchedData<
                          ProgramDay,
                          $ProgramDaysTable,
                          ProgramExercise
                        >(
                          currentTable: table,
                          referencedTable: $$ProgramDaysTableReferences
                              ._programExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProgramDaysTableReferences(
                                db,
                                table,
                                p0,
                              ).programExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.programDayId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (workoutsRefs)
                        await $_getPrefetchedData<
                          ProgramDay,
                          $ProgramDaysTable,
                          Workout
                        >(
                          currentTable: table,
                          referencedTable: $$ProgramDaysTableReferences
                              ._workoutsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProgramDaysTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.programDayId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProgramDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgramDaysTable,
      ProgramDay,
      $$ProgramDaysTableFilterComposer,
      $$ProgramDaysTableOrderingComposer,
      $$ProgramDaysTableAnnotationComposer,
      $$ProgramDaysTableCreateCompanionBuilder,
      $$ProgramDaysTableUpdateCompanionBuilder,
      (ProgramDay, $$ProgramDaysTableReferences),
      ProgramDay,
      PrefetchHooks Function({
        bool programId,
        bool programExercisesRefs,
        bool workoutsRefs,
      })
    >;
typedef $$ProgramExercisesTableCreateCompanionBuilder =
    ProgramExercisesCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String programDayId,
      required String exerciseId,
      required int sortOrder,
      required int sets,
      required int repMin,
      required int repMax,
      required int restSeconds,
      required String reason,
      Value<int> rowid,
    });
typedef $$ProgramExercisesTableUpdateCompanionBuilder =
    ProgramExercisesCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> programDayId,
      Value<String> exerciseId,
      Value<int> sortOrder,
      Value<int> sets,
      Value<int> repMin,
      Value<int> repMax,
      Value<int> restSeconds,
      Value<String> reason,
      Value<int> rowid,
    });

final class $$ProgramExercisesTableReferences
    extends
        BaseReferences<_$AppDatabase, $ProgramExercisesTable, ProgramExercise> {
  $$ProgramExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProgramDaysTable _programDayIdTable(_$AppDatabase db) => db
      .programDays
      .createAlias('program_exercises__program_day_id__program_days__id');

  $$ProgramDaysTableProcessedTableManager get programDayId {
    final $_column = $_itemColumn<String>('program_day_id')!;

    final manager = $$ProgramDaysTableTableManager(
      $_db,
      $_db.programDays,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_programDayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProgramExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ProgramExercisesTable> {
  $$ProgramExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sets => $composableBuilder(
    column: $table.sets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repMin => $composableBuilder(
    column: $table.repMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repMax => $composableBuilder(
    column: $table.repMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  $$ProgramDaysTableFilterComposer get programDayId {
    final $$ProgramDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programDayId,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableFilterComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProgramExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgramExercisesTable> {
  $$ProgramExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sets => $composableBuilder(
    column: $table.sets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repMin => $composableBuilder(
    column: $table.repMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repMax => $composableBuilder(
    column: $table.repMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProgramDaysTableOrderingComposer get programDayId {
    final $$ProgramDaysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programDayId,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableOrderingComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProgramExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgramExercisesTable> {
  $$ProgramExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get sets =>
      $composableBuilder(column: $table.sets, builder: (column) => column);

  GeneratedColumn<int> get repMin =>
      $composableBuilder(column: $table.repMin, builder: (column) => column);

  GeneratedColumn<int> get repMax =>
      $composableBuilder(column: $table.repMax, builder: (column) => column);

  GeneratedColumn<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  $$ProgramDaysTableAnnotationComposer get programDayId {
    final $$ProgramDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programDayId,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProgramExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgramExercisesTable,
          ProgramExercise,
          $$ProgramExercisesTableFilterComposer,
          $$ProgramExercisesTableOrderingComposer,
          $$ProgramExercisesTableAnnotationComposer,
          $$ProgramExercisesTableCreateCompanionBuilder,
          $$ProgramExercisesTableUpdateCompanionBuilder,
          (ProgramExercise, $$ProgramExercisesTableReferences),
          ProgramExercise,
          PrefetchHooks Function({bool programDayId})
        > {
  $$ProgramExercisesTableTableManager(
    _$AppDatabase db,
    $ProgramExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgramExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgramExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgramExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> programDayId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> sets = const Value.absent(),
                Value<int> repMin = const Value.absent(),
                Value<int> repMax = const Value.absent(),
                Value<int> restSeconds = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgramExercisesCompanion(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                programDayId: programDayId,
                exerciseId: exerciseId,
                sortOrder: sortOrder,
                sets: sets,
                repMin: repMin,
                repMax: repMax,
                restSeconds: restSeconds,
                reason: reason,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String programDayId,
                required String exerciseId,
                required int sortOrder,
                required int sets,
                required int repMin,
                required int repMax,
                required int restSeconds,
                required String reason,
                Value<int> rowid = const Value.absent(),
              }) => ProgramExercisesCompanion.insert(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                programDayId: programDayId,
                exerciseId: exerciseId,
                sortOrder: sortOrder,
                sets: sets,
                repMin: repMin,
                repMax: repMax,
                restSeconds: restSeconds,
                reason: reason,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProgramExercisesTable, ProgramExercise>(table),
                  $$ProgramExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({programDayId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (programDayId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.programDayId,
                        referencedTable: $$ProgramExercisesTableReferences
                            ._programDayIdTable(db),
                        referencedColumn: $$ProgramExercisesTableReferences
                            ._programDayIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProgramExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgramExercisesTable,
      ProgramExercise,
      $$ProgramExercisesTableFilterComposer,
      $$ProgramExercisesTableOrderingComposer,
      $$ProgramExercisesTableAnnotationComposer,
      $$ProgramExercisesTableCreateCompanionBuilder,
      $$ProgramExercisesTableUpdateCompanionBuilder,
      (ProgramExercise, $$ProgramExercisesTableReferences),
      ProgramExercise,
      PrefetchHooks Function({bool programDayId})
    >;
typedef $$WorkoutsTableCreateCompanionBuilder = WorkoutsCompanion Function({
  Value<String> id,
  Value<String?> userId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> programDayId,
  Value<int?> dayIndex,
  required String name,
  required DateTime startedAt,
  Value<DateTime?> finishedAt,
  Value<int?> durationS,
  Value<String?> feeling,
  Value<String?> notes,
  required WorkoutStatus status,
  Value<int> rowid,
});
typedef $$WorkoutsTableUpdateCompanionBuilder = WorkoutsCompanion Function({
  Value<String> id,
  Value<String?> userId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> programDayId,
  Value<int?> dayIndex,
  Value<String> name,
  Value<DateTime> startedAt,
  Value<DateTime?> finishedAt,
  Value<int?> durationS,
  Value<String?> feeling,
  Value<String?> notes,
  Value<WorkoutStatus> status,
  Value<int> rowid,
});

final class $$WorkoutsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutsTable, Workout> {
  $$WorkoutsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProgramDaysTable _programDayIdTable(_$AppDatabase db) =>
      db.programDays.createAlias('workouts__program_day_id__program_days__id');

  $$ProgramDaysTableProcessedTableManager? get programDayId {
    final $_column = $_itemColumn<String>('program_day_id');
    if ($_column == null) return null;
    final manager = $$ProgramDaysTableTableManager(
      $_db,
      $_db.programDays,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_programDayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WorkoutExercisesTable, List<WorkoutExercise>>
  _workoutExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutExercises,
    aliasName: 'workouts__id__workout_exercises__workout_id',
  );

  $$WorkoutExercisesTableProcessedTableManager get workoutExercisesRefs {
    final manager = $$WorkoutExercisesTableTableManager(
      $_db,
      $_db.workoutExercises,
    ).filter((f) => f.workoutId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationS => $composableBuilder(
    column: $table.durationS,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feeling => $composableBuilder(
    column: $table.feeling,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WorkoutStatus, WorkoutStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$ProgramDaysTableFilterComposer get programDayId {
    final $$ProgramDaysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programDayId,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableFilterComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutExercisesRefs(
    Expression<bool> Function($$WorkoutExercisesTableFilterComposer f) f,
  ) {
    final $$WorkoutExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableFilterComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationS => $composableBuilder(
    column: $table.durationS,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feeling => $composableBuilder(
    column: $table.feeling,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProgramDaysTableOrderingComposer get programDayId {
    final $$ProgramDaysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programDayId,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableOrderingComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get dayIndex =>
      $composableBuilder(column: $table.dayIndex, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationS =>
      $composableBuilder(column: $table.durationS, builder: (column) => column);

  GeneratedColumn<String> get feeling =>
      $composableBuilder(column: $table.feeling, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WorkoutStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$ProgramDaysTableAnnotationComposer get programDayId {
    final $$ProgramDaysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.programDayId,
      referencedTable: $db.programDays,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgramDaysTableAnnotationComposer(
            $db: $db,
            $table: $db.programDays,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> workoutExercisesRefs<T extends Object>(
    Expression<T> Function($$WorkoutExercisesTableAnnotationComposer a) f,
  ) {
    final $$WorkoutExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutsTable,
          Workout,
          $$WorkoutsTableFilterComposer,
          $$WorkoutsTableOrderingComposer,
          $$WorkoutsTableAnnotationComposer,
          $$WorkoutsTableCreateCompanionBuilder,
          $$WorkoutsTableUpdateCompanionBuilder,
          (Workout, $$WorkoutsTableReferences),
          Workout,
          PrefetchHooks Function({bool programDayId, bool workoutExercisesRefs})
        > {
  $$WorkoutsTableTableManager(_$AppDatabase db, $WorkoutsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> programDayId = const Value.absent(),
                Value<int?> dayIndex = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<int?> durationS = const Value.absent(),
                Value<String?> feeling = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<WorkoutStatus> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutsCompanion(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                programDayId: programDayId,
                dayIndex: dayIndex,
                name: name,
                startedAt: startedAt,
                finishedAt: finishedAt,
                durationS: durationS,
                feeling: feeling,
                notes: notes,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> programDayId = const Value.absent(),
                Value<int?> dayIndex = const Value.absent(),
                required String name,
                required DateTime startedAt,
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<int?> durationS = const Value.absent(),
                Value<String?> feeling = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required WorkoutStatus status,
                Value<int> rowid = const Value.absent(),
              }) => WorkoutsCompanion.insert(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                programDayId: programDayId,
                dayIndex: dayIndex,
                name: name,
                startedAt: startedAt,
                finishedAt: finishedAt,
                durationS: durationS,
                feeling: feeling,
                notes: notes,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutsTable, Workout>(table),
                  $$WorkoutsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({programDayId = false, workoutExercisesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutExercisesRefs) db.workoutExercises,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (programDayId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.programDayId,
                            referencedTable: $$WorkoutsTableReferences
                                ._programDayIdTable(db),
                            referencedColumn: $$WorkoutsTableReferences
                                ._programDayIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutExercisesRefs)
                        await $_getPrefetchedData<
                          Workout,
                          $WorkoutsTable,
                          WorkoutExercise
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutsTableReferences
                              ._workoutExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutsTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workoutId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkoutsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutsTable,
      Workout,
      $$WorkoutsTableFilterComposer,
      $$WorkoutsTableOrderingComposer,
      $$WorkoutsTableAnnotationComposer,
      $$WorkoutsTableCreateCompanionBuilder,
      $$WorkoutsTableUpdateCompanionBuilder,
      (Workout, $$WorkoutsTableReferences),
      Workout,
      PrefetchHooks Function({bool programDayId, bool workoutExercisesRefs})
    >;
typedef $$WorkoutExercisesTableCreateCompanionBuilder =
    WorkoutExercisesCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String workoutId,
      required String exerciseId,
      required int sortOrder,
      required int repMin,
      required int repMax,
      required int restSeconds,
      Value<bool> skipped,
      Value<int> rowid,
    });
typedef $$WorkoutExercisesTableUpdateCompanionBuilder =
    WorkoutExercisesCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> workoutId,
      Value<String> exerciseId,
      Value<int> sortOrder,
      Value<int> repMin,
      Value<int> repMax,
      Value<int> restSeconds,
      Value<bool> skipped,
      Value<int> rowid,
    });

final class $$WorkoutExercisesTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutExercisesTable, WorkoutExercise> {
  $$WorkoutExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutsTable _workoutIdTable(_$AppDatabase db) =>
      db.workouts.createAlias('workout_exercises__workout_id__workouts__id');

  $$WorkoutsTableProcessedTableManager get workoutId {
    final $_column = $_itemColumn<String>('workout_id')!;

    final manager = $$WorkoutsTableTableManager(
      $_db,
      $_db.workouts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WorkoutSetsTable, List<WorkoutSet>>
  _workoutSetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSets,
    aliasName: 'workout_exercises__id__workout_sets__workout_exercise_id',
  );

  $$WorkoutSetsTableProcessedTableManager get workoutSetsRefs {
    final manager = $$WorkoutSetsTableTableManager($_db, $_db.workoutSets)
        .filter(
          (f) => f.workoutExerciseId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_workoutSetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repMin => $composableBuilder(
    column: $table.repMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repMax => $composableBuilder(
    column: $table.repMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get skipped => $composableBuilder(
    column: $table.skipped,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutsTableFilterComposer get workoutId {
    final $$WorkoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableFilterComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutSetsRefs(
    Expression<bool> Function($$WorkoutSetsTableFilterComposer f) f,
  ) {
    final $$WorkoutSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.workoutExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repMin => $composableBuilder(
    column: $table.repMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repMax => $composableBuilder(
    column: $table.repMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get skipped => $composableBuilder(
    column: $table.skipped,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutsTableOrderingComposer get workoutId {
    final $$WorkoutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableOrderingComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get repMin =>
      $composableBuilder(column: $table.repMin, builder: (column) => column);

  GeneratedColumn<int> get repMax =>
      $composableBuilder(column: $table.repMax, builder: (column) => column);

  GeneratedColumn<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get skipped =>
      $composableBuilder(column: $table.skipped, builder: (column) => column);

  $$WorkoutsTableAnnotationComposer get workoutId {
    final $$WorkoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> workoutSetsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.workoutExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutExercisesTable,
          WorkoutExercise,
          $$WorkoutExercisesTableFilterComposer,
          $$WorkoutExercisesTableOrderingComposer,
          $$WorkoutExercisesTableAnnotationComposer,
          $$WorkoutExercisesTableCreateCompanionBuilder,
          $$WorkoutExercisesTableUpdateCompanionBuilder,
          (WorkoutExercise, $$WorkoutExercisesTableReferences),
          WorkoutExercise,
          PrefetchHooks Function({bool workoutId, bool workoutSetsRefs})
        > {
  $$WorkoutExercisesTableTableManager(
    _$AppDatabase db,
    $WorkoutExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> workoutId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> repMin = const Value.absent(),
                Value<int> repMax = const Value.absent(),
                Value<int> restSeconds = const Value.absent(),
                Value<bool> skipped = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutExercisesCompanion(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                workoutId: workoutId,
                exerciseId: exerciseId,
                sortOrder: sortOrder,
                repMin: repMin,
                repMax: repMax,
                restSeconds: restSeconds,
                skipped: skipped,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String workoutId,
                required String exerciseId,
                required int sortOrder,
                required int repMin,
                required int repMax,
                required int restSeconds,
                Value<bool> skipped = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutExercisesCompanion.insert(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                workoutId: workoutId,
                exerciseId: exerciseId,
                sortOrder: sortOrder,
                repMin: repMin,
                repMax: repMax,
                restSeconds: restSeconds,
                skipped: skipped,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutExercisesTable, WorkoutExercise>(table),
                  $$WorkoutExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({workoutId = false, workoutSetsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutSetsRefs) db.workoutSets,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (workoutId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.workoutId,
                            referencedTable: $$WorkoutExercisesTableReferences
                                ._workoutIdTable(db),
                            referencedColumn: $$WorkoutExercisesTableReferences
                                ._workoutIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutSetsRefs)
                        await $_getPrefetchedData<
                          WorkoutExercise,
                          $WorkoutExercisesTable,
                          WorkoutSet
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutExercisesTableReferences
                              ._workoutSetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workoutExerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkoutExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutExercisesTable,
      WorkoutExercise,
      $$WorkoutExercisesTableFilterComposer,
      $$WorkoutExercisesTableOrderingComposer,
      $$WorkoutExercisesTableAnnotationComposer,
      $$WorkoutExercisesTableCreateCompanionBuilder,
      $$WorkoutExercisesTableUpdateCompanionBuilder,
      (WorkoutExercise, $$WorkoutExercisesTableReferences),
      WorkoutExercise,
      PrefetchHooks Function({bool workoutId, bool workoutSetsRefs})
    >;
typedef $$WorkoutSetsTableCreateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String workoutExerciseId,
      required int setIndex,
      Value<double?> weightKg,
      required int reps,
      required int targetReps,
      Value<int?> rpe,
      Value<bool> isWarmup,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });
typedef $$WorkoutSetsTableUpdateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> workoutExerciseId,
      Value<int> setIndex,
      Value<double?> weightKg,
      Value<int> reps,
      Value<int> targetReps,
      Value<int?> rpe,
      Value<bool> isWarmup,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });

final class $$WorkoutSetsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutSetsTable, WorkoutSet> {
  $$WorkoutSetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutExercisesTable _workoutExerciseIdTable(_$AppDatabase db) => db
      .workoutExercises
      .createAlias('workout_sets__workout_exercise_id__workout_exercises__id');

  $$WorkoutExercisesTableProcessedTableManager get workoutExerciseId {
    final $_column = $_itemColumn<String>('workout_exercise_id')!;

    final manager = $$WorkoutExercisesTableTableManager(
      $_db,
      $_db.workoutExercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutSetsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setIndex => $composableBuilder(
    column: $table.setIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isWarmup => $composableBuilder(
    column: $table.isWarmup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutExercisesTableFilterComposer get workoutExerciseId {
    final $$WorkoutExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutExerciseId,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableFilterComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setIndex => $composableBuilder(
    column: $table.setIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isWarmup => $composableBuilder(
    column: $table.isWarmup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutExercisesTableOrderingComposer get workoutExerciseId {
    final $$WorkoutExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutExerciseId,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get setIndex =>
      $composableBuilder(column: $table.setIndex, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rpe =>
      $composableBuilder(column: $table.rpe, builder: (column) => column);

  GeneratedColumn<bool> get isWarmup =>
      $composableBuilder(column: $table.isWarmup, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$WorkoutExercisesTableAnnotationComposer get workoutExerciseId {
    final $$WorkoutExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutExerciseId,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSetsTable,
          WorkoutSet,
          $$WorkoutSetsTableFilterComposer,
          $$WorkoutSetsTableOrderingComposer,
          $$WorkoutSetsTableAnnotationComposer,
          $$WorkoutSetsTableCreateCompanionBuilder,
          $$WorkoutSetsTableUpdateCompanionBuilder,
          (WorkoutSet, $$WorkoutSetsTableReferences),
          WorkoutSet,
          PrefetchHooks Function({bool workoutExerciseId})
        > {
  $$WorkoutSetsTableTableManager(_$AppDatabase db, $WorkoutSetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> workoutExerciseId = const Value.absent(),
                Value<int> setIndex = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<int> targetReps = const Value.absent(),
                Value<int?> rpe = const Value.absent(),
                Value<bool> isWarmup = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSetsCompanion(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                workoutExerciseId: workoutExerciseId,
                setIndex: setIndex,
                weightKg: weightKg,
                reps: reps,
                targetReps: targetReps,
                rpe: rpe,
                isWarmup: isWarmup,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String workoutExerciseId,
                required int setIndex,
                Value<double?> weightKg = const Value.absent(),
                required int reps,
                required int targetReps,
                Value<int?> rpe = const Value.absent(),
                Value<bool> isWarmup = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSetsCompanion.insert(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                workoutExerciseId: workoutExerciseId,
                setIndex: setIndex,
                weightKg: weightKg,
                reps: reps,
                targetReps: targetReps,
                rpe: rpe,
                isWarmup: isWarmup,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSetsTable, WorkoutSet>(table),
                  $$WorkoutSetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutExerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (workoutExerciseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.workoutExerciseId,
                        referencedTable: $$WorkoutSetsTableReferences
                            ._workoutExerciseIdTable(db),
                        referencedColumn: $$WorkoutSetsTableReferences
                            ._workoutExerciseIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSetsTable,
      WorkoutSet,
      $$WorkoutSetsTableFilterComposer,
      $$WorkoutSetsTableOrderingComposer,
      $$WorkoutSetsTableAnnotationComposer,
      $$WorkoutSetsTableCreateCompanionBuilder,
      $$WorkoutSetsTableUpdateCompanionBuilder,
      (WorkoutSet, $$WorkoutSetsTableReferences),
      WorkoutSet,
      PrefetchHooks Function({bool workoutExerciseId})
    >;
typedef $$ExerciseStatesTableCreateCompanionBuilder =
    ExerciseStatesCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String exerciseId,
      Value<double?> currentWeightKg,
      required int currentRepTarget,
      Value<int> stallCount,
      Value<int> lastTotalReps,
      Value<String?> lastDecision,
      Value<DateTime?> lastProgressedAt,
      Value<int> rowid,
    });
typedef $$ExerciseStatesTableUpdateCompanionBuilder =
    ExerciseStatesCompanion Function({
      Value<String> id,
      Value<String?> userId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> exerciseId,
      Value<double?> currentWeightKg,
      Value<int> currentRepTarget,
      Value<int> stallCount,
      Value<int> lastTotalReps,
      Value<String?> lastDecision,
      Value<DateTime?> lastProgressedAt,
      Value<int> rowid,
    });

class $$ExerciseStatesTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseStatesTable> {
  $$ExerciseStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentWeightKg => $composableBuilder(
    column: $table.currentWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentRepTarget => $composableBuilder(
    column: $table.currentRepTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stallCount => $composableBuilder(
    column: $table.stallCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastTotalReps => $composableBuilder(
    column: $table.lastTotalReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastDecision => $composableBuilder(
    column: $table.lastDecision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastProgressedAt => $composableBuilder(
    column: $table.lastProgressedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExerciseStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseStatesTable> {
  $$ExerciseStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentWeightKg => $composableBuilder(
    column: $table.currentWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentRepTarget => $composableBuilder(
    column: $table.currentRepTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stallCount => $composableBuilder(
    column: $table.stallCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastTotalReps => $composableBuilder(
    column: $table.lastTotalReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastDecision => $composableBuilder(
    column: $table.lastDecision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastProgressedAt => $composableBuilder(
    column: $table.lastProgressedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExerciseStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseStatesTable> {
  $$ExerciseStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get currentWeightKg => $composableBuilder(
    column: $table.currentWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentRepTarget => $composableBuilder(
    column: $table.currentRepTarget,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stallCount => $composableBuilder(
    column: $table.stallCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastTotalReps => $composableBuilder(
    column: $table.lastTotalReps,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastDecision => $composableBuilder(
    column: $table.lastDecision,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastProgressedAt => $composableBuilder(
    column: $table.lastProgressedAt,
    builder: (column) => column,
  );
}

class $$ExerciseStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciseStatesTable,
          ExerciseState,
          $$ExerciseStatesTableFilterComposer,
          $$ExerciseStatesTableOrderingComposer,
          $$ExerciseStatesTableAnnotationComposer,
          $$ExerciseStatesTableCreateCompanionBuilder,
          $$ExerciseStatesTableUpdateCompanionBuilder,
          (
            ExerciseState,
            BaseReferences<_$AppDatabase, $ExerciseStatesTable, ExerciseState>,
          ),
          ExerciseState,
          PrefetchHooks Function()
        > {
  $$ExerciseStatesTableTableManager(
    _$AppDatabase db,
    $ExerciseStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<double?> currentWeightKg = const Value.absent(),
                Value<int> currentRepTarget = const Value.absent(),
                Value<int> stallCount = const Value.absent(),
                Value<int> lastTotalReps = const Value.absent(),
                Value<String?> lastDecision = const Value.absent(),
                Value<DateTime?> lastProgressedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseStatesCompanion(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                exerciseId: exerciseId,
                currentWeightKg: currentWeightKg,
                currentRepTarget: currentRepTarget,
                stallCount: stallCount,
                lastTotalReps: lastTotalReps,
                lastDecision: lastDecision,
                lastProgressedAt: lastProgressedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String exerciseId,
                Value<double?> currentWeightKg = const Value.absent(),
                required int currentRepTarget,
                Value<int> stallCount = const Value.absent(),
                Value<int> lastTotalReps = const Value.absent(),
                Value<String?> lastDecision = const Value.absent(),
                Value<DateTime?> lastProgressedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseStatesCompanion.insert(
                id: id,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                exerciseId: exerciseId,
                currentWeightKg: currentWeightKg,
                currentRepTarget: currentRepTarget,
                stallCount: stallCount,
                lastTotalReps: lastTotalReps,
                lastDecision: lastDecision,
                lastProgressedAt: lastProgressedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExerciseStatesTable, ExerciseState>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ExerciseStatesTable,
                    ExerciseState
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExerciseStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciseStatesTable,
      ExerciseState,
      $$ExerciseStatesTableFilterComposer,
      $$ExerciseStatesTableOrderingComposer,
      $$ExerciseStatesTableAnnotationComposer,
      $$ExerciseStatesTableCreateCompanionBuilder,
      $$ExerciseStatesTableUpdateCompanionBuilder,
      (
        ExerciseState,
        BaseReferences<_$AppDatabase, $ExerciseStatesTable, ExerciseState>,
      ),
      ExerciseState,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, Setting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$ProgramsTableTableManager get programs =>
      $$ProgramsTableTableManager(_db, _db.programs);
  $$ProgramDaysTableTableManager get programDays =>
      $$ProgramDaysTableTableManager(_db, _db.programDays);
  $$ProgramExercisesTableTableManager get programExercises =>
      $$ProgramExercisesTableTableManager(_db, _db.programExercises);
  $$WorkoutsTableTableManager get workouts =>
      $$WorkoutsTableTableManager(_db, _db.workouts);
  $$WorkoutExercisesTableTableManager get workoutExercises =>
      $$WorkoutExercisesTableTableManager(_db, _db.workoutExercises);
  $$WorkoutSetsTableTableManager get workoutSets =>
      $$WorkoutSetsTableTableManager(_db, _db.workoutSets);
  $$ExerciseStatesTableTableManager get exerciseStates =>
      $$ExerciseStatesTableTableManager(_db, _db.exerciseStates);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}

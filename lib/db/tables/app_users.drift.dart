// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:memori_app/db/tables/app_users.drift.dart' as i1;
import 'package:memori_app/db/tables/app_users.dart' as i2;
import 'package:drift/src/runtime/query_builder/query_builder.dart' as i3;

class $AppUsersTable extends i2.AppUsers
    with i0.TableInfo<$AppUsersTable, i1.AppUser> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppUsersTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<String> id = i0.GeneratedColumn<String>(
      'id', aliasedName, false,
      type: i0.DriftSqlType.string, requiredDuringInsert: true);
  static const i0.VerificationMeta _emailMeta =
      const i0.VerificationMeta('email');
  @override
  late final i0.GeneratedColumn<String> email = i0.GeneratedColumn<String>(
      'email', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const i0.VerificationMeta _usernameMeta =
      const i0.VerificationMeta('username');
  @override
  late final i0.GeneratedColumn<String> username = i0.GeneratedColumn<String>(
      'username', aliasedName, false,
      type: i0.DriftSqlType.string, requiredDuringInsert: true);
  static const i0.VerificationMeta _isEmailVerifiedMeta =
      const i0.VerificationMeta('isEmailVerified');
  @override
  late final i0.GeneratedColumn<bool> isEmailVerified =
      i0.GeneratedColumn<bool>('is_email_verified', aliasedName, false,
          type: i0.DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
              'CHECK ("is_email_verified" IN (0, 1))'),
          defaultValue: const i3.Constant(false));
  static const i0.VerificationMeta _dailyResetTimeMeta =
      const i0.VerificationMeta('dailyResetTime');
  @override
  late final i0.GeneratedColumn<int> dailyResetTime = i0.GeneratedColumn<int>(
      'daily_reset_time', aliasedName, false,
      check: () =>
          dailyResetTime.isBetween(const i3.Constant(0), const i3.Constant(23)),
      type: i0.DriftSqlType.int,
      requiredDuringInsert: true);
  static const i0.VerificationMeta _deviceIdMeta =
      const i0.VerificationMeta('deviceId');
  @override
  late final i0.GeneratedColumn<String> deviceId = i0.GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const i0.VerificationMeta _timezoneIdMeta =
      const i0.VerificationMeta('timezoneId');
  @override
  late final i0.GeneratedColumn<int> timezoneId = i0.GeneratedColumn<int>(
      'timezone_id', aliasedName, false,
      type: i0.DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          i0.GeneratedColumn.constraintIsAlways('REFERENCES time_zones (id)'));
  static const i0.VerificationMeta _lastSyncedAtMeta =
      const i0.VerificationMeta('lastSyncedAt');
  @override
  late final i0.GeneratedColumn<DateTime> lastSyncedAt =
      i0.GeneratedColumn<DateTime>('last_synced_at', aliasedName, false,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<i0.GeneratedColumn> get $columns => [
        id,
        email,
        username,
        isEmailVerified,
        dailyResetTime,
        deviceId,
        timezoneId,
        lastSyncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_users';
  @override
  i0.VerificationContext validateIntegrity(i0.Insertable<i1.AppUser> instance,
      {bool isInserting = false}) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('is_email_verified')) {
      context.handle(
          _isEmailVerifiedMeta,
          isEmailVerified.isAcceptableOrUnknown(
              data['is_email_verified']!, _isEmailVerifiedMeta));
    }
    if (data.containsKey('daily_reset_time')) {
      context.handle(
          _dailyResetTimeMeta,
          dailyResetTime.isAcceptableOrUnknown(
              data['daily_reset_time']!, _dailyResetTimeMeta));
    } else if (isInserting) {
      context.missing(_dailyResetTimeMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('timezone_id')) {
      context.handle(
          _timezoneIdMeta,
          timezoneId.isAcceptableOrUnknown(
              data['timezone_id']!, _timezoneIdMeta));
    } else if (isInserting) {
      context.missing(_timezoneIdMeta);
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
          _lastSyncedAtMeta,
          lastSyncedAt.isAcceptableOrUnknown(
              data['last_synced_at']!, _lastSyncedAtMeta));
    } else if (isInserting) {
      context.missing(_lastSyncedAtMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.AppUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.AppUser(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}id'])!,
      email: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}email'])!,
      username: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}username'])!,
      isEmailVerified: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.bool, data['${effectivePrefix}is_email_verified'])!,
      dailyResetTime: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.int, data['${effectivePrefix}daily_reset_time'])!,
      deviceId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      timezoneId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}timezone_id'])!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at'])!,
    );
  }

  @override
  $AppUsersTable createAlias(String alias) {
    return $AppUsersTable(attachedDatabase, alias);
  }
}

class AppUser extends i0.DataClass implements i0.Insertable<i1.AppUser> {
  final String id;
  final String email;
  final String username;
  final bool isEmailVerified;
  final int dailyResetTime;
  final String deviceId;
  final int timezoneId;
  final DateTime lastSyncedAt;
  const AppUser(
      {required this.id,
      required this.email,
      required this.username,
      required this.isEmailVerified,
      required this.dailyResetTime,
      required this.deviceId,
      required this.timezoneId,
      required this.lastSyncedAt});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<String>(id);
    map['email'] = i0.Variable<String>(email);
    map['username'] = i0.Variable<String>(username);
    map['is_email_verified'] = i0.Variable<bool>(isEmailVerified);
    map['daily_reset_time'] = i0.Variable<int>(dailyResetTime);
    map['device_id'] = i0.Variable<String>(deviceId);
    map['timezone_id'] = i0.Variable<int>(timezoneId);
    map['last_synced_at'] = i0.Variable<DateTime>(lastSyncedAt);
    return map;
  }

  i1.AppUsersCompanion toCompanion(bool nullToAbsent) {
    return i1.AppUsersCompanion(
      id: i0.Value(id),
      email: i0.Value(email),
      username: i0.Value(username),
      isEmailVerified: i0.Value(isEmailVerified),
      dailyResetTime: i0.Value(dailyResetTime),
      deviceId: i0.Value(deviceId),
      timezoneId: i0.Value(timezoneId),
      lastSyncedAt: i0.Value(lastSyncedAt),
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return AppUser(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      username: serializer.fromJson<String>(json['username']),
      isEmailVerified: serializer.fromJson<bool>(json['isEmailVerified']),
      dailyResetTime: serializer.fromJson<int>(json['dailyResetTime']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      timezoneId: serializer.fromJson<int>(json['timezoneId']),
      lastSyncedAt: serializer.fromJson<DateTime>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'username': serializer.toJson<String>(username),
      'isEmailVerified': serializer.toJson<bool>(isEmailVerified),
      'dailyResetTime': serializer.toJson<int>(dailyResetTime),
      'deviceId': serializer.toJson<String>(deviceId),
      'timezoneId': serializer.toJson<int>(timezoneId),
      'lastSyncedAt': serializer.toJson<DateTime>(lastSyncedAt),
    };
  }

  i1.AppUser copyWith(
          {String? id,
          String? email,
          String? username,
          bool? isEmailVerified,
          int? dailyResetTime,
          String? deviceId,
          int? timezoneId,
          DateTime? lastSyncedAt}) =>
      i1.AppUser(
        id: id ?? this.id,
        email: email ?? this.email,
        username: username ?? this.username,
        isEmailVerified: isEmailVerified ?? this.isEmailVerified,
        dailyResetTime: dailyResetTime ?? this.dailyResetTime,
        deviceId: deviceId ?? this.deviceId,
        timezoneId: timezoneId ?? this.timezoneId,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      );
  @override
  String toString() {
    return (StringBuffer('AppUser(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('username: $username, ')
          ..write('isEmailVerified: $isEmailVerified, ')
          ..write('dailyResetTime: $dailyResetTime, ')
          ..write('deviceId: $deviceId, ')
          ..write('timezoneId: $timezoneId, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, email, username, isEmailVerified,
      dailyResetTime, deviceId, timezoneId, lastSyncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.AppUser &&
          other.id == this.id &&
          other.email == this.email &&
          other.username == this.username &&
          other.isEmailVerified == this.isEmailVerified &&
          other.dailyResetTime == this.dailyResetTime &&
          other.deviceId == this.deviceId &&
          other.timezoneId == this.timezoneId &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class AppUsersCompanion extends i0.UpdateCompanion<i1.AppUser> {
  final i0.Value<String> id;
  final i0.Value<String> email;
  final i0.Value<String> username;
  final i0.Value<bool> isEmailVerified;
  final i0.Value<int> dailyResetTime;
  final i0.Value<String> deviceId;
  final i0.Value<int> timezoneId;
  final i0.Value<DateTime> lastSyncedAt;
  final i0.Value<int> rowid;
  const AppUsersCompanion({
    this.id = const i0.Value.absent(),
    this.email = const i0.Value.absent(),
    this.username = const i0.Value.absent(),
    this.isEmailVerified = const i0.Value.absent(),
    this.dailyResetTime = const i0.Value.absent(),
    this.deviceId = const i0.Value.absent(),
    this.timezoneId = const i0.Value.absent(),
    this.lastSyncedAt = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  AppUsersCompanion.insert({
    required String id,
    required String email,
    required String username,
    this.isEmailVerified = const i0.Value.absent(),
    required int dailyResetTime,
    required String deviceId,
    required int timezoneId,
    required DateTime lastSyncedAt,
    this.rowid = const i0.Value.absent(),
  })  : id = i0.Value(id),
        email = i0.Value(email),
        username = i0.Value(username),
        dailyResetTime = i0.Value(dailyResetTime),
        deviceId = i0.Value(deviceId),
        timezoneId = i0.Value(timezoneId),
        lastSyncedAt = i0.Value(lastSyncedAt);
  static i0.Insertable<i1.AppUser> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? email,
    i0.Expression<String>? username,
    i0.Expression<bool>? isEmailVerified,
    i0.Expression<int>? dailyResetTime,
    i0.Expression<String>? deviceId,
    i0.Expression<int>? timezoneId,
    i0.Expression<DateTime>? lastSyncedAt,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (username != null) 'username': username,
      if (isEmailVerified != null) 'is_email_verified': isEmailVerified,
      if (dailyResetTime != null) 'daily_reset_time': dailyResetTime,
      if (deviceId != null) 'device_id': deviceId,
      if (timezoneId != null) 'timezone_id': timezoneId,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.AppUsersCompanion copyWith(
      {i0.Value<String>? id,
      i0.Value<String>? email,
      i0.Value<String>? username,
      i0.Value<bool>? isEmailVerified,
      i0.Value<int>? dailyResetTime,
      i0.Value<String>? deviceId,
      i0.Value<int>? timezoneId,
      i0.Value<DateTime>? lastSyncedAt,
      i0.Value<int>? rowid}) {
    return i1.AppUsersCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      dailyResetTime: dailyResetTime ?? this.dailyResetTime,
      deviceId: deviceId ?? this.deviceId,
      timezoneId: timezoneId ?? this.timezoneId,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = i0.Variable<String>(email.value);
    }
    if (username.present) {
      map['username'] = i0.Variable<String>(username.value);
    }
    if (isEmailVerified.present) {
      map['is_email_verified'] = i0.Variable<bool>(isEmailVerified.value);
    }
    if (dailyResetTime.present) {
      map['daily_reset_time'] = i0.Variable<int>(dailyResetTime.value);
    }
    if (deviceId.present) {
      map['device_id'] = i0.Variable<String>(deviceId.value);
    }
    if (timezoneId.present) {
      map['timezone_id'] = i0.Variable<int>(timezoneId.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = i0.Variable<DateTime>(lastSyncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppUsersCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('username: $username, ')
          ..write('isEmailVerified: $isEmailVerified, ')
          ..write('dailyResetTime: $dailyResetTime, ')
          ..write('deviceId: $deviceId, ')
          ..write('timezoneId: $timezoneId, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

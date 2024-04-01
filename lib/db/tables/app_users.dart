import 'package:drift/drift.dart';
import 'package:memori_app/db/tables/time_zones.dart';

class AppUsers extends Table {
  @override
  String get tableName => 'app_users';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text()();
  TextColumn get email => text().unique()();
  TextColumn get username => text()();
  BoolColumn get isEmailVerified =>
      boolean().withDefault(const Constant(false))();
  IntColumn get dailyResetTime => integer()
      // ignore: recursive_getters
      .check(dailyResetTime.isBetween(const Constant(0), const Constant(23)))();
  TextColumn get deviceId => text().unique()();
  IntColumn get timezoneId => integer().references(TimeZones, #id)();
  DateTimeColumn get lastSyncedAt => dateTime()();
  // storage_size_in_byte bigint NOT NULL, (Not implemented)
  // tier tinyint NOT NULL, (Not implemented)
  // CONSTRAINT app_user_tier_check CHECK (((tier >= 0) AND (tier <= 1))),
}

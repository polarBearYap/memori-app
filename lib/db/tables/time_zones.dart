import 'package:drift/drift.dart';

@TableIndex(
  name: 'idx_region',
  columns: {
    #region,
  },
  unique: false,
)
@TableIndex(
  name: 'id_code',
  columns: {
    #code,
  },
  unique: true,
)
@DataClassName("TimeZone")
class TimeZones extends Table {
  @override
  String get tableName => 'time_zones';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get region => text()();
  TextColumn get city => text()();
  TextColumn get code => text().unique()();
}
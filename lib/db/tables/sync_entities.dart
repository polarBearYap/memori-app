import 'package:drift/drift.dart';
import 'package:memori_app/db/tables/app_users.dart';

@TableIndex(
  name: 'idx_created_at',
  columns: {
    #createdAt,
  },
  unique: false,
)
@TableIndex(
  name: 'idx_sort_order',
  columns: {
    #sortOrder,
  },
  unique: false,
)
@TableIndex(
  name: 'idx_user_id',
  columns: {
    #userId,
  },
  unique: false,
)
@DataClassName("SyncEntity")
class SyncEntities extends Table {
  @override
  String get tableName => 'sync_entities';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text()();
  // @JsonKey('useful_hint_text')
  IntColumn get sortOrder => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  DateTimeColumn get lastModified => dateTime()();
  DateTimeColumn get syncedAt => dateTime()();
  IntColumn get version => integer()();
  TextColumn get modifiedByDeviceId => text()();
  TextColumn get entityType => text()();
  TextColumn get userId => text().references(AppUsers, #id)();
  DateTimeColumn get localLastSyncedAt => dateTime().nullable()();
}

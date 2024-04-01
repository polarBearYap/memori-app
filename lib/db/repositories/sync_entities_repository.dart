import 'package:drift/drift.dart';

import 'package:memori_app/db/database.dart';

import 'package:memori_app/db/tables/sync_entities.dart';
import 'package:memori_app/db/tables/sync_entities.drift.dart';
import 'package:memori_app/db/repositories/sync_entities_repository.drift.dart';

@DriftAccessor(tables: [
  SyncEntities,
],)
class SyncEntitiesRepository extends DatabaseAccessor<AppDb>
    with $SyncEntitiesRepositoryMixin {
  SyncEntitiesRepository(super.db);

  Future<SyncEntity?> getEntity(final String id) => (select(syncEntities)..where((final tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

  Future<int> addEntity(final SyncEntitiesCompanion entry) => into(syncEntities).insert(entry);

  Future updateEntity(final SyncEntity entry) => update(syncEntities).replace(entry);

  Future deleteEntity(final String id) => (delete(syncEntities)..where((final t) => t.id.equals(id))).go();
}

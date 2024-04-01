import 'package:drift/drift.dart';
import 'package:memori_app/db/database.dart';
import 'package:memori_app/db/repositories/app_users_repository.drift.dart';
import 'package:memori_app/db/tables/app_users.dart';
import 'package:memori_app/db/tables/app_users.drift.dart';

@DriftAccessor(tables: [
  AppUsers,
],)
class AppUsersRepository extends DatabaseAccessor<AppDb>
    with $AppUsersRepositoryMixin {
  AppUsersRepository(super.db);

  Future<AppUser?> getEntity(final String id) => (select(appUsers)..where((final tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

  Future<int> addEntity(final AppUsersCompanion entry) => into(appUsers).insert(entry);

  Future updateEntity(final AppUsersCompanion entry) => update(appUsers).replace(entry);

  Future deleteEntity(final String id) => (delete(appUsers)..where((final t) => t.id.equals(id))).go();
}

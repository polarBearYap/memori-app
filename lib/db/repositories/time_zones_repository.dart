import 'package:drift/drift.dart';

import 'package:memori_app/db/database.dart';
import 'package:memori_app/db/tables/time_zones.dart';
import 'package:memori_app/db/tables/time_zones.drift.dart';
import 'package:memori_app/db/repositories/time_zones_repository.drift.dart';

@DriftAccessor(tables: [
  TimeZones,
],)
class TimeZonesRepository extends DatabaseAccessor<AppDb>
    with $TimeZonesRepositoryMixin {
  TimeZonesRepository(super.db);

  Future<int?> countEntity() async {
    final query = selectOnly(timeZones)..addColumns([timeZones.id.count()]);
    final result = await query.getSingle();
    return result.read(timeZones.id.count());
  }

  Future<TimeZone?> getEntity(final String code) => (select(timeZones)..where((final tbl) => tbl.code.equals(code)))
        .getSingleOrNull();
}

// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:memori_app/db/database.dart' as i1;
import 'package:memori_app/db/tables/time_zones.drift.dart' as i2;
import 'package:drift/internal/modular.dart' as i3;
import 'package:memori_app/db/tables/app_users.drift.dart' as i4;

mixin $AppUsersRepositoryMixin on i0.DatabaseAccessor<i1.AppDb> {
  i2.$TimeZonesTable get timeZones =>
      i3.ReadDatabaseContainer(attachedDatabase).resultSet('time_zones');
  i4.$AppUsersTable get appUsers =>
      i3.ReadDatabaseContainer(attachedDatabase).resultSet('app_users');
}

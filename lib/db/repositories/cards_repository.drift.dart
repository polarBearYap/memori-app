// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:memori_app/db/database.dart' as i1;
import 'package:memori_app/db/tables/time_zones.drift.dart' as i2;
import 'package:drift/internal/modular.dart' as i3;
import 'package:memori_app/db/tables/app_users.drift.dart' as i4;
import 'package:memori_app/db/tables/sync_entities.drift.dart' as i5;
import 'package:memori_app/db/tables/deck_settings.drift.dart' as i6;
import 'package:memori_app/db/tables/decks.drift.dart' as i7;
import 'package:memori_app/db/tables/cards.drift.dart' as i8;

mixin $CardsRepositoryMixin on i0.DatabaseAccessor<i1.AppDb> {
  i2.$TimeZonesTable get timeZones =>
      i3.ReadDatabaseContainer(attachedDatabase).resultSet('time_zones');
  i4.$AppUsersTable get appUsers =>
      i3.ReadDatabaseContainer(attachedDatabase).resultSet('app_users');
  i5.$SyncEntitiesTable get syncEntities =>
      i3.ReadDatabaseContainer(attachedDatabase).resultSet('sync_entities');
  i6.$DeckSettingsTable get deckSettings =>
      i3.ReadDatabaseContainer(attachedDatabase).resultSet('deck_settings');
  i7.$DecksTable get decks =>
      i3.ReadDatabaseContainer(attachedDatabase).resultSet('deck');
  i8.$CardsTable get cards =>
      i3.ReadDatabaseContainer(attachedDatabase).resultSet('cards');
}

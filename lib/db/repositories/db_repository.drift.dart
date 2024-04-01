// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:drift/internal/modular.dart' as i3;
import 'package:memori_app/db/database.dart' as i1;
import 'package:memori_app/db/tables/app_users.drift.dart' as i4;
import 'package:memori_app/db/tables/card_schedule_history.drift.dart' as i12;
import 'package:memori_app/db/tables/card_tag_mappings.drift.dart' as i10;
import 'package:memori_app/db/tables/card_tags.drift.dart' as i9;
import 'package:memori_app/db/tables/cards.drift.dart' as i8;
import 'package:memori_app/db/tables/conflicted_rows.drift.dart' as i14;
import 'package:memori_app/db/tables/deck_learn_histories.drift.dart' as i11;
import 'package:memori_app/db/tables/deck_settings.drift.dart' as i6;
import 'package:memori_app/db/tables/decks.drift.dart' as i7;
import 'package:memori_app/db/tables/review_logs.drift.dart' as i13;
import 'package:memori_app/db/tables/sync_entities.drift.dart' as i5;
import 'package:memori_app/db/tables/time_zones.drift.dart' as i2;

mixin $DbRepositoryMixin on i0.DatabaseAccessor<i1.AppDb> {
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
  i9.$CardTagsTable get cardTags =>
      i3.ReadDatabaseContainer(attachedDatabase).resultSet('card_tags');
  i10.$CardTagMappingsTable get cardTagMappings =>
      i3.ReadDatabaseContainer(attachedDatabase).resultSet('card_tag_mappings');
  i11.$DeckLearnHistoriesTable get deckLearnHistories =>
      i3.ReadDatabaseContainer(attachedDatabase)
          .resultSet('deck_learn_histories');
  i12.$CardScheduleHistoriesTable get cardScheduleHistories =>
      i3.ReadDatabaseContainer(attachedDatabase)
          .resultSet('card_schedule_histories');
  i13.$ReviewLogsTable get reviewLogs =>
      i3.ReadDatabaseContainer(attachedDatabase).resultSet('review_logs');
  i14.$ConflictedRowsTable get conflictedRows =>
      i3.ReadDatabaseContainer(attachedDatabase).resultSet('conflicted_rows');
}

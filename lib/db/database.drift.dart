// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:memori_app/db/tables/time_zones.drift.dart' as i1;
import 'package:memori_app/db/tables/app_users.drift.dart' as i2;
import 'package:memori_app/db/tables/sync_entities.drift.dart' as i3;
import 'package:memori_app/db/tables/card_tags.drift.dart' as i4;
import 'package:memori_app/db/tables/deck_settings.drift.dart' as i5;
import 'package:memori_app/db/tables/deck_tags.drift.dart' as i6;
import 'package:memori_app/db/tables/study_options.drift.dart' as i7;
import 'package:memori_app/db/tables/decks.drift.dart' as i8;
import 'package:memori_app/db/tables/study_option_states.drift.dart' as i9;
import 'package:memori_app/db/tables/study_option_tags.drift.dart' as i10;
import 'package:memori_app/db/tables/cards.drift.dart' as i11;
import 'package:memori_app/db/tables/deck_images.drift.dart' as i12;
import 'package:memori_app/db/tables/deck_reviews.drift.dart' as i13;
import 'package:memori_app/db/tables/deck_tag_mappings.drift.dart' as i14;
import 'package:memori_app/db/tables/study_option_decks.drift.dart' as i15;
import 'package:memori_app/db/tables/card_hints.drift.dart' as i16;
import 'package:memori_app/db/tables/card_tag_mappings.drift.dart' as i17;
import 'package:memori_app/db/tables/review_logs.drift.dart' as i18;
import 'package:memori_app/db/tables/deck_learn_histories.drift.dart' as i19;
import 'package:memori_app/db/tables/card_schedule_history.drift.dart' as i20;
import 'package:memori_app/db/tables/conflicted_rows.drift.dart' as i21;
import 'package:memori_app/db/repositories/app_users_repository.dart' as i22;
import 'package:memori_app/db/database.dart' as i23;
import 'package:memori_app/db/repositories/cards_repository.dart' as i24;
import 'package:memori_app/db/repositories/sync_entities_repository.dart'
    as i25;
import 'package:memori_app/db/repositories/time_zones_repository.dart' as i26;
import 'package:memori_app/db/repositories/db_repository.dart' as i27;

abstract class $AppDb extends i0.GeneratedDatabase {
  $AppDb(i0.QueryExecutor e) : super(e);
  late final i1.$TimeZonesTable timeZones = i1.$TimeZonesTable(this);
  late final i2.$AppUsersTable appUsers = i2.$AppUsersTable(this);
  late final i3.$SyncEntitiesTable syncEntities = i3.$SyncEntitiesTable(this);
  late final i4.$CardTagsTable cardTags = i4.$CardTagsTable(this);
  late final i5.$DeckSettingsTable deckSettings = i5.$DeckSettingsTable(this);
  late final i6.$DeckTagsTable deckTags = i6.$DeckTagsTable(this);
  late final i7.$StudyOptionsTable studyOptions = i7.$StudyOptionsTable(this);
  late final i8.$DecksTable decks = i8.$DecksTable(this);
  late final i9.$StudyOptionStatesTable studyOptionStates =
      i9.$StudyOptionStatesTable(this);
  late final i10.$StudyOptionTagsTable studyOptionTags =
      i10.$StudyOptionTagsTable(this);
  late final i11.$CardsTable cards = i11.$CardsTable(this);
  late final i12.$DeckImagesTable deckImages = i12.$DeckImagesTable(this);
  late final i13.$DeckReviewsTable deckReviews = i13.$DeckReviewsTable(this);
  late final i14.$DeckTagMappingsTable deckTagMappings =
      i14.$DeckTagMappingsTable(this);
  late final i15.$StudyOptionDecksTable studyOptionDecks =
      i15.$StudyOptionDecksTable(this);
  late final i16.$CardHintsTable cardHints = i16.$CardHintsTable(this);
  late final i17.$CardTagMappingsTable cardTagMappings =
      i17.$CardTagMappingsTable(this);
  late final i18.$ReviewLogsTable reviewLogs = i18.$ReviewLogsTable(this);
  late final i19.$DeckLearnHistoriesTable deckLearnHistories =
      i19.$DeckLearnHistoriesTable(this);
  late final i20.$CardScheduleHistoriesTable cardScheduleHistories =
      i20.$CardScheduleHistoriesTable(this);
  late final i21.$ConflictedRowsTable conflictedRows =
      i21.$ConflictedRowsTable(this);
  late final i22.AppUsersRepository appUsersRepository =
      i22.AppUsersRepository(this as i23.AppDb);
  late final i24.CardsRepository cardsRepository =
      i24.CardsRepository(this as i23.AppDb);
  late final i25.SyncEntitiesRepository syncEntitiesRepository =
      i25.SyncEntitiesRepository(this as i23.AppDb);
  late final i26.TimeZonesRepository timeZonesRepository =
      i26.TimeZonesRepository(this as i23.AppDb);
  late final i27.DbRepository dbRepository =
      i27.DbRepository(this as i23.AppDb);
  @override
  Iterable<i0.TableInfo<i0.Table, Object?>> get allTables =>
      allSchemaEntities.whereType<i0.TableInfo<i0.Table, Object?>>();
  @override
  List<i0.DatabaseSchemaEntity> get allSchemaEntities => [
        timeZones,
        appUsers,
        syncEntities,
        cardTags,
        deckSettings,
        deckTags,
        studyOptions,
        decks,
        studyOptionStates,
        studyOptionTags,
        cards,
        deckImages,
        deckReviews,
        deckTagMappings,
        studyOptionDecks,
        cardHints,
        cardTagMappings,
        reviewLogs,
        deckLearnHistories,
        cardScheduleHistories,
        conflictedRows,
        i3.idxCreatedAt,
        i3.idxSortOrder,
        i3.idxUserId,
        i1.idxRegion,
        i1.idCode
      ];
  @override
  i0.DriftDatabaseOptions get options =>
      const i0.DriftDatabaseOptions(storeDateTimeAsText: true);
}

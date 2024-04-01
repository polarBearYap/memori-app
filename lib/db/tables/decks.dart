import 'package:drift/drift.dart';
import 'package:memori_app/db/tables/deck_settings.dart';
import 'package:memori_app/db/tables/sync_entities.dart';

@DataClassName("Deck")
class Decks extends Table {
  @override
  String get tableName => 'deck';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().references(SyncEntities, #id)();
  TextColumn get deckSettingsId => text().references(DeckSettings, #id)();
  TextColumn get name => text()();
  TextColumn get description => text()();
  IntColumn get newCount => integer()();
  IntColumn get learningCount => integer()();
  IntColumn get reviewCount => integer()();
  IntColumn get totalCount => integer()();
  TextColumn get shareCode => text()();
  BoolColumn get canShareExpired => boolean()();
  DateTimeColumn get shareExpirationTime => dateTime()();
  DateTimeColumn get lastReviewTime => dateTime().nullable()();
}

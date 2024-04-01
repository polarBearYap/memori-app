import 'package:drift/drift.dart';

import 'package:memori_app/db/tables/decks.dart';
import 'package:memori_app/db/tables/sync_entities.dart';

@DataClassName("DeckImage")
class DeckImages extends Table {
  @override
  String get tableName => 'deck_images';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().references(SyncEntities, #id)();
  TextColumn get deckId => text().references(Decks, #id)();
  BlobColumn get imageData => blob().nullable()();
}
import 'package:drift/drift.dart';

import 'package:memori_app/db/tables/deck_tags.dart';
import 'package:memori_app/db/tables/decks.dart';
import 'package:memori_app/db/tables/sync_entities.dart';

@DataClassName("DeckTagMapping")
class DeckTagMappings extends Table {
  @override
  String get tableName => 'deck_tag_mappings';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().references(SyncEntities, #id)();
  TextColumn get deckId => text().references(Decks, #id)();
  TextColumn get deckTagId => text().references(DeckTags, #id)();
}
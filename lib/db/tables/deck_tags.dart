import 'package:drift/drift.dart';

import 'package:memori_app/db/tables/sync_entities.dart';

@DataClassName("DeckTag")
class DeckTags extends Table {
  @override
  String get tableName => 'deck_tags';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().references(SyncEntities, #id)();
  TextColumn get name => text()();
}
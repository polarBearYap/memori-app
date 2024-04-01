import 'package:drift/drift.dart';

import 'package:memori_app/db/tables/sync_entities.dart';

@DataClassName("CardTag")
class CardTags extends Table {
  @override
  String get tableName => 'card_tags';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().references(SyncEntities, #id)();
  TextColumn get name => text()();
}
import 'package:drift/drift.dart';

import 'package:memori_app/db/tables/card_tags.dart';
import 'package:memori_app/db/tables/cards.dart';
import 'package:memori_app/db/tables/sync_entities.dart';

@DataClassName("CardTagMapping")
class CardTagMappings extends Table {
  @override
  String get tableName => 'card_tag_mappings';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().references(SyncEntities, #id)();
  TextColumn get cardId => text().references(Cards, #id)();
  TextColumn get cardTagId => text().references(CardTags, #id)();
}
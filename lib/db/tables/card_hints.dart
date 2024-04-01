import 'package:drift/drift.dart';

import 'package:memori_app/db/tables/cards.dart';
import 'package:memori_app/db/tables/sync_entities.dart';

@DataClassName("CardHint")
class CardHints extends Table {
  @override
  String get tableName => 'card_hints';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().references(SyncEntities, #id)();
  TextColumn get cardId => text().references(Cards, #id)();
  BlobColumn get hintText => blob()();
  IntColumn get displayOrder => integer()();
}
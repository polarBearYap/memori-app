import 'package:drift/drift.dart';
import 'package:memori_app/db/tables/app_users.dart';
import 'package:memori_app/db/tables/decks.dart';

@DataClassName("DeckLearnHistory")
class DeckLearnHistories extends Table {
  @override
  String get tableName => 'deck_learn_histories';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text()();
  IntColumn get currentProgress => integer()();
  TextColumn get cardIds => text()();
  IntColumn get newCount => integer()();
  IntColumn get learningCount => integer()();
  IntColumn get reviewCount => integer()();
  TextColumn get deckId => text().references(Decks, #id)();
  TextColumn get userId => text().references(AppUsers, #id)();
}

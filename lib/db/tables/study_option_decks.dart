import 'package:drift/drift.dart';

import 'package:memori_app/db/tables/decks.dart';
import 'package:memori_app/db/tables/study_options.dart';
import 'package:memori_app/db/tables/sync_entities.dart';

@DataClassName("StudyOptionDeck")
class StudyOptionDecks extends Table {
  @override
  String get tableName => 'study_option_decks';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().references(SyncEntities, #id)();
  TextColumn get studyOptionId => text().references(StudyOptions, #id)();
  TextColumn get deckId => text().references(Decks, #id)();
}

import 'package:drift/drift.dart';

import 'package:memori_app/db/tables/card_tags.dart';
import 'package:memori_app/db/tables/study_options.dart';
import 'package:memori_app/db/tables/sync_entities.dart';

@DataClassName("StudyOptionTag")
class StudyOptionTags extends Table {
  @override
  String get tableName => 'study_option_tags';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().references(SyncEntities, #id)();
  TextColumn get studyOptionId => text().references(StudyOptions, #id)();
  TextColumn get cardTagId => text().references(CardTags, #id)();
}

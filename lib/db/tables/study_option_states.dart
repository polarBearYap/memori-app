import 'package:drift/drift.dart';

import 'package:memori_app/db/tables/study_options.dart';
import 'package:memori_app/db/tables/sync_entities.dart';

@DataClassName("StudyOptionState")
class StudyOptionStates extends Table {
  @override
  String get tableName => 'study_option_states';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().references(SyncEntities, #id)();
  TextColumn get studyOptionId => text().references(StudyOptions, #id)();
  IntColumn get state =>
      // ignore: recursive_getters
      integer().check(state.isBetween(const Constant(0), const Constant(3)))();
}
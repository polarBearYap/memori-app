// ignore_for_file: constant_identifier_names

import 'package:drift/drift.dart';
import 'package:memori_app/db/tables/sync_entities.dart';

class Priority {
  static const Priority RANDOM = Priority._(1);
  static const Priority FIRST = Priority._(2);
  static const Priority SECOND = Priority._(3);
  static const Priority THIRD = Priority._(4);

  final int value;

  const Priority._(this.value);

  int getValue() => value;

  static Priority fromValue(final int value) {
    for (Priority priority in Priority.values) {
      if (priority.getValue() == value) {
        return priority;
      }
    }
    throw ArgumentError("No matching priority for value: $value");
  }

  static bool isValidCode(final int value) {
    for (Priority priority in Priority.values) {
      if (priority.getValue() == value) return true;
    }
    return false;
  }

  static List<Priority> get values => [
        RANDOM,
        FIRST,
        SECOND,
        THIRD,
      ];
}

@DataClassName("DeckSetting")
class DeckSettings extends Table {
  @override
  String get tableName => 'deck_settings';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().references(SyncEntities, #id)();
  TextColumn get learningSteps => text()();
  TextColumn get reLearningSteps => text()();
  RealColumn get desiredRetention => real()();
  BoolColumn get isDefault => boolean()();
  IntColumn get maxNewCardsPerDay => integer()();
  IntColumn get maxReviewPerDay => integer()();
  IntColumn get maximumAnswerSeconds => integer()();
  BoolColumn get skipNewCard => boolean()();
  BoolColumn get skipLearningCard => boolean()();
  BoolColumn get skipReviewCard => boolean()();
  IntColumn get newPriority => integer()
      // ignore: recursive_getters
      .check(newPriority.isBetween(const Constant(1), const Constant(4)))();
  IntColumn get interdayPriority => integer().check(
        // ignore: recursive_getters
        interdayPriority.isBetween(const Constant(1), const Constant(4)),
      )();
  IntColumn get reviewPriority => integer().check(
        // ignore: recursive_getters
        reviewPriority.isBetween(const Constant(1), const Constant(4)),
      )();
}

// ignore_for_file: constant_identifier_names

import 'package:drift/drift.dart';

import 'package:memori_app/db/tables/sync_entities.dart';

class Mode {
  static const Mode PREVIEW = Mode._(1);
  static const Mode STUDY = Mode._(2);

  final int value;

  const Mode._(this.value);

  int getValue() => value;

  static Mode fromValue(final int value) {
    for (Mode mode in Mode.values) {
      if (mode.getValue() == value) {
        return mode;
      }
    }
    throw ArgumentError("No matching mode for value: $value");
  }

  static bool isValidCode(final int value) {
    for (Mode mode in Mode.values) {
      if (mode.getValue() == value) return true;
    }
    return false;
  }

  static List<Mode> get values => [
        PREVIEW,
        STUDY,
      ];
}

class SortOption {
  static const SortOption RANDOM = SortOption._(1);
  static const SortOption MOST_DIFFICULT_FIRST = SortOption._(2);
  static const SortOption MOST_DIFFICULT_LAST = SortOption._(3);
  static const SortOption MOST_FORGOTTEN_FIRST = SortOption._(4);
  static const SortOption MOST_FORGOTTEN_LAST = SortOption._(5);
  static const SortOption EARLIEST_ADDED_FIRST = SortOption._(6);
  static const SortOption EARLIEST_ADDED_LAST = SortOption._(7);
  static const SortOption MOST_DUE_FIRST = SortOption._(8);
  static const SortOption MOST_DUE_LAST = SortOption._(9);

  final int value;

  const SortOption._(this.value);

  int getValue() => value;

  static SortOption fromValue(final int value) {
    for (SortOption sortOption in SortOption.values) {
      if (sortOption.getValue() == value) {
        return sortOption;
      }
    }
    throw ArgumentError("No matching sortOption for value: $value");
  }

  static bool isValidCode(final int value) {
    for (SortOption sortOption in SortOption.values) {
      if (sortOption.getValue() == value) return true;
    }
    return false;
  }

  static List<SortOption> get values => [
        RANDOM,
        MOST_DIFFICULT_FIRST,
        MOST_DIFFICULT_LAST,
        MOST_FORGOTTEN_FIRST,
        MOST_FORGOTTEN_LAST,
        EARLIEST_ADDED_FIRST,
        EARLIEST_ADDED_LAST,
        MOST_DUE_FIRST,
        MOST_DUE_LAST,
      ];
}

@DataClassName("StudyOption")
class StudyOptions extends Table {
  @override
  String get tableName => 'study_options';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().references(SyncEntities, #id)();
  IntColumn get mode =>
      // ignore: recursive_getters
      integer().check(mode.isBetween(const Constant(1), const Constant(2)))();
  IntColumn get sortOption =>
      // ignore: recursive_getters
      integer().check(sortOption.isBetween(const Constant(1), const Constant(9)))();
}

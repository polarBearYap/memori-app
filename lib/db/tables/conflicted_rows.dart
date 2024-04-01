// ignore_for_file: constant_identifier_names

import 'package:drift/drift.dart';
import 'package:memori_app/db/tables/app_users.dart';

class Source {
  static const Source PUSH_TO_CLOUD = Source._(1);
  static const Source PULL_FROM_CLOUD = Source._(2);

  final int value;

  const Source._(this.value);

  int getValue() => value;

  static Source fromValue(final int value) {
    for (Source source in Source.values) {
      if (source.getValue() == value) {
        return source;
      }
    }
    throw ArgumentError("No matching source for value: $value");
  }

  static bool isValidCode(final int value) {
    for (Source source in Source.values) {
      if (source.getValue() == value) return true;
    }
    return false;
  }

  static List<Source> get values => [
        PUSH_TO_CLOUD,
        PULL_FROM_CLOUD,
      ];
}

@DataClassName("ConflictedRow")
class ConflictedRows extends Table {
  @override
  String get tableName => 'conflicted_rows';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text()();
  IntColumn get source =>
      // ignore: recursive_getters
      integer().check(source.isBetween(const Constant(1), const Constant(2)))();
  TextColumn get userId => text().references(AppUsers, #id)();
}

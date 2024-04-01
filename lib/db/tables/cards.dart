// ignore_for_file: constant_identifier_names

import 'package:drift/drift.dart';
import 'package:memori_app/db/tables/decks.dart';
import 'package:memori_app/db/tables/sync_entities.dart';

/*
class State(IntEnum):
    New = 0
    Learning = 1
    Review = 2
    Relearning = 3
*/

class State {
  static const State NEW = State._(0);
  static const State LEARNING = State._(1);
  static const State REVIEW = State._(2);
  static const State RELEARNING = State._(3);

  final int value;

  const State._(this.value);

  int getValue() => value;

  static State fromValue(final int value) {
    for (State state in State.values) {
      if (state.getValue() == value) {
        return state;
      }
    }
    throw ArgumentError("No matching state for value: $value");
  }

  static bool isValidCode(final int value) {
    for (State state in State.values) {
      if (state.getValue() == value) return true;
    }
    return false;
  }

  static List<State> get values => [
        NEW,
        LEARNING,
        REVIEW,
        RELEARNING,
      ];
}

@DataClassName("Card")
class Cards extends Table {
  @override
  String get tableName => 'cards';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().references(SyncEntities, #id)();
  TextColumn get deckId => text().references(Decks, #id)();
  TextColumn get front => text()();
  TextColumn get back => text()();
  TextColumn get frontPlainText => text()();
  TextColumn get backPlainText => text()();
  TextColumn get explanation => text()();
  IntColumn get displayOrder => integer()();
  IntColumn get lapses => integer()();
  IntColumn get reps => integer()();
  IntColumn get elapsedDays => integer()();
  IntColumn get scheduledDays => integer()();
  RealColumn get difficulty => real()();
  RealColumn get stability => real()();
  BoolColumn get isSuspended => boolean()();
  DateTimeColumn get due => dateTime()();
  DateTimeColumn get actualDue => dateTime()();
  DateTimeColumn get lastReview => dateTime()();
  IntColumn get state =>
      // ignore: recursive_getters
      integer().check(state.isBetween(const Constant(0), const Constant(3)))();
}

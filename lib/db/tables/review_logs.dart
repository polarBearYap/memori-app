// ignore_for_file: constant_identifier_names

import 'package:drift/drift.dart';

import 'package:memori_app/db/tables/cards.dart';
import 'package:memori_app/db/tables/sync_entities.dart';

class CardRating {
  static const CardRating AGAIN = CardRating._(1);
  static const CardRating HARD = CardRating._(2);
  static const CardRating GOOD = CardRating._(3);
  static const CardRating EASY = CardRating._(4);

  final int value;

  const CardRating._(this.value);

  int getValue() => value;

  static CardRating fromValue(final int value) {
    for (CardRating rating in CardRating.values) {
      if (rating.getValue() == value) {
        return rating;
      }
    }
    throw ArgumentError("No matching rating for value: $value");
  }

  static bool isValidCode(final int value) {
    for (CardRating rating in CardRating.values) {
      if (rating.getValue() == value) return true;
    }
    return false;
  }

  static List<CardRating> get values => [
        AGAIN,
        HARD,
        GOOD,
        EASY,
      ];
}

@DataClassName("ReviewLog")
class ReviewLogs extends Table {
  @override
  String get tableName => 'review_logs';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().references(SyncEntities, #id)();
  TextColumn get cardId => text().references(Cards, #id)();
  IntColumn get elapsedDays => integer()();
  IntColumn get scheduledDays => integer()();
  DateTimeColumn get review => dateTime()();
  DateTimeColumn get lastReview => dateTime()();
  IntColumn get reviewDurationInMs => integer()();
  IntColumn get state =>
      // ignore: recursive_getters
      integer().check(state.isBetween(const Constant(0), const Constant(3)))();
  IntColumn get rating =>
      // ignore: recursive_getters
      integer().check(rating.isBetween(const Constant(1), const Constant(4)))();
}

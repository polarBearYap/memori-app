// ignore_for_file: constant_identifier_names

import 'package:drift/drift.dart';

import 'package:memori_app/db/tables/decks.dart';
import 'package:memori_app/db/tables/sync_entities.dart';

class Rating {
  static const Rating ONE = Rating._(1);
  static const Rating TWO = Rating._(2);
  static const Rating THREE = Rating._(3);
  static const Rating FOUR = Rating._(4);
  static const Rating FIVE = Rating._(5);

  final int value;

  const Rating._(this.value);

  int getValue() => value;

  static Rating fromValue(final int value) {
    for (Rating rating in Rating.values) {
      if (rating.getValue() == value) {
        return rating;
      }
    }
    throw ArgumentError("No matching rating for value: $value");
  }

  static bool isValidCode(final int value) {
    for (Rating rating in Rating.values) {
      if (rating.getValue() == value) return true;
    }
    return false;
  }

  static List<Rating> get values => [
        ONE,
        TWO,
        THREE,
        FOUR,
        FIVE,
      ];
}

@DataClassName("DeckReview")
class DeckReviews extends Table {
  @override
  String get tableName => 'deck_reviews';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().references(SyncEntities, #id)();
  TextColumn get deckId => text().references(Decks, #id)();
  BlobColumn get comment => blob()();
  IntColumn get rating =>
      // ignore: recursive_getters
      integer().check(rating.isBetween(const Constant(1), const Constant(5)))();
}
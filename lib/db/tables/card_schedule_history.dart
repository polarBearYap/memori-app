import 'package:drift/drift.dart';
import 'package:memori_app/db/tables/app_users.dart';
import 'package:memori_app/db/tables/cards.dart';

@DataClassName("CardScheduleHistory")
class CardScheduleHistories extends Table {
  @override
  String get tableName => 'card_schedule_histories';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text()();
  IntColumn get lapses => integer()();
  IntColumn get reps => integer()();
  IntColumn get elapsedDays => integer()();
  IntColumn get scheduledDays => integer()();
  RealColumn get difficulty => real()();
  RealColumn get stability => real()();
  DateTimeColumn get due => dateTime()();
  DateTimeColumn get lastReview => dateTime()();
  DateTimeColumn get review => dateTime()();
  IntColumn get state =>
      // ignore: recursive_getters
      integer().check(state.isBetween(const Constant(0), const Constant(3)))();
  IntColumn get rating =>
      // ignore: recursive_getters
      integer().check(rating.isBetween(const Constant(1), const Constant(4)))();
  TextColumn get cardId => text().references(Cards, #id)();
  TextColumn get userId => text().references(AppUsers, #id)();
}

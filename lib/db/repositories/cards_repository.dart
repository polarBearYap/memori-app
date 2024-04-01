import 'package:drift/drift.dart';
import 'package:memori_app/db/database.dart';
import 'package:memori_app/db/repositories/cards_repository.drift.dart';
import 'package:memori_app/db/tables/cards.dart';
import 'package:memori_app/db/tables/cards.drift.dart';
import 'package:memori_app/db/tables/decks.drift.dart';

@DriftAccessor(
  tables: [
    Cards,
  ],
)
class CardsRepository extends DatabaseAccessor<AppDb>
    with $CardsRepositoryMixin {
  CardsRepository(super.db);

  Future<List<Card>> get allCards => select(cards).get();

  Stream<List<Card>> watchEntriesInDeck(final Deck c) =>
      (select(cards)..where((final t) => t.deckId.equals(c.id))).watch();

  Future<List<Card>> limitTodos(final int limit, {final int? offset}) =>
      (select(cards)..limit(limit, offset: offset)).get();

  // Exposes `get` and `watch`
  MultiSelectable<Card> pageOfTodos(final int page, {final int pageSize = 10}) =>
      select(cards)..limit(pageSize, offset: page);

  // Exposes `getSingle` and `watchSingle`
  SingleSelectable<Card> selectableEntryById(final String id) =>
      select(cards)..where((final t) => t.id.equals(id));

  // Exposes `getSingleOrNull` and `watchSingleOrNull`
  SingleOrNullSelectable<Card> entryFromExternalLink(final String id) =>
      select(cards)..where((final t) => t.id.equals(id));

  Future<List<Card>> sortEntries() => (select(cards)
        ..orderBy([(final t) => OrderingTerm(expression: t.displayOrder)]))
      .get();

  Stream<Card> entryById(final String id) =>
      (select(cards)..where((final t) => t.id.equals(id))).watchSingle();

  Stream<List<String>> mapToIdList() {
    final query = select(cards);

    return query.map((final row) => row.id).watch();
  }

  // returns the generated id
  Future<int> addCard(final CardsCompanion entry) => into(cards).insert(entry);

  Future<Card> addTodoReturning(final CardsCompanion entry) =>
      into(cards).insertReturning(entry);

  // using replace will update all fields from the entry that are not marked as a primary key.
  // it will also make sure that only the entry with the same primary key will be updated.
  // Here, this means that the row that has the same id as entry will be updated to reflect
  // the entry's title, content and category. As its where clause is set automatically, it
  // cannot be used together with where.
  Future updateTodo(final Card entry) => update(cards).replace(entry);

  // final AppDb dbContext;
  // final $CardsTable cards;

  // CardsRepository(this.dbContext) : cards = dbContext.cards;

  // Future<List<Card>> getAllCards() async {
  //   return dbContext.cards.select(distinct: false).get();
  // }

  // Stream<List<Card>> watchAllCards() {
  //   return cards.select(distinct: false).get().asStream();
  // }

  // Future insertCard(Insertable<Card> card) async {
  //   return dbContext.cards.insert(card);
  // }

  // Future updateCard(Insertable<Card> card) async {
  //   return dbContext.cards.replace(card);
  // }

  // Future deleteCard(Insertable<Card> card) async {
  //   return delete(cards).delete(card);
  // }
}

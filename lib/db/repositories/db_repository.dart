import 'dart:math';

import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memori_app/db/database.dart';
import 'package:memori_app/db/dtos/card.dart';
import 'package:memori_app/db/dtos/conflicted_row.dart';
import 'package:memori_app/db/dtos/deck.dart';
import 'package:memori_app/db/dtos/pagination.dart';
import 'package:memori_app/db/dtos/sync_entity.dart';
import 'package:memori_app/db/exceptions/exception.dart';
import 'package:memori_app/db/repositories/db_repository.drift.dart';
import 'package:memori_app/db/tables/conflicted_rows.dart';
import 'package:memori_app/db/tables/conflicted_rows.drift.dart';
import 'package:memori_app/db/tables/tables.dart';
import 'package:memori_app/db/utils/sort_order.dart';
import 'package:memori_app/features/cards/models/card_list_view.dart';
import 'package:uuid/uuid.dart';

class PersistStatus {
  final bool isSuccessful;

  final bool hasSyncConflict;

  PersistStatus({
    required this.isSuccessful,
    required this.hasSyncConflict,
  });
}

@DriftAccessor(
  tables: [
    CardTagMappings,
    DeckLearnHistories,
    CardScheduleHistories,
    ReviewLogs,
    ConflictedRows,
  ],
)
class DbRepository extends DatabaseAccessor<AppDb> with $DbRepositoryMixin {
  DbRepository(super.db);

  // #region App users

  String getUserId() => FirebaseAuth.instance.currentUser?.uid ?? "";

  Future<AppUser?> getUserById(final String id) async =>
      await (select(appUsers)..where((final tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<String> getDeviceId(final String userId) async {
    final appUser = await (select(appUsers)
          ..where((final a) => a.id.equals(userId)))
        .getSingleOrNull();

    if (appUser == null) {
      throw EntityNotFoundException<AppUsers>();
    }

    return appUser.deviceId;
  }

  Future<void> updateDeviceSyncedDate({
    required final DateTime lastSyncedAt,
  }) async {
    final appUser = await getUserById(getUserId());
    if (appUser != null) {
      update(appUsers).replace(
        appUser.copyWith(
          lastSyncedAt: lastSyncedAt,
        ),
      );
    }
  }

  // #endregion

  // #region Sync entities

  Future<SyncEntity?> getSyncEntityById({
    required final String id,
    required final String entityType,
  }) async {
    final userId = getUserId();

    return await (select(syncEntities)
          ..where(
            (final tbl) =>
                tbl.id.equals(id) &
                tbl.entityType.equals(entityType) &
                tbl.userId.equals(userId),
          ))
        .getSingleOrNull();
  }

  Future<String> addSyncEntity<T extends Table>() async {
    final syncEntityId = const Uuid().v4().toString();

    final utcNow = Value(DateTime.now().toUtc());
    final userId = getUserId();

    final syncEntityEntry = SyncEntitiesCompanion(
      id: Value(syncEntityId),
      createdAt: utcNow,
      deletedAt: const Value(null),
      lastModified: utcNow,
      version: const Value(0),
      syncedAt: Value(DateTime.utc(1970, 1, 1, 0, 0, 0, 0)),
      sortOrder: Value(getSortOrder<T>()),
      entityType: Value(getEntityName<T>()),
      userId: Value(userId),
      modifiedByDeviceId: Value(await getDeviceId(userId)),
    );

    await into(syncEntities).insert(syncEntityEntry);

    return syncEntityId;
  }

  Future updateSyncEntity<T extends Table>({
    required final String id,
    final bool isDeleted = false,
  }) async {
    final syncEntity = await (select(syncEntities)
          ..where((final tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    if (syncEntity == null) {
      throw EntityNotFoundException<T>();
    }
    final now = DateTime.now().toUtc();
    await update(syncEntities).replace(
      syncEntity.copyWith(
        lastModified: now,
        deletedAt: isDeleted ? Value(now) : const Value(null),
      ),
    );
  }

  // #endregion

  // #region Decks

  Future<int> nextDeckPageCount({
    required final int page,
    required final int pageSize,
    final String? searchText,
  }) async {
    final amountOfDecks = decks.id.count();
    final query = select(decks).join(
      [
        innerJoin(
          syncEntities,
          syncEntities.id.equalsExp(decks.id),
        ),
      ],
    )
      ..where(syncEntities.deletedAt.isNull())
      ..where(syncEntities.userId.equals(getUserId()));

    if (searchText != null && searchText.isNotEmpty) {
      query.where(decks.name.contains(searchText.toLowerCase()));
    }

    query
      ..orderBy([OrderingTerm.desc(syncEntities.lastModified)])
      ..addColumns([amountOfDecks]);

    final totalDecks =
        await query.map((final row) => row.read(amountOfDecks)!).getSingle();

    final nextPageStartIndex = (page + 1) * pageSize;
    if (totalDecks <= nextPageStartIndex) {
      return 0;
    } else {
      return min(pageSize, totalDecks - nextPageStartIndex);
    }
  }

  Future<List<Deck>> pagesOfDecks({
    required final int page,
    required final int pageSize,
    final String? searchText,
  }) {
    final query = select(decks).join(
      [
        innerJoin(
          syncEntities,
          syncEntities.id.equalsExp(decks.id),
        ),
      ],
    )
      ..where(syncEntities.deletedAt.isNull())
      ..where(syncEntities.userId.equals(getUserId()));

    if (searchText != null && searchText.isNotEmpty) {
      query.where(decks.name.contains(searchText.toLowerCase()));
    }

    query
      ..orderBy([OrderingTerm.desc(syncEntities.lastModified)])
      ..limit(pageSize, offset: page * pageSize);

    return query
        .map(
          (final row) => row.readTable(decks),
        )
        .get();
  }

  Future<Deck?> getDeckById(final String id) async =>
      await (select(decks)..where((final tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<String> addDeckByName(final String name) async =>
      transaction(() async {
        final deckId = await addSyncEntity<Decks>();

        final deckEntry = DecksCompanion(
          id: Value(deckId),
          name: Value(name),
          description: const Value(''),
          newCount: const Value(0),
          learningCount: const Value(0),
          reviewCount: const Value(0),
          totalCount: const Value(0),
          shareCode: const Value(''),
          canShareExpired: const Value(false),
          shareExpirationTime: Value(DateTime.now()),
          deckSettingsId: Value(await addDefaultDeckSetting()),
        );

        await into(decks).insert(deckEntry);

        return deckId;
      });

  Future updateDeck(final Deck entry) async {
    transaction(() async {
      await updateSyncEntity(id: entry.id, isDeleted: false);
      await update(decks).replace(entry);
    });
  }

  Future updateDeckLastReviewTime({
    required final String deckId,
    required final DateTime reviewTime,
  }) async {
    transaction(() async {
      final deck = await getDeckById(deckId);
      if (deck == null) {
        throw EntityNotFoundException();
      }
      await updateSyncEntity(id: deckId, isDeleted: false);
      await update(decks).replace(
        deck.copyWith(
          lastReviewTime: Value(reviewTime),
        ),
      );
    });
  }

  Future deleteDeck(final Deck entry) async {
    transaction(() async {
      await updateSyncEntity(id: entry.id, isDeleted: true);
      await updateSyncEntity(id: entry.deckSettingsId, isDeleted: true);
    });
  }

  Future<DeckStatsDto> getStatsByDeckId(final String deckId) async {
    final amountOfCards = cards.id.count();

    final query = select(cards).join(
      [
        innerJoin(
          syncEntities,
          syncEntities.id.equalsExp(cards.id),
          useColumns: false,
        ),
        innerJoin(
          decks,
          decks.id.equalsExp(cards.deckId),
          useColumns: false,
        ),
      ],
    )
      ..where(syncEntities.deletedAt.isNull())
      ..where(syncEntities.userId.equals(getUserId()))
      ..where(decks.id.equals(deckId))
      ..addColumns([amountOfCards])
      ..groupBy([cards.state]);

    int newCount = 0;
    int learningCount = 0;
    int reviewCount = 0;
    final result = await query.get();

    for (final row in result) {
      final state = row.readTable(cards).state;
      final count = row.read(amountOfCards) ?? 0;
      if (state == State.NEW.value) {
        newCount += count;
      } else if (state == State.LEARNING.value ||
          state == State.RELEARNING.value) {
        learningCount += count;
      } else if (state == State.REVIEW.value) {
        reviewCount += count;
      }
    }

    return DeckStatsDto(
      newCount: newCount,
      learningCount: learningCount,
      reviewCount: reviewCount,
    );
  }

  Future<int> getTodayLearntDeckCount() async {
    final user = await getUserById(getUserId());
    final now = DateTime.now();
    final todayUtc = DateTime(now.year, now.month, now.day).subtract(
      const Duration(hours: 8),
    );
    if (user == null) {
      return 0;
    }
    final amountOfDecks = decks.id.count();
    final query = selectOnly(decks).join(
      [
        innerJoin(
          syncEntities,
          syncEntities.id.equalsExp(decks.id),
        ),
      ],
    )
      ..where(syncEntities.deletedAt.isNull())
      ..where(syncEntities.userId.equals(getUserId()))
      ..where(decks.lastReviewTime.isBiggerOrEqualValue(todayUtc))
      ..addColumns([amountOfDecks]);
    return await query.map((final row) => row.read(amountOfDecks)!).getSingle();
  }

  // #endregion

  // #region Deck settings

  Future<DeckSetting?> getDeckSettingById(final String id) async =>
      await (select(deckSettings)..where((final tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<String> addDefaultDeckSetting() async => transaction(() async {
        final deckSettingsId = await addSyncEntity<DeckSettings>();

        final deckSettingsEntry = DeckSettingsCompanion(
          id: Value(deckSettingsId),
          isDefault: const Value(false),
          learningSteps: const Value('1m 10m'),
          reLearningSteps: const Value('10m'),
          desiredRetention: const Value(0.95),
          maxNewCardsPerDay: const Value(20),
          maxReviewPerDay: const Value(40),
          maximumAnswerSeconds: const Value(60),
          newPriority: const Value(1),
          interdayPriority: const Value(1),
          reviewPriority: const Value(1),
          skipNewCard: const Value(false),
          skipLearningCard: const Value(false),
          skipReviewCard: const Value(false),
        );

        await into(deckSettings).insert(deckSettingsEntry);

        return deckSettingsId;
      });

  Future updateDeckSetting(final DeckSetting entry) async {
    transaction(() async {
      await updateSyncEntity(id: entry.id, isDeleted: false);
      await update(deckSettings).replace(entry);
    });
  }

  // #endregion

  // #region Card tags

  Future<PaginationResult> nextCardTagPageCount({
    required final int page,
    required final int pageSize,
    final String? searchText,
  }) async {
    final amountOfCardTags = cardTags.id.count();
    final query = select(cardTags).join(
      [
        innerJoin(
          syncEntities,
          syncEntities.id.equalsExp(cardTags.id),
        ),
      ],
    )
      ..where(syncEntities.deletedAt.isNull())
      ..where(syncEntities.userId.equals(getUserId()));

    if (searchText != null && searchText.isNotEmpty) {
      query.where(cardTags.name.contains(searchText.toLowerCase()));
    }

    query.addColumns([amountOfCardTags]);

    final totalCardTags =
        await query.map((final row) => row.read(amountOfCardTags)!).getSingle();

    final nextPageStartIndex = (page + 1) * pageSize;
    int nextPageSize = 0;
    if (totalCardTags <= nextPageStartIndex) {
    } else {
      nextPageSize = min(pageSize, totalCardTags - nextPageStartIndex);
    }
    return PaginationResult(
      nextPageSize: nextPageSize,
      totalRecords: totalCardTags,
    );
  }

  Future<List<CardTag>> pagesOfCardTags({
    required final int page,
    required final int pageSize,
    final String? searchText,
  }) {
    final query = select(cardTags).join(
      [
        innerJoin(
          syncEntities,
          syncEntities.id.equalsExp(cardTags.id),
        ),
      ],
    )
      ..where(syncEntities.deletedAt.isNull())
      ..where(syncEntities.userId.equals(getUserId()));

    if (searchText != null && searchText.isNotEmpty) {
      query.where(cardTags.name.contains(searchText.toLowerCase()));
    }

    query.limit(pageSize, offset: page * pageSize);

    return query
        .map(
          (final row) => row.readTable(cardTags),
        )
        .get();
  }

  Future<CardTag?> getCardTagById(final String id) async =>
      await (select(cardTags)..where((final tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<String> addCardTagByName(final String name) async =>
      transaction(() async {
        final cardTagId = await addSyncEntity<CardTags>();

        final cardTagEntry = CardTagsCompanion(
          id: Value(cardTagId),
          name: Value(name),
        );

        await into(cardTags).insert(cardTagEntry);

        return cardTagId;
      });

  Future updateCardTag(final CardTag entry) async {
    transaction(() async {
      await updateSyncEntity(id: entry.id, isDeleted: false);
      await update(cardTags).replace(entry);
    });
  }

  Future deleteCardTag(final CardTag entry) async {
    await updateSyncEntity(id: entry.id, isDeleted: true);
  }

  // #endregion

  // #region Cards

  JoinedSelectStatement<HasResultSet, dynamic> buildCardQuery({
    required final int page,
    required final int pageSize,
    final List<String>? selectedDecks,
    final List<String>? selectedTags,
    final String? searchText,
    required final CardSortOptionValue sortOption,
  }) {
    final tagEntities = alias(syncEntities, 'tag_sync');

    final subQuery = Subquery(
      selectOnly(cardTagMappings, distinct: true).join(
        [
          innerJoin(
            tagEntities,
            tagEntities.id.equalsExp(cardTagMappings.id),
          ),
        ],
      )
        ..where(cardTagMappings.cardTagId.isIn(selectedTags ?? []))
        ..where(tagEntities.deletedAt.isNull())
        ..where(tagEntities.userId.equals(getUserId()))
        ..addColumns([cardTagMappings.cardId]),
      's',
    );

    final query = select(cards).join(
      [
        innerJoin(
          syncEntities,
          syncEntities.id.equalsExp(cards.id),
        ),
        innerJoin(
          decks,
          decks.id.equalsExp(cards.deckId),
        ),
        // if (selectedTags != null && selectedTags.isNotEmpty)
        //   innerJoin(
        //     cardTagMappings,
        //     cardTagMappings.cardId.equalsExp(cards.id),
        //   ),
        if (selectedTags != null && selectedTags.isNotEmpty)
          innerJoin(
            subQuery,
            subQuery.ref(cardTagMappings.cardId).equalsExp(cards.id),
          ),
      ],
    )
      ..where(syncEntities.deletedAt.isNull())
      ..where(syncEntities.userId.equals(getUserId()));

    if (searchText != null && searchText.isNotEmpty) {
      query.where(
        cards.frontPlainText.contains(searchText.toLowerCase()) |
            cards.backPlainText.contains(searchText.toLowerCase()),
      );
    }

    if (selectedDecks != null && selectedDecks.isNotEmpty) {
      query.where(cards.deckId.isIn(selectedDecks));
    }

    /*if (selectedTags != null && selectedTags.isNotEmpty) {
      query.where(subQuery.ref(cardTagMappings.cardTagId).isIn(selectedTags));
    }*/

    if (sortOption == CardSortOptionValue.createdAsc) {
      query.orderBy([OrderingTerm.asc(syncEntities.createdAt)]);
    } else if (sortOption == CardSortOptionValue.createdDsc) {
      query.orderBy([OrderingTerm.desc(syncEntities.createdAt)]);
    } else if (sortOption == CardSortOptionValue.modifiedAsc) {
      query.orderBy([OrderingTerm.asc(syncEntities.lastModified)]);
    } else if (sortOption == CardSortOptionValue.modifiedDsc) {
      query.orderBy([OrderingTerm.desc(syncEntities.lastModified)]);
    }

    return query;
  }

  Future<PaginatedCardDto> pagesOfCards({
    required final int page,
    required final int pageSize,
    final List<String>? selectedDecks,
    final List<String>? selectedTags,
    final String? searchText,
    required final CardSortOptionValue sortOption,
  }) async {
    final amountOfCards = cards.id.count();

    final countQuery = buildCardQuery(
      page: page,
      pageSize: pageSize,
      selectedDecks: selectedDecks,
      selectedTags: selectedTags,
      searchText: searchText,
      sortOption: sortOption,
    )..addColumns([amountOfCards]);

    final totalCards = await countQuery
        .map((final row) => row.read(amountOfCards)!)
        .getSingle();

    final nextPageStartIndex = (page + 1) * pageSize;
    int nextPageSize = 0;
    if (totalCards <= nextPageStartIndex) {
    } else {
      nextPageSize = min(pageSize, totalCards - nextPageStartIndex);
    }
    final pagination = PaginationResult(
      nextPageSize: nextPageSize,
      totalRecords: totalCards,
    );

    final recQuery = buildCardQuery(
      page: page,
      pageSize: pageSize,
      selectedDecks: selectedDecks,
      selectedTags: selectedTags,
      searchText: searchText,
      sortOption: sortOption,
    )..limit(
        pageSize,
        offset: page * pageSize,
      );

    final dtos = await recQuery
        .map(
          (final row) => CardDto(
            syncEntity: row.readTable(syncEntities),
            card: row.readTable(cards),
            deck: row.readTable(decks),
          ),
        )
        .get();
    return PaginatedCardDto(pagination: pagination, dtos: dtos);
  }

  Future<Card?> getCardById(final String id) async =>
      await (select(cards)..where((final tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<int> getCardCount() async {
    final amountOfCards = cards.id.count();
    final query = select(cards).join(
      [
        innerJoin(
          syncEntities,
          syncEntities.id.equalsExp(cards.id),
        ),
      ],
    )
      ..where(syncEntities.deletedAt.isNull())
      ..where(syncEntities.userId.equals(getUserId()))
      ..addColumns([amountOfCards]);

    return await query.map((final row) => row.read(amountOfCards)!).getSingle();
  }

  Future<int> getCardCountByDeck({required final String deckId}) async {
    final amountOfCards = cards.id.count();
    final query = select(cards).join(
      [
        innerJoin(
          syncEntities,
          syncEntities.id.equalsExp(cards.id),
        ),
      ],
    )
      ..where(syncEntities.deletedAt.isNull())
      ..where(syncEntities.userId.equals(getUserId()))
      ..where(cards.deckId.equals(deckId))
      ..addColumns([amountOfCards]);

    return await query.map((final row) => row.read(amountOfCards)!).getSingle();
  }

  Future<String> createDefaultCard({
    required final String deckId,
    required final String front,
    required final String back,
    required final String frontPlainText,
    required final String backPlainText,
  }) async =>
      transaction(() async {
        final cardId = await addSyncEntity<Cards>();
        final now = DateTime.now().toUtc();

        await into(cards).insert(
          CardsCompanion(
            id: Value(cardId),
            deckId: Value(deckId),
            front: Value(front),
            back: Value(back),
            frontPlainText: Value(frontPlainText),
            backPlainText: Value(backPlainText),
            explanation: const Value('{}'),
            displayOrder: Value(await getCardCount() + 1),
            lapses: const Value(0),
            reps: const Value(0),
            elapsedDays: const Value(0),
            scheduledDays: const Value(0),
            difficulty: const Value(0),
            stability: const Value(0),
            isSuspended: const Value(false),
            due: Value(now),
            actualDue: Value(now),
            lastReview: Value(now),
            state: Value(State.NEW.value),
          ),
        );

        final deck = await getDeckById(deckId);
        await updateDeck(deck!);

        return cardId;
      });

  Future<String> createCard(final CardsCompanion card) async =>
      transaction(() async {
        final cardId = await addSyncEntity<Cards>();

        await into(cards).insert(card.copyWith(id: Value(cardId)));

        return cardId;
      });

  Future updateCard(final Card entry) async {
    transaction(() async {
      await updateSyncEntity(id: entry.id, isDeleted: false);
      await update(cards).replace(entry);

      final deck = await getDeckById(entry.deckId);
      await updateDeck(deck!);
    });
  }

  Future deleteCard(final Card entry) async {
    transaction(() async {
      await updateSyncEntity(id: entry.id, isDeleted: true);
    });
  }

  JoinedSelectStatement<HasResultSet, dynamic> buildLearnCardQuery({
    required final String deckId,
    required final bool fetchNew,
    required final bool fetchLearning,
    required final bool fetchReview,
  }) {
    final query = select(cards).join(
      [
        innerJoin(
          syncEntities,
          syncEntities.id.equalsExp(cards.id),
        ),
        innerJoin(
          decks,
          decks.id.equalsExp(cards.deckId),
        ),
      ],
    )
      ..where(syncEntities.deletedAt.isNull())
      ..where(syncEntities.userId.equals(getUserId()))
      ..where(cards.deckId.equals(deckId));

    if (!fetchNew || !fetchLearning || !fetchReview) {
      List<int> cardStates = [];
      if (fetchNew) {
        cardStates.add(State.NEW.getValue());
      }
      if (fetchLearning) {
        cardStates
          ..add(State.LEARNING.getValue())
          ..add(State.RELEARNING.getValue());
      }
      if (fetchReview) {
        cardStates.add(State.REVIEW.getValue());
      }
      query.where(cards.state.isIn(cardStates));
    }

    return query;
  }

  Future<List<Card>> getTodayNewCardIds({
    required final String deckId,
    required final int maxNewCardsPerDay,
  }) async {
    final query = buildLearnCardQuery(
      deckId: deckId,
      fetchNew: true,
      fetchLearning: false,
      fetchReview: false,
    )
      ..orderBy([OrderingTerm.asc(syncEntities.createdAt)])
      ..limit(maxNewCardsPerDay);

    return query
        .map(
          (final e) => e.readTable(cards),
        )
        .get();
  }

  Future<List<Card>> getTodayReviewCardIds({
    required final String deckId,
    required final int maxReviewPerDay,
  }) async {
    final query = buildLearnCardQuery(
      deckId: deckId,
      fetchNew: false,
      fetchLearning: true,
      fetchReview: true,
    )
      ..where(cards.due.isSmallerOrEqualValue(DateTime.now().toUtc()))
      ..orderBy([
        OrderingTerm.asc(cards.due),
        OrderingTerm.asc(syncEntities.createdAt),
      ])
      ..limit(maxReviewPerDay);

    return query
        .map(
          (final e) => e.readTable(cards),
        )
        .get();
  }

  Future<List<Card>> getAllReviewCardIds({
    required final String deckId,
    required final int maxReviewPerDay,
  }) async {
    final query = buildLearnCardQuery(
      deckId: deckId,
      fetchNew: false,
      fetchLearning: true,
      fetchReview: true,
    )
      ..orderBy([
        OrderingTerm.asc(cards.due),
        OrderingTerm.asc(syncEntities.createdAt),
      ])
      ..limit(maxReviewPerDay);

    return query
        .map(
          (final e) => e.readTable(cards),
        )
        .get();
  }

  // #endregion

  // #region Card tag mappings

  Future<CardTagMapping?> getCardTagMappingById(final String id) async =>
      await (select(cardTagMappings)..where((final tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<List<CardTag>> getCardTagByCardId({
    required final String cardId,
    final bool includeDeleted = false,
  }) async {
    final mapEntities = alias(syncEntities, 'map_sync');
    final tagEntities = alias(syncEntities, 'tag_sync');

    final query = select(cardTagMappings).join(
      [
        innerJoin(
          mapEntities,
          mapEntities.id.equalsExp(cardTagMappings.id),
        ),
        innerJoin(
          cardTags,
          cardTags.id.equalsExp(cardTagMappings.cardTagId),
        ),
        innerJoin(
          tagEntities,
          tagEntities.id.equalsExp(cardTagMappings.cardTagId),
        ),
      ],
    )
      ..where(cardTagMappings.cardId.equals(cardId))
      ..where(mapEntities.userId.equals(getUserId()))
      ..where(tagEntities.deletedAt.isNull());

    if (!includeDeleted) {
      query.where(mapEntities.deletedAt.isNull());
    }

    return await query
        .map(
          (final row) => row.readTable(cardTags),
        )
        .get();
  }

  Future<List<CardTagMapping>> getCardTagMappingByCardId({
    required final String cardId,
    final bool includeDeleted = false,
  }) async {
    final query = select(cardTagMappings).join(
      [
        innerJoin(
          syncEntities,
          syncEntities.id.equalsExp(cardTagMappings.id),
        ),
      ],
    )
      ..where(cardTagMappings.cardId.equals(cardId))
      ..where(syncEntities.userId.equals(getUserId()));

    if (!includeDeleted) {
      query.where(syncEntities.deletedAt.isNull());
    }

    return await query
        .map(
          (final row) => row.readTable(cardTagMappings),
        )
        .get();
  }

  Future<String> _createCardTag({
    required final String cardId,
    required final String cardTagId,
  }) async {
    final mappingId = await addSyncEntity<CardTagMappings>();

    await into(cardTagMappings).insert(
      CardTagMappingsCompanion(
        id: Value(mappingId),
        cardId: Value(cardId),
        cardTagId: Value(cardTagId),
      ),
    );

    return mappingId;
  }

  Future _updateCardTagMapping({
    required final String cardId,
    required final String cardTagId,
  }) async {
    final query = select(cardTagMappings)
      ..where((final tbl) => tbl.cardId.equals(cardId))
      ..where((final tbl) => tbl.cardTagId.equals(cardTagId));
    final mapping = await query.getSingleOrNull();
    if (mapping == null) {
      throw EntityNotFoundException<CardTagMappings>();
    }
    await updateSyncEntity(id: mapping.id, isDeleted: false);
  }

  Future _deleteCardTagMapping({
    required final String cardId,
    required final String cardTagId,
  }) async {
    final query = select(cardTagMappings)
      ..where((final tbl) => tbl.cardId.equals(cardId))
      ..where((final tbl) => tbl.cardTagId.equals(cardTagId));
    final mapping = await query.getSingleOrNull();
    if (mapping == null) {
      throw EntityNotFoundException<CardTagMappings>();
    }
    await updateSyncEntity(id: mapping.id, isDeleted: true);
  }

  Future updateCardTagMapping(
    final String cardId,
    final List<String> cardTagIds,
  ) async {
    transaction(() async {
      final newSet = cardTagIds.toSet();

      final cardTagMappings = await getCardTagMappingByCardId(
        cardId: cardId,
        includeDeleted: true,
      );

      final oldSet = cardTagMappings.map((final e) => e.cardTagId).toSet();

      // Card tag id not yet exist in database
      for (final id in newSet.difference(oldSet)) {
        await _createCardTag(
          cardId: cardId,
          cardTagId: id,
        );
      }

      // Card tag id will not exist in database
      for (final id in oldSet.difference(newSet)) {
        await _deleteCardTagMapping(
          cardId: cardId,
          cardTagId: id,
        );
      }

      // Card tag id existing in database
      for (final id in oldSet.intersection(newSet)) {
        await _updateCardTagMapping(
          cardId: cardId,
          cardTagId: id,
        );
      }
    });
  }

  // #endregion

  // #region Deck learn history

  Future<DeckLearnHistory?> getDeckLearnHistory() async {
    final query = select(deckLearnHistories)
      ..where((final tbl) => tbl.userId.equals(getUserId()));

    return await query.getSingleOrNull();
  }

  Future updateDeckLearnHistory(
    final DeckLearnHistoriesCompanion companion,
  ) async {
    transaction(() async {
      final history = await getDeckLearnHistory();

      if (history == null) {
        await into(deckLearnHistories).insert(
          companion,
        );
      } else {
        await update(deckLearnHistories).replace(
          companion.copyWith(
            id: Value(
              history.id,
            ),
          ),
        );
      }
    });
  }

  Future deleteDeckLearnHistory() async {
    transaction(() async {
      final history = await getDeckLearnHistory();
      if (history != null) {
        await delete(deckLearnHistories).delete(history);
      }
    });
  }

  Future updateDeckLearnHistoryProgress(
    final int curProgress,
  ) async {
    transaction(() async {
      final history = await getDeckLearnHistory();

      if (history == null) {
        return;
      } else {
        await update(deckLearnHistories).replace(
          history.copyWith(
            currentProgress: curProgress,
          ),
        );
      }
    });
  }

  Future updateDeckLearnHistoryCount({
    required final int newCount,
    required final int learningCount,
    required final int reviewCount,
  }) async {
    transaction(() async {
      final history = await getDeckLearnHistory();

      if (history == null) {
        return;
      } else {
        await update(deckLearnHistories).replace(
          history.copyWith(
            newCount: newCount,
            learningCount: learningCount,
            reviewCount: reviewCount,
          ),
        );
      }
    });
  }

  // #endregion

  // #region Card schedule history

  Future<List<CardScheduleHistory>> getCardScheduleHistoryByCardId({
    required final String cardId,
  }) async {
    final query = select(cardScheduleHistories)
      ..where((final tbl) => tbl.userId.equals(getUserId()))
      ..where((final tbl) => tbl.cardId.equals(cardId));
    return await query.get();
  }

  Future updateCardScheduleHistoryByCardId({
    required final String cardId,
    required final List<CardScheduleHistory> histories,
  }) async {
    transaction(() async {
      await deleteCardScheduleHistoryByCardId(cardId: cardId);
      for (final history in histories) {
        await into(cardScheduleHistories).insert(history);
      }
    });
  }

  Future deleteCardScheduleHistoryByCardId({
    required final String cardId,
  }) async {
    transaction(() async {
      final histories = await getCardScheduleHistoryByCardId(
        cardId: cardId,
      );
      for (final history in histories) {
        await delete(cardScheduleHistories).delete(history);
      }
    });
  }

  // #endregion

  // #region Review log

  Future<ReviewLog?> getReviewLogById(final String id) async =>
      await (select(reviewLogs)..where((final tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future addReviewLog(final ReviewLogsCompanion companion) async {
    transaction(() async {
      final mappingId = await addSyncEntity<ReviewLogs>();
      await into(reviewLogs).insert(
        companion.copyWith(
          id: Value(
            mappingId,
          ),
        ),
      );
    });
  }

  // #endregion

  // #region Conflicted rows

  Future<ConflictedRow?> getConflictedRowsById(final String id) async =>
      await (select(conflictedRows)
            ..where(
              (final tbl) => tbl.id.equals(id) & tbl.userId.equals(getUserId()),
            ))
          .getSingleOrNull();

  Future<void> insertConflictedRows(final ConflictedRowsCompanion entry) async {
    transaction(() async {
      final existingRecord = await getConflictedRowsById(entry.id.value);
      if (existingRecord == null) {
        await into(conflictedRows).insert(entry);
      } else {
        await update(conflictedRows).replace(entry);
      }
    });
  }

  JoinedSelectStatement<HasResultSet, dynamic> buildConfictedRows({
    required final int page,
    required final int pageSize,
  }) {
    final query = select(conflictedRows).join(
      [
        innerJoin(
          syncEntities,
          syncEntities.id.equalsExp(conflictedRows.id),
        ),
      ],
    )..where(conflictedRows.userId.equals(getUserId()));

    return query;
  }

  Future<PaginatedConflictedRowDto> getConflictedSyncEntities({
    required final int page,
    required final int pageSize,
  }) async {
    final amountOfEntities = syncEntities.id.count();

    final countQuery = buildConfictedRows(
      page: page,
      pageSize: pageSize,
    )..addColumns([amountOfEntities]);

    final totalEntities = await countQuery
        .map((final row) => row.read(amountOfEntities)!)
        .getSingle();

    final items = await (buildConfictedRows(
      page: page,
      pageSize: pageSize,
    )..limit(pageSize, offset: page * pageSize))
        .map(
          (final row) => row.readTable(syncEntities),
        )
        .get();

    return PaginatedConflictedRowDto(
      items: items,
      pagination: getPaginationResult(
        totalRecords: totalEntities,
        page: page,
        pageSize: pageSize,
      ),
    );
  }

  Future<void> deleteConflictedRow({
    required final String entityId,
  }) async {
    await (delete(conflictedRows)
          ..where(
            (final t) => t.id.equals(entityId),
          ))
        .go();
  }

  Future<void> deleteConflictedRows({
    required final List<String> entityIds,
  }) async {
    await (delete(conflictedRows)
          ..where(
            (final t) => t.id.isIn(entityIds),
          ))
        .go();
  }

  // #endregion

  // #region Cloud sync

  PaginationResult getPaginationResult({
    required final int totalRecords,
    required final int page,
    required final int pageSize,
  }) {
    final nextPageStartIndex = (page + 1) * pageSize;
    int nextPageSize = 0;
    if (totalRecords <= nextPageStartIndex) {
    } else {
      nextPageSize = min(pageSize, totalRecords - nextPageStartIndex);
    }
    return PaginationResult(
      nextPageSize: nextPageSize,
      totalRecords: totalRecords,
    );
  }

  SimpleSelectStatement<$SyncEntitiesTable, SyncEntity>
      buildCreatedEntitiesToBePushed({
    required final DateTime lastSyncDate,
    required final int page,
    required final int pageSize,
  }) =>
          select(syncEntities)
            ..where(
              (final tbl) =>
                  tbl.userId.equals(getUserId()) &
                  tbl.createdAt.isBiggerThanValue(lastSyncDate),
            )
            /*..where(
              (final tbl) =>
                  tbl.localLastSyncedAt.isNull() |
                  tbl.localLastSyncedAt.isSmallerThanValue(lastSyncDate),
            )*/
            ..orderBy([
              (final u) => OrderingTerm.asc(
                    syncEntities.sortOrder,
                  ),
              (final u) => OrderingTerm.asc(
                    syncEntities.createdAt,
                  ),
            ]);

  Future<PaginatedSyncEntityDto> getCreatedEntitiesToBePushed({
    required final DateTime lastSyncDate,
    required final int page,
    required final int pageSize,
  }) async {
    /*
      @Query("SELECT e FROM SyncEntity e WHERE e.userId = :userId AND e.createdAt > :lastSyncDate ORDER BY e.sortOrder ASC, e.createdAt ASC")
    */
    final amountOfEntities = syncEntities.id.count();

    final totalEntities = await buildCreatedEntitiesToBePushed(
      lastSyncDate: lastSyncDate,
      page: page,
      pageSize: pageSize,
    )
        .addColumns([amountOfEntities])
        .map((final row) => row.read(amountOfEntities)!)
        .getSingle();

    final items = await (buildCreatedEntitiesToBePushed(
      lastSyncDate: lastSyncDate,
      page: page,
      pageSize: pageSize,
    )..limit(pageSize, offset: page * pageSize))
        .get();

    return PaginatedSyncEntityDto(
      items: items,
      pagination: getPaginationResult(
        totalRecords: totalEntities,
        page: page,
        pageSize: pageSize,
      ),
    );
  }

  SimpleSelectStatement<$SyncEntitiesTable, SyncEntity>
      buildUpdatedEntitiesToBePushed({
    required final DateTime lastSyncDate,
    required final int page,
    required final int pageSize,
  }) =>
          select(syncEntities)
            ..where(
              (final tbl) =>
                  tbl.userId.equals(getUserId()) &
                  tbl.createdAt.isSmallerOrEqualValue(lastSyncDate) &
                  tbl.deletedAt.isNull() &
                  tbl.lastModified.isBiggerThanValue(lastSyncDate),
            )
            /*..where(
              (final tbl) =>
                  tbl.localLastSyncedAt.isNull() |
                  tbl.localLastSyncedAt.isSmallerThanValue(lastSyncDate),
            )*/
            ..orderBy([
              (final u) => OrderingTerm.asc(
                    syncEntities.lastModified,
                  ),
            ]);

  Future<PaginatedSyncEntityDto> getUpdatedEntitiesToBePushed({
    required final DateTime lastSyncDate,
    required final int page,
    required final int pageSize,
  }) async {
    /*
      @Query("SELECT e FROM SyncEntity e WHERE e.userId = :userId AND e.createdAt <= :lastSyncDate AND e.deletedAt IS NULL AND e.lastModified > :lastSyncDate ORDER BY e.lastModified ASC")
    */
    final amountOfEntities = syncEntities.id.count();

    final totalEntities = await buildUpdatedEntitiesToBePushed(
      lastSyncDate: lastSyncDate,
      page: page,
      pageSize: pageSize,
    )
        .addColumns([amountOfEntities])
        .map((final row) => row.read(amountOfEntities)!)
        .getSingle();

    final items = await (buildUpdatedEntitiesToBePushed(
      lastSyncDate: lastSyncDate,
      page: page,
      pageSize: pageSize,
    )..limit(pageSize, offset: page * pageSize))
        .get();

    return PaginatedSyncEntityDto(
      items: items,
      pagination: getPaginationResult(
        totalRecords: totalEntities,
        page: page,
        pageSize: pageSize,
      ),
    );
  }

  SimpleSelectStatement<$SyncEntitiesTable, SyncEntity>
      buildDeletedEntitiesToBePushed({
    required final DateTime lastSyncDate,
    required final int page,
    required final int pageSize,
  }) =>
          select(syncEntities)
            ..where(
              (final tbl) =>
                  tbl.userId.equals(getUserId()) &
                  tbl.createdAt.isSmallerOrEqualValue(lastSyncDate) &
                  tbl.deletedAt.isNotNull() &
                  tbl.deletedAt.isBiggerThanValue(lastSyncDate),
            )
            /*..where(
              (final tbl) =>
                  tbl.localLastSyncedAt.isNull() |
                  tbl.localLastSyncedAt.isSmallerThanValue(lastSyncDate),
            )*/
            ..orderBy([
              (final u) => OrderingTerm.asc(
                    syncEntities.deletedAt,
                  ),
            ]);

  Future<PaginatedSyncEntityDto> getDeletedEntitiesToBePushed({
    required final DateTime lastSyncDate,
    required final int page,
    required final int pageSize,
  }) async {
    /*
      @Query("SELECT e FROM SyncEntity e WHERE e.userId = :userId AND e.createdAt <= :lastSyncDate AND e.deletedAt IS NOT NULL AND e.deletedAt > :lastSyncDate ORDER BY e.deletedAt ASC")
    */
    final amountOfEntities = syncEntities.id.count();

    final totalEntities = await buildDeletedEntitiesToBePushed(
      lastSyncDate: lastSyncDate,
      page: page,
      pageSize: pageSize,
    )
        .addColumns([amountOfEntities])
        .map((final row) => row.read(amountOfEntities)!)
        .getSingle();

    final items = await (buildDeletedEntitiesToBePushed(
      lastSyncDate: lastSyncDate,
      page: page,
      pageSize: pageSize,
    )..limit(pageSize, offset: page * pageSize))
        .get();

    return PaginatedSyncEntityDto(
      items: items,
      pagination: getPaginationResult(
        totalRecords: totalEntities,
        page: page,
        pageSize: pageSize,
      ),
    );
  }

  bool hasPullSyncConflict(
    final int versionFromCloud,
    final DateTime deviceLastSyncedAt,
    final SyncEntity entityFromDatabase,
  ) {
    if (versionFromCloud > entityFromDatabase.version &&
        deviceLastSyncedAt.isBefore(entityFromDatabase.lastModified)) {
      return true;
    }
    return false;
  }

  Future syncInsertSyncEntity(
    final SyncEntitiesCompanion entry,
  ) async {
    await into(syncEntities).insert(entry);
  }

  Future syncUpdateSyncEntity(
    final SyncEntity syncEntity,
  ) async {
    await update(syncEntities).replace(syncEntity);
  }

  Future syncSyncEntityWithCloud({
    required final String id,
    required final String entityType,
    required final int version,
    required final DateTime createdAt,
    required final DateTime lastModified,
    required final DateTime? deletedAt,
    required final DateTime syncedAt,
  }) async {
    transaction(() async {
      final syncEntity =
          await getSyncEntityById(id: id, entityType: entityType);
      if (syncEntity == null) {
        throw EntityNotFoundException();
      }
      await syncUpdateSyncEntity(
        syncEntity.copyWith(
          id: id,
          createdAt: createdAt,
          lastModified: lastModified,
          deletedAt: Value(deletedAt),
          syncedAt: syncedAt,
          version: version,
          entityType: entityType,
        ),
      );
    });
  }

  Future<PersistStatus> createSyncPulledEntity<T extends Table>(
    final SyncEntitiesCompanion entityFromCloud,
  ) async {
    final entityFromDatabase = await getSyncEntityById(
      id: entityFromCloud.id.value,
      entityType: entityFromCloud.entityType.value,
    );

    if (entityFromDatabase != null) {
      throw EntityAlreadyExistException(
        message:
            "Creation failed since entity with id ${entityFromCloud.id} exists in local database.",
      );
    }

    await syncInsertSyncEntity(
      entityFromCloud.copyWith(
        localLastSyncedAt: Value(DateTime.now().toUtc()),
      ),
    );

    return PersistStatus(
      isSuccessful: true,
      hasSyncConflict: false,
    );
  }

  Future<PersistStatus> updateOrDeleteSyncPulledEntity({
    required final SyncEntitiesCompanion entityFromCloud,
    required final bool isDeleted,
    required final bool overrideEnabled,
    required final DateTime deviceLastSyncedAt,
  }) async {
    if (isDeleted && entityFromCloud.deletedAt.value == null) {
      throw ArgumentError("deleted at must not be null");
    }

    final entityFromDatabase = await getSyncEntityById(
      id: entityFromCloud.id.value,
      entityType: entityFromCloud.entityType.value,
    );

    if (entityFromDatabase == null) {
      throw EntityNotFoundException<SyncEntities>(
        message: "Entity with id ${entityFromCloud.id} not found",
      );
    }

    if (!overrideEnabled &&
        hasPullSyncConflict(
          entityFromCloud.version.value,
          deviceLastSyncedAt,
          entityFromDatabase,
        )) {
      return PersistStatus(
        isSuccessful: false,
        hasSyncConflict: true,
      );
    }

    await syncUpdateSyncEntity(
      entityFromDatabase.copyWith(
        version:
            entityFromCloud.version.value, // Get the version number from cloud
        syncedAt: entityFromCloud.syncedAt.value,
        deletedAt: Value(entityFromCloud.deletedAt.value),
        localLastSyncedAt: Value(DateTime.now().toUtc()),
      ),
    );

    return PersistStatus(
      isSuccessful: true,
      hasSyncConflict: false,
    );
  }

  Future<PersistStatus> syncInsertCardTags(
    final SyncEntitiesCompanion syncEntity,
    final CardTagsCompanion cardTag,
  ) async {
    try {
      return await transaction(() async {
        final persistStatus =
            await createSyncPulledEntity<CardTags>(syncEntity);
        if (persistStatus.isSuccessful && !persistStatus.hasSyncConflict) {
          await into(cardTags).insert(cardTag);
        }
        return persistStatus;
      });
    } on EntityAlreadyExistException catch (_) {
      return PersistStatus(
        isSuccessful: true,
        hasSyncConflict: false,
      );
    }
  }

  Future<PersistStatus> syncUpdateCardTags(
    final SyncEntitiesCompanion syncEntity,
    final CardTagsCompanion cardTag, {
    required final bool isDeleted,
    required final bool overrideEnabled,
    required final DateTime deviceLastSyncedAt,
  }) async =>
      await transaction(() async {
        final persistStatus = await updateOrDeleteSyncPulledEntity(
          entityFromCloud: syncEntity,
          isDeleted: isDeleted,
          overrideEnabled: overrideEnabled,
          deviceLastSyncedAt: deviceLastSyncedAt,
        );
        if (persistStatus.isSuccessful && !persistStatus.hasSyncConflict) {
          await update(cardTags).replace(cardTag);
        }
        return persistStatus;
      });

  Future<PersistStatus> syncInsertDeckSettings(
    final SyncEntitiesCompanion syncEntity,
    final DeckSettingsCompanion deckSetting,
  ) async {
    try {
      return await transaction(() async {
        final persistStatus =
            await createSyncPulledEntity<DeckSettings>(syncEntity);
        if (persistStatus.isSuccessful && !persistStatus.hasSyncConflict) {
          await into(deckSettings).insert(deckSetting);
        }
        return persistStatus;
      });
    } on EntityAlreadyExistException catch (_) {
      return PersistStatus(
        isSuccessful: true,
        hasSyncConflict: false,
      );
    }
  }

  Future<PersistStatus> syncUpdateDeckSettings(
    final SyncEntitiesCompanion syncEntity,
    final DeckSettingsCompanion deckSetting, {
    required final bool isDeleted,
    required final bool overrideEnabled,
    required final DateTime deviceLastSyncedAt,
  }) async =>
      await transaction(() async {
        final persistStatus = await updateOrDeleteSyncPulledEntity(
          entityFromCloud: syncEntity,
          isDeleted: isDeleted,
          overrideEnabled: overrideEnabled,
          deviceLastSyncedAt: deviceLastSyncedAt,
        );
        if (persistStatus.isSuccessful && !persistStatus.hasSyncConflict) {
          await update(deckSettings).replace(deckSetting);
        }
        return persistStatus;
      });

  Future<PersistStatus> syncInsertDecks(
    final SyncEntitiesCompanion syncEntity,
    final DecksCompanion deck,
  ) async {
    try {
      return await transaction(() async {
        final persistStatus = await createSyncPulledEntity<Decks>(syncEntity);
        if (persistStatus.isSuccessful && !persistStatus.hasSyncConflict) {
          await into(decks).insert(deck);
        }
        return persistStatus;
      });
    } on EntityAlreadyExistException catch (_) {
      return PersistStatus(
        isSuccessful: true,
        hasSyncConflict: false,
      );
    }
  }

  Future<PersistStatus> syncUpdateDecks(
    final SyncEntitiesCompanion syncEntity,
    final DecksCompanion deck, {
    required final bool isDeleted,
    required final bool overrideEnabled,
    required final DateTime deviceLastSyncedAt,
  }) async =>
      await transaction(() async {
        final persistStatus = await updateOrDeleteSyncPulledEntity(
          entityFromCloud: syncEntity,
          isDeleted: isDeleted,
          overrideEnabled: overrideEnabled,
          deviceLastSyncedAt: deviceLastSyncedAt,
        );
        if (persistStatus.isSuccessful && !persistStatus.hasSyncConflict) {
          await update(decks).replace(deck);
        }
        return persistStatus;
      });

  Future<PersistStatus> syncInsertCards(
    final SyncEntitiesCompanion syncEntity,
    final CardsCompanion card,
  ) async {
    try {
      return await transaction(() async {
        final persistStatus = await createSyncPulledEntity<Cards>(syncEntity);
        if (persistStatus.isSuccessful && !persistStatus.hasSyncConflict) {
          await into(cards).insert(card);
        }
        return persistStatus;
      });
    } on EntityAlreadyExistException catch (_) {
      return PersistStatus(
        isSuccessful: true,
        hasSyncConflict: false,
      );
    }
  }

  Future<PersistStatus> syncUpdateCards(
    final SyncEntitiesCompanion syncEntity,
    final CardsCompanion card, {
    required final bool isDeleted,
    required final bool overrideEnabled,
    required final DateTime deviceLastSyncedAt,
  }) async =>
      await transaction(() async {
        final persistStatus = await updateOrDeleteSyncPulledEntity(
          entityFromCloud: syncEntity,
          isDeleted: isDeleted,
          overrideEnabled: overrideEnabled,
          deviceLastSyncedAt: deviceLastSyncedAt,
        );
        if (persistStatus.isSuccessful && !persistStatus.hasSyncConflict) {
          await update(cards).replace(card);
        }
        return persistStatus;
      });

  Future<PersistStatus> syncInsertCardTagMappings(
    final SyncEntitiesCompanion syncEntity,
    final CardTagMappingsCompanion cardTagMapping,
  ) async {
    try {
      return await transaction(() async {
        final persistStatus =
            await createSyncPulledEntity<CardTagMappings>(syncEntity);
        if (persistStatus.isSuccessful && !persistStatus.hasSyncConflict) {
          await into(cardTagMappings).insert(cardTagMapping);
        }
        return persistStatus;
      });
    } on EntityAlreadyExistException catch (_) {
      return PersistStatus(
        isSuccessful: true,
        hasSyncConflict: false,
      );
    }
  }

  Future<PersistStatus> syncUpdateCardTagMappings(
    final SyncEntitiesCompanion syncEntity,
    final CardTagMappingsCompanion cardTagMapping, {
    required final bool isDeleted,
    required final bool overrideEnabled,
    required final DateTime deviceLastSyncedAt,
  }) async =>
      await transaction(() async {
        final persistStatus = await updateOrDeleteSyncPulledEntity(
          entityFromCloud: syncEntity,
          isDeleted: isDeleted,
          overrideEnabled: overrideEnabled,
          deviceLastSyncedAt: deviceLastSyncedAt,
        );
        if (persistStatus.isSuccessful && !persistStatus.hasSyncConflict) {
          await update(cardTagMappings).replace(cardTagMapping);
        }
        return persistStatus;
      });

  Future<PersistStatus> syncInsertReviewLog(
    final SyncEntitiesCompanion syncEntity,
    final ReviewLogsCompanion reviewLog,
  ) async {
    try {
      return await transaction(() async {
        final persistStatus =
            await createSyncPulledEntity<ReviewLogs>(syncEntity);
        if (persistStatus.isSuccessful && !persistStatus.hasSyncConflict) {
          await into(reviewLogs).insert(reviewLog);
        }
        return persistStatus;
      });
    } on EntityAlreadyExistException catch (_) {
      return PersistStatus(
        isSuccessful: true,
        hasSyncConflict: false,
      );
    }
  }

  Future<PersistStatus> syncUpdateReviewLog(
    final SyncEntitiesCompanion syncEntity,
    final ReviewLogsCompanion reviewLog, {
    required final bool isDeleted,
    required final bool overrideEnabled,
    required final DateTime deviceLastSyncedAt,
  }) async =>
      await transaction(() async {
        final persistStatus = await updateOrDeleteSyncPulledEntity(
          entityFromCloud: syncEntity,
          isDeleted: isDeleted,
          overrideEnabled: overrideEnabled,
          deviceLastSyncedAt: deviceLastSyncedAt,
        );
        if (persistStatus.isSuccessful && !persistStatus.hasSyncConflict) {
          await update(reviewLogs).replace(reviewLog);
        }
        return persistStatus;
      });

  // #endregion
}

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:memori_app/api/sync/card_api.dart';
import 'package:memori_app/api/sync/models/card_schedule_request.dart';
import 'package:memori_app/db/repositories/db_repository.dart';
import 'package:memori_app/db/tables/tables.dart';
import 'package:memori_app/features/cards/bloc/card/congratulate_card_bloc.dart';
import 'package:uuid/uuid.dart';

part 'learn_card_event.dart';
part 'learn_card_state.dart';

class LearnCardBloc extends Bloc<LearnCardEvent, LearnCardState> {
  final DbRepository _dbRepository;
  final CongratulateCardBloc _congratulateBloc;

  LearnCardBloc({
    required final DbRepository dbRepository,
    required final CongratulateCardBloc congratulateBloc,
  })  : _dbRepository = dbRepository,
        _congratulateBloc = congratulateBloc,
        super(
          LearnCardState(
            front: Document(),
            back: Document(),
          ),
        ) {
    on<LearnCardInit>(_onLearnCardInit);
    on<LearnCardNext>(_onLearnCardNext);
    on<LearnCardPrevious>(_onLearnCardPrevious);
    on<LearnCardRated>(_onLearnCardRated);
  }

  static const learnDeckKey = 'learning_deck';
  static const learnStepKey = 'learning_card_step';
  static const learnCardsKey = 'learning_cards';
  static const newStateKey = 'learning_card_new_state_count';
  static const learningStateKey = 'learning_card_learning_state_count';
  static const reviewtateKey = 'learning_card_review_state_count';

  Future<Map<int, CardScheduleHistory>> scheduleCard({
    required final String cardId,
    required final DateTime reviewTime,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return {};
    }
    final card = await _dbRepository.getCardById(cardId);
    if (card == null) {
      return {};
    }
    final response = await CardApi().scheduleCard(
      request: CardScheduleRequest(
        difficulty: card.difficulty,
        due: card.due,
        elapsedDays: card.elapsedDays,
        lapses: card.lapses,
        lastReview: card.lastReview,
        reps: card.reps,
        scheduledDays: card.scheduledDays,
        stability: card.stability,
        state: card.state,
        currentReview: reviewTime,
      ),
    );
    if (response == null) {
      return {};
    }
    final List<CardScheduleHistory> histories = [];
    for (var entry in response.data.entries) {
      histories.add(
        CardScheduleHistory(
          id: const Uuid().v4(),
          lapses: entry.value.card.lapses,
          reps: entry.value.card.reps,
          elapsedDays: entry.value.card.elapsedDays,
          scheduledDays: entry.value.card.scheduledDays,
          difficulty: entry.value.card.difficulty,
          stability: entry.value.card.stability,
          due: entry.value.card.due,
          lastReview: entry.value.card.lastReview,
          review: entry.value.reviewLog.review,
          state: entry.value.card.state,
          rating: entry.value.reviewLog.rating,
          cardId: cardId,
          userId: user.uid,
        ),
      );
    }
    await _dbRepository.updateCardScheduleHistoryByCardId(
      cardId: cardId,
      histories: histories,
    );
    Map<int, CardScheduleHistory> map = {};
    for (final history in histories) {
      map[history.rating] = history;
    }
    return map;
  }

  Future<LearnCardState> getFirstCard({
    required final DateTime reviewTime,
    required final LearnInitStatus initStatus,
    required final bool isShowcasing,
  }) async {
    final learnHistory = await _dbRepository.getDeckLearnHistory();

    final deckId = learnHistory?.deckId ?? '';
    final newStateCount = learnHistory?.newCount ?? 0;
    final learningStateCount = learnHistory?.learningCount ?? 0;
    final reviewStateCount = learnHistory?.reviewCount ?? 0;

    final deck = await _dbRepository.getDeckById(deckId);

    final List<String> cardIds = learnHistory == null
        ? []
        : List<String>.from(jsonDecode(learnHistory.cardIds));
    final curStep = learnHistory?.currentProgress ?? 0;

    /*
    final deckId = _prefs.getString(learnDeckKey);
    final newStateCount = _prefs.getInt(newStateKey);
    final learningStateCount = _prefs.getInt(learningStateKey);
    final reviewStateCount = _prefs.getInt(reviewtateKey);

    final deck = await _dbRepository.getDeckById(deckId ?? '');
    final cardIds = _prefs.getStringList(learnCardsKey);
    final curStep = _prefs.getInt(learnStepKey);
    */

    Card? card;
    Map<int, CardScheduleHistory> histories = {};
    if (cardIds.isNotEmpty) {
      card = await _dbRepository.getCardById(cardIds[curStep]);
      histories = await scheduleCard(
        cardId: card!.id,
        reviewTime: reviewTime,
      );
    }

    return state.copyWith(
      stateId: const Uuid().v4(),
      initStatus: initStatus,
      deckId: deckId,
      deckName: deck?.name,
      newCount: newStateCount,
      learningCount: learningStateCount,
      reviewCount: reviewStateCount,
      curProgress: curStep,
      totalProgress: cardIds.length,
      cardId: card?.id,
      front: card == null ? null : Document.fromJson(json.decode(card.front)),
      back: card == null ? null : Document.fromJson(json.decode(card.back)),
      againNextDue: histories[CardRating.AGAIN.value]?.due,
      hardNextDue: histories[CardRating.HARD.value]?.due,
      goodNextDue: histories[CardRating.GOOD.value]?.due,
      easyNextDue: histories[CardRating.EASY.value]?.due,
      isShowcasing: isShowcasing,
    );
  }

  Future<LearnCardState> getNextCard({
    required final DateTime reviewTime,
    required final int curStep,
  }) async {
    final learnHistory = await _dbRepository.getDeckLearnHistory();
    final List<String> cardIds = learnHistory == null
        ? []
        : List<String>.from(jsonDecode(learnHistory.cardIds));

    // final cardIds = _prefs.getStringList(learnCardsKey);

    Card? card;
    Map<int, CardScheduleHistory> histories = {};
    if (cardIds.isNotEmpty) {
      if (curStep + 1 < cardIds.length) {
        // _prefs.setInt(learnStepKey, curStep + 1);
        await _dbRepository.updateDeckLearnHistoryProgress(curStep + 1);
        card = await _dbRepository.getCardById(cardIds[curStep + 1]);
        histories = await scheduleCard(
          cardId: card!.id,
          reviewTime: reviewTime,
        );
      }
      // Last card
      else if (curStep + 1 == cardIds.length) {
        await _dbRepository.deleteDeckLearnHistory();
        if (learnHistory != null) {
          await _dbRepository.updateDeckLastReviewTime(
            deckId: learnHistory.deckId,
            reviewTime: reviewTime,
          );
        }
        _congratulateBloc.add(const CongratulateCardInit());
      }
    }

    return state.copyWith(
      stateId: const Uuid().v4(),
      initStatus: LearnInitStatus.none,
      curProgress: curStep + 1,
      cardId: card?.id,
      front: card == null ? null : Document.fromJson(json.decode(card.front)),
      back: card == null ? null : Document.fromJson(json.decode(card.back)),
      againNextDue: histories[CardRating.AGAIN.value]?.due,
      hardNextDue: histories[CardRating.HARD.value]?.due,
      goodNextDue: histories[CardRating.GOOD.value]?.due,
      easyNextDue: histories[CardRating.EASY.value]?.due,
      newCount: learnHistory?.newCount,
      learningCount: learnHistory?.learningCount,
      reviewCount: learnHistory?.reviewCount,
    );
  }

  Future<LearnCardState> getPreviousCard({
    required final DateTime reviewTime,
    required final int curStep,
  }) async {
    final learnHistory = await _dbRepository.getDeckLearnHistory();
    final List<String> cardIds = learnHistory == null
        ? []
        : List<String>.from(jsonDecode(learnHistory.cardIds));

    // final cardIds = _prefs.getStringList(learnCardsKey);

    Card? card;
    Map<int, CardScheduleHistory> histories = {};
    if (cardIds.isNotEmpty && curStep - 1 >= 0) {
      // _prefs.setInt(learnStepKey, curStep - 1);
      await _dbRepository.updateDeckLearnHistoryProgress(curStep - 1);
      card = await _dbRepository.getCardById(cardIds[curStep - 1]);
      histories = await scheduleCard(
        cardId: card!.id,
        reviewTime: reviewTime,
      );
    }

    return state.copyWith(
      stateId: const Uuid().v4(),
      initStatus: LearnInitStatus.none,
      curProgress: curStep - 1,
      cardId: card?.id,
      front: card == null ? null : Document.fromJson(json.decode(card.front)),
      back: card == null ? null : Document.fromJson(json.decode(card.back)),
      againNextDue: histories[CardRating.AGAIN.value]?.due,
      hardNextDue: histories[CardRating.HARD.value]?.due,
      goodNextDue: histories[CardRating.GOOD.value]?.due,
      easyNextDue: histories[CardRating.EASY.value]?.due,
    );
  }

  void _onLearnCardInit(
    final LearnCardInit event,
    final Emitter<LearnCardState> emit,
  ) async {
    final deck = await _dbRepository.getDeckById(event.deckId);
    if (deck == null) {
      return;
    }
    final setting = await _dbRepository.getDeckSettingById(deck.deckSettingsId);
    if (setting == null) {
      return;
    }
    bool? resumeLearning = event.resumeLearning;
    LearnInitStatus initStatus = LearnInitStatus.success;
    if (resumeLearning == null || resumeLearning) {
      final learnHistory = await _dbRepository.getDeckLearnHistory();
      final prevLearnedDeck = learnHistory?.deckId ?? '';
      // final prevLearnedDeck = _prefs.getString(learnDeckKey);
      // Finish previous deck, cache should be empty
      if (prevLearnedDeck.isEmpty) {
        resumeLearning = false;
      }
      // X finish previous deck, cache still exist, but then deck id not match
      else if (prevLearnedDeck != event.deckId) {
        resumeLearning = false;
      }
      // X finish previous deck, cache still exist, but then deck id matches
      if (resumeLearning == null) {
        emit(
          state.copyWith(
            stateId: const Uuid().v4(),
            initStatus: LearnInitStatus.askResumeLearning,
            deckId: event.deckId,
          ),
        );
        return;
      }
    }
    if (!resumeLearning) {
      final cardCount = await _dbRepository.getCardCountByDeck(
        deckId: event.deckId,
      );
      if (cardCount == 0) {
        emit(
          state.copyWith(
            stateId: const Uuid().v4(),
            initStatus: LearnInitStatus.noCardCreated,
            deckId: event.deckId,
          ),
        );
        return;
      }

      final List<String> cardIds = [];
      int newCount = 0;
      int learningCount = 0;
      int reviewCount = 0;

      if (!setting.skipReviewCard || !setting.skipLearningCard) {
        final todayReviewCards = await _dbRepository.getTodayReviewCardIds(
          deckId: event.deckId,
          maxReviewPerDay: setting.maxReviewPerDay,
        );

        if (!setting.skipLearningCard) {
          cardIds.addAll(
            todayReviewCards
                .where(
                  (final e) =>
                      e.state == State.LEARNING.value ||
                      e.state == State.RELEARNING.value,
                )
                .map((final e) => e.id)
                .toList(),
          );
          learningCount = todayReviewCards
              .where(
                (final e) =>
                    e.state == State.LEARNING.value ||
                    e.state == State.RELEARNING.value,
              )
              .length;
        }

        if (!setting.skipReviewCard) {
          cardIds.addAll(
            todayReviewCards
                .where((final e) => e.state == State.REVIEW.value)
                .map((final e) => e.id)
                .toList(),
          );
          reviewCount = todayReviewCards
              .where((final e) => e.state == State.REVIEW.value)
              .length;
        }
      }

      if (!setting.skipNewCard) {
        final todayNewCards = await _dbRepository.getTodayNewCardIds(
          deckId: event.deckId,
          maxNewCardsPerDay: setting.maxNewCardsPerDay,
        );
        newCount = todayNewCards.length;
        cardIds.addAll(todayNewCards.map((final e) => e.id).toList());
      }

      if (cardIds.isEmpty) {
        if (setting.skipLearningCard && setting.skipReviewCard) {
          emit(
            state.copyWith(
              stateId: const Uuid().v4(),
              initStatus: LearnInitStatus.noCardMatchCriteria,
              deckId: event.deckId,
            ),
          );
          return;
        } else {
          final todayReviewCards = await _dbRepository.getAllReviewCardIds(
            deckId: event.deckId,
            maxReviewPerDay: setting.maxReviewPerDay,
          );

          if (!setting.skipLearningCard) {
            cardIds.addAll(
              todayReviewCards
                  .where(
                    (final e) =>
                        e.state == State.LEARNING.value ||
                        e.state == State.RELEARNING.value,
                  )
                  .map((final e) => e.id)
                  .toList(),
            );
            learningCount = todayReviewCards
                .where(
                  (final e) =>
                      e.state == State.LEARNING.value ||
                      e.state == State.RELEARNING.value,
                )
                .length;
          }

          if (!setting.skipReviewCard) {
            cardIds.addAll(
              todayReviewCards
                  .where((final e) => e.state == State.REVIEW.value)
                  .map((final e) => e.id)
                  .toList(),
            );
            reviewCount = todayReviewCards
                .where((final e) => e.state == State.REVIEW.value)
                .length;
          }

          if (cardIds.isEmpty) {
            emit(
              state.copyWith(
                stateId: const Uuid().v4(),
                initStatus: LearnInitStatus.noCardMatchCriteria,
                deckId: event.deckId,
              ),
            );
            return;
          } else {
            initStatus = LearnInitStatus.noDueCard;
          }
        }
      }

      /*
      _prefs
        ..setInt(newStateKey, newCount)
        ..setInt(learningStateKey, learningCount)
        ..setInt(reviewtateKey, reviewCount)
        ..setString(learnDeckKey, event.deckId)
        ..setInt(learnStepKey, 0)
        ..setStringList(
          learnCardsKey,
          cardIds,
        );
      */

      await _dbRepository.updateDeckLearnHistory(
        DeckLearnHistoriesCompanion(
          id: Value(const Uuid().v4()),
          newCount: Value(newCount),
          learningCount: Value(learningCount),
          reviewCount: Value(reviewCount),
          deckId: Value(event.deckId),
          currentProgress: const Value(0),
          cardIds: Value(
            jsonEncode(
              cardIds,
            ),
          ),
          userId: Value(
            _dbRepository.getUserId(),
          ),
        ),
      );
    }
    emit(
      await getFirstCard(
        initStatus: initStatus,
        reviewTime: event.reviewTime,
        isShowcasing: event.isShowcasing,
      ),
    );
  }

  void _onLearnCardNext(
    final LearnCardNext event,
    final Emitter<LearnCardState> emit,
  ) async {
    emit(
      await getNextCard(
        curStep: event.curProgress,
        reviewTime: event.reviewTime,
      ),
    );
  }

  void _onLearnCardPrevious(
    final LearnCardPrevious event,
    final Emitter<LearnCardState> emit,
  ) async {
    emit(
      await getPreviousCard(
        curStep: event.curProgress,
        reviewTime: event.reviewTime,
      ),
    );
  }

  void _onLearnCardRated(
    final LearnCardRated event,
    final Emitter<LearnCardState> emit,
  ) async {
    final card = await _dbRepository.getCardById(event.cardId);
    if (card == null) {
      return;
    }
    final learnHistory = await _dbRepository.getDeckLearnHistory();
    if (learnHistory == null) {
      return;
    }
    int newCount = learnHistory.newCount;
    int learningCount = learnHistory.learningCount;
    int reviewCount = learnHistory.reviewCount;
    final histories = await _dbRepository.getCardScheduleHistoryByCardId(
      cardId: event.cardId,
    );
    for (final history in histories) {
      bool match = false;
      switch (event.rating) {
        case LearnCardRating.again:
          if (history.rating == CardRating.AGAIN.value) {
            match = true;
          }
          break;
        case LearnCardRating.hard:
          if (history.rating == CardRating.HARD.value) {
            match = true;
          }
          break;
        case LearnCardRating.good:
          if (history.rating == CardRating.GOOD.value) {
            match = true;
          }
          break;
        case LearnCardRating.easy:
          if (history.rating == CardRating.EASY.value) {
            match = true;
          }
          break;
      }
      if (match) {
        final oldState = card.state;
        await _dbRepository.updateCard(
          card.copyWith(
            difficulty: history.difficulty,
            due: history.due,
            elapsedDays: history.elapsedDays,
            lapses: history.lapses,
            lastReview: history.lastReview,
            reps: history.reps,
            scheduledDays: history.scheduledDays,
            stability: history.stability,
            state: history.state,
          ),
        );
        await _dbRepository.addReviewLog(
          ReviewLogsCompanion(
            cardId: Value(event.cardId),
            elapsedDays: Value(history.elapsedDays),
            scheduledDays: Value(history.scheduledDays),
            review: Value(history.review),
            lastReview: Value(history.lastReview),
            state: Value(history.state),
            rating: Value(history.rating),
            reviewDurationInMs: Value(event.reviewDurationInMs),
          ),
        );
        // update the state count
        if (oldState == State.NEW.value) {
          newCount--;
        } else if (oldState == State.LEARNING.value ||
            oldState == State.RELEARNING.value) {
          learningCount--;
        } else if (oldState == State.REVIEW.value) {
          reviewCount--;
        }
        if (history.state == State.NEW.value) {
          newCount++;
        } else if (history.state == State.LEARNING.value ||
            history.state == State.RELEARNING.value) {
          learningCount++;
        } else if (history.state == State.REVIEW.value) {
          reviewCount++;
        }
        await _dbRepository.updateDeckLearnHistoryCount(
          newCount: newCount,
          learningCount: learningCount,
          reviewCount: reviewCount,
        );
        emit(
          await getNextCard(
            curStep: event.curProgress,
            reviewTime: event.reviewTime,
          ),
        );
        return;
      }
    }
  }
}

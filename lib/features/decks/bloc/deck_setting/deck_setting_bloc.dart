import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:memori_app/db/repositories/db_repository.dart';
import 'package:uuid/uuid.dart';

part 'deck_setting_event.dart';
part 'deck_setting_state.dart';

class DeckSettingBloc extends Bloc<DeckSettingEvent, DeckSettingState> {
  final DbRepository _dbRepository;

  DeckSettingBloc({
    required final DbRepository dbRepository,
  })  : _dbRepository = dbRepository,
        super(const DeckSettingState()) {
    on<DeckSettingsInit>(_onInit);
    on<DeckSettingUpdated>(_onDeck);
  }

  void _onInit(
    final DeckSettingsInit event,
    final Emitter<DeckSettingState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          stateId: const Uuid().v4().toString(),
          deckStatus: FormzSubmissionStatus.inProgress,
        ),
      );
      final deck = await _dbRepository.getDeckById(event.deckId);
      if (deck == null) {
        throw Exception('Deck is missing');
      }
      final deckSetting =
          await _dbRepository.getDeckSettingById(deck.deckSettingsId);
      if (deckSetting == null) {
        throw Exception('Deck setting is missing');
      }
      emit(
        state.copyWith(
          stateId: const Uuid().v4().toString(),
          deckName: deck.name,
          deckStatus: FormzSubmissionStatus.initial,
          deckSettingId: deckSetting.id,
          newCardPerDay: deckSetting.maxNewCardsPerDay,
          maxReviewPerDay: deckSetting.maxReviewPerDay,
          skipNewCard: deckSetting.skipNewCard,
          skipLearningCard: deckSetting.skipLearningCard,
          skipReviewCard: deckSetting.skipReviewCard,
        ),
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(
        state.copyWith(
          deckStatus: FormzSubmissionStatus.failure,
        ),
      );
    }
  }

  void _onDeck(
    final DeckSettingUpdated event,
    final Emitter<DeckSettingState> emit,
  ) async {
    emit(
      state.copyWith(
        deckStatus: FormzSubmissionStatus.inProgress,
      ),
    );
    try {
      final deckSetting =
          await _dbRepository.getDeckSettingById(event.deckSettingId);
      if (deckSetting == null) {
        return;
      }
      await _dbRepository.updateDeckSetting(
        deckSetting.copyWith(
          maxNewCardsPerDay: event.newCardPerDay,
          maxReviewPerDay: event.maxReviewPerDay,
          skipNewCard: event.skipNewCard,
          skipLearningCard: event.skipLearningCard,
          skipReviewCard: event.skipReviewCard,
        ),
      );
      emit(
        state.copyWith(
          deckStatus: FormzSubmissionStatus.success,
        ),
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(
        state.copyWith(
          deckStatus: FormzSubmissionStatus.failure,
        ),
      );
    }
  }
}

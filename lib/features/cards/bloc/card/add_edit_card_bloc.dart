import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:memori_app/db/repositories/db_repository.dart';
import 'package:memori_app/features/cards/bloc/card/card_bloc.dart';
import 'package:memori_app/features/cards/models/tag_dropdown_option.dart';
import 'package:uuid/uuid.dart';

part 'add_edit_card_event.dart';
part 'add_edit_card_state.dart';

class AddEditCardBloc extends Bloc<AddEditCardEvent, AddEditCardState> {
  final DbRepository _dbRepository;
  final CardBloc _cardBloc;

  AddEditCardBloc({
    required final DbRepository dbRepository,
    required final CardBloc cardBloc,
  })  : _dbRepository = dbRepository,
        _cardBloc = cardBloc,
        super(
          AddEditCardState(
            cardId: '',
            selectedTags: const [],
            front: Document(),
            back: Document(),
          ),
        ) {
    on<AddEditCardFormInit>(_onAddEditCardInit);
    on<AddEditCardChanged>(_onAddEditCardChanged);
    on<AddEditCardDeleted>(_onAddEditCardDeleted);
  }

  void _onAddEditCardInit(
    final AddEditCardFormInit event,
    final Emitter<AddEditCardState> emit,
  ) async {
    if (event.cardId.isEmpty) {
      emit(
        state.copyWith(
          cardId: '',
          stateId: const Uuid().v4(),
          submittedAction: null,
          submissionStatus: AddEditCardStatus.initial,
          selectedDeck: '',
          deckName: '',
          selectedTags: [],
          front: Document(),
          back: Document(),
          isShowcasing: event.isShowcasing,
        ),
      );
      return;
    }
    final card = await _dbRepository.getCardById(event.cardId);
    if (card == null) {
      return;
    }
    final deck = await _dbRepository.getDeckById(card.deckId);
    if (deck == null) {
      return;
    }
    final cardTags = await _dbRepository.getCardTagByCardId(cardId: card.id);
    emit(
      state.copyWith(
        cardId: card.id,
        stateId: const Uuid().v4(),
        submittedAction: null,
        submissionStatus: AddEditCardStatus.initial,
        selectedDeck: deck.id,
        deckName: deck.name,
        selectedTags: cardTags
            .map(
              (final e) => SelectCardTagDropdownOption(
                id: e.id,
                name: e.name,
              ),
            )
            .toList(),
        front: Document.fromJson(json.decode(card.front)),
        back: Document.fromJson(json.decode(card.back)),
        isShowcasing: false,
      ),
    );
  }

  void _onAddEditCardChanged(
    final AddEditCardChanged event,
    final Emitter<AddEditCardState> emit,
  ) async {
    final deck = await _dbRepository.getDeckById(event.selectedDeck);
    List<String> finalTags = [];
    for (final tagId in event.selectedTags) {
      final cardTag = await _dbRepository.getCardTagById(tagId);
      if (cardTag != null) {
        finalTags.add(tagId);
      }
    }
    final cur = state.copyWith(
      stateId: const Uuid().v4(),
      isDeckValid: deck != null,
      isTagValid: true,
      isFrontValid: event.front.toPlainText().trim().isNotEmpty,
      isBackValid: event.back.toPlainText().trim().isNotEmpty,
    );
    if (cur.isDeckValid &&
        cur.isTagValid &&
        cur.isFrontValid &&
        cur.isBackValid) {
      if (event.action == AddEditCardAction.create) {
        final cardId = await _dbRepository.createDefaultCard(
          deckId: event.selectedDeck,
          front: jsonEncode(event.front.toDelta().toJson()),
          frontPlainText: event.front.toPlainText(),
          back: jsonEncode(event.back.toDelta().toJson()),
          backPlainText: event.back.toPlainText(),
        );
        await _dbRepository.updateCardTagMapping(cardId, finalTags);
        emit(
          cur.copyWith(
            cardId: cardId,
            stateId: const Uuid().v4(),
            submittedAction: event.action,
            submissionStatus: AddEditCardStatus.completed,
            newlyEditedDeckId: event.selectedDeck,
          ),
        );
        return;
      }
      final card = await _dbRepository.getCardById(event.id);
      if (card == null) {
        emit(
          cur.copyWith(
            cardId: '',
            stateId: const Uuid().v4(),
            submittedAction: event.action,
            submissionStatus: AddEditCardStatus.inputInvalid,
            newlyEditedDeckId: '',
          ),
        );
        return;
      }
      if (event.action == AddEditCardAction.update) {
        await _dbRepository.updateCard(
          card.copyWith(
            deckId: deck!.id,
            front: jsonEncode(event.front.toDelta().toJson()),
            frontPlainText: event.front.toPlainText(),
            back: jsonEncode(event.back.toDelta().toJson()),
            backPlainText: event.back.toPlainText(),
          ),
        );
        await _dbRepository.updateCardTagMapping(event.id, finalTags);
      } else if (event.action == AddEditCardAction.delete) {
        await _dbRepository.deleteCard(card);
      }
      emit(
        cur.copyWith(
          cardId: event.id,
          stateId: const Uuid().v4(),
          submittedAction: event.action,
          submissionStatus: AddEditCardStatus.completed,
          newlyEditedDeckId: '',
        ),
      );
      _cardBloc.add(CardReloaded());
    } else {
      emit(
        cur.copyWith(
          cardId: event.id,
          stateId: const Uuid().v4(),
          submittedAction: event.action,
          submissionStatus: AddEditCardStatus.inputInvalid,
          newlyEditedDeckId: '',
        ),
      );
    }
  }

  void _onAddEditCardDeleted(
    final AddEditCardDeleted event,
    final Emitter<AddEditCardState> emit,
  ) async {
    final card = await _dbRepository.getCardById(event.id);
    if (card == null) {
      emit(
        state.copyWith(
          cardId: '',
          stateId: const Uuid().v4(),
          submittedAction: AddEditCardAction.delete,
          submissionStatus: AddEditCardStatus.inputInvalid,
          newlyEditedDeckId: '',
        ),
      );
      return;
    }
    await _dbRepository.deleteCard(card);
    emit(
      state.copyWith(
        cardId: '',
        stateId: const Uuid().v4(),
        submittedAction: AddEditCardAction.delete,
        submissionStatus: AddEditCardStatus.completed,
        newlyEditedDeckId: '',
      ),
    );
    _cardBloc.add(CardReloaded());
  }
}

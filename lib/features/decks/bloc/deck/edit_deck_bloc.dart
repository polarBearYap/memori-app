import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:memori_app/db/repositories/db_repository.dart';
import 'package:memori_app/features/decks/bloc/deck/deck_bloc.dart';
import 'package:memori_app/features/decks/models/deck.dart';

part 'edit_deck_event.dart';
part 'edit_deck_state.dart';

class EditDeckBloc extends Bloc<EditDeckEvent, EditDeckState> {
  final DbRepository _dbRepository;
  final DeckBloc _deckBloc;

  EditDeckBloc({
    required final DbRepository dbRepository,
    required final DeckBloc deckBloc,
  })  : _dbRepository = dbRepository,
        _deckBloc = deckBloc,
        super(const EditDeckState()) {
    on<EditDeckOpened>(_onDeckFormInit);
    on<DeckNameChanged>(_onDeckNameChanged);
    on<DeckEditedSubmitted>(_onDeckEditedSubmitted);
  }

  void _onDeckFormInit(
    final EditDeckOpened event,
    final Emitter<EditDeckState> emit,
  ) async {
    final deck = await _dbRepository.getDeckById(event.deckId);
    if (deck == null) {
      return;
    }
    final deckInput = DeckInput.dirty(deck.name);
    emit(
      state.copyWith(
        deckEdited: deckInput,
        deckEditedStatus: FormzSubmissionStatus.initial,
        overrideDeckName: true,
      ),
    );
  }

  void _onDeckNameChanged(
    final DeckNameChanged event,
    final Emitter<EditDeckState> emit,
  ) {
    final deck = DeckInput.dirty(event.deckName);
    emit(
      state.copyWith(
        deckEdited: deck,
        deckEditedStatus:
            state.deckEditedStatus == FormzSubmissionStatus.failure
                ? FormzSubmissionStatus.initial
                : state.deckEditedStatus,
        overrideDeckName: false,
      ),
    );
  }

  void _onDeckEditedSubmitted(
    final DeckEditedSubmitted event,
    final Emitter<EditDeckState> emit,
  ) async {
    final deck = DeckInput.dirty(event.deckName);
    if (deck.isNotValid) {
      emit(
        state.copyWith(
          deckEdited: deck,
          overrideDeckName: false,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        deckEditedStatus: FormzSubmissionStatus.inProgress,
        overrideDeckName: false,
      ),
    );
    try {
      final deck = await _dbRepository.getDeckById(event.deckId);
      if (deck == null) {
        return;
      }
      await _dbRepository.updateDeck(
        deck.copyWith(
          name: event.deckName,
        ),
      );
      emit(
        state.copyWith(
          deckEditedStatus: FormzSubmissionStatus.success,
        ),
      );
      _deckBloc.add(const DeckReloaded());
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(
        state.copyWith(
          deckEditedStatus: FormzSubmissionStatus.failure,
        ),
      );
    }
  }
}

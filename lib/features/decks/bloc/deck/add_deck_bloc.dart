import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:memori_app/db/repositories/db_repository.dart';
import 'package:memori_app/features/decks/bloc/deck/deck_bloc.dart';
import 'package:memori_app/features/decks/models/deck.dart';

part 'add_deck_event.dart';
part 'add_deck_state.dart';

class AddDeckBloc extends Bloc<AddDeckEvent, AddDeckState> {
  final DbRepository _dbRepository;
  final DeckBloc _deckBloc;

  AddDeckBloc({
    required final DbRepository dbRepository,
    required final DeckBloc deckBloc,
  })  : _dbRepository = dbRepository,
        _deckBloc = deckBloc,
        super(const AddDeckState()) {
    on<AddDeckOpened>(_onDeckFormInit);
    on<DeckNameChanged>(_onDeckNameChanged);
    on<DeckAddedSubmitted>(_onDeckAddedSubmitted);
  }

  void _onDeckFormInit(
    final AddDeckOpened event,
    final Emitter<AddDeckState> emit,
  ) {
    const deck = DeckInput.dirty('');
    emit(
      state.copyWith(
        deckAdded: deck,
        deckAddedStatus: FormzSubmissionStatus.initial,
      ),
    );
  }

  void _onDeckNameChanged(
    final DeckNameChanged event,
    final Emitter<AddDeckState> emit,
  ) {
    final deck = DeckInput.dirty(event.deckName);
    emit(
      state.copyWith(
        deckAdded: deck,
        deckAddedStatus: state.deckAddedStatus == FormzSubmissionStatus.failure
            ? FormzSubmissionStatus.initial
            : state.deckAddedStatus,
      ),
    );
  }

  void _onDeckAddedSubmitted(
    final DeckAddedSubmitted event,
    final Emitter<AddDeckState> emit,
  ) async {
    final deck = DeckInput.dirty(event.deckName);
    if (deck.isNotValid) {
      emit(
        state.copyWith(
          deckAdded: deck,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        deckAddedStatus: FormzSubmissionStatus.inProgress,
      ),
    );
    try {
      final deckId = await _dbRepository.addDeckByName(
        event.deckName,
      );
      emit(
        state.copyWith(
          deckAddedStatus: FormzSubmissionStatus.success,
        ),
      );
      _deckBloc.add(
        DeckReloaded(
          newlyAddedDeckId: event.isShowcasing ? deckId : '',
        ),
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(
        state.copyWith(
          deckAddedStatus: FormzSubmissionStatus.failure,
        ),
      );
    }
  }
}

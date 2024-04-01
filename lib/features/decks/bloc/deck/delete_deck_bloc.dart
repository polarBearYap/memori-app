import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:memori_app/db/repositories/db_repository.dart';
import 'package:memori_app/features/decks/bloc/deck/deck_bloc.dart';

part 'delete_deck_event.dart';
part 'delete_deck_state.dart';

class DeleteDeckBloc extends Bloc<DeleteDeckEvent, DeleteDeckState> {
  final DbRepository _dbRepository;
  final DeckBloc _deckBloc;

  DeleteDeckBloc({
    required final DbRepository dbRepository,
    required final DeckBloc deckBloc,
  })  : _dbRepository = dbRepository,
        _deckBloc = deckBloc,
        super(const DeleteDeckState()) {
    on<DeckDeleted>(_onDeckDeleted);
  }

  void _onDeckDeleted(
    final DeckDeleted event,
    final Emitter<DeleteDeckState> emit,
  ) async {
    emit(
      state.copyWith(
        deckDeletedStatus: FormzSubmissionStatus.inProgress,
      ),
    );
    try {
      final deck = await _dbRepository.getDeckById(event.deckId);
      if (deck == null) {
        return;
      }
      await _dbRepository.deleteDeck(
        deck,
      );
      emit(
        state.copyWith(
          deckDeletedStatus: FormzSubmissionStatus.success,
        ),
      );
      _deckBloc.add(const DeckReloaded());
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(
        state.copyWith(
          deckDeletedStatus: FormzSubmissionStatus.failure,
        ),
      );
    }
  }
}

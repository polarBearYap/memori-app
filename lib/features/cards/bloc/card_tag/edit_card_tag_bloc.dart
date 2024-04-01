import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:memori_app/db/repositories/db_repository.dart';
import 'package:memori_app/features/cards/bloc/card/card_bloc.dart';
import 'package:memori_app/features/cards/bloc/card_tag/card_tag_bloc.dart';
import 'package:memori_app/features/cards/models/card_tag.dart';

part 'edit_card_tag_event.dart';
part 'edit_card_tag_state.dart';

class EditCardTagBloc extends Bloc<EditCardTagEvent, EditCardTagState> {
  final DbRepository _dbRepository;
  final CardTagBloc _cardTagBloc;
  final CardBloc _cardBloc;

  EditCardTagBloc({
    required final DbRepository dbRepository,
    required final CardTagBloc cardTagBloc,
    required final CardBloc cardBloc,
  })  : _dbRepository = dbRepository,
        _cardTagBloc = cardTagBloc,
        _cardBloc = cardBloc,
        super(const EditCardTagState()) {
    on<EditCardTagOpened>(_onCardTagFormInit);
    on<CardTagNameChanged>(_onCardTagNameChanged);
    on<CardTagEditedSubmitted>(_onCardTagEditedSubmitted);
  }

  void _onCardTagFormInit(
    final EditCardTagOpened event,
    final Emitter<EditCardTagState> emit,
  ) async {
    final cardTag = await _dbRepository.getCardTagById(event.cardTagId);
    if (cardTag == null) {
      return;
    }
    final cardTagInput = CardTagInput.dirty(cardTag.name);
    emit(
      state.copyWith(
        cardTagEdited: cardTagInput,
        cardTagEditedStatus: FormzSubmissionStatus.initial,
        overrideCardTagName: true,
      ),
    );
  }

  void _onCardTagNameChanged(
    final CardTagNameChanged event,
    final Emitter<EditCardTagState> emit,
  ) {
    final cardTag = CardTagInput.dirty(event.cardTagName);
    emit(
      state.copyWith(
        cardTagEdited: cardTag,
        cardTagEditedStatus:
            state.cardTagEditedStatus == FormzSubmissionStatus.failure
                ? FormzSubmissionStatus.initial
                : state.cardTagEditedStatus,
        overrideCardTagName: false,
      ),
    );
  }

  void _onCardTagEditedSubmitted(
    final CardTagEditedSubmitted event,
    final Emitter<EditCardTagState> emit,
  ) async {
    final cardTag = CardTagInput.dirty(event.cardTagName);
    if (cardTag.isNotValid) {
      emit(
        state.copyWith(
          cardTagEdited: cardTag,
          overrideCardTagName: false,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        cardTagEditedStatus: FormzSubmissionStatus.inProgress,
        overrideCardTagName: false,
      ),
    );
    try {
      final cardTag = await _dbRepository.getCardTagById(event.cardTagId);
      if (cardTag == null) {
        return;
      }
      await _dbRepository.updateCardTag(
        cardTag.copyWith(
          name: event.cardTagName,
        ),
      );
      emit(
        state.copyWith(
          id: cardTag.id,
          cardTagName: event.cardTagName,
          cardTagEditedStatus: FormzSubmissionStatus.success,
        ),
      );
      _cardTagBloc.add(CardTagReloaded());
      _cardBloc.add(CardReloaded());
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(
        state.copyWith(
          cardTagEditedStatus: FormzSubmissionStatus.failure,
        ),
      );
    }
  }
}

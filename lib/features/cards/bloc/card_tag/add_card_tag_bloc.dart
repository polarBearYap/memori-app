import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:memori_app/db/repositories/db_repository.dart';
import 'package:memori_app/features/cards/bloc/card_tag/card_tag_bloc.dart';
import 'package:memori_app/features/cards/models/card_tag.dart';

part 'add_card_tag_event.dart';
part 'add_card_tag_state.dart';

class AddCardTagBloc extends Bloc<AddCardTagEvent, AddCardTagState> {
  final DbRepository _dbRepository;
  final CardTagBloc _cardTagBloc;

  AddCardTagBloc({
    required final DbRepository dbRepository,
    required final CardTagBloc cardTagBloc,
  })  : _dbRepository = dbRepository,
        _cardTagBloc = cardTagBloc,
        super(const AddCardTagState()) {
    on<AddCardTagOpened>(_onCardTagFormInit);
    on<CardTagNameChanged>(_onCardTagNameChanged);
    on<CardTagAddedSubmitted>(_onCardTagAddedSubmitted);
  }

  void _onCardTagFormInit(
    final AddCardTagOpened event,
    final Emitter<AddCardTagState> emit,
  ) {
    final cardTag = CardTagInput.dirty(event.cardTagName);
    emit(
      state.copyWith(
        cardTagAdded: cardTag,
        cardTagAddedStatus: FormzSubmissionStatus.initial,
      ),
    );
  }

  void _onCardTagNameChanged(
    final CardTagNameChanged event,
    final Emitter<AddCardTagState> emit,
  ) {
    final cardTag = CardTagInput.dirty(event.cardTagName);
    emit(
      state.copyWith(
        cardTagAdded: cardTag,
        cardTagAddedStatus:
            state.cardTagAddedStatus == FormzSubmissionStatus.failure
                ? FormzSubmissionStatus.initial
                : state.cardTagAddedStatus,
      ),
    );
  }

  void _onCardTagAddedSubmitted(
    final CardTagAddedSubmitted event,
    final Emitter<AddCardTagState> emit,
  ) async {
    final cardTag = CardTagInput.dirty(event.cardTagName);
    if (cardTag.isNotValid) {
      emit(
        state.copyWith(
          cardTagAdded: cardTag,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        cardTagAddedStatus: FormzSubmissionStatus.inProgress,
      ),
    );
    try {
      await _dbRepository.addCardTagByName(
        event.cardTagName,
      );
      emit(
        state.copyWith(
          cardTagAddedStatus: FormzSubmissionStatus.success,
        ),
      );
      _cardTagBloc.add(CardTagReloaded());
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(
        state.copyWith(
          cardTagAddedStatus: FormzSubmissionStatus.failure,
        ),
      );
    }
  }
}

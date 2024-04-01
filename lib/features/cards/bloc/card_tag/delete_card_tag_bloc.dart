import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:memori_app/db/repositories/db_repository.dart';
import 'package:memori_app/features/cards/bloc/card_tag/card_tag_bloc.dart';

part 'delete_card_tag_event.dart';
part 'delete_card_tag_state.dart';

class DeleteCardTagBloc extends Bloc<DeleteCardTagEvent, DeleteCardTagState> {
  final DbRepository _dbRepository;
  final CardTagBloc _cardTagBloc;

  DeleteCardTagBloc({
    required final DbRepository dbRepository,
    required final CardTagBloc cardTagBloc,
  })  : _dbRepository = dbRepository,
        _cardTagBloc = cardTagBloc,
        super(const DeleteCardTagState()) {
    on<CardTagDeleted>(_onCardTagDeleted);
  }

  void _onCardTagDeleted(
    final CardTagDeleted event,
    final Emitter<DeleteCardTagState> emit,
  ) async {
    emit(
      state.copyWith(
        cardTagDeletedStatus: FormzSubmissionStatus.inProgress,
      ),
    );
    try {
      final cardTag = await _dbRepository.getCardTagById(event.cardTagId);
      if (cardTag == null) {
        return;
      }
      await _dbRepository.deleteCardTag(
        cardTag,
      );
      emit(
        state.copyWith(
          id: cardTag.id,
          cardTagName: cardTag.name,
          cardTagDeletedStatus: FormzSubmissionStatus.success,
        ),
      );
      _cardTagBloc.add(CardTagReloaded());
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(
        state.copyWith(
          cardTagDeletedStatus: FormzSubmissionStatus.failure,
        ),
      );
    }
  }
}

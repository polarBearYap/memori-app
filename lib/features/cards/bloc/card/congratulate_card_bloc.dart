import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memori_app/db/repositories/db_repository.dart';
import 'package:uuid/uuid.dart';

part 'congratulate_card_event.dart';
part 'congratulate_card_state.dart';

class CongratulateCardBloc
    extends Bloc<CongratulateCardEvent, CongratulateCardState> {
  final DbRepository _dbRepository;

  CongratulateCardBloc({required final DbRepository dbRepository})
      : _dbRepository = dbRepository,
        super(const CongratulateCardState()) {
    on<CongratulateCardInit>(_onCongratulateCardInit);
  }

  void _onCongratulateCardInit(
    final CongratulateCardInit event,
    final Emitter<CongratulateCardState> emit,
  ) async {
    emit(
      state.copyWith(
        stateId: const Uuid().v4(),
        deckCount: await _dbRepository.getTodayLearntDeckCount(),
      ),
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:uuid/uuid.dart';

part 'preview_card_event.dart';
part 'preview_card_state.dart';

class PreviewCardBloc extends Bloc<PreviewCardEvent, PreviewCardState> {
  PreviewCardBloc()
      : super(
          PreviewCardState(
            frontDocument: Document(),
            backDocument: Document(),
          ),
        ) {
    on<PreviewCardOpened>(_onCardFormInit);
  }

  void _onCardFormInit(
    final PreviewCardOpened event,
    final Emitter<PreviewCardState> emit,
  ) async {
    emit(
      state.copyWith(
        stateId: const Uuid().v4().toString(),
        frontDocument: event.frontDocument,
        backDocument: event.backDocument,
      ),
    );
  }
}

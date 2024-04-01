import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'quill_event.dart';
part 'quill_state.dart';

class CardScreenBloc extends Bloc<CardScreenEvent, CardScreenState> {
  CardScreenBloc() : super(const CardScreenState()) {
    on<SearchOpened>(_onSearchOpened);
    on<SearchClosed>(_onSearchClosed);
  }

  void _onSearchOpened(
    final SearchOpened event,
    final Emitter<CardScreenState> emit,
  ) {
    emit(
      state.copyWith(
        isSearchOpened: true,
      ),
    );
  }

  void _onSearchClosed(
    final SearchClosed event,
    final Emitter<CardScreenState> emit,
  ) {
    emit(
      state.copyWith(
        isSearchOpened: false,
      ),
    );
  }
}

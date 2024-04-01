import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memori_app/firebase/auth/auth.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  LogoutBloc({
    required final AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LogoutState()) {
    on<LogoutSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _onSubmitted(
    final LogoutSubmitted event,
    final Emitter<LogoutState> emit,
  ) async {
    try {
      emit(state.copyWith(logoutStatus: LogoutStatus.inprogress));
      await _authenticationRepository.logOut();
      emit(state.copyWith(logoutStatus: LogoutStatus.success));
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(state.copyWith(logoutStatus: LogoutStatus.failed));
    }
  }
}

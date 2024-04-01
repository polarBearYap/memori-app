import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:formz/formz.dart';
import 'package:memori_app/features/authentication/models/models.dart';
import 'package:memori_app/firebase/auth/auth.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required final AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginPasswordVisibilityChanged>(_onPasswordVisiblityChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  FormzSubmissionStatus _adjustSubmissionStatusOnInputChanged(
    final FormzSubmissionStatus status,
  ) {
    if (status == FormzSubmissionStatus.failure ||
        status == FormzSubmissionStatus.success) {
      return FormzSubmissionStatus.initial;
    }
    return status;
  }

  void _onEmailChanged(
    final LoginEmailChanged event,
    final Emitter<LoginState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        status: _adjustSubmissionStatusOnInputChanged(state.status),
        isValid: Formz.validate([state.password, email]),
      ),
    );
  }

  void _onPasswordChanged(
    final LoginPasswordChanged event,
    final Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        status: _adjustSubmissionStatusOnInputChanged(state.status),
        isValid: Formz.validate([password, state.email]),
      ),
    );
  }

  void _onPasswordVisiblityChanged(
    final LoginPasswordVisibilityChanged event,
    final Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(
        isPasswordVisible: !state.isPasswordVisible,
        status: _adjustSubmissionStatusOnInputChanged(state.status),
      ),
    );
  }

  Future<void> _onSubmitted(
    final LoginSubmitted event,
    final Emitter<LoginState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await _authenticationRepository.logInWithEmailAndPassword(
          email: state.email.value,
          password: state.password.value,
          localized: event.localized,
        );
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } on LogInWithEmailAndPasswordFailure catch (e) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            failedMessage: e.message,
          ),
        );
      } on Exception catch (e) {
        if (kDebugMode) {
          print(e);
        }
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:formz/formz.dart';
import 'package:memori_app/features/authentication/models/models.dart';
import 'package:memori_app/features/authentication/utilities/password_strength_checker.dart';
import 'package:memori_app/features/authentication/utilities/utilities.dart';
import 'package:memori_app/firebase/auth/auth.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({
    required final AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const SignUpState()) {
    on<SignUpUsernameChanged>(_onUsernameChanged);
    on<SignUpEmailChanged>(_onEmailChanged);
    on<SignUpPasswordChanged>(_onPasswordChanged);
    on<SignUpPasswordConfirmChanged>(_onPasswordMatchChanged);
    on<SignUpPasswordVisibilityChanged>(_onPasswordVisiblityChanged);
    on<SignUpPasswordConfirmVisibilityChanged>(
      _onPasswordConfirmVisiblityChanged,
    );
    on<SignUpSubmitted>(_onSubmitted);
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

  void _onUsernameChanged(
    final SignUpUsernameChanged event,
    final Emitter<SignUpState> emit,
  ) {
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        isValid: Formz.validate(
          [state.password, state.passwordConfirm, state.email, username],
        ),
        status: _adjustSubmissionStatusOnInputChanged(state.status),
      ),
    );
  }

  void _onEmailChanged(
    final SignUpEmailChanged event,
    final Emitter<SignUpState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate(
          [state.password, state.passwordConfirm, email, state.username],
        ),
        status: _adjustSubmissionStatusOnInputChanged(state.status),
      ),
    );
  }

  void _onPasswordChanged(
    final SignUpPasswordChanged event,
    final Emitter<SignUpState> emit,
  ) {
    final passwordStrength = evaluatePasswordStrength(event.password);
    final password = NewPassword.dirty(
      passwordStrength: passwordStrength,
      value: event.password,
    );
    final passwordConfirm = PasswordConfirm.dirty(
      originalPassword: event.password,
      value: state.passwordConfirm.value,
    );
    emit(
      state.copyWith(
        password: password,
        previousPasswordStrength: state.passwordStrength,
        passwordStrength: passwordStrength,
        passwordValidation: validatePassword(event.password),
        passwordConfirm: passwordConfirm,
        isValid: Formz.validate(
          [password, passwordConfirm, state.email, state.username],
        ),
        status: _adjustSubmissionStatusOnInputChanged(state.status),
      ),
    );
  }

  void _onPasswordMatchChanged(
    final SignUpPasswordConfirmChanged event,
    final Emitter<SignUpState> emit,
  ) {
    final passwordConfirm = PasswordConfirm.dirty(
      originalPassword: state.password.value,
      value: event.passwordConfirm,
    );
    emit(
      state.copyWith(
        passwordConfirm: passwordConfirm,
        isValid: Formz.validate(
          [state.password, passwordConfirm, state.email, state.username],
        ),
        status: _adjustSubmissionStatusOnInputChanged(state.status),
      ),
    );
  }

  void _onPasswordVisiblityChanged(
    final SignUpPasswordVisibilityChanged event,
    final Emitter<SignUpState> emit,
  ) {
    emit(
      state.copyWith(
        isPasswordVisible: event.isPasswordVisible,
        status: _adjustSubmissionStatusOnInputChanged(state.status),
      ),
    );
  }

  void _onPasswordConfirmVisiblityChanged(
    final SignUpPasswordConfirmVisibilityChanged event,
    final Emitter<SignUpState> emit,
  ) {
    emit(
      state.copyWith(
        isPasswordConfirmVisible: event.isPasswordVisible,
        status: _adjustSubmissionStatusOnInputChanged(state.status),
      ),
    );
  }

  Future<void> _onSubmitted(
    final SignUpSubmitted event,
    final Emitter<SignUpState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await _authenticationRepository.signUp(
          username: state.username.value,
          email: state.email.value,
          password: state.password.value,
          localized: event.localized,
        );
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } on SignUpWithEmailAndPasswordFailure catch (e) {
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

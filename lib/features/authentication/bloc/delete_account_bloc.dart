import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:formz/formz.dart';
import 'package:memori_app/features/authentication/models/models.dart';
import 'package:memori_app/firebase/auth/auth.dart';

part 'delete_account_event.dart';
part 'delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  DeleteAccountBloc({
    required final AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const DeleteAccountState()) {
    on<DeleteAccountPasswordChanged>(_onPasswordChanged);
    on<DeleteAccountPasswordVisibilityChanged>(_onPasswordVisiblityChanged);
    on<DeleteAccountSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  FormzSubmissionStatus _adjustSubmissionStatusOnInputChanged(
    final FormzSubmissionStatus status,
  ) {
    if (status == FormzSubmissionStatus.failure) {
      return FormzSubmissionStatus.initial;
    }
    return status;
  }

  void _onPasswordChanged(
    final DeleteAccountPasswordChanged event,
    final Emitter<DeleteAccountState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        status: _adjustSubmissionStatusOnInputChanged(state.status),
        isValid: Formz.validate([password]),
      ),
    );
  }

  void _onPasswordVisiblityChanged(
    final DeleteAccountPasswordVisibilityChanged event,
    final Emitter<DeleteAccountState> emit,
  ) {
    emit(
      state.copyWith(
        isPasswordVisible: !state.isPasswordVisible,
        status: _adjustSubmissionStatusOnInputChanged(state.status),
      ),
    );
  }

  Future<void> _onSubmitted(
    final DeleteAccountSubmitted event,
    final Emitter<DeleteAccountState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await _authenticationRepository.deleteUser(
          password: state.password.value,
          localized: event.localized,
        );
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
          ),
        );
      } on ReauthenticateWithPasswordFailure catch (e) {
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

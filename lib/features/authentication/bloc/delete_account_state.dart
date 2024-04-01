part of 'delete_account_bloc.dart';

final class DeleteAccountState extends Equatable {
  const DeleteAccountState({
    this.status = FormzSubmissionStatus.initial,
    this.password = const Password.pure(),
    this.isValid = false,
    this.isPasswordVisible = false,
    this.failedMessage = "",
  });

  final FormzSubmissionStatus status;
  final Password password;
  final bool isValid;
  final bool isPasswordVisible;
  final String failedMessage;

  DeleteAccountState copyWith({
    final FormzSubmissionStatus? status,
    final Password? password,
    final bool? isValid,
    final bool? isPasswordVisible,
    final String? failedMessage,
  }) =>
      DeleteAccountState(
        status: status ?? this.status,
        password: password ?? this.password,
        isValid: isValid ?? this.isValid,
        isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
        failedMessage: failedMessage ?? this.failedMessage,
      );

  @override
  List<Object> get props => [
        status,
        password,
        isPasswordVisible,
        failedMessage,
      ];
}

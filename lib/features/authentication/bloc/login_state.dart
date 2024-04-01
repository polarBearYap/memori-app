part of 'login_bloc.dart';

final class LoginState extends Equatable {
  const LoginState({
    this.status = FormzSubmissionStatus.initial,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
    this.isPasswordVisible = false,
    this.failedMessage = "",
  });

  final FormzSubmissionStatus status;
  final Email email;
  final Password password;
  final bool isValid;
  final bool isPasswordVisible;
  final String failedMessage;

  LoginState copyWith({
    final FormzSubmissionStatus? status,
    final Email? email,
    final Password? password,
    final bool? isValid,
    final bool? isPasswordVisible,
    final String? failedMessage,
  }) =>
      LoginState(
        status: status ?? this.status,
        email: email ?? this.email,
        password: password ?? this.password,
        isValid: isValid ?? this.isValid,
        isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
        failedMessage: failedMessage ?? this.failedMessage,
      );

  @override
  List<Object> get props => [
        status,
        email,
        password,
        isPasswordVisible,
        failedMessage,
      ];
}

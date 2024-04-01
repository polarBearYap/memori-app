part of 'signup_bloc.dart';

final class SignUpState extends Equatable {
  const SignUpState({
    this.status = FormzSubmissionStatus.initial,
    this.username = const Username.pure(),
    this.email = const Email.pure(),
    this.password = const NewPassword.pure(),
    this.passwordConfirm = const PasswordConfirm.pure(),
    this.isValid = false,
    this.isPasswordVisible = false,
    this.isPasswordConfirmVisible = false,
    this.passwordStrength = PasswordStrength.unspecified,
    this.previousPasswordStrength = PasswordStrength.unspecified,
    this.passwordValidation = const PasswordValidation(),
    this.failedMessage = "",
  });

  final FormzSubmissionStatus status;
  final Username username;
  final Email email;
  final NewPassword password;
  final PasswordConfirm passwordConfirm;
  final bool isValid;
  final bool isPasswordVisible;
  final bool isPasswordConfirmVisible;
  final PasswordStrength passwordStrength;
  final PasswordStrength previousPasswordStrength;
  final PasswordValidation passwordValidation;
  final String failedMessage;

  SignUpState copyWith({
    final FormzSubmissionStatus? status,
    final Username? username,
    final Email? email,
    final NewPassword? password,
    final PasswordConfirm? passwordConfirm,
    final bool? isValid,
    final bool? isPasswordVisible,
    final bool? isPasswordConfirmVisible,
    final PasswordStrength? passwordStrength,
    final PasswordStrength? previousPasswordStrength,
    final PasswordValidation? passwordValidation,
    final String? failedMessage,
  }) =>
      SignUpState(
        status: status ?? this.status,
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
        passwordConfirm: passwordConfirm ?? this.passwordConfirm,
        isValid: isValid ?? this.isValid,
        isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
        isPasswordConfirmVisible:
            isPasswordConfirmVisible ?? this.isPasswordConfirmVisible,
        passwordStrength: passwordStrength ?? this.passwordStrength,
        previousPasswordStrength:
            previousPasswordStrength ?? this.previousPasswordStrength,
        passwordValidation: passwordValidation ?? this.passwordValidation,
        failedMessage: failedMessage ?? this.failedMessage,
      );

  @override
  List<Object> get props => [
        status,
        username,
        email,
        password,
        passwordConfirm,
        isPasswordVisible,
        isPasswordConfirmVisible,
        passwordStrength,
        previousPasswordStrength,
        failedMessage,
      ];
}

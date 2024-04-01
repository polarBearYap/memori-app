part of 'signup_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

final class SignUpUsernameChanged extends SignUpEvent {
  const SignUpUsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

final class SignUpEmailChanged extends SignUpEvent {
  const SignUpEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

final class SignUpPasswordChanged extends SignUpEvent {
  const SignUpPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

final class SignUpPasswordConfirmChanged extends SignUpEvent {
  const SignUpPasswordConfirmChanged(this.passwordConfirm);

  final String passwordConfirm;

  @override
  List<Object> get props => [passwordConfirm];
}

final class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted(this.localized);

  final AppLocalizations localized;
}

final class SignUpPasswordVisibilityChanged extends SignUpEvent {
  const SignUpPasswordVisibilityChanged({required this.isPasswordVisible});

  final bool isPasswordVisible;

  @override
  List<Object> get props => [isPasswordVisible];
}

final class SignUpPasswordConfirmVisibilityChanged extends SignUpEvent {
  const SignUpPasswordConfirmVisibilityChanged({
    required this.isPasswordVisible,
  });

  final bool isPasswordVisible;

  @override
  List<Object> get props => [isPasswordVisible];
}

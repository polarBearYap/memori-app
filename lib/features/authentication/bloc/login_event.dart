part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

final class LoginEmailChanged extends LoginEvent {
  const LoginEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

final class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted(this.localized);

  final AppLocalizations localized;
}

final class LoginPasswordVisibilityChanged extends LoginEvent {
  const LoginPasswordVisibilityChanged({required this.isPasswordVisible});

  final bool isPasswordVisible;

  @override
  List<Object> get props => [isPasswordVisible];
}

part of 'delete_account_bloc.dart';

sealed class DeleteAccountEvent extends Equatable {
  const DeleteAccountEvent();

  @override
  List<Object> get props => [];
}

final class DeleteAccountPasswordChanged extends DeleteAccountEvent {
  const DeleteAccountPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

final class DeleteAccountSubmitted extends DeleteAccountEvent {
  const DeleteAccountSubmitted(this.localized);

  final AppLocalizations localized;
}

final class DeleteAccountPasswordVisibilityChanged extends DeleteAccountEvent {
  const DeleteAccountPasswordVisibilityChanged({
    required this.isPasswordVisible,
  });

  final bool isPasswordVisible;

  @override
  List<Object> get props => [isPasswordVisible];
}

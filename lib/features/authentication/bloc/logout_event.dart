part of 'logout_bloc.dart';

sealed class LogoutEvent extends Equatable {
  const LogoutEvent();

  @override
  List<Object> get props => [];
}

final class LogoutSubmitted extends LogoutEvent {
  const LogoutSubmitted();
}

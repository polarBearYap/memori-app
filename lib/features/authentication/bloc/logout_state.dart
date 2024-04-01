part of 'logout_bloc.dart';

enum LogoutStatus {
  unspecified,
  inprogress,
  success,
  failed,
}

final class LogoutState extends Equatable {
  const LogoutState({
    this.logoutStatus = LogoutStatus.unspecified,
  });

  final LogoutStatus logoutStatus;

  LogoutState copyWith({
    final LogoutStatus? logoutStatus,
  }) =>
      LogoutState(
        logoutStatus: logoutStatus ?? this.logoutStatus,
      );

  @override
  List<Object> get props => [
        logoutStatus,
      ];
}

part of 'sync_bloc.dart';

sealed class SyncEvent extends Equatable {
  const SyncEvent();

  @override
  List<Object?> get props => [];
}

final class UserAutoLogin extends SyncEvent {}

final class SyncInit extends SyncEvent {
  const SyncInit({
    required this.overrideLocalWithCloudCopy,
    required this.overrideCloudWithLocalCopy,
  });

  final bool overrideLocalWithCloudCopy;
  final bool overrideCloudWithLocalCopy;

  @override
  List<Object?> get props => [
        overrideLocalWithCloudCopy,
        overrideCloudWithLocalCopy,
      ];
}

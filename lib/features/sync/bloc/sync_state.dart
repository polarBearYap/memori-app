part of 'sync_bloc.dart';

enum SyncProgress {
  none,
  init,
  pulledCreate,
  pulledUpdate,
  pulledDelete,
  pushedCreate,
  pushedUpdate,
  pushedDelete,
  successful,
  conflicted,
  failed,
  backendNotAvailable,
}

final class SyncState extends Equatable {
  const SyncState({
    this.curProgress = SyncProgress.none,
    this.showInitSync = false,
  });

  final SyncProgress curProgress;
  final bool showInitSync;

  SyncState copyWith({
    final SyncProgress? curProgress,
    final bool? showInitSync,
  }) =>
      SyncState(
        curProgress: curProgress ?? this.curProgress,
        showInitSync: showInitSync ?? this.showInitSync,
      );

  @override
  List<Object?> get props => [
        curProgress,
        showInitSync,
      ];
}

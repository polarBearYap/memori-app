part of 'deck_bloc.dart';

enum DeckListStatus {
  forceRefresh,
  loading,
  completed,
  failed,
}

final class DeckState extends Equatable {
  const DeckState({
    required this.decks,
    this.hasNextPage = true,
    this.currentPageNo = 0,
    this.currentPageSize = 0,
    this.status = DeckListStatus.completed,
    this.eventSource = DeckScrollEventSource.all,
    this.newlyAddedDeckId = '',
    this.newlyEditedDeckId = '',
  });

  final DeckScrollEventSource eventSource;
  final List<DeckListViewItem> decks;
  final bool hasNextPage;
  final int currentPageNo;
  final int currentPageSize;
  final DeckListStatus status;
  final String newlyAddedDeckId;
  final String newlyEditedDeckId;

  DeckState copyWith({
    final DeckScrollEventSource? eventSource,
    final List<DeckListViewItem>? decks,
    final bool? hasNextPage,
    final int? currentPageNo,
    final int? currentPageSize,
    final DeckListStatus? status,
    final String? newlyAddedDeckId,
    final String? newlyEditedDeckId,
  }) =>
      DeckState(
        eventSource: eventSource ?? this.eventSource,
        decks: decks ?? this.decks,
        hasNextPage: hasNextPage ?? this.hasNextPage,
        currentPageNo: currentPageNo ?? this.currentPageNo,
        currentPageSize: currentPageSize ?? this.currentPageSize,
        status: status ?? this.status,
        newlyAddedDeckId: newlyAddedDeckId ?? this.newlyAddedDeckId,
        newlyEditedDeckId: newlyEditedDeckId ?? this.newlyEditedDeckId,
      );

  @override
  List<Object?> get props => [
        eventSource,
        decks,
        hasNextPage,
        currentPageNo,
        currentPageSize,
        status,
        newlyAddedDeckId,
        newlyEditedDeckId,
      ];
}

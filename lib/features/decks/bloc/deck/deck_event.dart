part of 'deck_bloc.dart';

sealed class DeckEvent extends Equatable {
  const DeckEvent();

  @override
  List<Object?> get props => [];
}

final class DeckReloaded extends DeckEvent {
  final String newlyAddedDeckId;
  final String newlyEditedDeckId;

  const DeckReloaded({
    this.newlyAddedDeckId = '',
    this.newlyEditedDeckId = '',
  });

  @override
  List<Object?> get props => [
        newlyAddedDeckId,
        newlyEditedDeckId,
      ];
}

enum DeckScrollEventSource {
  all,
  homepage,
  formfield,
}

final class DeckScrolledDown extends DeckEvent {
  final DeckScrollEventSource eventSource;
  final int pageNumber;
  final int pageSize;
  final String? searchText;

  const DeckScrolledDown({
    required this.eventSource,
    required this.pageNumber,
    required this.pageSize,
    this.searchText,
  });

  @override
  List<Object?> get props => [
        eventSource,
        pageNumber,
        pageSize,
        searchText,
      ];
}

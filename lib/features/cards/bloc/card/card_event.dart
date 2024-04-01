part of 'card_bloc.dart';

sealed class CardEvent extends Equatable {
  const CardEvent();

  @override
  List<Object?> get props => [];
}

final class CardReloaded extends CardEvent {}

final class CardScrolledDown extends CardEvent {
  final int pageNumber;
  final int pageSize;
  final List<String> selectedDecks;
  final List<String> selectedTags;
  final CardSortOptionValue cardSortOption;
  final String? searchText;

  const CardScrolledDown({
    required this.pageNumber,
    required this.pageSize,
    required this.selectedDecks,
    required this.selectedTags,
    required this.cardSortOption,
    this.searchText,
  });

  @override
  List<Object?> get props => [
        pageNumber,
        pageSize,
        selectedDecks,
        selectedTags,
        cardSortOption,
        searchText,
      ];
}

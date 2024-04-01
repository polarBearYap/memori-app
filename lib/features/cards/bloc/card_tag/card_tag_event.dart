part of 'card_tag_bloc.dart';

sealed class CardTagEvent extends Equatable {
  const CardTagEvent();

  @override
  List<Object?> get props => [];
}

final class CardTagReloaded extends CardTagEvent {}

final class CardTagScrolledDown extends CardTagEvent {
  final int pageNumber;
  final int pageSize;
  final String? searchText;

  const CardTagScrolledDown({
    required this.pageNumber,
    required this.pageSize,
    this.searchText,
  });

  @override
  List<Object?> get props => [
        pageNumber,
        pageSize,
        searchText,
      ];
}

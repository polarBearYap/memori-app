part of 'card_bloc.dart';

enum CardListStatus {
  forceRefresh,
  loading,
  completed,
  failed,
}

final class CardState extends Equatable {
  const CardState({
    required this.cards,
    this.hasNextPage = true,
    this.currentPageNo = 0,
    this.currentPageSize = 0,
    this.totalRecords = 0,
    this.status = CardListStatus.completed,
  });

  final List<CardListViewItem> cards;
  final bool hasNextPage;
  final int currentPageNo;
  final int currentPageSize;
  final int totalRecords;
  final CardListStatus status;

  CardState copyWith({
    final List<CardListViewItem>? cards,
    final bool? hasNextPage,
    final int? currentPageNo,
    final int? currentPageSize,
    final int? totalRecords,
    final CardListStatus? status,
  }) =>
      CardState(
        cards: cards ?? this.cards,
        hasNextPage: hasNextPage ?? this.hasNextPage,
        currentPageNo: currentPageNo ?? this.currentPageNo,
        currentPageSize: currentPageSize ?? this.currentPageSize,
        totalRecords: totalRecords ?? this.totalRecords,
        status: status ?? this.status,
      );

  @override
  List<Object?> get props => [
        cards,
        hasNextPage,
        currentPageNo,
        currentPageSize,
        totalRecords,
        status,
      ];
}

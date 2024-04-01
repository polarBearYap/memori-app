part of 'card_tag_bloc.dart';

enum CardTagListStatus {
  forceRefresh,
  loading,
  completed,
  failed,
}

final class CardTagState extends Equatable {
  const CardTagState({
    required this.cardTags,
    this.hasNextPage = true,
    this.currentPageNo = 0,
    this.currentPageSize = 0,
    this.totalRecords = 0,
    this.status = CardTagListStatus.completed,
  });

  final List<CardTagListViewItem> cardTags;
  final bool hasNextPage;
  final int currentPageNo;
  final int currentPageSize;
  final int totalRecords;
  final CardTagListStatus status;

  CardTagState copyWith({
    final List<CardTagListViewItem>? cardTags,
    final bool? hasNextPage,
    final int? currentPageNo,
    final int? currentPageSize,
    final int? totalRecords,
    final CardTagListStatus? status,
  }) =>
      CardTagState(
        cardTags: cardTags ?? this.cardTags,
        hasNextPage: hasNextPage ?? this.hasNextPage,
        currentPageNo: currentPageNo ?? this.currentPageNo,
        currentPageSize: currentPageSize ?? this.currentPageSize,
        totalRecords: totalRecords ?? this.totalRecords,
        status: status ?? this.status,
      );

  @override
  List<Object?> get props => [
        cardTags,
        hasNextPage,
        currentPageNo,
        currentPageSize,
        totalRecords,
        status,
      ];
}

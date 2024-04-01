part of 'congratulate_card_bloc.dart';

final class CongratulateCardState extends Equatable {
  const CongratulateCardState({
    this.stateId = '',
    this.deckCount = 0,
  });

  final String stateId;
  final int deckCount;

  CongratulateCardState copyWith({
    final String? stateId,
    final int? deckCount,
  }) =>
      CongratulateCardState(
        stateId: stateId ?? this.stateId,
        deckCount: deckCount ?? this.deckCount,
      );

  @override
  List<Object?> get props => [
        stateId,
        deckCount,
      ];
}

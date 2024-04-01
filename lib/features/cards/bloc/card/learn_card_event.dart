part of 'learn_card_bloc.dart';

sealed class LearnCardEvent extends Equatable {
  const LearnCardEvent();

  @override
  List<Object?> get props => [];
}

final class LearnCardInit extends LearnCardEvent {
  const LearnCardInit({
    required this.deckId,
    required this.resumeLearning,
    required this.reviewTime,
    required this.isShowcasing,
  });

  final String deckId;
  final bool? resumeLearning;
  final DateTime reviewTime;
  final bool isShowcasing;

  @override
  List<Object?> get props => [
        deckId,
        resumeLearning,
        reviewTime,
        isShowcasing,
      ];
}

enum LearnCardRating {
  again,
  hard,
  good,
  easy,
}

final class LearnCardRated extends LearnCardEvent {
  const LearnCardRated({
    required this.cardId,
    required this.rating,
    required this.reviewDurationInMs,
    required this.curProgress,
    required this.reviewTime,
  });

  final String cardId;
  final LearnCardRating rating;
  final int reviewDurationInMs;
  final int curProgress;
  final DateTime reviewTime;

  @override
  List<Object?> get props => [
        cardId,
        rating,
        reviewDurationInMs,
        curProgress,
        reviewTime,
      ];
}

final class LearnCardPrevious extends LearnCardEvent {
  const LearnCardPrevious({
    required this.curProgress,
    required this.reviewTime,
  });

  final int curProgress;
  final DateTime reviewTime;

  @override
  List<Object?> get props => [
        curProgress,
        reviewTime,
      ];
}

final class LearnCardNext extends LearnCardEvent {
  const LearnCardNext({
    required this.curProgress,
    required this.reviewTime,
  });

  final int curProgress;
  final DateTime reviewTime;

  @override
  List<Object?> get props => [
        curProgress,
        reviewTime,
      ];
}

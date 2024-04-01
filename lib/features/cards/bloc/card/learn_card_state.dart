part of 'learn_card_bloc.dart';

enum LearnInitStatus {
  none,
  inProgress,
  success,
  noCardCreated,
  noCardMatchCriteria,
  noDueCard,
  askResumeLearning,
}

final class LearnCardState extends Equatable {
  const LearnCardState({
    this.stateId = '',
    this.initStatus = LearnInitStatus.none,
    this.deckId = '',
    this.cardId = '',
    this.deckName = '',
    this.newCount = 0,
    this.learningCount = 0,
    this.reviewCount = 0,
    this.curProgress = 0,
    this.totalProgress = 0,
    required this.front,
    required this.back,
    this.againNextDue,
    this.hardNextDue,
    this.goodNextDue,
    this.easyNextDue,
    this.isShowcasing = false,
  });

  final String stateId;
  final LearnInitStatus initStatus;

  final String deckId;
  final String deckName;
  final int newCount;
  final int learningCount;
  final int reviewCount;
  final int curProgress;
  final int totalProgress;

  final String cardId;
  final Document front;
  final Document back;
  final DateTime? againNextDue;
  final DateTime? hardNextDue;
  final DateTime? goodNextDue;
  final DateTime? easyNextDue;

  final bool isShowcasing;

  LearnCardState copyWith({
    final String? cardId,
    final LearnInitStatus? initStatus,
    final String? deckId,
    final String? deckName,
    final String? stateId,
    final Document? front,
    final Document? back,
    final int? newCount,
    final int? learningCount,
    final int? reviewCount,
    final int? curProgress,
    final int? totalProgress,
    final DateTime? againNextDue,
    final DateTime? hardNextDue,
    final DateTime? goodNextDue,
    final DateTime? easyNextDue,
    final bool? isShowcasing,
  }) =>
      LearnCardState(
        stateId: stateId ?? this.stateId,
        initStatus: initStatus ?? this.initStatus,
        deckId: deckId ?? this.deckId,
        deckName: deckName ?? this.deckName,
        cardId: cardId ?? this.cardId,
        front: front ?? this.front,
        back: back ?? this.back,
        newCount: newCount ?? this.newCount,
        learningCount: learningCount ?? this.learningCount,
        reviewCount: reviewCount ?? this.reviewCount,
        curProgress: curProgress ?? this.curProgress,
        totalProgress: totalProgress ?? this.totalProgress,
        againNextDue: againNextDue ?? this.againNextDue,
        hardNextDue: hardNextDue ?? this.hardNextDue,
        goodNextDue: goodNextDue ?? this.goodNextDue,
        easyNextDue: easyNextDue ?? this.easyNextDue,
        isShowcasing: isShowcasing ?? this.isShowcasing,
      );

  @override
  List<Object?> get props => [
        stateId,
        initStatus,
        deckId,
        deckName,
        cardId,
        front,
        back,
        newCount,
        learningCount,
        reviewCount,
        curProgress,
        totalProgress,
        againNextDue,
        hardNextDue,
        goodNextDue,
        easyNextDue,
        isShowcasing,
      ];
}

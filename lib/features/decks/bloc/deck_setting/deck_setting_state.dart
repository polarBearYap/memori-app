part of 'deck_setting_bloc.dart';

final class DeckSettingState extends Equatable {
  const DeckSettingState({
    this.stateId = '',
    this.deckName = '',
    this.deckStatus = FormzSubmissionStatus.initial,
    this.deckSettingId = '',
    this.newCardPerDay = 0,
    this.maxReviewPerDay = 0,
    this.skipNewCard = false,
    this.skipLearningCard = false,
    this.skipReviewCard = false,
  });

  final String stateId;
  final String deckName;
  final FormzSubmissionStatus deckStatus;
  final String deckSettingId;
  final int newCardPerDay;
  final int maxReviewPerDay;
  final bool skipNewCard;
  final bool skipLearningCard;
  final bool skipReviewCard;

  DeckSettingState copyWith({
    final String? stateId,
    final String? deckName,
    final FormzSubmissionStatus? deckStatus,
    final String? deckSettingId,
    final int? newCardPerDay,
    final int? maxReviewPerDay,
    final bool? skipNewCard,
    final bool? skipLearningCard,
    final bool? skipReviewCard,
  }) =>
      DeckSettingState(
        stateId: stateId ?? this.stateId,
        deckName: deckName ?? this.deckName,
        deckStatus: deckStatus ?? this.deckStatus,
        deckSettingId: deckSettingId ?? this.deckSettingId,
        newCardPerDay: newCardPerDay ?? this.newCardPerDay,
        maxReviewPerDay: maxReviewPerDay ?? this.maxReviewPerDay,
        skipNewCard: skipNewCard ?? this.skipNewCard,
        skipLearningCard: skipLearningCard ?? this.skipLearningCard,
        skipReviewCard: skipReviewCard ?? this.skipReviewCard,
      );

  @override
  List<Object?> get props => [
        stateId,
        deckName,
        deckStatus,
        deckSettingId,
        newCardPerDay,
        maxReviewPerDay,
        skipNewCard,
        skipLearningCard,
        skipReviewCard,
      ];
}

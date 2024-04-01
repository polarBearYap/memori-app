part of 'deck_setting_bloc.dart';

sealed class DeckSettingEvent extends Equatable {
  const DeckSettingEvent();

  @override
  List<Object> get props => [];
}

final class DeckSettingsInit extends DeckSettingEvent {
  final String deckId;

  const DeckSettingsInit({required this.deckId});
}

final class DeckSettingUpdated extends DeckSettingEvent {
  const DeckSettingUpdated({
    required this.deckSettingId,
    required this.newCardPerDay,
    required this.maxReviewPerDay,
    required this.skipNewCard,
    required this.skipLearningCard,
    required this.skipReviewCard,
  });

  final String deckSettingId;

  final int newCardPerDay;

  final int maxReviewPerDay;

  final bool skipNewCard;

  final bool skipLearningCard;

  final bool skipReviewCard;

  @override
  List<Object> get props => [deckSettingId];
}

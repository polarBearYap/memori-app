part of 'edit_card_tag_bloc.dart';

sealed class EditCardTagEvent extends Equatable {
  const EditCardTagEvent();

  @override
  List<Object> get props => [];
}

final class EditCardTagOpened extends EditCardTagEvent {
  const EditCardTagOpened(this.cardTagId);

  final String cardTagId;

  @override
  List<Object> get props => [cardTagId];
}

final class CardTagNameChanged extends EditCardTagEvent {
  const CardTagNameChanged(this.cardTagName);

  final String cardTagName;

  @override
  List<Object> get props => [cardTagName];
}

final class CardTagEditedSubmitted extends EditCardTagEvent {
  const CardTagEditedSubmitted({
    required this.cardTagId,
    required this.cardTagName,
  });

  final String cardTagId;

  final String cardTagName;

  @override
  List<Object> get props => [
        cardTagId,
        cardTagName,
      ];
}

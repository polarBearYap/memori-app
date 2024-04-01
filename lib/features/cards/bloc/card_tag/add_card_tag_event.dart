part of 'add_card_tag_bloc.dart';

sealed class AddCardTagEvent extends Equatable {
  const AddCardTagEvent();

  @override
  List<Object> get props => [];
}

final class AddCardTagOpened extends AddCardTagEvent {
  const AddCardTagOpened(this.cardTagName);

  final String cardTagName;

  @override
  List<Object> get props => [cardTagName];
}

final class CardTagNameChanged extends AddCardTagEvent {
  const CardTagNameChanged(this.cardTagName);

  final String cardTagName;

  @override
  List<Object> get props => [cardTagName];
}

final class CardTagAddedSubmitted extends AddCardTagEvent {
  const CardTagAddedSubmitted(this.cardTagName);

  final String cardTagName;

  @override
  List<Object> get props => [cardTagName];
}

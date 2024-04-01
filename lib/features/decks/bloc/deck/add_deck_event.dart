part of 'add_deck_bloc.dart';

sealed class AddDeckEvent extends Equatable {
  const AddDeckEvent();

  @override
  List<Object> get props => [];
}

final class AddDeckOpened extends AddDeckEvent {}

final class DeckNameChanged extends AddDeckEvent {
  const DeckNameChanged(this.deckName);

  final String deckName;

  @override
  List<Object> get props => [deckName];
}

final class DeckAddedSubmitted extends AddDeckEvent {
  const DeckAddedSubmitted({
    required this.deckName,
    required this.isShowcasing,
  });

  final String deckName;
  final bool isShowcasing;

  @override
  List<Object> get props => [
        deckName,
        isShowcasing,
      ];
}

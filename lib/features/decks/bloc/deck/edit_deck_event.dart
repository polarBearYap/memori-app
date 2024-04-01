part of 'edit_deck_bloc.dart';

sealed class EditDeckEvent extends Equatable {
  const EditDeckEvent();

  @override
  List<Object> get props => [];
}

final class EditDeckOpened extends EditDeckEvent {
  const EditDeckOpened(this.deckId);

  final String deckId;

  @override
  List<Object> get props => [deckId];
}

final class DeckNameChanged extends EditDeckEvent {
  const DeckNameChanged(this.deckName);

  final String deckName;

  @override
  List<Object> get props => [deckName];
}

final class DeckEditedSubmitted extends EditDeckEvent {
  const DeckEditedSubmitted({
    required this.deckId,
    required this.deckName,
  });

  final String deckId;

  final String deckName;

  @override
  List<Object> get props => [
        deckId,
        deckName,
      ];
}

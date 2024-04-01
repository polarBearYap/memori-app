part of 'delete_deck_bloc.dart';

sealed class DeleteDeckEvent extends Equatable {
  const DeleteDeckEvent();

  @override
  List<Object> get props => [];
}

final class DeckDeleted extends DeleteDeckEvent {
  const DeckDeleted(this.deckId);

  final String deckId;

  @override
  List<Object> get props => [deckId];
}

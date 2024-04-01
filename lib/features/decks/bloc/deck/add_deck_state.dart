part of 'add_deck_bloc.dart';

final class AddDeckState extends Equatable {
  const AddDeckState({
    this.deckAdded = const DeckInput.pure(),
    this.deckAddedStatus = FormzSubmissionStatus.initial,
  });

  final DeckInput deckAdded;
  final FormzSubmissionStatus deckAddedStatus;

  AddDeckState copyWith({
    final DeckInput? deckAdded,
    final FormzSubmissionStatus? deckAddedStatus,
  }) =>
      AddDeckState(
        deckAdded: deckAdded ?? this.deckAdded,
        deckAddedStatus: deckAddedStatus ?? this.deckAddedStatus,
      );

  @override
  List<Object?> get props => [
        deckAdded,
        deckAddedStatus,
      ];
}

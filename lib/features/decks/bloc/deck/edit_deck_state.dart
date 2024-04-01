part of 'edit_deck_bloc.dart';

final class EditDeckState extends Equatable {
  const EditDeckState({
    this.deckEdited = const DeckInput.pure(),
    this.deckEditedStatus = FormzSubmissionStatus.initial,
    this.overrideDeckName = false,
  });

  final DeckInput deckEdited;
  final FormzSubmissionStatus deckEditedStatus;
  final bool overrideDeckName;

  EditDeckState copyWith({
    final DeckInput? deckEdited,
    final FormzSubmissionStatus? deckEditedStatus,
    final bool? overrideDeckName,
  }) =>
      EditDeckState(
        deckEdited: deckEdited ?? this.deckEdited,
        deckEditedStatus: deckEditedStatus ?? this.deckEditedStatus,
        overrideDeckName: overrideDeckName ?? this.overrideDeckName,
      );

  @override
  List<Object?> get props => [
        deckEdited,
        deckEditedStatus,
        overrideDeckName,
      ];
}

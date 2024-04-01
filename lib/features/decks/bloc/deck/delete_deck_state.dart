part of 'delete_deck_bloc.dart';

final class DeleteDeckState extends Equatable {
  const DeleteDeckState({
    this.deckName = '',
    this.deckDeletedStatus = FormzSubmissionStatus.initial,
  });

  final String deckName;
  final FormzSubmissionStatus deckDeletedStatus;

  DeleteDeckState copyWith({
    final FormzSubmissionStatus? deckDeletedStatus,
  }) =>
      DeleteDeckState(
        deckDeletedStatus: deckDeletedStatus ?? this.deckDeletedStatus,
      );

  @override
  List<Object?> get props => [
        deckDeletedStatus,
      ];
}

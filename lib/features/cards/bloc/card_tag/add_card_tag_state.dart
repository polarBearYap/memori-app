part of 'add_card_tag_bloc.dart';

final class AddCardTagState extends Equatable {
  const AddCardTagState({
    this.cardTagAdded = const CardTagInput.pure(),
    this.cardTagAddedStatus = FormzSubmissionStatus.initial,
  });

  final CardTagInput cardTagAdded;
  final FormzSubmissionStatus cardTagAddedStatus;

  AddCardTagState copyWith({
    final CardTagInput? cardTagAdded,
    final FormzSubmissionStatus? cardTagAddedStatus,
  }) =>
      AddCardTagState(
        cardTagAdded: cardTagAdded ?? this.cardTagAdded,
        cardTagAddedStatus: cardTagAddedStatus ?? this.cardTagAddedStatus,
      );

  @override
  List<Object?> get props => [
        cardTagAdded,
        cardTagAddedStatus,
      ];
}

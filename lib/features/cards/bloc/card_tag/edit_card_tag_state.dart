part of 'edit_card_tag_bloc.dart';

final class EditCardTagState extends Equatable {
  const EditCardTagState({
    this.id = '',
    this.cardTagName = '',
    this.cardTagEdited = const CardTagInput.pure(),
    this.cardTagEditedStatus = FormzSubmissionStatus.initial,
    this.overrideCardTagName = false,
  });

  final String id;
  final String cardTagName;
  final CardTagInput cardTagEdited;
  final FormzSubmissionStatus cardTagEditedStatus;
  final bool overrideCardTagName;

  EditCardTagState copyWith({
    final String? id,
    final String? cardTagName,
    final CardTagInput? cardTagEdited,
    final FormzSubmissionStatus? cardTagEditedStatus,
    final bool? overrideCardTagName,
  }) =>
      EditCardTagState(
        id: id ?? this.id,
        cardTagName: cardTagName ?? this.cardTagName,
        cardTagEdited: cardTagEdited ?? this.cardTagEdited,
        cardTagEditedStatus: cardTagEditedStatus ?? this.cardTagEditedStatus,
        overrideCardTagName: overrideCardTagName ?? this.overrideCardTagName,
      );

  @override
  List<Object?> get props => [
        id,
        cardTagName,
        cardTagEdited,
        cardTagEditedStatus,
        overrideCardTagName,
      ];
}

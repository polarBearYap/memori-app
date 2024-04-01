part of 'delete_card_tag_bloc.dart';

final class DeleteCardTagState extends Equatable {
  const DeleteCardTagState({
    this.id = '',
    this.cardTagName = '',
    this.cardTagDeletedStatus = FormzSubmissionStatus.initial,
  });

  final String id;
  final String cardTagName;
  final FormzSubmissionStatus cardTagDeletedStatus;

  DeleteCardTagState copyWith({
    final String? id,
    final String? cardTagName,
    final FormzSubmissionStatus? cardTagDeletedStatus,
  }) =>
      DeleteCardTagState(
        id: id ?? this.id,
        cardTagName: cardTagName ?? this.cardTagName,
        cardTagDeletedStatus: cardTagDeletedStatus ?? this.cardTagDeletedStatus,
      );

  @override
  List<Object?> get props => [
        id,
        cardTagName,
        cardTagDeletedStatus,
      ];
}

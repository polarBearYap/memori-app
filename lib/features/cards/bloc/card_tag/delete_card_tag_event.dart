part of 'delete_card_tag_bloc.dart';

sealed class DeleteCardTagEvent extends Equatable {
  const DeleteCardTagEvent();

  @override
  List<Object> get props => [];
}

final class CardTagDeleted extends DeleteCardTagEvent {
  const CardTagDeleted(this.cardTagId);

  final String cardTagId;

  @override
  List<Object> get props => [cardTagId];
}

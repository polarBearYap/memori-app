part of 'add_edit_card_bloc.dart';

sealed class AddEditCardEvent extends Equatable {
  const AddEditCardEvent();

  @override
  List<Object> get props => [];
}

enum AddEditCardAction {
  delete,
  update,
  create,
}

final class AddEditCardFormInit extends AddEditCardEvent {
  const AddEditCardFormInit({
    required this.cardId,
    this.isShowcasing = false,
  });

  final String cardId;
  final bool isShowcasing;

  @override
  List<Object> get props => [
        cardId,
        isShowcasing,
      ];
}

final class AddEditCardChanged extends AddEditCardEvent {
  final String id;
  final AddEditCardAction action;
  final String selectedDeck;
  final List<String> selectedTags;
  final Document front;
  final Document back;

  const AddEditCardChanged({
    required this.id,
    required this.action,
    required this.selectedDeck,
    required this.selectedTags,
    required this.front,
    required this.back,
  });

  @override
  List<Object> get props => [
        id,
        action,
        selectedDeck,
        selectedTags,
        front,
        back,
      ];
}

final class AddEditCardDeleted extends AddEditCardEvent {
  final String id;

  const AddEditCardDeleted({
    required this.id,
  });

  @override
  List<Object> get props => [
        id,
      ];
}

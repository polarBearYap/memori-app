part of 'add_edit_card_bloc.dart';

enum AddEditCardStatus {
  initial,
  inProgress,
  inputInvalid,
  completed,
  failure,
}

final class AddEditCardState extends Equatable {
  const AddEditCardState({
    this.stateId = '',
    this.submittedAction,
    this.submissionStatus = AddEditCardStatus.initial,
    this.isDeckValid = false,
    this.isTagValid = false,
    this.isFrontValid = false,
    this.isBackValid = false,
    this.selectedDeck = '',
    this.deckName = '',
    required this.cardId,
    required this.selectedTags,
    required this.front,
    required this.back,
    this.isShowcasing = false,
    this.newlyEditedDeckId = '',
  });

  final String stateId;
  final AddEditCardAction? submittedAction;
  final AddEditCardStatus submissionStatus;
  final bool isDeckValid;
  final bool isTagValid;
  final bool isFrontValid;
  final bool isBackValid;

  final String cardId;
  final String selectedDeck;
  final String deckName;
  final List<SelectCardTagDropdownOption> selectedTags;
  final Document front;
  final Document back;

  final bool isShowcasing;
  final String newlyEditedDeckId;

  AddEditCardState copyWith({
    final String? cardId,
    final String? stateId,
    final AddEditCardAction? submittedAction,
    final AddEditCardStatus? submissionStatus,
    final bool? isDeckValid,
    final bool? isTagValid,
    final bool? isFrontValid,
    final bool? isBackValid,
    final String? selectedDeck,
    final String? deckName,
    final List<SelectCardTagDropdownOption>? selectedTags,
    final Document? front,
    final Document? back,
    final bool? isShowcasing,
    final String? newlyEditedDeckId,
  }) =>
      AddEditCardState(
        cardId: cardId ?? this.cardId,
        stateId: stateId ?? this.stateId,
        submittedAction: submittedAction ?? this.submittedAction,
        submissionStatus: submissionStatus ?? this.submissionStatus,
        isDeckValid: isDeckValid ?? this.isDeckValid,
        isTagValid: isTagValid ?? this.isTagValid,
        isFrontValid: isFrontValid ?? this.isFrontValid,
        isBackValid: isBackValid ?? this.isBackValid,
        selectedDeck: selectedDeck ?? this.selectedDeck,
        deckName: deckName ?? this.deckName,
        selectedTags: selectedTags ?? this.selectedTags,
        front: front ?? this.front,
        back: back ?? this.back,
        isShowcasing: isShowcasing ?? this.isShowcasing,
        newlyEditedDeckId: newlyEditedDeckId ?? this.newlyEditedDeckId,
      );

  @override
  List<Object?> get props => [
        cardId,
        stateId,
        submittedAction,
        submissionStatus,
        isDeckValid,
        isTagValid,
        isFrontValid,
        isBackValid,
        selectedDeck,
        deckName,
        selectedTags,
        front,
        back,
        isShowcasing,
        newlyEditedDeckId,
      ];
}

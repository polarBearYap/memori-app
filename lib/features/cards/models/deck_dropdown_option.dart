class SelectDeckDropdownOption {
  String id;
  String deckName;

  SelectDeckDropdownOption copyWith({
    final String? id,
    final String? deckName,
  }) =>
      SelectDeckDropdownOption(
        id: id ?? this.id,
        deckName: deckName ?? this.deckName,
      );

  SelectDeckDropdownOption({
    required this.id,
    required this.deckName,
  });
}

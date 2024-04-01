class SelectCardTagDropdownOption {
  final String id;
  final String name;

  SelectCardTagDropdownOption copyWith({
    final String? id,
    final String? name,
  }) =>
      SelectCardTagDropdownOption(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  SelectCardTagDropdownOption({
    required this.id,
    required this.name,
  });
}

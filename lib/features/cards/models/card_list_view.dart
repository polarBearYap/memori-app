import 'package:flutter_quill/flutter_quill.dart';

class CardListViewItem {
  final String id;
  final String frontPlainText;
  final String backPlainText;
  final Document frontDocument;
  final Document backDocument;
  final DateTime lastCreatedAt;
  final DateTime lastModifiedAt;
  final String deckname;
  final List<String> tagNames;

  CardListViewItem({
    required this.id,
    required this.frontPlainText,
    required this.backPlainText,
    required this.frontDocument,
    required this.backDocument,
    required this.lastCreatedAt,
    required this.lastModifiedAt,
    required this.deckname,
    required this.tagNames,
  });
}

enum CardListDateDisplayType {
  modifiedAt,
  createdAt,
}

enum CardSortOptionValue {
  modifiedAsc,
  modifiedDsc,
  createdAsc,
  createdDsc,
}

class CardSortOption {
  CardSortOptionValue value;

  CardSortOption({
    required this.value,
  });

  @override
  bool operator ==(final Object other) =>
      identical(this, other) || other is CardSortOption && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

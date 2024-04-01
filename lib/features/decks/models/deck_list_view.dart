import 'package:flutter/material.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/time_passed.dart';

class DeckListViewItem {
  final String id;
  final String deckName;
  final int newCount;
  final int learningCount;
  final int reviewCount;
  final DateTime? lastReviewedTime;

  DeckListViewItem({
    required this.id,
    required this.deckName,
    required this.newCount,
    required this.learningCount,
    required this.reviewCount,
    required this.lastReviewedTime,
  });
}

String getReviewTimePassed(
  final DateTime? inputDate,
  final BuildContext context,
) {
  if (inputDate == null) {
    return localized(context).deck_review_not_yet;
  }

  String review = localized(context).deck_review_last_review;

  return review +
      getTimePassed(
        inputDate,
        localized(context),
      );
}

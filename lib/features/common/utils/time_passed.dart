import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getTimePassed(
  final DateTime inputDate,
  final AppLocalizations localized,
) {
  DateTime currentDate = DateTime.now().toUtc();

  String timePassed = '';

  Duration difference = currentDate.difference(inputDate);

  if (difference.inMinutes < 60) {
    timePassed += localized.timepassed_minutes(difference.inMinutes);
  } else if (difference.inHours < 24) {
    timePassed += localized.timepassed_hours(difference.inHours);
  } else if (difference.inDays < 7) {
    timePassed += localized.timepassed_days(difference.inDays);
  } else if (difference.inDays < 30) {
    int weeks = difference.inDays ~/ 7;
    timePassed += localized.timepassed_weeks(weeks);
  } else {
    int months = difference.inDays ~/ 30;
    timePassed += localized.timepassed_months(months);
  }

  return timePassed;
}

String getNextReviewTimeDesc(
  final DateTime? inputDate,
  final AppLocalizations localized,
) {
  DateTime currentDate = DateTime.now().toUtc();

  String timePassed = '';

  if (inputDate == null) {
    return timePassed;
  }

  Duration duration = inputDate.difference(currentDate);
  if (duration.isNegative) {
    duration = Duration.zero;
  }

  if (duration.inMinutes < 60) {
    timePassed += localized.next_review_time_minutes(duration.inMinutes);
  } else if (duration.inHours < 24) {
    timePassed += localized.next_review_time_hours(duration.inHours);
  } else if (duration.inDays < 7) {
    timePassed += localized.next_review_time_days(duration.inDays);
  } else if (duration.inDays < 30) {
    int weeks = duration.inDays ~/ 7;
    timePassed += localized.next_review_time_weeks(weeks);
  } else {
    int months = duration.inDays ~/ 30;
    timePassed += localized.next_review_time_months(months);
  }

  return timePassed;
}

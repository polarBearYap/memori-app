import 'package:json_annotation/json_annotation.dart';

class CustomDateTimeConverter implements JsonConverter<DateTime, String> {
  const CustomDateTimeConverter();

  @override
  DateTime fromJson(final String date) => DateTime.parse(date);

  // String toJson(final DateTime date) => date.toIso8601String();

  @override
  String toJson(final DateTime date) {
    final utcDate = date.toUtc();
    return '${utcDate.year.toString().padLeft(4, '0')}-'
        '${utcDate.month.toString().padLeft(2, '0')}-'
        '${utcDate.day.toString().padLeft(2, '0')}T'
        '${utcDate.hour.toString().padLeft(2, '0')}:'
        '${utcDate.minute.toString().padLeft(2, '0')}:'
        '${utcDate.second.toString().padLeft(2, '0')}Z';
  }
}

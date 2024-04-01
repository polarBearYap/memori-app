// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_schedule_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardScheduleRequest _$CardScheduleRequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'difficulty',
      'due',
      'elapsed_days',
      'lapses',
      'last_review',
      'reps',
      'scheduled_days',
      'stability',
      'state',
      'current_review'
    ],
  );
  return CardScheduleRequest(
    difficulty: (json['difficulty'] as num).toDouble(),
    due: const CustomDateTimeConverter().fromJson(json['due'] as String),
    elapsedDays: json['elapsed_days'] as int,
    lapses: json['lapses'] as int,
    lastReview:
        const CustomDateTimeConverter().fromJson(json['last_review'] as String),
    reps: json['reps'] as int,
    scheduledDays: json['scheduled_days'] as int,
    stability: (json['stability'] as num).toDouble(),
    state: json['state'] as int,
    currentReview: const CustomDateTimeConverter()
        .fromJson(json['current_review'] as String),
  );
}

Map<String, dynamic> _$CardScheduleRequestToJson(
        CardScheduleRequest instance) =>
    <String, dynamic>{
      'difficulty': instance.difficulty,
      'due': const CustomDateTimeConverter().toJson(instance.due),
      'elapsed_days': instance.elapsedDays,
      'lapses': instance.lapses,
      'last_review':
          const CustomDateTimeConverter().toJson(instance.lastReview),
      'reps': instance.reps,
      'scheduled_days': instance.scheduledDays,
      'stability': instance.stability,
      'state': instance.state,
      'current_review':
          const CustomDateTimeConverter().toJson(instance.currentReview),
    };

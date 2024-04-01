// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_schedule_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardScheduleResponse _$CardScheduleResponseFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['message', 'data'],
  );
  return CardScheduleResponse(
    message: json['message'] as String,
    data: (json['data'] as Map<String, dynamic>).map(
      (k, e) =>
          MapEntry(k, CardScheduleItem.fromJson(e as Map<String, dynamic>)),
    ),
  );
}

Map<String, dynamic> _$CardScheduleResponseToJson(
        CardScheduleResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

CardScheduleItem _$CardScheduleItemFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['card', 'review_log'],
  );
  return CardScheduleItem(
    card: CardInfo.fromJson(json['card'] as Map<String, dynamic>),
    reviewLog: ReviewLog.fromJson(json['review_log'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CardScheduleItemToJson(CardScheduleItem instance) =>
    <String, dynamic>{
      'card': instance.card,
      'review_log': instance.reviewLog,
    };

CardInfo _$CardInfoFromJson(Map<String, dynamic> json) {
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
      'state'
    ],
  );
  return CardInfo(
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
  );
}

Map<String, dynamic> _$CardInfoToJson(CardInfo instance) => <String, dynamic>{
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
    };

ReviewLog _$ReviewLogFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'elapsed_days',
      'rating',
      'review',
      'scheduled_days',
      'state'
    ],
  );
  return ReviewLog(
    elapsedDays: json['elapsed_days'] as int,
    rating: json['rating'] as int,
    review: const CustomDateTimeConverter().fromJson(json['review'] as String),
    scheduledDays: json['scheduled_days'] as int,
    state: json['state'] as int,
  );
}

Map<String, dynamic> _$ReviewLogToJson(ReviewLog instance) => <String, dynamic>{
      'elapsed_days': instance.elapsedDays,
      'rating': instance.rating,
      'review': const CustomDateTimeConverter().toJson(instance.review),
      'scheduled_days': instance.scheduledDays,
      'state': instance.state,
    };

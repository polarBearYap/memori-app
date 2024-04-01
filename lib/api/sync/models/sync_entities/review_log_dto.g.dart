// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_log_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewLogDto _$ReviewLogDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'createdAt',
      'lastModified',
      'version',
      'modifiedByDeviceId',
      'userId',
      'action',
      'entityType',
      'elapsedDays',
      'rating',
      'review',
      'scheduledDays',
      'state',
      'reviewDurationInMs',
      'lastReview',
      'cardId'
    ],
  );
  return ReviewLogDto(
    id: json['id'] as String,
    createdAt:
        const CustomDateTimeConverter().fromJson(json['createdAt'] as String),
    lastModified: const CustomDateTimeConverter()
        .fromJson(json['lastModified'] as String),
    version: json['version'] as int,
    deletedAt: _$JsonConverterFromJson<String, DateTime>(
        json['deletedAt'], const CustomDateTimeConverter().fromJson),
    syncedAt: _$JsonConverterFromJson<String, DateTime>(
        json['syncedAt'], const CustomDateTimeConverter().fromJson),
    modifiedByDeviceId: json['modifiedByDeviceId'] as String,
    userId: json['userId'] as String,
    action: actionFromJson(json['action'] as String),
    elapsedDays: json['elapsedDays'] as int,
    rating: json['rating'] as int,
    review: const CustomDateTimeConverter().fromJson(json['review'] as String),
    scheduledDays: json['scheduledDays'] as int,
    state: json['state'] as int,
    reviewDurationInMs: json['reviewDurationInMs'] as int,
    lastReview:
        const CustomDateTimeConverter().fromJson(json['lastReview'] as String),
    cardId: json['cardId'] as String,
    entityType: json['entityType'] as String,
  );
}

Map<String, dynamic> _$ReviewLogDtoToJson(ReviewLogDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': const CustomDateTimeConverter().toJson(instance.createdAt),
      'lastModified':
          const CustomDateTimeConverter().toJson(instance.lastModified),
      'version': instance.version,
      'deletedAt': _$JsonConverterToJson<String, DateTime>(
          instance.deletedAt, const CustomDateTimeConverter().toJson),
      'syncedAt': _$JsonConverterToJson<String, DateTime>(
          instance.syncedAt, const CustomDateTimeConverter().toJson),
      'modifiedByDeviceId': instance.modifiedByDeviceId,
      'userId': instance.userId,
      'action': actionToJson(instance.action),
      'entityType': instance.entityType,
      'elapsedDays': instance.elapsedDays,
      'rating': instance.rating,
      'review': const CustomDateTimeConverter().toJson(instance.review),
      'scheduledDays': instance.scheduledDays,
      'state': instance.state,
      'reviewDurationInMs': instance.reviewDurationInMs,
      'lastReview': const CustomDateTimeConverter().toJson(instance.lastReview),
      'cardId': instance.cardId,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

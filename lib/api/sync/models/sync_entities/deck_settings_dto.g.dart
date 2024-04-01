// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck_settings_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeckSettingsDto _$DeckSettingsDtoFromJson(Map<String, dynamic> json) {
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
      'isDefault',
      'learningSteps',
      'relearningSteps',
      'maxNewCardsPerDay',
      'maxReviewPerDay',
      'maximumAnswerSeconds',
      'desiredRetention',
      'newPriority',
      'interdayPriority',
      'reviewPriority',
      'skipNewCard',
      'skipLearningCard',
      'skipReviewCard'
    ],
  );
  return DeckSettingsDto(
    isDefault: json['isDefault'] as bool,
    learningSteps: json['learningSteps'] as String,
    relearningSteps: json['relearningSteps'] as String,
    maxNewCardsPerDay: json['maxNewCardsPerDay'] as int,
    maxReviewPerDay: json['maxReviewPerDay'] as int,
    maximumAnswerSeconds: json['maximumAnswerSeconds'] as int,
    desiredRetention: (json['desiredRetention'] as num).toDouble(),
    newPriority: json['newPriority'] as int,
    interdayPriority: json['interdayPriority'] as int,
    reviewPriority: json['reviewPriority'] as int,
    skipNewCard: json['skipNewCard'] as bool,
    skipLearningCard: json['skipLearningCard'] as bool,
    skipReviewCard: json['skipReviewCard'] as bool,
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
    entityType: json['entityType'] as String,
  );
}

Map<String, dynamic> _$DeckSettingsDtoToJson(DeckSettingsDto instance) =>
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
      'isDefault': instance.isDefault,
      'learningSteps': instance.learningSteps,
      'relearningSteps': instance.relearningSteps,
      'maxNewCardsPerDay': instance.maxNewCardsPerDay,
      'maxReviewPerDay': instance.maxReviewPerDay,
      'maximumAnswerSeconds': instance.maximumAnswerSeconds,
      'desiredRetention': instance.desiredRetention,
      'newPriority': instance.newPriority,
      'interdayPriority': instance.interdayPriority,
      'reviewPriority': instance.reviewPriority,
      'skipNewCard': instance.skipNewCard,
      'skipLearningCard': instance.skipLearningCard,
      'skipReviewCard': instance.skipReviewCard,
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardDto _$CardDtoFromJson(Map<String, dynamic> json) {
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
      'front',
      'back',
      'explanation',
      'displayOrder',
      'difficulty',
      'due',
      'actual_due',
      'elapsed_days',
      'lapses',
      'last_review',
      'reps',
      'scheduled_days',
      'stability',
      'state',
      'isSuspended',
      'deckId'
    ],
  );
  return CardDto(
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
    front: json['front'] as String,
    back: json['back'] as String,
    explanation: json['explanation'] as String,
    displayOrder: json['displayOrder'] as int,
    difficulty: (json['difficulty'] as num).toDouble(),
    due: const CustomDateTimeConverter().fromJson(json['due'] as String),
    actualDue:
        const CustomDateTimeConverter().fromJson(json['actual_due'] as String),
    elapsedDays: json['elapsed_days'] as int,
    lapses: json['lapses'] as int,
    lastReview:
        const CustomDateTimeConverter().fromJson(json['last_review'] as String),
    reps: json['reps'] as int,
    scheduledDays: json['scheduled_days'] as int,
    stability: (json['stability'] as num).toDouble(),
    state: json['state'] as int,
    isSuspended: json['isSuspended'] as bool,
    deckId: json['deckId'] as String,
    entityType: json['entityType'] as String,
  );
}

Map<String, dynamic> _$CardDtoToJson(CardDto instance) => <String, dynamic>{
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
      'front': instance.front,
      'back': instance.back,
      'explanation': instance.explanation,
      'displayOrder': instance.displayOrder,
      'difficulty': instance.difficulty,
      'due': const CustomDateTimeConverter().toJson(instance.due),
      'actual_due': const CustomDateTimeConverter().toJson(instance.actualDue),
      'elapsed_days': instance.elapsedDays,
      'lapses': instance.lapses,
      'last_review':
          const CustomDateTimeConverter().toJson(instance.lastReview),
      'reps': instance.reps,
      'scheduled_days': instance.scheduledDays,
      'stability': instance.stability,
      'state': instance.state,
      'isSuspended': instance.isSuspended,
      'deckId': instance.deckId,
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

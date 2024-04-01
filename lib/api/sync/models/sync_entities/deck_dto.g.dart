// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeckDto _$DeckDtoFromJson(Map<String, dynamic> json) {
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
      'name',
      'description',
      'totalCount',
      'newCount',
      'learningCount',
      'reviewCount',
      'shareCode',
      'canShareExpired',
      'shareExpirationTime',
      'deckSettingsId',
      'lastReviewTime'
    ],
  );
  return DeckDto(
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
    name: json['name'] as String,
    description: json['description'] as String,
    totalCount: json['totalCount'] as int,
    newCount: json['newCount'] as int,
    learningCount: json['learningCount'] as int,
    reviewCount: json['reviewCount'] as int,
    shareCode: json['shareCode'] as String,
    canShareExpired: json['canShareExpired'] as bool,
    shareExpirationTime: const CustomDateTimeConverter()
        .fromJson(json['shareExpirationTime'] as String),
    deckSettingsId: json['deckSettingsId'] as String,
    lastReviewTime: _$JsonConverterFromJson<String, DateTime>(
        json['lastReviewTime'], const CustomDateTimeConverter().fromJson),
  );
}

Map<String, dynamic> _$DeckDtoToJson(DeckDto instance) => <String, dynamic>{
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
      'name': instance.name,
      'description': instance.description,
      'totalCount': instance.totalCount,
      'newCount': instance.newCount,
      'learningCount': instance.learningCount,
      'reviewCount': instance.reviewCount,
      'shareCode': instance.shareCode,
      'canShareExpired': instance.canShareExpired,
      'shareExpirationTime':
          const CustomDateTimeConverter().toJson(instance.shareExpirationTime),
      'deckSettingsId': instance.deckSettingsId,
      'lastReviewTime': _$JsonConverterToJson<String, DateTime>(
          instance.lastReviewTime, const CustomDateTimeConverter().toJson),
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

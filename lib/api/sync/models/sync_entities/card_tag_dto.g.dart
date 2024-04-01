// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_tag_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardTagDto _$CardTagDtoFromJson(Map<String, dynamic> json) {
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
      'name'
    ],
  );
  return CardTagDto(
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
    name: json['name'] as String,
    entityType: json['entityType'] as String,
  );
}

Map<String, dynamic> _$CardTagDtoToJson(CardTagDto instance) =>
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
      'name': instance.name,
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

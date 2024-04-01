// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_push_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncPushRequestDto _$SyncPushRequestDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['items'],
  );
  return SyncPushRequestDto(
    items: (json['items'] as List<dynamic>)
        .map((e) => SyncEntityDto.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SyncPushRequestDtoToJson(SyncPushRequestDto instance) =>
    <String, dynamic>{
      'items': instance.items,
    };

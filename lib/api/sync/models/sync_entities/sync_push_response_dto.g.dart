// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_push_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncPushResponseDto _$SyncPushResponseDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['conflictedItems', 'successfulItems'],
  );
  return SyncPushResponseDto(
    conflictedItems: (json['conflictedItems'] as List<dynamic>)
        .map((e) => SyncEntityDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    successfulItems: (json['successfulItems'] as List<dynamic>)
        .map((e) => SyncEntityDto.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SyncPushResponseDtoToJson(
        SyncPushResponseDto instance) =>
    <String, dynamic>{
      'conflictedItems': instance.conflictedItems,
      'successfulItems': instance.successfulItems,
    };

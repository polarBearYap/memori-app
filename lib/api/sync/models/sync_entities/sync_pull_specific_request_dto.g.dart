// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_pull_specific_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncPullSpecificRequestDto _$SyncPullSpecificRequestDtoFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['entityIds', 'userId'],
  );
  return SyncPullSpecificRequestDto(
    entityIds:
        (json['entityIds'] as List<dynamic>).map((e) => e as String).toList(),
    userId: json['userId'] as String,
  );
}

Map<String, dynamic> _$SyncPullSpecificRequestDtoToJson(
        SyncPullSpecificRequestDto instance) =>
    <String, dynamic>{
      'entityIds': instance.entityIds,
      'userId': instance.userId,
    };

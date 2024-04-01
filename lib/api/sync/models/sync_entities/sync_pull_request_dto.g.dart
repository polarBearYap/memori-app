// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_pull_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncPullRequestDto _$SyncPullRequestDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'lastSyncDateTimeStr',
      'userId',
      'pageNumber',
      'pageSize'
    ],
  );
  return SyncPullRequestDto(
    lastSyncDateTimeStr: const CustomDateTimeConverter()
        .fromJson(json['lastSyncDateTimeStr'] as String),
    userId: json['userId'] as String,
    pageNumber: json['pageNumber'] as int,
    pageSize: json['pageSize'] as int,
  );
}

Map<String, dynamic> _$SyncPullRequestDtoToJson(SyncPullRequestDto instance) =>
    <String, dynamic>{
      'lastSyncDateTimeStr':
          const CustomDateTimeConverter().toJson(instance.lastSyncDateTimeStr),
      'userId': instance.userId,
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
    };

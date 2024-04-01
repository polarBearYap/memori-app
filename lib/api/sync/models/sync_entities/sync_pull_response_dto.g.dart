// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_pull_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncPullResponseDto _$SyncPullResponseDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'message',
      'totalPages',
      'totalElements',
      'currentPageNumber',
      'hasNextPage',
      'hasPreviousPage',
      'items'
    ],
  );
  return SyncPullResponseDto(
    message: json['message'] as String,
    totalPages: json['totalPages'] as int,
    totalElements: json['totalElements'] as int,
    currentPageNumber: json['currentPageNumber'] as int,
    hasNextPage: json['hasNextPage'] as bool,
    hasPreviousPage: json['hasPreviousPage'] as bool,
    items: (json['items'] as List<dynamic>)
        .map((e) => SyncEntityDto.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SyncPullResponseDtoToJson(
        SyncPullResponseDto instance) =>
    <String, dynamic>{
      'message': instance.message,
      'totalPages': instance.totalPages,
      'totalElements': instance.totalElements,
      'currentPageNumber': instance.currentPageNumber,
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
      'items': instance.items,
    };

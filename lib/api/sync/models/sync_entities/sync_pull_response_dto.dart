import 'package:json_annotation/json_annotation.dart';
import 'package:memori_app/api/sync/models/sync_entities/sync_entity_dto.dart';

part 'sync_pull_response_dto.g.dart';

/*
{
  "message" : "The created records are fetched successfully.",
  "totalPages" : 1,
  "totalElements" : 6,
  "currentPageNumber" : 0,
  "hasNextPage" : false,
  "hasPreviousPage" : false,
  "items" : []
}
*/

@JsonSerializable()
class SyncPullResponseDto {
  @JsonKey(name: 'message', required: true)
  final String message;

  @JsonKey(name: 'totalPages', required: true)
  final int totalPages;

  @JsonKey(name: 'totalElements', required: true)
  final int totalElements;

  @JsonKey(name: 'currentPageNumber', required: true)
  final int currentPageNumber;

  @JsonKey(name: 'hasNextPage', required: true)
  final bool hasNextPage;

  @JsonKey(name: 'hasPreviousPage', required: true)
  final bool hasPreviousPage;

  @JsonKey(name: 'items', required: true)
  final List<SyncEntityDto> items;

  SyncPullResponseDto({
    required this.message,
    required this.totalPages,
    required this.totalElements,
    required this.currentPageNumber,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.items,
  });

  factory SyncPullResponseDto.fromJson(final Map<String, dynamic> json) =>
      _$SyncPullResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SyncPullResponseDtoToJson(this);
}

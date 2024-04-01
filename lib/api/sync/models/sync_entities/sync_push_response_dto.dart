import 'package:json_annotation/json_annotation.dart';
import 'package:memori_app/api/sync/models/sync_entities/sync_entity_dto.dart';

part 'sync_push_response_dto.g.dart';

@JsonSerializable()
class SyncPushResponseDto {
  @JsonKey(name: 'conflictedItems', required: true)
  final List<SyncEntityDto> conflictedItems;

  @JsonKey(name: 'successfulItems', required: true)
  final List<SyncEntityDto> successfulItems;

  SyncPushResponseDto({
    required this.conflictedItems,
    required this.successfulItems,
  });

  factory SyncPushResponseDto.fromJson(final Map<String, dynamic> json) =>
      _$SyncPushResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SyncPushResponseDtoToJson(this);
}

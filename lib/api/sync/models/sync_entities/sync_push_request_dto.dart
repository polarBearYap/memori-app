import 'package:json_annotation/json_annotation.dart';
import 'package:memori_app/api/sync/models/sync_entities/sync_entity_dto.dart';

part 'sync_push_request_dto.g.dart';

@JsonSerializable()
class SyncPushRequestDto {
  @JsonKey(name: 'items', required: true)
  final List<SyncEntityDto> items;

  SyncPushRequestDto({
    required this.items,
  });

  factory SyncPushRequestDto.fromJson(final Map<String, dynamic> json) =>
      _$SyncPushRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SyncPushRequestDtoToJson(this);
}

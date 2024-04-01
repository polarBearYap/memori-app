import 'package:json_annotation/json_annotation.dart';

part 'sync_pull_specific_request_dto.g.dart';

@JsonSerializable()
class SyncPullSpecificRequestDto {
  @JsonKey(name: 'entityIds', required: true)
  final List<String> entityIds;

  @JsonKey(name: 'userId', required: true)
  final String userId;

  SyncPullSpecificRequestDto({
    required this.entityIds,
    required this.userId,
  });

  factory SyncPullSpecificRequestDto.fromJson(
    final Map<String, dynamic> json,
  ) =>
      _$SyncPullSpecificRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SyncPullSpecificRequestDtoToJson(this);
}

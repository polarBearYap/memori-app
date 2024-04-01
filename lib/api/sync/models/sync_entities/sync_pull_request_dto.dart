import 'package:json_annotation/json_annotation.dart';
import 'package:memori_app/api/sync/models/converter.dart';

part 'sync_pull_request_dto.g.dart';

@JsonSerializable()
class SyncPullRequestDto {
  @JsonKey(name: 'lastSyncDateTimeStr', required: true)
  @CustomDateTimeConverter()
  final DateTime lastSyncDateTimeStr;

  @JsonKey(name: 'userId', required: true)
  final String userId;

  @JsonKey(name: 'pageNumber', required: true)
  final int pageNumber;

  @JsonKey(name: 'pageSize', required: true)
  final int pageSize;

  SyncPullRequestDto({
    required this.lastSyncDateTimeStr,
    required this.userId,
    required this.pageNumber,
    required this.pageSize,
  });

  factory SyncPullRequestDto.fromJson(final Map<String, dynamic> json) =>
      _$SyncPullRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SyncPullRequestDtoToJson(this);
}

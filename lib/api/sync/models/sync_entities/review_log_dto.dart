import 'package:json_annotation/json_annotation.dart';
import 'package:memori_app/api/sync/models/converter.dart';
import 'package:memori_app/api/sync/models/sync_entities/sync_entity_dto.dart';

part 'review_log_dto.g.dart';

/*
{
  "id" : "ee0efcb0-325a-482c-a0a5-8c5174417b18",
  "createdAt" : "2024-03-18T07:20:26.179864Z",
  "lastModified" : "2024-03-18T07:20:26.179864Z",
  "version" : 1,
  "deletedAt" : null,
  "syncedAt" : null,
  "modifiedByDeviceId" : "2844088b-a3e5-4096-a8fe-b06bdeedff75",
  "userId" : "07e30a62-d6b2-4203-b78e-d9cb596b9d04",
  "entityType" : "ReviewLog",
  "action" : "CREATE",
  "elapsedDays" : 0,
  "rating" : 1,
  "review" : "2024-03-18T07:15:26.180483Z",
  "scheduledDays" : 0,
  "state" : 0,
  "reviewDurationInMs" : 10000,
  "lastReview" : "2024-03-18T07:15:26.180483Z",
  "cardId" : "dd7d7b7b-f808-4891-853c-6e6ef7fcee18"
} 
*/

@JsonSerializable()
class ReviewLogDto extends SyncEntityDto {
  @JsonKey(name: 'elapsedDays', required: true)
  final int elapsedDays;

  @JsonKey(name: 'rating', required: true)
  final int rating;

  @JsonKey(name: 'review', required: true)
  @CustomDateTimeConverter()
  final DateTime review;

  @JsonKey(name: 'scheduledDays', required: true)
  final int scheduledDays;

  @JsonKey(name: 'state', required: true)
  final int state;

  @JsonKey(name: 'reviewDurationInMs', required: true)
  final int reviewDurationInMs;

  @JsonKey(name: 'lastReview', required: true)
  @CustomDateTimeConverter()
  final DateTime lastReview;

  @JsonKey(name: 'cardId', required: true)
  final String cardId;

  ReviewLogDto({
    required super.id,
    required super.createdAt,
    required super.lastModified,
    required super.version,
    required super.deletedAt,
    required super.syncedAt,
    required super.modifiedByDeviceId,
    required super.userId,
    required super.action,
    required this.elapsedDays,
    required this.rating,
    required this.review,
    required this.scheduledDays,
    required this.state,
    required this.reviewDurationInMs,
    required this.lastReview,
    required this.cardId,
    required super.entityType,
  });

  factory ReviewLogDto.fromJson(final Map<String, dynamic> json) =>
      _$ReviewLogDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ReviewLogDtoToJson(this);
}

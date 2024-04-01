import 'package:json_annotation/json_annotation.dart';
import 'package:memori_app/api/sync/models/converter.dart';
import 'package:memori_app/api/sync/models/sync_entities/sync_entity_dto.dart';

part 'card_dto.g.dart';

/*
{
  "id" : "dd7d7b7b-f808-4891-853c-6e6ef7fcee18",
  "createdAt" : "2024-03-18T07:20:26.179864Z",
  "lastModified" : "2024-03-18T07:20:26.179864Z",
  "version" : 1,
  "deletedAt" : null,
  "syncedAt" : null,
  "modifiedByDeviceId" : "f557f493-5116-401b-89d9-e3b6d359b523",
  "userId" : "07e30a62-d6b2-4203-b78e-d9cb596b9d04",
  "entityType" : "Card",
  "action" : "CREATE",
  "front" : "{}",
  "back" : "{}",
  "explanation" : "{}",
  "displayOrder" : 0,
  "difficulty" : 0.0,
  "due" : "2024-03-18T07:15:26.18036Z",
  "actual_due" : "2024-03-18T07:15:26.18036Z",
  "elapsed_days" : 0,
  "lapses" : 0,
  "last_review" : "2024-03-18T07:15:26.18036Z",
  "reps" : 0,
  "scheduled_days" : 0,
  "stability" : 0.0,
  "state" : 0,
  "isSuspended" : false,
  "deckId" : "c4122582-5cdf-45e6-8ce3-f6de696410e4"
}
*/

@JsonSerializable()
class CardDto extends SyncEntityDto {
  @JsonKey(name: 'front', required: true)
  final String front;

  @JsonKey(name: 'back', required: true)
  final String back;

  @JsonKey(name: 'explanation', required: true)
  final String explanation;

  @JsonKey(name: 'displayOrder', required: true)
  final int displayOrder;

  @JsonKey(name: 'difficulty', required: true)
  final double difficulty;

  @JsonKey(name: 'due', required: true)
  @CustomDateTimeConverter()
  final DateTime due;

  @JsonKey(name: 'actual_due', required: true)
  @CustomDateTimeConverter()
  final DateTime actualDue;

  @JsonKey(name: 'elapsed_days', required: true)
  final int elapsedDays;

  @JsonKey(name: 'lapses', required: true)
  final int lapses;

  @JsonKey(name: 'last_review', required: true)
  @CustomDateTimeConverter()
  final DateTime lastReview;

  @JsonKey(name: 'reps', required: true)
  final int reps;

  @JsonKey(name: 'scheduled_days', required: true)
  final int scheduledDays;

  @JsonKey(name: 'stability', required: true)
  final double stability;

  @JsonKey(name: 'state', required: true)
  final int state;

  @JsonKey(name: 'isSuspended', required: true)
  final bool isSuspended;

  @JsonKey(name: 'deckId', required: true)
  final String deckId;

  CardDto({
    required super.id,
    required super.createdAt,
    required super.lastModified,
    required super.version,
    required super.deletedAt,
    required super.syncedAt,
    required super.modifiedByDeviceId,
    required super.userId,
    required super.action,
    required this.front,
    required this.back,
    required this.explanation,
    required this.displayOrder,
    required this.difficulty,
    required this.due,
    required this.actualDue,
    required this.elapsedDays,
    required this.lapses,
    required this.lastReview,
    required this.reps,
    required this.scheduledDays,
    required this.stability,
    required this.state,
    required this.isSuspended,
    required this.deckId,
    required super.entityType,
  });

  factory CardDto.fromJson(final Map<String, dynamic> json) =>
      _$CardDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CardDtoToJson(this);
}

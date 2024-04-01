import 'package:json_annotation/json_annotation.dart';
import 'package:memori_app/api/sync/models/converter.dart';
import 'package:memori_app/api/sync/models/sync_entities/sync_entity_dto.dart';

part 'deck_settings_dto.g.dart';

/*
{
  "id" : "32ba7614-ba74-46a8-9bc1-4f85a7baf391",
  "createdAt" : "2024-03-18T07:20:26.179864Z",
  "lastModified" : "2024-03-18T07:20:26.179864Z",
  "version" : 1,
  "deletedAt" : null,
  "syncedAt" : null,
  "modifiedByDeviceId" : "342f2396-0425-4402-8f2c-74a5e89cf043",
  "userId" : "07e30a62-d6b2-4203-b78e-d9cb596b9d04",
  "entityType" : "DeckSettings",
  "action" : "CREATE",
  "isDefault" : true,
  "learningSteps" : "1m 10m 1h",
  "relearningSteps" : "1m 10m",
  "maxNewCardsPerDay" : 10,
  "maxReviewPerDay" : 5,
  "maximumAnswerSeconds" : 60,
  "desiredRetention" : 0.95,
  "newPriority" : 1,
  "interdayPriority" : 2,
  "reviewPriority" : 3
}
*/
@JsonSerializable()
class DeckSettingsDto extends SyncEntityDto {
  @JsonKey(name: 'isDefault', required: true)
  final bool isDefault;

  @JsonKey(name: 'learningSteps', required: true)
  final String learningSteps;

  @JsonKey(name: 'relearningSteps', required: true)
  final String relearningSteps;

  @JsonKey(name: 'maxNewCardsPerDay', required: true)
  final int maxNewCardsPerDay;

  @JsonKey(name: 'maxReviewPerDay', required: true)
  final int maxReviewPerDay;

  @JsonKey(name: 'maximumAnswerSeconds', required: true)
  final int maximumAnswerSeconds;

  @JsonKey(name: 'desiredRetention', required: true)
  final double desiredRetention;

  @JsonKey(name: 'newPriority', required: true)
  final int newPriority;

  @JsonKey(name: 'interdayPriority', required: true)
  final int interdayPriority;

  @JsonKey(name: 'reviewPriority', required: true)
  final int reviewPriority;

  @JsonKey(name: 'skipNewCard', required: true)
  final bool skipNewCard;

  @JsonKey(name: 'skipLearningCard', required: true)
  final bool skipLearningCard;

  @JsonKey(name: 'skipReviewCard', required: true)
  final bool skipReviewCard;

  DeckSettingsDto({
    required this.isDefault,
    required this.learningSteps,
    required this.relearningSteps,
    required this.maxNewCardsPerDay,
    required this.maxReviewPerDay,
    required this.maximumAnswerSeconds,
    required this.desiredRetention,
    required this.newPriority,
    required this.interdayPriority,
    required this.reviewPriority,
    required this.skipNewCard,
    required this.skipLearningCard,
    required this.skipReviewCard,
    required super.id,
    required super.createdAt,
    required super.lastModified,
    required super.version,
    required super.deletedAt,
    required super.syncedAt,
    required super.modifiedByDeviceId,
    required super.userId,
    required super.action,
    required super.entityType,
  });

  factory DeckSettingsDto.fromJson(final Map<String, dynamic> json) =>
      _$DeckSettingsDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DeckSettingsDtoToJson(this);
}

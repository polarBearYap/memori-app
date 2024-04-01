import 'package:json_annotation/json_annotation.dart';
import 'package:memori_app/api/sync/models/converter.dart';
import 'package:memori_app/api/sync/models/sync_entities/sync_entity_dto.dart';

part 'deck_dto.g.dart';

/*
{
  "id" : "c4122582-5cdf-45e6-8ce3-f6de696410e4",
  "createdAt" : "2024-03-18T07:20:26.179864Z",
  "lastModified" : "2024-03-18T07:20:26.179864Z",
  "version" : 1,
  "deletedAt" : null,
  "syncedAt" : null,
  "modifiedByDeviceId" : "38ebcfdb-37c2-4541-a0eb-6bd1f050732f",
  "userId" : "07e30a62-d6b2-4203-b78e-d9cb596b9d04",
  "entityType" : "Deck",
  "action" : "CREATE",
  "name" : "Deck example 1",
  "description" : "Deck description 1",
  "totalCount" : 0,
  "newCount" : 0,
  "learningCount" : 0,
  "reviewCount" : 0,
  "shareCode" : "",
  "canShareExpired" : false,
  "shareExpirationTime" : "2024-03-18T07:15:26.180224Z",
  "deckSettingsId" : "32ba7614-ba74-46a8-9bc1-4f85a7baf391"
}
*/
@JsonSerializable()
class DeckDto extends SyncEntityDto {
  @JsonKey(name: 'name', required: true)
  final String name;

  @JsonKey(name: 'description', required: true)
  final String description;

  @JsonKey(name: 'totalCount', required: true)
  final int totalCount;

  @JsonKey(name: 'newCount', required: true)
  final int newCount;

  @JsonKey(name: 'learningCount', required: true)
  final int learningCount;

  @JsonKey(name: 'reviewCount', required: true)
  final int reviewCount;

  @JsonKey(name: 'shareCode', required: true)
  final String shareCode;

  @JsonKey(name: 'canShareExpired', required: true)
  final bool canShareExpired;

  @JsonKey(name: 'shareExpirationTime', required: true)
  @CustomDateTimeConverter()
  final DateTime shareExpirationTime;

  @JsonKey(name: 'deckSettingsId', required: true)
  final String deckSettingsId;

  @JsonKey(name: 'lastReviewTime', required: true)
  @CustomDateTimeConverter()
  final DateTime? lastReviewTime;

  DeckDto({
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
    required this.name,
    required this.description,
    required this.totalCount,
    required this.newCount,
    required this.learningCount,
    required this.reviewCount,
    required this.shareCode,
    required this.canShareExpired,
    required this.shareExpirationTime,
    required this.deckSettingsId,
    required this.lastReviewTime,
  });

  factory DeckDto.fromJson(final Map<String, dynamic> json) =>
      _$DeckDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DeckDtoToJson(this);
}

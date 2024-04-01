import 'package:json_annotation/json_annotation.dart';
import 'package:memori_app/api/sync/models/converter.dart';
import 'package:memori_app/api/sync/models/sync_entities/sync_entity_dto.dart';

part 'card_tag_mapping_dto.g.dart';

/*
{
  "id" : "b2415be4-d6be-4479-bb0a-5b6450a3568e",
  "createdAt" : "2024-03-18T07:20:26.179864Z",
  "lastModified" : "2024-03-18T07:20:26.179864Z",
  "version" : 1,
  "deletedAt" : null,
  "syncedAt" : null,
  "modifiedByDeviceId" : "c2b7e873-2724-4375-a334-16e904365723",
  "userId" : "07e30a62-d6b2-4203-b78e-d9cb596b9d04",
  "entityType" : "CardTagMapping",
  "action" : "CREATE",
  "cardId" : "dd7d7b7b-f808-4891-853c-6e6ef7fcee18",
  "cardTagId" : "ca7af754-1192-4f4c-a294-1656d1f8e8fb"
}
*/

@JsonSerializable()
class CardTagMappingDto extends SyncEntityDto {
  @JsonKey(name: 'cardId', required: true)
  final String cardId;

  @JsonKey(name: 'cardTagId', required: true)
  final String cardTagId;

  CardTagMappingDto({
    required super.id,
    required super.createdAt,
    required super.lastModified,
    required super.version,
    required super.deletedAt,
    required super.syncedAt,
    required super.modifiedByDeviceId,
    required super.userId,
    required super.action,
    required this.cardId,
    required this.cardTagId,
    required super.entityType,
  });

  factory CardTagMappingDto.fromJson(final Map<String, dynamic> json) =>
      _$CardTagMappingDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CardTagMappingDtoToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:memori_app/api/sync/models/converter.dart';
import 'package:memori_app/api/sync/models/sync_entities/sync_entity_dto.dart';

part 'card_tag_dto.g.dart';

/*
{
  "id" : "ca7af754-1192-4f4c-a294-1656d1f8e8fb",
  "createdAt" : "2024-03-18T07:20:26.179864Z",
  "lastModified" : "2024-03-18T07:20:26.179864Z",
  "version" : 1,
  "deletedAt" : null,
  "syncedAt" : null,
  "modifiedByDeviceId" : "c64353fd-a9c7-4956-8541-d861341c875e",
  "userId" : "07e30a62-d6b2-4203-b78e-d9cb596b9d04",
  "entityType" : "CardTag",
  "action" : "CREATE",
  "name" : "Card tag example 1"
}
*/
@JsonSerializable()
class CardTagDto extends SyncEntityDto {
  @JsonKey(name: 'name', required: true)
  final String name;

  CardTagDto({
    required super.id,
    required super.createdAt,
    required super.lastModified,
    required super.version,
    required super.deletedAt,
    required super.syncedAt,
    required super.modifiedByDeviceId,
    required super.userId,
    required super.action,
    required this.name,
    required super.entityType,
  });

  factory CardTagDto.fromJson(final Map<String, dynamic> json) =>
      _$CardTagDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CardTagDtoToJson(this);
}

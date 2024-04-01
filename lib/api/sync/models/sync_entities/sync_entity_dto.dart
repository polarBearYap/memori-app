import 'package:json_annotation/json_annotation.dart';
import 'package:memori_app/api/sync/models/converter.dart';
import 'package:memori_app/api/sync/models/sync_entities/card_dto.dart';
import 'package:memori_app/api/sync/models/sync_entities/card_tag_dto.dart';
import 'package:memori_app/api/sync/models/sync_entities/card_tag_mapping_dto.dart';
import 'package:memori_app/api/sync/models/sync_entities/deck_dto.dart';
import 'package:memori_app/api/sync/models/sync_entities/deck_settings_dto.dart';
import 'package:memori_app/api/sync/models/sync_entities/review_log_dto.dart';

enum SyncAction {
  create,
  update,
  delete,
}

String actionToJson(final SyncAction action) {
  switch (action) {
    case SyncAction.create:
      return 'CREATE';
    case SyncAction.update:
      return 'UPDATE';
    case SyncAction.delete:
      return 'DELETE';
  }
}

SyncAction actionFromJson(final String action) {
  switch (action) {
    case 'CREATE':
      return SyncAction.create;
    case 'UPDATE':
      return SyncAction.update;
    case 'DELETE':
      return SyncAction.delete;
    default:
      throw ArgumentError('Invalid action');
  }
}

abstract class SyncEntityDto {
  @JsonKey(name: 'id', required: true)
  final String id;

  @JsonKey(name: 'createdAt', required: true)
  @CustomDateTimeConverter()
  final DateTime createdAt;

  @JsonKey(name: 'lastModified', required: true)
  @CustomDateTimeConverter()
  final DateTime lastModified;

  @JsonKey(name: 'version', required: true)
  final int version;

  @JsonKey(name: 'deletedAt', required: false)
  @CustomDateTimeConverter()
  final DateTime? deletedAt;

  @JsonKey(name: 'syncedAt', required: false)
  @CustomDateTimeConverter()
  final DateTime? syncedAt;

  @JsonKey(name: 'modifiedByDeviceId', required: true)
  final String modifiedByDeviceId;

  @JsonKey(name: 'userId', required: true)
  final String userId;

  @JsonKey(
    name: 'action',
    required: true,
    toJson: actionToJson,
    fromJson: actionFromJson,
  )
  final SyncAction action;

  @JsonKey(name: 'entityType', required: true)
  final String entityType;

  Map<String, dynamic> toJson();

  factory SyncEntityDto.fromJson(final Map<String, dynamic> json) {
    switch (json['entityType']) {
      case 'CardTag':
        return CardTagDto.fromJson(json);
      case 'DeckSettings':
        return DeckSettingsDto.fromJson(json);
      case 'Deck':
        return DeckDto.fromJson(json);
      case 'Card':
        return CardDto.fromJson(json);
      case 'CardTagMapping':
        return CardTagMappingDto.fromJson(json);
      case 'ReviewLog':
        return ReviewLogDto.fromJson(json);
      default:
        throw Exception('Unknown entityType: ${json['entityType']}');
    }
  }

  SyncEntityDto({
    required this.id,
    required this.createdAt,
    required this.lastModified,
    required this.version,
    required this.deletedAt,
    required this.syncedAt,
    required this.modifiedByDeviceId,
    required this.userId,
    required this.action,
    required this.entityType,
  });
}

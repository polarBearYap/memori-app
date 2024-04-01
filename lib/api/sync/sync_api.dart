import 'dart:convert';

import 'package:memori_app/api/sync/base_api.dart';
import 'package:memori_app/api/sync/models/converter.dart';
import 'package:memori_app/api/sync/models/sync_entities/sync_entity_dto.dart';
import 'package:memori_app/api/sync/models/sync_entities/sync_pull_request_dto.dart';
import 'package:memori_app/api/sync/models/sync_entities/sync_pull_response_dto.dart';
import 'package:memori_app/api/sync/models/sync_entities/sync_pull_specific_request_dto.dart';
import 'package:memori_app/api/sync/models/sync_entities/sync_push_request_dto.dart';
import 'package:memori_app/api/sync/models/sync_entities/sync_push_response_dto.dart';
import 'package:memori_app/api/sync/models/user_creation_request.dart';
import 'package:memori_app/api/sync/models/user_creation_response.dart';

class SyncApi extends BaseApi {
  Future<bool> createUser(final UserCreationRequest request) async {
    final response = await performRequest(
      (final dio) => dio.post(
        '/api/user',
        data: jsonEncode(request),
      ),
    );

    if (response != null &&
        response.statusCode != null &&
        response.statusCode == 200) {
      UserCreationResponse.fromJson(response.data);
      return true;
    }

    return false;
  }

  final converter = const CustomDateTimeConverter();

  Future<SyncPullResponseDto?> pullSync({
    required final SyncPullRequestDto request,
    required final SyncAction action,
  }) async {
    String? subPath;
    switch (action) {
      case SyncAction.create:
        subPath = 'pullcreate';
        break;
      case SyncAction.update:
        subPath = 'pullupdate';
        break;
      case SyncAction.delete:
        subPath = 'pulldelete';
        break;
    }
    final response = await performRequest(
      (final dio) => dio.get(
        '/api/schedulecard/${subPath ?? ''}',
        queryParameters: {
          'lastSyncDateTimeStr': converter.toJson(
            request.lastSyncDateTimeStr,
          ),
          'userId': request.userId,
          'pageNumber': request.pageNumber,
          'pageSize': request.pageSize,
        },
      ),
    );
    if (response == null) {
      return null;
    }
    return SyncPullResponseDto.fromJson(response.data);
  }

  Future<SyncPullResponseDto?> pullSpecificSync({
    required final SyncPullSpecificRequestDto request,
  }) async {
    final response = await performRequest(
      (final dio) => dio.get(
        '/api/schedulecard/pullspecific',
        queryParameters: {
          'entityIds': request.entityIds,
          'userId': request.userId,
        },
      ),
    );
    if (response == null) {
      return null;
    }
    return SyncPullResponseDto.fromJson(response.data);
  }

  Future<SyncPushResponseDto?> pushSync({
    required final SyncPushRequestDto items,
    required final bool forceOverride,
  }) async {
    String subPath = forceOverride ? 'forceupload' : 'upload';
    final response = await performRequest(
      (final dio) => dio.post(
        '/api/schedulecard/$subPath',
        data: jsonEncode(items),
      ),
    );
    if (response == null) {
      return null;
    }
    return SyncPushResponseDto.fromJson(response.data);
  }
}

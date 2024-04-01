import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:memori_app/api/sync/heartbeat_api.dart';
import 'package:memori_app/api/sync/models/sync_entities/card_dto.dart'
    as card_dto;
import 'package:memori_app/api/sync/models/sync_entities/card_tag_dto.dart';
import 'package:memori_app/api/sync/models/sync_entities/card_tag_mapping_dto.dart';
import 'package:memori_app/api/sync/models/sync_entities/deck_dto.dart';
import 'package:memori_app/api/sync/models/sync_entities/deck_settings_dto.dart';
import 'package:memori_app/api/sync/models/sync_entities/review_log_dto.dart';
import 'package:memori_app/api/sync/models/sync_entities/sync_entity_dto.dart';
import 'package:memori_app/api/sync/models/sync_entities/sync_pull_request_dto.dart';
import 'package:memori_app/api/sync/models/sync_entities/sync_pull_response_dto.dart';
import 'package:memori_app/api/sync/models/sync_entities/sync_pull_specific_request_dto.dart';
import 'package:memori_app/api/sync/models/sync_entities/sync_push_request_dto.dart';
import 'package:memori_app/api/sync/sync_api.dart';
import 'package:memori_app/db/dtos/conflicted_row.dart';
import 'package:memori_app/db/dtos/sync_entity.dart';
import 'package:memori_app/db/repositories/db_repository.dart';
import 'package:memori_app/db/tables/conflicted_rows.dart';
import 'package:memori_app/db/tables/conflicted_rows.drift.dart';
import 'package:memori_app/db/tables/tables.dart';
import 'package:memori_app/db/utils/sort_order.dart';
import 'package:memori_app/features/decks/bloc/deck/deck_bloc.dart';
import 'package:memori_app/firebase/auth/authentication_repository.dart';

part 'sync_event.dart';
part 'sync_state.dart';

/*
0) AppUsers,

1) SyncEntities,
2) CardTags,
3) DeckSettings,
4) Decks,
5) Cards,
6) CardTagMappings,
7) ReviewLogs,
*/
/*
Source == PUSH_TO_CLOUD (Not happens when pushing newly created records)
  OverrideLocalWithCloudCopy
    New API to get cloud copy by specific ids

  OverrideCloudWithLocalCopy
    Call OveridePush API (Getting record from database)

Source == PULL_FROM_CLOUD (Not happens when pulling newly created records)
  OverrideLocalWithCloudCopy (Done)
    New API to get cloud copy by specific ids

  OverrideCloudWithLocalCopy
    Call OveridePush API (Getting record from database)
*/
class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final AuthenticationRepository _authenticationRepository;
  final DbRepository _dbRepository;
  final SyncApi _syncApi = SyncApi();
  final HeartbeatApi _heartbeatApi = HeartbeatApi();
  final DeckBloc _deckBloc;

  SyncBloc({
    required final AuthenticationRepository authenticationRepository,
    required final DbRepository dbRepository,
    required final DeckBloc deckBloc,
  })  : _authenticationRepository = authenticationRepository,
        _dbRepository = dbRepository,
        _deckBloc = deckBloc,
        super(const SyncState()) {
    on<UserAutoLogin>(_onUserAutoLogin);
    on<SyncInit>(_onSyncInit);
  }

  SyncState failedSyncState() => const SyncState(
        curProgress: SyncProgress.init,
      );

  Future<PersistStatus> _pullSync(
    final SyncEntityDto item, {
    required final bool overrideEnabled,
    required final DateTime deviceLastSyncedAt,
  }) async {
    SyncEntitiesCompanion syncEntity = SyncEntitiesCompanion(
      id: Value(item.id),
      createdAt: Value(item.createdAt),
      deletedAt: Value(item.deletedAt),
      lastModified: Value(item.lastModified),
      syncedAt: Value(item.syncedAt ?? DateTime.now().toUtc()),
      modifiedByDeviceId: Value(item.modifiedByDeviceId),
      userId: Value(item.userId),
      version: Value(item.version),
    );
    if (item is CardTagDto) {
      syncEntity = syncEntity.copyWith(
        sortOrder: Value(getSortOrder<CardTags>()),
        entityType: Value(getEntityName<CardTags>()),
      );
      final companion = CardTagsCompanion(
        id: Value(item.id),
        name: Value(item.name),
      );
      switch (item.action) {
        case SyncAction.create:
          return await _dbRepository.syncInsertCardTags(
            syncEntity,
            companion,
          );
        case SyncAction.update:
          return await _dbRepository.syncUpdateCardTags(
            syncEntity,
            companion,
            isDeleted: false,
            overrideEnabled: overrideEnabled,
            deviceLastSyncedAt: deviceLastSyncedAt,
          );
        case SyncAction.delete:
          return await _dbRepository.syncUpdateCardTags(
            syncEntity,
            companion,
            isDeleted: true,
            overrideEnabled: overrideEnabled,
            deviceLastSyncedAt: deviceLastSyncedAt,
          );
      }
    }
    if (item is DeckSettingsDto) {
      syncEntity = syncEntity.copyWith(
        sortOrder: Value(getSortOrder<DeckSettings>()),
        entityType: Value(getEntityName<DeckSettings>()),
      );
      final companion = DeckSettingsCompanion(
        id: Value(item.id),
        learningSteps: Value(item.learningSteps),
        reLearningSteps: Value(item.relearningSteps),
        desiredRetention: Value(item.desiredRetention),
        isDefault: Value(item.isDefault),
        maxNewCardsPerDay: Value(item.maxNewCardsPerDay),
        maxReviewPerDay: Value(item.maxReviewPerDay),
        maximumAnswerSeconds: Value(item.maximumAnswerSeconds),
        skipNewCard: Value(item.skipNewCard),
        skipLearningCard: Value(item.skipLearningCard),
        skipReviewCard: Value(item.skipReviewCard),
        newPriority: Value(item.newPriority),
        interdayPriority: Value(item.interdayPriority),
        reviewPriority: Value(item.reviewPriority),
      );
      switch (item.action) {
        case SyncAction.create:
          return await _dbRepository.syncInsertDeckSettings(
            syncEntity,
            companion,
          );
        case SyncAction.update:
          return await _dbRepository.syncUpdateDeckSettings(
            syncEntity,
            companion,
            isDeleted: false,
            overrideEnabled: overrideEnabled,
            deviceLastSyncedAt: deviceLastSyncedAt,
          );
        case SyncAction.delete:
          return await _dbRepository.syncUpdateDeckSettings(
            syncEntity,
            companion,
            isDeleted: true,
            overrideEnabled: overrideEnabled,
            deviceLastSyncedAt: deviceLastSyncedAt,
          );
      }
    }
    if (item is DeckDto) {
      syncEntity = syncEntity.copyWith(
        sortOrder: Value(getSortOrder<Decks>()),
        entityType: Value(getEntityName<Decks>()),
      );
      final companion = DecksCompanion(
        id: Value(item.id),
        deckSettingsId: Value(item.deckSettingsId),
        name: Value(item.name),
        description: Value(item.description),
        newCount: Value(item.newCount),
        learningCount: Value(item.learningCount),
        reviewCount: Value(item.reviewCount),
        totalCount: Value(item.totalCount),
        shareCode: Value(item.shareCode),
        canShareExpired: Value(item.canShareExpired),
        shareExpirationTime: Value(item.shareExpirationTime),
      );
      switch (item.action) {
        case SyncAction.create:
          return await _dbRepository.syncInsertDecks(
            syncEntity,
            companion,
          );
        case SyncAction.update:
          return await _dbRepository.syncUpdateDecks(
            syncEntity,
            companion,
            isDeleted: false,
            overrideEnabled: overrideEnabled,
            deviceLastSyncedAt: deviceLastSyncedAt,
          );
        case SyncAction.delete:
          return await _dbRepository.syncUpdateDecks(
            syncEntity,
            companion,
            isDeleted: true,
            overrideEnabled: overrideEnabled,
            deviceLastSyncedAt: deviceLastSyncedAt,
          );
      }
    }
    if (item is card_dto.CardDto) {
      syncEntity = syncEntity.copyWith(
        sortOrder: Value(getSortOrder<Cards>()),
        entityType: Value(getEntityName<Cards>()),
      );
      final companion = CardsCompanion(
        id: Value(item.id),
        deckId: Value(item.deckId),
        front: Value(item.front),
        back: Value(item.back),
        frontPlainText: Value(() {
          try {
            return Document.fromJson(json.decode(item.front)).toPlainText();
          } on Exception catch (_) {
            return '';
          }
        }()),
        backPlainText: Value(() {
          try {
            return Document.fromJson(json.decode(item.back)).toPlainText();
          } on Exception catch (_) {
            return '';
          }
        }()),
        explanation: Value(item.explanation),
        displayOrder: Value(item.displayOrder),
        lapses: Value(item.lapses),
        reps: Value(item.reps),
        elapsedDays: Value(item.elapsedDays),
        scheduledDays: Value(item.scheduledDays),
        difficulty: Value(item.difficulty),
        stability: Value(item.stability),
        isSuspended: Value(item.isSuspended),
        due: Value(item.due),
        actualDue: Value(item.actualDue),
        lastReview: Value(item.lastReview),
        state: Value(item.state),
      );
      switch (item.action) {
        case SyncAction.create:
          return await _dbRepository.syncInsertCards(
            syncEntity,
            companion,
          );
        case SyncAction.update:
          return await _dbRepository.syncUpdateCards(
            syncEntity,
            companion,
            isDeleted: false,
            overrideEnabled: overrideEnabled,
            deviceLastSyncedAt: deviceLastSyncedAt,
          );
        case SyncAction.delete:
          return await _dbRepository.syncUpdateCards(
            syncEntity,
            companion,
            isDeleted: true,
            overrideEnabled: overrideEnabled,
            deviceLastSyncedAt: deviceLastSyncedAt,
          );
      }
    }
    if (item is CardTagMappingDto) {
      syncEntity = syncEntity.copyWith(
        sortOrder: Value(getSortOrder<CardTagMappings>()),
        entityType: Value(getEntityName<CardTagMappings>()),
      );
      final companion = CardTagMappingsCompanion(
        id: Value(item.id),
        cardId: Value(item.cardId),
        cardTagId: Value(item.cardTagId),
      );
      switch (item.action) {
        case SyncAction.create:
          return await _dbRepository.syncInsertCardTagMappings(
            syncEntity,
            companion,
          );
        case SyncAction.update:
          return await _dbRepository.syncUpdateCardTagMappings(
            syncEntity,
            companion,
            isDeleted: false,
            overrideEnabled: overrideEnabled,
            deviceLastSyncedAt: deviceLastSyncedAt,
          );
        case SyncAction.delete:
          return await _dbRepository.syncUpdateCardTagMappings(
            syncEntity,
            companion,
            isDeleted: true,
            overrideEnabled: overrideEnabled,
            deviceLastSyncedAt: deviceLastSyncedAt,
          );
      }
    }
    if (item is ReviewLogDto) {
      syncEntity = syncEntity.copyWith(
        sortOrder: Value(getSortOrder<ReviewLogs>()),
        entityType: Value(getEntityName<ReviewLogs>()),
      );
      final companion = ReviewLogsCompanion(
        id: Value(item.id),
        cardId: Value(item.cardId),
        elapsedDays: Value(item.elapsedDays),
        scheduledDays: Value(item.scheduledDays),
        review: Value(item.review),
        lastReview: Value(item.lastReview),
        reviewDurationInMs: Value(item.reviewDurationInMs),
        state: Value(item.state),
        rating: Value(item.rating),
      );
      switch (item.action) {
        case SyncAction.create:
          return await _dbRepository.syncInsertReviewLog(
            syncEntity,
            companion,
          );
        case SyncAction.update:
          return await _dbRepository.syncUpdateReviewLog(
            syncEntity,
            companion,
            isDeleted: false,
            overrideEnabled: overrideEnabled,
            deviceLastSyncedAt: deviceLastSyncedAt,
          );
        case SyncAction.delete:
          return await _dbRepository.syncUpdateReviewLog(
            syncEntity,
            companion,
            isDeleted: true,
            overrideEnabled: overrideEnabled,
            deviceLastSyncedAt: deviceLastSyncedAt,
          );
      }
    }
    return PersistStatus(
      isSuccessful: false,
      hasSyncConflict: false,
    );
  }

  Future<void> _initNormalPullSync({
    required final String userId,
    required final SyncAction action,
    required final DateTime deviceLastSyncedAt,
  }) async {
    int pageNumber = 0;
    const pageSize = 50;

    SyncPullResponseDto? response;

    do {
      response = await _syncApi.pullSync(
        request: SyncPullRequestDto(
          lastSyncDateTimeStr: deviceLastSyncedAt,
          userId: userId,
          pageNumber: pageNumber,
          pageSize: pageSize,
        ),
        action: action,
      );
      if (response != null) {
        if (kDebugMode) {
          print(
            '${response.items.length} ${action.toString()} records is pulled at $deviceLastSyncedAt',
          );
        }
        for (final item in response.items) {
          final persistStatus = await _pullSync(
            item,
            overrideEnabled: false,
            deviceLastSyncedAt: deviceLastSyncedAt,
          );
          if (persistStatus.hasSyncConflict) {
            await _dbRepository.insertConflictedRows(
              ConflictedRowsCompanion(
                id: Value(item.id),
                source: Value(Source.PULL_FROM_CLOUD.value),
                userId: Value(userId),
              ),
            );
          }
        }
      }
      pageNumber++;
    } while (response != null && response.hasNextPage);
  }

  Future<void> _initOverridePullSync({
    required final String userId,
    required final DateTime deviceLastSyncedAt,
  }) async {
    int pageNumber = 0;
    const pageSize = 50;

    PaginatedConflictedRowDto? res;

    do {
      res = await _dbRepository.getConflictedSyncEntities(
        page: pageNumber,
        pageSize: pageSize,
      );

      final entityIds = res.items.map((final e) => e.id).toList();

      final response = await _syncApi.pullSpecificSync(
        request: SyncPullSpecificRequestDto(
          entityIds: entityIds,
          userId: userId,
        ),
      );
      if (response != null) {
        for (final item in response.items) {
          final persistStatus = await _pullSync(
            item,
            overrideEnabled: true,
            deviceLastSyncedAt: deviceLastSyncedAt,
          );
          if (persistStatus.isSuccessful) {
            await _dbRepository.deleteConflictedRow(entityId: item.id);
          }
        }
      }

      pageNumber++;
    } while (res.pagination.nextPageSize > 0);
  }

  Future<void> _pushAsync({
    required final List<SyncEntity> syncEntities,
    required final SyncAction action,
    required final bool overrideEnabled,
    required final String userId,
  }) async {
    List<SyncEntityDto> items = [];
    for (final item in syncEntities) {
      switch (item.entityType) {
        case 'CardTag':
          final cardTag = await _dbRepository.getCardTagById(item.id);
          if (cardTag == null) {
            continue;
          }
          items.add(
            CardTagDto(
              id: item.id,
              createdAt: item.createdAt,
              lastModified: item.lastModified,
              version: item.version,
              deletedAt: item.deletedAt,
              syncedAt: item.syncedAt,
              modifiedByDeviceId: item.modifiedByDeviceId,
              userId: item.userId,
              entityType: item.entityType,
              action: action,
              name: cardTag.name,
            ),
          );
          break;
        case 'DeckSettings':
          final deckSetting = await _dbRepository.getDeckSettingById(item.id);
          if (deckSetting == null) {
            continue;
          }
          items.add(
            DeckSettingsDto(
              id: item.id,
              createdAt: item.createdAt,
              lastModified: item.lastModified,
              version: item.version,
              deletedAt: item.deletedAt,
              syncedAt: item.syncedAt,
              modifiedByDeviceId: item.modifiedByDeviceId,
              userId: item.userId,
              entityType: item.entityType,
              action: action,
              isDefault: deckSetting.isDefault,
              learningSteps: deckSetting.learningSteps,
              relearningSteps: deckSetting.reLearningSteps,
              maxNewCardsPerDay: deckSetting.maxNewCardsPerDay,
              maxReviewPerDay: deckSetting.maxReviewPerDay,
              maximumAnswerSeconds: deckSetting.maximumAnswerSeconds,
              desiredRetention: deckSetting.desiredRetention,
              newPriority: deckSetting.newPriority,
              interdayPriority: deckSetting.interdayPriority,
              reviewPriority: deckSetting.reviewPriority,
              skipNewCard: deckSetting.skipNewCard,
              skipLearningCard: deckSetting.skipLearningCard,
              skipReviewCard: deckSetting.skipReviewCard,
            ),
          );
          break;
        case 'Deck':
          final deck = await _dbRepository.getDeckById(item.id);
          if (deck == null) {
            continue;
          }
          items.add(
            DeckDto(
              id: item.id,
              createdAt: item.createdAt,
              lastModified: item.lastModified,
              version: item.version,
              deletedAt: item.deletedAt,
              syncedAt: item.syncedAt,
              modifiedByDeviceId: item.modifiedByDeviceId,
              userId: item.userId,
              entityType: item.entityType,
              action: action,
              name: deck.name,
              description: deck.description,
              totalCount: deck.totalCount,
              newCount: deck.newCount,
              learningCount: deck.learningCount,
              reviewCount: deck.reviewCount,
              shareCode: deck.shareCode,
              canShareExpired: deck.canShareExpired,
              shareExpirationTime: deck.shareExpirationTime,
              deckSettingsId: deck.deckSettingsId,
              lastReviewTime: deck.lastReviewTime,
            ),
          );
          break;
        case 'Card':
          final card = await _dbRepository.getCardById(item.id);
          if (card == null) {
            continue;
          }
          items.add(
            card_dto.CardDto(
              id: item.id,
              createdAt: item.createdAt,
              lastModified: item.lastModified,
              version: item.version,
              deletedAt: item.deletedAt,
              syncedAt: item.syncedAt,
              modifiedByDeviceId: item.modifiedByDeviceId,
              userId: item.userId,
              entityType: item.entityType,
              action: action,
              front: card.front,
              back: card.back,
              explanation: card.explanation,
              displayOrder: card.displayOrder,
              difficulty: card.difficulty,
              due: card.due,
              actualDue: card.actualDue,
              elapsedDays: card.elapsedDays,
              lapses: card.lapses,
              lastReview: card.lastReview,
              reps: card.reps,
              scheduledDays: card.scheduledDays,
              stability: card.stability,
              state: card.state,
              isSuspended: card.isSuspended,
              deckId: card.deckId,
            ),
          );
          break;
        case 'CardTagMapping':
          final cardTagMapping = await _dbRepository.getCardTagMappingById(
            item.id,
          );
          if (cardTagMapping == null) {
            continue;
          }
          items.add(
            CardTagMappingDto(
              id: item.id,
              createdAt: item.createdAt,
              lastModified: item.lastModified,
              version: item.version,
              deletedAt: item.deletedAt,
              syncedAt: item.syncedAt,
              modifiedByDeviceId: item.modifiedByDeviceId,
              userId: item.userId,
              entityType: item.entityType,
              action: action,
              cardId: cardTagMapping.cardId,
              cardTagId: cardTagMapping.cardTagId,
            ),
          );
          break;
        case 'ReviewLog':
          final reviewLog = await _dbRepository.getReviewLogById(item.id);
          if (reviewLog == null) {
            continue;
          }
          items.add(
            ReviewLogDto(
              id: item.id,
              createdAt: item.createdAt,
              lastModified: item.lastModified,
              version: item.version,
              deletedAt: item.deletedAt,
              syncedAt: item.syncedAt,
              modifiedByDeviceId: item.modifiedByDeviceId,
              userId: item.userId,
              entityType: item.entityType,
              action: action,
              elapsedDays: reviewLog.elapsedDays,
              rating: reviewLog.rating,
              review: reviewLog.review,
              scheduledDays: reviewLog.scheduledDays,
              state: reviewLog.state,
              reviewDurationInMs: reviewLog.reviewDurationInMs,
              lastReview: reviewLog.lastReview,
              cardId: reviewLog.cardId,
            ),
          );
          break;
      }
    }
    final response = await _syncApi.pushSync(
      items: SyncPushRequestDto(
        items: items,
      ),
      forceOverride: overrideEnabled,
    );
    if (response != null) {
      if (response.successfulItems.isNotEmpty) {
        for (final item in response.successfulItems) {
          await _dbRepository.syncSyncEntityWithCloud(
            id: item.id,
            entityType: item.entityType,
            version: item.version,
            syncedAt: item.syncedAt ?? DateTime.now().toUtc(),
            createdAt: item.createdAt,
            lastModified: item.lastModified,
            deletedAt: item.deletedAt,
          );
        }
      }
      if (response.conflictedItems.isNotEmpty) {
        for (final item in response.conflictedItems) {
          await _dbRepository.insertConflictedRows(
            ConflictedRowsCompanion(
              id: Value(item.id),
              source: Value(Source.PUSH_TO_CLOUD.value),
              userId: Value(userId),
            ),
          );
        }
      }
    }
  }

  Future<void> _initNormalPushSync({
    required final String userId,
    required final SyncAction action,
    required final DateTime deviceLastSyncedAt,
  }) async {
    int pageNumber = 0;
    const pageSize = 50;

    PaginatedSyncEntityDto? res;

    do {
      switch (action) {
        case SyncAction.create:
          res = await _dbRepository.getCreatedEntitiesToBePushed(
            lastSyncDate: deviceLastSyncedAt,
            page: pageNumber,
            pageSize: pageSize,
          );
          break;
        case SyncAction.update:
          res = await _dbRepository.getUpdatedEntitiesToBePushed(
            lastSyncDate: deviceLastSyncedAt,
            page: pageNumber,
            pageSize: pageSize,
          );
          break;
        case SyncAction.delete:
          res = await _dbRepository.getDeletedEntitiesToBePushed(
            lastSyncDate: deviceLastSyncedAt,
            page: pageNumber,
            pageSize: pageSize,
          );
          break;
      }

      if (kDebugMode) {
        print(
          '${res.items.length} ${action.toString()} records is pushed at $deviceLastSyncedAt',
        );
      }

      if (res.items.isNotEmpty) {
        await _pushAsync(
          syncEntities: res.items,
          action: action,
          overrideEnabled: false,
          userId: userId,
        );
      }

      pageNumber++;
    } while (res.pagination.nextPageSize > 0);
  }

  Future<void> _initOverridePushSync({
    required final String userId,
  }) async {
    int pageNumber = 0;
    const pageSize = 50;

    PaginatedConflictedRowDto? res;

    do {
      res = await _dbRepository.getConflictedSyncEntities(
        page: pageNumber,
        pageSize: pageSize,
      );

      await _pushAsync(
        syncEntities: res.items,
        action: SyncAction.update,
        overrideEnabled: true,
        userId: userId,
      );

      await _dbRepository.deleteConflictedRows(
        entityIds: res.items.map((final e) => e.id).toList(),
      );

      pageNumber++;
    } while (res.pagination.nextPageSize > 0);
  }

  Future<void> _onSyncMain({
    required final bool overrideCloudWithLocalCopy,
    required final bool overrideLocalWithCloudCopy,
    required final bool showInitSync,
    required final Emitter<SyncState> emit,
  }) async {
    final nextDeviceLastSyncedAt = DateTime.now().toUtc().subtract(
          const Duration(
            milliseconds: 500,
          ),
        );

    // init,
    emit(
      SyncState(
        curProgress: SyncProgress.init,
        showInitSync: showInitSync,
      ),
    );

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(failedSyncState());
    }
    final appUser = await _dbRepository.getUserById(user!.uid);
    if (appUser == null) {
      emit(failedSyncState());
    }

    final userId = user.uid;
    final deviceLastSyncedAtPush = appUser!.lastSyncedAt;
    // final deviceLastSyncedAtPull = deviceLastSyncedAtPush;
    final deviceLastSyncedAtPull = deviceLastSyncedAtPush.subtract(
      const Duration(
        minutes: 1,
      ),
    );

    try {
      if (!await _heartbeatApi.isBackendHeartBeating()) {
        emit(
          const SyncState(
            curProgress: SyncProgress.backendNotAvailable,
          ),
        );
        return;
      }

      if (!overrideCloudWithLocalCopy && !overrideLocalWithCloudCopy) {
        // pushedCreate
        await _initNormalPushSync(
          userId: userId,
          action: SyncAction.create,
          deviceLastSyncedAt: deviceLastSyncedAtPush,
        );
        emit(
          const SyncState(
            curProgress: SyncProgress.pushedCreate,
          ),
        );

        // pushedUpdate
        await _initNormalPushSync(
          userId: userId,
          action: SyncAction.update,
          deviceLastSyncedAt: deviceLastSyncedAtPush,
        );
        emit(
          const SyncState(
            curProgress: SyncProgress.pushedUpdate,
          ),
        );

        // pushedDelete
        await _initNormalPushSync(
          userId: userId,
          action: SyncAction.delete,
          deviceLastSyncedAt: deviceLastSyncedAtPush,
        );
        emit(
          const SyncState(
            curProgress: SyncProgress.pushedDelete,
          ),
        );

        // pulledCreate,
        await _initNormalPullSync(
          userId: userId,
          deviceLastSyncedAt: deviceLastSyncedAtPull,
          action: SyncAction.create,
        );
        emit(
          const SyncState(
            curProgress: SyncProgress.pulledCreate,
          ),
        );

        // pulledUpdate,
        await _initNormalPullSync(
          userId: userId,
          deviceLastSyncedAt: deviceLastSyncedAtPull,
          action: SyncAction.update,
        );
        emit(
          const SyncState(
            curProgress: SyncProgress.pulledUpdate,
          ),
        );

        // pulledDelete,
        await _initNormalPullSync(
          userId: userId,
          deviceLastSyncedAt: deviceLastSyncedAtPull,
          action: SyncAction.delete,
        );
        emit(
          const SyncState(
            curProgress: SyncProgress.pulledDelete,
          ),
        );
      } else if (overrideLocalWithCloudCopy) {
        emit(
          const SyncState(
            curProgress: SyncProgress.pulledCreate,
          ),
        );
        await _initOverridePullSync(
          userId: userId,
          deviceLastSyncedAt: deviceLastSyncedAtPull,
        );
      } else if (overrideCloudWithLocalCopy) {
        emit(
          const SyncState(
            curProgress: SyncProgress.pushedCreate,
          ),
        );
        await _initOverridePushSync(
          userId: userId,
        );
      }

      final conflictedRows = await _dbRepository.getConflictedSyncEntities(
        page: 0,
        pageSize: 1,
      );

      if (conflictedRows.items.isEmpty) {
        await _dbRepository.updateDeviceSyncedDate(
          lastSyncedAt: nextDeviceLastSyncedAt,
        );
        // successful, // 100%
        emit(
          const SyncState(
            curProgress: SyncProgress.successful,
          ),
        );
      } else {
        // conflicted, // 100%
        emit(
          const SyncState(
            curProgress: SyncProgress.conflicted,
          ),
        );
      }
    } on Exception catch (e) {
      // failed,
      emit(
        const SyncState(
          curProgress: SyncProgress.failed,
        ),
      );

      if (kDebugMode) {
        print(e);
      }
    }

    // Trigger refresh of home page
    _deckBloc.add(
      const DeckReloaded(
        newlyAddedDeckId: '',
      ),
    );
  }

  void _onSyncInit(
    final SyncInit event,
    final Emitter<SyncState> emit,
  ) async {
    await _onSyncMain(
      overrideCloudWithLocalCopy: event.overrideCloudWithLocalCopy,
      overrideLocalWithCloudCopy: event.overrideLocalWithCloudCopy,
      showInitSync: false,
      emit: emit,
    );
  }

  void _onUserAutoLogin(
    final UserAutoLogin event,
    final Emitter<SyncState> emit,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    final appUser = await _dbRepository.getUserById(user.uid);
    if (appUser == null) {
      await _authenticationRepository.createUserInDatabase(
        user,
        user.displayName ?? '',
      );
    }
    await _onSyncMain(
      overrideCloudWithLocalCopy: false,
      overrideLocalWithCloudCopy: false,
      showInitSync: true,
      emit: emit,
    );
  }
}

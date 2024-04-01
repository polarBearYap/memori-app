// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:memori_app/db/tables/sync_entities.drift.dart' as i1;
import 'package:memori_app/db/tables/sync_entities.dart' as i2;

i0.Index get idxCreatedAt => i0.Index('idx_created_at',
    'CREATE INDEX idx_created_at ON sync_entities (created_at)');

class $SyncEntitiesTable extends i2.SyncEntities
    with i0.TableInfo<$SyncEntitiesTable, i1.SyncEntity> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncEntitiesTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<String> id = i0.GeneratedColumn<String>(
      'id', aliasedName, false,
      type: i0.DriftSqlType.string, requiredDuringInsert: true);
  static const i0.VerificationMeta _sortOrderMeta =
      const i0.VerificationMeta('sortOrder');
  @override
  late final i0.GeneratedColumn<int> sortOrder = i0.GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: i0.DriftSqlType.int, requiredDuringInsert: true);
  static const i0.VerificationMeta _createdAtMeta =
      const i0.VerificationMeta('createdAt');
  @override
  late final i0.GeneratedColumn<DateTime> createdAt =
      i0.GeneratedColumn<DateTime>('created_at', aliasedName, false,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _deletedAtMeta =
      const i0.VerificationMeta('deletedAt');
  @override
  late final i0.GeneratedColumn<DateTime> deletedAt =
      i0.GeneratedColumn<DateTime>('deleted_at', aliasedName, true,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: false);
  static const i0.VerificationMeta _lastModifiedMeta =
      const i0.VerificationMeta('lastModified');
  @override
  late final i0.GeneratedColumn<DateTime> lastModified =
      i0.GeneratedColumn<DateTime>('last_modified', aliasedName, false,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _syncedAtMeta =
      const i0.VerificationMeta('syncedAt');
  @override
  late final i0.GeneratedColumn<DateTime> syncedAt =
      i0.GeneratedColumn<DateTime>('synced_at', aliasedName, false,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _versionMeta =
      const i0.VerificationMeta('version');
  @override
  late final i0.GeneratedColumn<int> version = i0.GeneratedColumn<int>(
      'version', aliasedName, false,
      type: i0.DriftSqlType.int, requiredDuringInsert: true);
  static const i0.VerificationMeta _modifiedByDeviceIdMeta =
      const i0.VerificationMeta('modifiedByDeviceId');
  @override
  late final i0.GeneratedColumn<String> modifiedByDeviceId =
      i0.GeneratedColumn<String>('modified_by_device_id', aliasedName, false,
          type: i0.DriftSqlType.string, requiredDuringInsert: true);
  static const i0.VerificationMeta _entityTypeMeta =
      const i0.VerificationMeta('entityType');
  @override
  late final i0.GeneratedColumn<String> entityType = i0.GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: i0.DriftSqlType.string, requiredDuringInsert: true);
  static const i0.VerificationMeta _userIdMeta =
      const i0.VerificationMeta('userId');
  @override
  late final i0.GeneratedColumn<String> userId = i0.GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          i0.GeneratedColumn.constraintIsAlways('REFERENCES app_users (id)'));
  static const i0.VerificationMeta _localLastSyncedAtMeta =
      const i0.VerificationMeta('localLastSyncedAt');
  @override
  late final i0.GeneratedColumn<DateTime> localLastSyncedAt =
      i0.GeneratedColumn<DateTime>('local_last_synced_at', aliasedName, true,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<i0.GeneratedColumn> get $columns => [
        id,
        sortOrder,
        createdAt,
        deletedAt,
        lastModified,
        syncedAt,
        version,
        modifiedByDeviceId,
        entityType,
        userId,
        localLastSyncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_entities';
  @override
  i0.VerificationContext validateIntegrity(
      i0.Insertable<i1.SyncEntity> instance,
      {bool isInserting = false}) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('last_modified')) {
      context.handle(
          _lastModifiedMeta,
          lastModified.isAcceptableOrUnknown(
              data['last_modified']!, _lastModifiedMeta));
    } else if (isInserting) {
      context.missing(_lastModifiedMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    } else if (isInserting) {
      context.missing(_syncedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('modified_by_device_id')) {
      context.handle(
          _modifiedByDeviceIdMeta,
          modifiedByDeviceId.isAcceptableOrUnknown(
              data['modified_by_device_id']!, _modifiedByDeviceIdMeta));
    } else if (isInserting) {
      context.missing(_modifiedByDeviceIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('local_last_synced_at')) {
      context.handle(
          _localLastSyncedAtMeta,
          localLastSyncedAt.isAcceptableOrUnknown(
              data['local_last_synced_at']!, _localLastSyncedAtMeta));
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.SyncEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.SyncEntity(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}id'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      createdAt: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      lastModified: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime, data['${effectivePrefix}last_modified'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.dateTime, data['${effectivePrefix}synced_at'])!,
      version: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}version'])!,
      modifiedByDeviceId: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string,
          data['${effectivePrefix}modified_by_device_id'])!,
      entityType: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      userId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      localLastSyncedAt: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime,
          data['${effectivePrefix}local_last_synced_at']),
    );
  }

  @override
  $SyncEntitiesTable createAlias(String alias) {
    return $SyncEntitiesTable(attachedDatabase, alias);
  }
}

class SyncEntity extends i0.DataClass implements i0.Insertable<i1.SyncEntity> {
  final String id;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final DateTime lastModified;
  final DateTime syncedAt;
  final int version;
  final String modifiedByDeviceId;
  final String entityType;
  final String userId;
  final DateTime? localLastSyncedAt;
  const SyncEntity(
      {required this.id,
      required this.sortOrder,
      required this.createdAt,
      this.deletedAt,
      required this.lastModified,
      required this.syncedAt,
      required this.version,
      required this.modifiedByDeviceId,
      required this.entityType,
      required this.userId,
      this.localLastSyncedAt});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<String>(id);
    map['sort_order'] = i0.Variable<int>(sortOrder);
    map['created_at'] = i0.Variable<DateTime>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = i0.Variable<DateTime>(deletedAt);
    }
    map['last_modified'] = i0.Variable<DateTime>(lastModified);
    map['synced_at'] = i0.Variable<DateTime>(syncedAt);
    map['version'] = i0.Variable<int>(version);
    map['modified_by_device_id'] = i0.Variable<String>(modifiedByDeviceId);
    map['entity_type'] = i0.Variable<String>(entityType);
    map['user_id'] = i0.Variable<String>(userId);
    if (!nullToAbsent || localLastSyncedAt != null) {
      map['local_last_synced_at'] = i0.Variable<DateTime>(localLastSyncedAt);
    }
    return map;
  }

  i1.SyncEntitiesCompanion toCompanion(bool nullToAbsent) {
    return i1.SyncEntitiesCompanion(
      id: i0.Value(id),
      sortOrder: i0.Value(sortOrder),
      createdAt: i0.Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(deletedAt),
      lastModified: i0.Value(lastModified),
      syncedAt: i0.Value(syncedAt),
      version: i0.Value(version),
      modifiedByDeviceId: i0.Value(modifiedByDeviceId),
      entityType: i0.Value(entityType),
      userId: i0.Value(userId),
      localLastSyncedAt: localLastSyncedAt == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(localLastSyncedAt),
    );
  }

  factory SyncEntity.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return SyncEntity(
      id: serializer.fromJson<String>(json['id']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
      version: serializer.fromJson<int>(json['version']),
      modifiedByDeviceId:
          serializer.fromJson<String>(json['modifiedByDeviceId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      userId: serializer.fromJson<String>(json['userId']),
      localLastSyncedAt:
          serializer.fromJson<DateTime?>(json['localLastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'lastModified': serializer.toJson<DateTime>(lastModified),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
      'version': serializer.toJson<int>(version),
      'modifiedByDeviceId': serializer.toJson<String>(modifiedByDeviceId),
      'entityType': serializer.toJson<String>(entityType),
      'userId': serializer.toJson<String>(userId),
      'localLastSyncedAt': serializer.toJson<DateTime?>(localLastSyncedAt),
    };
  }

  i1.SyncEntity copyWith(
          {String? id,
          int? sortOrder,
          DateTime? createdAt,
          i0.Value<DateTime?> deletedAt = const i0.Value.absent(),
          DateTime? lastModified,
          DateTime? syncedAt,
          int? version,
          String? modifiedByDeviceId,
          String? entityType,
          String? userId,
          i0.Value<DateTime?> localLastSyncedAt = const i0.Value.absent()}) =>
      i1.SyncEntity(
        id: id ?? this.id,
        sortOrder: sortOrder ?? this.sortOrder,
        createdAt: createdAt ?? this.createdAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        lastModified: lastModified ?? this.lastModified,
        syncedAt: syncedAt ?? this.syncedAt,
        version: version ?? this.version,
        modifiedByDeviceId: modifiedByDeviceId ?? this.modifiedByDeviceId,
        entityType: entityType ?? this.entityType,
        userId: userId ?? this.userId,
        localLastSyncedAt: localLastSyncedAt.present
            ? localLastSyncedAt.value
            : this.localLastSyncedAt,
      );
  @override
  String toString() {
    return (StringBuffer('SyncEntity(')
          ..write('id: $id, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastModified: $lastModified, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('version: $version, ')
          ..write('modifiedByDeviceId: $modifiedByDeviceId, ')
          ..write('entityType: $entityType, ')
          ..write('userId: $userId, ')
          ..write('localLastSyncedAt: $localLastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      sortOrder,
      createdAt,
      deletedAt,
      lastModified,
      syncedAt,
      version,
      modifiedByDeviceId,
      entityType,
      userId,
      localLastSyncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.SyncEntity &&
          other.id == this.id &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt &&
          other.lastModified == this.lastModified &&
          other.syncedAt == this.syncedAt &&
          other.version == this.version &&
          other.modifiedByDeviceId == this.modifiedByDeviceId &&
          other.entityType == this.entityType &&
          other.userId == this.userId &&
          other.localLastSyncedAt == this.localLastSyncedAt);
}

class SyncEntitiesCompanion extends i0.UpdateCompanion<i1.SyncEntity> {
  final i0.Value<String> id;
  final i0.Value<int> sortOrder;
  final i0.Value<DateTime> createdAt;
  final i0.Value<DateTime?> deletedAt;
  final i0.Value<DateTime> lastModified;
  final i0.Value<DateTime> syncedAt;
  final i0.Value<int> version;
  final i0.Value<String> modifiedByDeviceId;
  final i0.Value<String> entityType;
  final i0.Value<String> userId;
  final i0.Value<DateTime?> localLastSyncedAt;
  final i0.Value<int> rowid;
  const SyncEntitiesCompanion({
    this.id = const i0.Value.absent(),
    this.sortOrder = const i0.Value.absent(),
    this.createdAt = const i0.Value.absent(),
    this.deletedAt = const i0.Value.absent(),
    this.lastModified = const i0.Value.absent(),
    this.syncedAt = const i0.Value.absent(),
    this.version = const i0.Value.absent(),
    this.modifiedByDeviceId = const i0.Value.absent(),
    this.entityType = const i0.Value.absent(),
    this.userId = const i0.Value.absent(),
    this.localLastSyncedAt = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  SyncEntitiesCompanion.insert({
    required String id,
    required int sortOrder,
    required DateTime createdAt,
    this.deletedAt = const i0.Value.absent(),
    required DateTime lastModified,
    required DateTime syncedAt,
    required int version,
    required String modifiedByDeviceId,
    required String entityType,
    required String userId,
    this.localLastSyncedAt = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  })  : id = i0.Value(id),
        sortOrder = i0.Value(sortOrder),
        createdAt = i0.Value(createdAt),
        lastModified = i0.Value(lastModified),
        syncedAt = i0.Value(syncedAt),
        version = i0.Value(version),
        modifiedByDeviceId = i0.Value(modifiedByDeviceId),
        entityType = i0.Value(entityType),
        userId = i0.Value(userId);
  static i0.Insertable<i1.SyncEntity> custom({
    i0.Expression<String>? id,
    i0.Expression<int>? sortOrder,
    i0.Expression<DateTime>? createdAt,
    i0.Expression<DateTime>? deletedAt,
    i0.Expression<DateTime>? lastModified,
    i0.Expression<DateTime>? syncedAt,
    i0.Expression<int>? version,
    i0.Expression<String>? modifiedByDeviceId,
    i0.Expression<String>? entityType,
    i0.Expression<String>? userId,
    i0.Expression<DateTime>? localLastSyncedAt,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (lastModified != null) 'last_modified': lastModified,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (version != null) 'version': version,
      if (modifiedByDeviceId != null)
        'modified_by_device_id': modifiedByDeviceId,
      if (entityType != null) 'entity_type': entityType,
      if (userId != null) 'user_id': userId,
      if (localLastSyncedAt != null) 'local_last_synced_at': localLastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.SyncEntitiesCompanion copyWith(
      {i0.Value<String>? id,
      i0.Value<int>? sortOrder,
      i0.Value<DateTime>? createdAt,
      i0.Value<DateTime?>? deletedAt,
      i0.Value<DateTime>? lastModified,
      i0.Value<DateTime>? syncedAt,
      i0.Value<int>? version,
      i0.Value<String>? modifiedByDeviceId,
      i0.Value<String>? entityType,
      i0.Value<String>? userId,
      i0.Value<DateTime?>? localLastSyncedAt,
      i0.Value<int>? rowid}) {
    return i1.SyncEntitiesCompanion(
      id: id ?? this.id,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      lastModified: lastModified ?? this.lastModified,
      syncedAt: syncedAt ?? this.syncedAt,
      version: version ?? this.version,
      modifiedByDeviceId: modifiedByDeviceId ?? this.modifiedByDeviceId,
      entityType: entityType ?? this.entityType,
      userId: userId ?? this.userId,
      localLastSyncedAt: localLastSyncedAt ?? this.localLastSyncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<String>(id.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = i0.Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = i0.Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = i0.Variable<DateTime>(deletedAt.value);
    }
    if (lastModified.present) {
      map['last_modified'] = i0.Variable<DateTime>(lastModified.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = i0.Variable<DateTime>(syncedAt.value);
    }
    if (version.present) {
      map['version'] = i0.Variable<int>(version.value);
    }
    if (modifiedByDeviceId.present) {
      map['modified_by_device_id'] =
          i0.Variable<String>(modifiedByDeviceId.value);
    }
    if (entityType.present) {
      map['entity_type'] = i0.Variable<String>(entityType.value);
    }
    if (userId.present) {
      map['user_id'] = i0.Variable<String>(userId.value);
    }
    if (localLastSyncedAt.present) {
      map['local_last_synced_at'] =
          i0.Variable<DateTime>(localLastSyncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncEntitiesCompanion(')
          ..write('id: $id, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('lastModified: $lastModified, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('version: $version, ')
          ..write('modifiedByDeviceId: $modifiedByDeviceId, ')
          ..write('entityType: $entityType, ')
          ..write('userId: $userId, ')
          ..write('localLastSyncedAt: $localLastSyncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

i0.Index get idxSortOrder => i0.Index('idx_sort_order',
    'CREATE INDEX idx_sort_order ON sync_entities (sort_order)');
i0.Index get idxUserId => i0.Index(
    'idx_user_id', 'CREATE INDEX idx_user_id ON sync_entities (user_id)');

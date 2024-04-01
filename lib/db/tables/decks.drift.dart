// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:memori_app/db/tables/decks.drift.dart' as i1;
import 'package:memori_app/db/tables/decks.dart' as i2;

class $DecksTable extends i2.Decks with i0.TableInfo<$DecksTable, i1.Deck> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DecksTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<String> id = i0.GeneratedColumn<String>(
      'id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'REFERENCES sync_entities (id)'));
  static const i0.VerificationMeta _deckSettingsIdMeta =
      const i0.VerificationMeta('deckSettingsId');
  @override
  late final i0.GeneratedColumn<String> deckSettingsId =
      i0.GeneratedColumn<String>(
          'deck_settings_id', aliasedName, false,
          type: i0.DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
              'REFERENCES deck_settings (id)'));
  static const i0.VerificationMeta _nameMeta =
      const i0.VerificationMeta('name');
  @override
  late final i0.GeneratedColumn<String> name = i0.GeneratedColumn<String>(
      'name', aliasedName, false,
      type: i0.DriftSqlType.string, requiredDuringInsert: true);
  static const i0.VerificationMeta _descriptionMeta =
      const i0.VerificationMeta('description');
  @override
  late final i0.GeneratedColumn<String> description =
      i0.GeneratedColumn<String>('description', aliasedName, false,
          type: i0.DriftSqlType.string, requiredDuringInsert: true);
  static const i0.VerificationMeta _newCountMeta =
      const i0.VerificationMeta('newCount');
  @override
  late final i0.GeneratedColumn<int> newCount = i0.GeneratedColumn<int>(
      'new_count', aliasedName, false,
      type: i0.DriftSqlType.int, requiredDuringInsert: true);
  static const i0.VerificationMeta _learningCountMeta =
      const i0.VerificationMeta('learningCount');
  @override
  late final i0.GeneratedColumn<int> learningCount = i0.GeneratedColumn<int>(
      'learning_count', aliasedName, false,
      type: i0.DriftSqlType.int, requiredDuringInsert: true);
  static const i0.VerificationMeta _reviewCountMeta =
      const i0.VerificationMeta('reviewCount');
  @override
  late final i0.GeneratedColumn<int> reviewCount = i0.GeneratedColumn<int>(
      'review_count', aliasedName, false,
      type: i0.DriftSqlType.int, requiredDuringInsert: true);
  static const i0.VerificationMeta _totalCountMeta =
      const i0.VerificationMeta('totalCount');
  @override
  late final i0.GeneratedColumn<int> totalCount = i0.GeneratedColumn<int>(
      'total_count', aliasedName, false,
      type: i0.DriftSqlType.int, requiredDuringInsert: true);
  static const i0.VerificationMeta _shareCodeMeta =
      const i0.VerificationMeta('shareCode');
  @override
  late final i0.GeneratedColumn<String> shareCode = i0.GeneratedColumn<String>(
      'share_code', aliasedName, false,
      type: i0.DriftSqlType.string, requiredDuringInsert: true);
  static const i0.VerificationMeta _canShareExpiredMeta =
      const i0.VerificationMeta('canShareExpired');
  @override
  late final i0.GeneratedColumn<bool> canShareExpired =
      i0.GeneratedColumn<bool>('can_share_expired', aliasedName, false,
          type: i0.DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
              'CHECK ("can_share_expired" IN (0, 1))'));
  static const i0.VerificationMeta _shareExpirationTimeMeta =
      const i0.VerificationMeta('shareExpirationTime');
  @override
  late final i0.GeneratedColumn<DateTime> shareExpirationTime =
      i0.GeneratedColumn<DateTime>('share_expiration_time', aliasedName, false,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _lastReviewTimeMeta =
      const i0.VerificationMeta('lastReviewTime');
  @override
  late final i0.GeneratedColumn<DateTime> lastReviewTime =
      i0.GeneratedColumn<DateTime>('last_review_time', aliasedName, true,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<i0.GeneratedColumn> get $columns => [
        id,
        deckSettingsId,
        name,
        description,
        newCount,
        learningCount,
        reviewCount,
        totalCount,
        shareCode,
        canShareExpired,
        shareExpirationTime,
        lastReviewTime
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deck';
  @override
  i0.VerificationContext validateIntegrity(i0.Insertable<i1.Deck> instance,
      {bool isInserting = false}) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('deck_settings_id')) {
      context.handle(
          _deckSettingsIdMeta,
          deckSettingsId.isAcceptableOrUnknown(
              data['deck_settings_id']!, _deckSettingsIdMeta));
    } else if (isInserting) {
      context.missing(_deckSettingsIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('new_count')) {
      context.handle(_newCountMeta,
          newCount.isAcceptableOrUnknown(data['new_count']!, _newCountMeta));
    } else if (isInserting) {
      context.missing(_newCountMeta);
    }
    if (data.containsKey('learning_count')) {
      context.handle(
          _learningCountMeta,
          learningCount.isAcceptableOrUnknown(
              data['learning_count']!, _learningCountMeta));
    } else if (isInserting) {
      context.missing(_learningCountMeta);
    }
    if (data.containsKey('review_count')) {
      context.handle(
          _reviewCountMeta,
          reviewCount.isAcceptableOrUnknown(
              data['review_count']!, _reviewCountMeta));
    } else if (isInserting) {
      context.missing(_reviewCountMeta);
    }
    if (data.containsKey('total_count')) {
      context.handle(
          _totalCountMeta,
          totalCount.isAcceptableOrUnknown(
              data['total_count']!, _totalCountMeta));
    } else if (isInserting) {
      context.missing(_totalCountMeta);
    }
    if (data.containsKey('share_code')) {
      context.handle(_shareCodeMeta,
          shareCode.isAcceptableOrUnknown(data['share_code']!, _shareCodeMeta));
    } else if (isInserting) {
      context.missing(_shareCodeMeta);
    }
    if (data.containsKey('can_share_expired')) {
      context.handle(
          _canShareExpiredMeta,
          canShareExpired.isAcceptableOrUnknown(
              data['can_share_expired']!, _canShareExpiredMeta));
    } else if (isInserting) {
      context.missing(_canShareExpiredMeta);
    }
    if (data.containsKey('share_expiration_time')) {
      context.handle(
          _shareExpirationTimeMeta,
          shareExpirationTime.isAcceptableOrUnknown(
              data['share_expiration_time']!, _shareExpirationTimeMeta));
    } else if (isInserting) {
      context.missing(_shareExpirationTimeMeta);
    }
    if (data.containsKey('last_review_time')) {
      context.handle(
          _lastReviewTimeMeta,
          lastReviewTime.isAcceptableOrUnknown(
              data['last_review_time']!, _lastReviewTimeMeta));
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.Deck map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.Deck(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}id'])!,
      deckSettingsId: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string, data['${effectivePrefix}deck_settings_id'])!,
      name: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}description'])!,
      newCount: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}new_count'])!,
      learningCount: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}learning_count'])!,
      reviewCount: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}review_count'])!,
      totalCount: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}total_count'])!,
      shareCode: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}share_code'])!,
      canShareExpired: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.bool, data['${effectivePrefix}can_share_expired'])!,
      shareExpirationTime: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime,
          data['${effectivePrefix}share_expiration_time'])!,
      lastReviewTime: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime, data['${effectivePrefix}last_review_time']),
    );
  }

  @override
  $DecksTable createAlias(String alias) {
    return $DecksTable(attachedDatabase, alias);
  }
}

class Deck extends i0.DataClass implements i0.Insertable<i1.Deck> {
  final String id;
  final String deckSettingsId;
  final String name;
  final String description;
  final int newCount;
  final int learningCount;
  final int reviewCount;
  final int totalCount;
  final String shareCode;
  final bool canShareExpired;
  final DateTime shareExpirationTime;
  final DateTime? lastReviewTime;
  const Deck(
      {required this.id,
      required this.deckSettingsId,
      required this.name,
      required this.description,
      required this.newCount,
      required this.learningCount,
      required this.reviewCount,
      required this.totalCount,
      required this.shareCode,
      required this.canShareExpired,
      required this.shareExpirationTime,
      this.lastReviewTime});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<String>(id);
    map['deck_settings_id'] = i0.Variable<String>(deckSettingsId);
    map['name'] = i0.Variable<String>(name);
    map['description'] = i0.Variable<String>(description);
    map['new_count'] = i0.Variable<int>(newCount);
    map['learning_count'] = i0.Variable<int>(learningCount);
    map['review_count'] = i0.Variable<int>(reviewCount);
    map['total_count'] = i0.Variable<int>(totalCount);
    map['share_code'] = i0.Variable<String>(shareCode);
    map['can_share_expired'] = i0.Variable<bool>(canShareExpired);
    map['share_expiration_time'] = i0.Variable<DateTime>(shareExpirationTime);
    if (!nullToAbsent || lastReviewTime != null) {
      map['last_review_time'] = i0.Variable<DateTime>(lastReviewTime);
    }
    return map;
  }

  i1.DecksCompanion toCompanion(bool nullToAbsent) {
    return i1.DecksCompanion(
      id: i0.Value(id),
      deckSettingsId: i0.Value(deckSettingsId),
      name: i0.Value(name),
      description: i0.Value(description),
      newCount: i0.Value(newCount),
      learningCount: i0.Value(learningCount),
      reviewCount: i0.Value(reviewCount),
      totalCount: i0.Value(totalCount),
      shareCode: i0.Value(shareCode),
      canShareExpired: i0.Value(canShareExpired),
      shareExpirationTime: i0.Value(shareExpirationTime),
      lastReviewTime: lastReviewTime == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(lastReviewTime),
    );
  }

  factory Deck.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return Deck(
      id: serializer.fromJson<String>(json['id']),
      deckSettingsId: serializer.fromJson<String>(json['deckSettingsId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      newCount: serializer.fromJson<int>(json['newCount']),
      learningCount: serializer.fromJson<int>(json['learningCount']),
      reviewCount: serializer.fromJson<int>(json['reviewCount']),
      totalCount: serializer.fromJson<int>(json['totalCount']),
      shareCode: serializer.fromJson<String>(json['shareCode']),
      canShareExpired: serializer.fromJson<bool>(json['canShareExpired']),
      shareExpirationTime:
          serializer.fromJson<DateTime>(json['shareExpirationTime']),
      lastReviewTime: serializer.fromJson<DateTime?>(json['lastReviewTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deckSettingsId': serializer.toJson<String>(deckSettingsId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'newCount': serializer.toJson<int>(newCount),
      'learningCount': serializer.toJson<int>(learningCount),
      'reviewCount': serializer.toJson<int>(reviewCount),
      'totalCount': serializer.toJson<int>(totalCount),
      'shareCode': serializer.toJson<String>(shareCode),
      'canShareExpired': serializer.toJson<bool>(canShareExpired),
      'shareExpirationTime': serializer.toJson<DateTime>(shareExpirationTime),
      'lastReviewTime': serializer.toJson<DateTime?>(lastReviewTime),
    };
  }

  i1.Deck copyWith(
          {String? id,
          String? deckSettingsId,
          String? name,
          String? description,
          int? newCount,
          int? learningCount,
          int? reviewCount,
          int? totalCount,
          String? shareCode,
          bool? canShareExpired,
          DateTime? shareExpirationTime,
          i0.Value<DateTime?> lastReviewTime = const i0.Value.absent()}) =>
      i1.Deck(
        id: id ?? this.id,
        deckSettingsId: deckSettingsId ?? this.deckSettingsId,
        name: name ?? this.name,
        description: description ?? this.description,
        newCount: newCount ?? this.newCount,
        learningCount: learningCount ?? this.learningCount,
        reviewCount: reviewCount ?? this.reviewCount,
        totalCount: totalCount ?? this.totalCount,
        shareCode: shareCode ?? this.shareCode,
        canShareExpired: canShareExpired ?? this.canShareExpired,
        shareExpirationTime: shareExpirationTime ?? this.shareExpirationTime,
        lastReviewTime:
            lastReviewTime.present ? lastReviewTime.value : this.lastReviewTime,
      );
  @override
  String toString() {
    return (StringBuffer('Deck(')
          ..write('id: $id, ')
          ..write('deckSettingsId: $deckSettingsId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('newCount: $newCount, ')
          ..write('learningCount: $learningCount, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('totalCount: $totalCount, ')
          ..write('shareCode: $shareCode, ')
          ..write('canShareExpired: $canShareExpired, ')
          ..write('shareExpirationTime: $shareExpirationTime, ')
          ..write('lastReviewTime: $lastReviewTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      deckSettingsId,
      name,
      description,
      newCount,
      learningCount,
      reviewCount,
      totalCount,
      shareCode,
      canShareExpired,
      shareExpirationTime,
      lastReviewTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.Deck &&
          other.id == this.id &&
          other.deckSettingsId == this.deckSettingsId &&
          other.name == this.name &&
          other.description == this.description &&
          other.newCount == this.newCount &&
          other.learningCount == this.learningCount &&
          other.reviewCount == this.reviewCount &&
          other.totalCount == this.totalCount &&
          other.shareCode == this.shareCode &&
          other.canShareExpired == this.canShareExpired &&
          other.shareExpirationTime == this.shareExpirationTime &&
          other.lastReviewTime == this.lastReviewTime);
}

class DecksCompanion extends i0.UpdateCompanion<i1.Deck> {
  final i0.Value<String> id;
  final i0.Value<String> deckSettingsId;
  final i0.Value<String> name;
  final i0.Value<String> description;
  final i0.Value<int> newCount;
  final i0.Value<int> learningCount;
  final i0.Value<int> reviewCount;
  final i0.Value<int> totalCount;
  final i0.Value<String> shareCode;
  final i0.Value<bool> canShareExpired;
  final i0.Value<DateTime> shareExpirationTime;
  final i0.Value<DateTime?> lastReviewTime;
  final i0.Value<int> rowid;
  const DecksCompanion({
    this.id = const i0.Value.absent(),
    this.deckSettingsId = const i0.Value.absent(),
    this.name = const i0.Value.absent(),
    this.description = const i0.Value.absent(),
    this.newCount = const i0.Value.absent(),
    this.learningCount = const i0.Value.absent(),
    this.reviewCount = const i0.Value.absent(),
    this.totalCount = const i0.Value.absent(),
    this.shareCode = const i0.Value.absent(),
    this.canShareExpired = const i0.Value.absent(),
    this.shareExpirationTime = const i0.Value.absent(),
    this.lastReviewTime = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  DecksCompanion.insert({
    required String id,
    required String deckSettingsId,
    required String name,
    required String description,
    required int newCount,
    required int learningCount,
    required int reviewCount,
    required int totalCount,
    required String shareCode,
    required bool canShareExpired,
    required DateTime shareExpirationTime,
    this.lastReviewTime = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  })  : id = i0.Value(id),
        deckSettingsId = i0.Value(deckSettingsId),
        name = i0.Value(name),
        description = i0.Value(description),
        newCount = i0.Value(newCount),
        learningCount = i0.Value(learningCount),
        reviewCount = i0.Value(reviewCount),
        totalCount = i0.Value(totalCount),
        shareCode = i0.Value(shareCode),
        canShareExpired = i0.Value(canShareExpired),
        shareExpirationTime = i0.Value(shareExpirationTime);
  static i0.Insertable<i1.Deck> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? deckSettingsId,
    i0.Expression<String>? name,
    i0.Expression<String>? description,
    i0.Expression<int>? newCount,
    i0.Expression<int>? learningCount,
    i0.Expression<int>? reviewCount,
    i0.Expression<int>? totalCount,
    i0.Expression<String>? shareCode,
    i0.Expression<bool>? canShareExpired,
    i0.Expression<DateTime>? shareExpirationTime,
    i0.Expression<DateTime>? lastReviewTime,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (deckSettingsId != null) 'deck_settings_id': deckSettingsId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (newCount != null) 'new_count': newCount,
      if (learningCount != null) 'learning_count': learningCount,
      if (reviewCount != null) 'review_count': reviewCount,
      if (totalCount != null) 'total_count': totalCount,
      if (shareCode != null) 'share_code': shareCode,
      if (canShareExpired != null) 'can_share_expired': canShareExpired,
      if (shareExpirationTime != null)
        'share_expiration_time': shareExpirationTime,
      if (lastReviewTime != null) 'last_review_time': lastReviewTime,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.DecksCompanion copyWith(
      {i0.Value<String>? id,
      i0.Value<String>? deckSettingsId,
      i0.Value<String>? name,
      i0.Value<String>? description,
      i0.Value<int>? newCount,
      i0.Value<int>? learningCount,
      i0.Value<int>? reviewCount,
      i0.Value<int>? totalCount,
      i0.Value<String>? shareCode,
      i0.Value<bool>? canShareExpired,
      i0.Value<DateTime>? shareExpirationTime,
      i0.Value<DateTime?>? lastReviewTime,
      i0.Value<int>? rowid}) {
    return i1.DecksCompanion(
      id: id ?? this.id,
      deckSettingsId: deckSettingsId ?? this.deckSettingsId,
      name: name ?? this.name,
      description: description ?? this.description,
      newCount: newCount ?? this.newCount,
      learningCount: learningCount ?? this.learningCount,
      reviewCount: reviewCount ?? this.reviewCount,
      totalCount: totalCount ?? this.totalCount,
      shareCode: shareCode ?? this.shareCode,
      canShareExpired: canShareExpired ?? this.canShareExpired,
      shareExpirationTime: shareExpirationTime ?? this.shareExpirationTime,
      lastReviewTime: lastReviewTime ?? this.lastReviewTime,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<String>(id.value);
    }
    if (deckSettingsId.present) {
      map['deck_settings_id'] = i0.Variable<String>(deckSettingsId.value);
    }
    if (name.present) {
      map['name'] = i0.Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = i0.Variable<String>(description.value);
    }
    if (newCount.present) {
      map['new_count'] = i0.Variable<int>(newCount.value);
    }
    if (learningCount.present) {
      map['learning_count'] = i0.Variable<int>(learningCount.value);
    }
    if (reviewCount.present) {
      map['review_count'] = i0.Variable<int>(reviewCount.value);
    }
    if (totalCount.present) {
      map['total_count'] = i0.Variable<int>(totalCount.value);
    }
    if (shareCode.present) {
      map['share_code'] = i0.Variable<String>(shareCode.value);
    }
    if (canShareExpired.present) {
      map['can_share_expired'] = i0.Variable<bool>(canShareExpired.value);
    }
    if (shareExpirationTime.present) {
      map['share_expiration_time'] =
          i0.Variable<DateTime>(shareExpirationTime.value);
    }
    if (lastReviewTime.present) {
      map['last_review_time'] = i0.Variable<DateTime>(lastReviewTime.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DecksCompanion(')
          ..write('id: $id, ')
          ..write('deckSettingsId: $deckSettingsId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('newCount: $newCount, ')
          ..write('learningCount: $learningCount, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('totalCount: $totalCount, ')
          ..write('shareCode: $shareCode, ')
          ..write('canShareExpired: $canShareExpired, ')
          ..write('shareExpirationTime: $shareExpirationTime, ')
          ..write('lastReviewTime: $lastReviewTime, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

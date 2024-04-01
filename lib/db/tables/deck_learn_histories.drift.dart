// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:memori_app/db/tables/deck_learn_histories.drift.dart' as i1;
import 'package:memori_app/db/tables/deck_learn_histories.dart' as i2;

class $DeckLearnHistoriesTable extends i2.DeckLearnHistories
    with i0.TableInfo<$DeckLearnHistoriesTable, i1.DeckLearnHistory> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeckLearnHistoriesTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<String> id = i0.GeneratedColumn<String>(
      'id', aliasedName, false,
      type: i0.DriftSqlType.string, requiredDuringInsert: true);
  static const i0.VerificationMeta _currentProgressMeta =
      const i0.VerificationMeta('currentProgress');
  @override
  late final i0.GeneratedColumn<int> currentProgress = i0.GeneratedColumn<int>(
      'current_progress', aliasedName, false,
      type: i0.DriftSqlType.int, requiredDuringInsert: true);
  static const i0.VerificationMeta _cardIdsMeta =
      const i0.VerificationMeta('cardIds');
  @override
  late final i0.GeneratedColumn<String> cardIds = i0.GeneratedColumn<String>(
      'card_ids', aliasedName, false,
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
  static const i0.VerificationMeta _deckIdMeta =
      const i0.VerificationMeta('deckId');
  @override
  late final i0.GeneratedColumn<String> deckId = i0.GeneratedColumn<String>(
      'deck_id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          i0.GeneratedColumn.constraintIsAlways('REFERENCES deck (id)'));
  static const i0.VerificationMeta _userIdMeta =
      const i0.VerificationMeta('userId');
  @override
  late final i0.GeneratedColumn<String> userId = i0.GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          i0.GeneratedColumn.constraintIsAlways('REFERENCES app_users (id)'));
  @override
  List<i0.GeneratedColumn> get $columns => [
        id,
        currentProgress,
        cardIds,
        newCount,
        learningCount,
        reviewCount,
        deckId,
        userId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deck_learn_histories';
  @override
  i0.VerificationContext validateIntegrity(
      i0.Insertable<i1.DeckLearnHistory> instance,
      {bool isInserting = false}) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('current_progress')) {
      context.handle(
          _currentProgressMeta,
          currentProgress.isAcceptableOrUnknown(
              data['current_progress']!, _currentProgressMeta));
    } else if (isInserting) {
      context.missing(_currentProgressMeta);
    }
    if (data.containsKey('card_ids')) {
      context.handle(_cardIdsMeta,
          cardIds.isAcceptableOrUnknown(data['card_ids']!, _cardIdsMeta));
    } else if (isInserting) {
      context.missing(_cardIdsMeta);
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
    if (data.containsKey('deck_id')) {
      context.handle(_deckIdMeta,
          deckId.isAcceptableOrUnknown(data['deck_id']!, _deckIdMeta));
    } else if (isInserting) {
      context.missing(_deckIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.DeckLearnHistory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.DeckLearnHistory(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}id'])!,
      currentProgress: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.int, data['${effectivePrefix}current_progress'])!,
      cardIds: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}card_ids'])!,
      newCount: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}new_count'])!,
      learningCount: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}learning_count'])!,
      reviewCount: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}review_count'])!,
      deckId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}deck_id'])!,
      userId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}user_id'])!,
    );
  }

  @override
  $DeckLearnHistoriesTable createAlias(String alias) {
    return $DeckLearnHistoriesTable(attachedDatabase, alias);
  }
}

class DeckLearnHistory extends i0.DataClass
    implements i0.Insertable<i1.DeckLearnHistory> {
  final String id;
  final int currentProgress;
  final String cardIds;
  final int newCount;
  final int learningCount;
  final int reviewCount;
  final String deckId;
  final String userId;
  const DeckLearnHistory(
      {required this.id,
      required this.currentProgress,
      required this.cardIds,
      required this.newCount,
      required this.learningCount,
      required this.reviewCount,
      required this.deckId,
      required this.userId});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<String>(id);
    map['current_progress'] = i0.Variable<int>(currentProgress);
    map['card_ids'] = i0.Variable<String>(cardIds);
    map['new_count'] = i0.Variable<int>(newCount);
    map['learning_count'] = i0.Variable<int>(learningCount);
    map['review_count'] = i0.Variable<int>(reviewCount);
    map['deck_id'] = i0.Variable<String>(deckId);
    map['user_id'] = i0.Variable<String>(userId);
    return map;
  }

  i1.DeckLearnHistoriesCompanion toCompanion(bool nullToAbsent) {
    return i1.DeckLearnHistoriesCompanion(
      id: i0.Value(id),
      currentProgress: i0.Value(currentProgress),
      cardIds: i0.Value(cardIds),
      newCount: i0.Value(newCount),
      learningCount: i0.Value(learningCount),
      reviewCount: i0.Value(reviewCount),
      deckId: i0.Value(deckId),
      userId: i0.Value(userId),
    );
  }

  factory DeckLearnHistory.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return DeckLearnHistory(
      id: serializer.fromJson<String>(json['id']),
      currentProgress: serializer.fromJson<int>(json['currentProgress']),
      cardIds: serializer.fromJson<String>(json['cardIds']),
      newCount: serializer.fromJson<int>(json['newCount']),
      learningCount: serializer.fromJson<int>(json['learningCount']),
      reviewCount: serializer.fromJson<int>(json['reviewCount']),
      deckId: serializer.fromJson<String>(json['deckId']),
      userId: serializer.fromJson<String>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'currentProgress': serializer.toJson<int>(currentProgress),
      'cardIds': serializer.toJson<String>(cardIds),
      'newCount': serializer.toJson<int>(newCount),
      'learningCount': serializer.toJson<int>(learningCount),
      'reviewCount': serializer.toJson<int>(reviewCount),
      'deckId': serializer.toJson<String>(deckId),
      'userId': serializer.toJson<String>(userId),
    };
  }

  i1.DeckLearnHistory copyWith(
          {String? id,
          int? currentProgress,
          String? cardIds,
          int? newCount,
          int? learningCount,
          int? reviewCount,
          String? deckId,
          String? userId}) =>
      i1.DeckLearnHistory(
        id: id ?? this.id,
        currentProgress: currentProgress ?? this.currentProgress,
        cardIds: cardIds ?? this.cardIds,
        newCount: newCount ?? this.newCount,
        learningCount: learningCount ?? this.learningCount,
        reviewCount: reviewCount ?? this.reviewCount,
        deckId: deckId ?? this.deckId,
        userId: userId ?? this.userId,
      );
  @override
  String toString() {
    return (StringBuffer('DeckLearnHistory(')
          ..write('id: $id, ')
          ..write('currentProgress: $currentProgress, ')
          ..write('cardIds: $cardIds, ')
          ..write('newCount: $newCount, ')
          ..write('learningCount: $learningCount, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('deckId: $deckId, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, currentProgress, cardIds, newCount,
      learningCount, reviewCount, deckId, userId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.DeckLearnHistory &&
          other.id == this.id &&
          other.currentProgress == this.currentProgress &&
          other.cardIds == this.cardIds &&
          other.newCount == this.newCount &&
          other.learningCount == this.learningCount &&
          other.reviewCount == this.reviewCount &&
          other.deckId == this.deckId &&
          other.userId == this.userId);
}

class DeckLearnHistoriesCompanion
    extends i0.UpdateCompanion<i1.DeckLearnHistory> {
  final i0.Value<String> id;
  final i0.Value<int> currentProgress;
  final i0.Value<String> cardIds;
  final i0.Value<int> newCount;
  final i0.Value<int> learningCount;
  final i0.Value<int> reviewCount;
  final i0.Value<String> deckId;
  final i0.Value<String> userId;
  final i0.Value<int> rowid;
  const DeckLearnHistoriesCompanion({
    this.id = const i0.Value.absent(),
    this.currentProgress = const i0.Value.absent(),
    this.cardIds = const i0.Value.absent(),
    this.newCount = const i0.Value.absent(),
    this.learningCount = const i0.Value.absent(),
    this.reviewCount = const i0.Value.absent(),
    this.deckId = const i0.Value.absent(),
    this.userId = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  DeckLearnHistoriesCompanion.insert({
    required String id,
    required int currentProgress,
    required String cardIds,
    required int newCount,
    required int learningCount,
    required int reviewCount,
    required String deckId,
    required String userId,
    this.rowid = const i0.Value.absent(),
  })  : id = i0.Value(id),
        currentProgress = i0.Value(currentProgress),
        cardIds = i0.Value(cardIds),
        newCount = i0.Value(newCount),
        learningCount = i0.Value(learningCount),
        reviewCount = i0.Value(reviewCount),
        deckId = i0.Value(deckId),
        userId = i0.Value(userId);
  static i0.Insertable<i1.DeckLearnHistory> custom({
    i0.Expression<String>? id,
    i0.Expression<int>? currentProgress,
    i0.Expression<String>? cardIds,
    i0.Expression<int>? newCount,
    i0.Expression<int>? learningCount,
    i0.Expression<int>? reviewCount,
    i0.Expression<String>? deckId,
    i0.Expression<String>? userId,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (currentProgress != null) 'current_progress': currentProgress,
      if (cardIds != null) 'card_ids': cardIds,
      if (newCount != null) 'new_count': newCount,
      if (learningCount != null) 'learning_count': learningCount,
      if (reviewCount != null) 'review_count': reviewCount,
      if (deckId != null) 'deck_id': deckId,
      if (userId != null) 'user_id': userId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.DeckLearnHistoriesCompanion copyWith(
      {i0.Value<String>? id,
      i0.Value<int>? currentProgress,
      i0.Value<String>? cardIds,
      i0.Value<int>? newCount,
      i0.Value<int>? learningCount,
      i0.Value<int>? reviewCount,
      i0.Value<String>? deckId,
      i0.Value<String>? userId,
      i0.Value<int>? rowid}) {
    return i1.DeckLearnHistoriesCompanion(
      id: id ?? this.id,
      currentProgress: currentProgress ?? this.currentProgress,
      cardIds: cardIds ?? this.cardIds,
      newCount: newCount ?? this.newCount,
      learningCount: learningCount ?? this.learningCount,
      reviewCount: reviewCount ?? this.reviewCount,
      deckId: deckId ?? this.deckId,
      userId: userId ?? this.userId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<String>(id.value);
    }
    if (currentProgress.present) {
      map['current_progress'] = i0.Variable<int>(currentProgress.value);
    }
    if (cardIds.present) {
      map['card_ids'] = i0.Variable<String>(cardIds.value);
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
    if (deckId.present) {
      map['deck_id'] = i0.Variable<String>(deckId.value);
    }
    if (userId.present) {
      map['user_id'] = i0.Variable<String>(userId.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeckLearnHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('currentProgress: $currentProgress, ')
          ..write('cardIds: $cardIds, ')
          ..write('newCount: $newCount, ')
          ..write('learningCount: $learningCount, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('deckId: $deckId, ')
          ..write('userId: $userId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

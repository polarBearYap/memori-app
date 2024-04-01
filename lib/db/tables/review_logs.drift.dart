// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:memori_app/db/tables/review_logs.drift.dart' as i1;
import 'package:memori_app/db/tables/review_logs.dart' as i2;
import 'package:drift/src/runtime/query_builder/query_builder.dart' as i3;

class $ReviewLogsTable extends i2.ReviewLogs
    with i0.TableInfo<$ReviewLogsTable, i1.ReviewLog> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewLogsTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<String> id = i0.GeneratedColumn<String>(
      'id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'REFERENCES sync_entities (id)'));
  static const i0.VerificationMeta _cardIdMeta =
      const i0.VerificationMeta('cardId');
  @override
  late final i0.GeneratedColumn<String> cardId = i0.GeneratedColumn<String>(
      'card_id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          i0.GeneratedColumn.constraintIsAlways('REFERENCES cards (id)'));
  static const i0.VerificationMeta _elapsedDaysMeta =
      const i0.VerificationMeta('elapsedDays');
  @override
  late final i0.GeneratedColumn<int> elapsedDays = i0.GeneratedColumn<int>(
      'elapsed_days', aliasedName, false,
      type: i0.DriftSqlType.int, requiredDuringInsert: true);
  static const i0.VerificationMeta _scheduledDaysMeta =
      const i0.VerificationMeta('scheduledDays');
  @override
  late final i0.GeneratedColumn<int> scheduledDays = i0.GeneratedColumn<int>(
      'scheduled_days', aliasedName, false,
      type: i0.DriftSqlType.int, requiredDuringInsert: true);
  static const i0.VerificationMeta _reviewMeta =
      const i0.VerificationMeta('review');
  @override
  late final i0.GeneratedColumn<DateTime> review = i0.GeneratedColumn<DateTime>(
      'review', aliasedName, false,
      type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _lastReviewMeta =
      const i0.VerificationMeta('lastReview');
  @override
  late final i0.GeneratedColumn<DateTime> lastReview =
      i0.GeneratedColumn<DateTime>('last_review', aliasedName, false,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _reviewDurationInMsMeta =
      const i0.VerificationMeta('reviewDurationInMs');
  @override
  late final i0.GeneratedColumn<int> reviewDurationInMs =
      i0.GeneratedColumn<int>('review_duration_in_ms', aliasedName, false,
          type: i0.DriftSqlType.int, requiredDuringInsert: true);
  static const i0.VerificationMeta _stateMeta =
      const i0.VerificationMeta('state');
  @override
  late final i0.GeneratedColumn<int> state = i0.GeneratedColumn<int>(
      'state', aliasedName, false,
      check: () => state.isBetween(const i3.Constant(0), const i3.Constant(3)),
      type: i0.DriftSqlType.int,
      requiredDuringInsert: true);
  static const i0.VerificationMeta _ratingMeta =
      const i0.VerificationMeta('rating');
  @override
  late final i0.GeneratedColumn<int> rating = i0.GeneratedColumn<int>(
      'rating', aliasedName, false,
      check: () => rating.isBetween(const i3.Constant(1), const i3.Constant(4)),
      type: i0.DriftSqlType.int,
      requiredDuringInsert: true);
  @override
  List<i0.GeneratedColumn> get $columns => [
        id,
        cardId,
        elapsedDays,
        scheduledDays,
        review,
        lastReview,
        reviewDurationInMs,
        state,
        rating
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_logs';
  @override
  i0.VerificationContext validateIntegrity(i0.Insertable<i1.ReviewLog> instance,
      {bool isInserting = false}) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(_cardIdMeta,
          cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta));
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('elapsed_days')) {
      context.handle(
          _elapsedDaysMeta,
          elapsedDays.isAcceptableOrUnknown(
              data['elapsed_days']!, _elapsedDaysMeta));
    } else if (isInserting) {
      context.missing(_elapsedDaysMeta);
    }
    if (data.containsKey('scheduled_days')) {
      context.handle(
          _scheduledDaysMeta,
          scheduledDays.isAcceptableOrUnknown(
              data['scheduled_days']!, _scheduledDaysMeta));
    } else if (isInserting) {
      context.missing(_scheduledDaysMeta);
    }
    if (data.containsKey('review')) {
      context.handle(_reviewMeta,
          review.isAcceptableOrUnknown(data['review']!, _reviewMeta));
    } else if (isInserting) {
      context.missing(_reviewMeta);
    }
    if (data.containsKey('last_review')) {
      context.handle(
          _lastReviewMeta,
          lastReview.isAcceptableOrUnknown(
              data['last_review']!, _lastReviewMeta));
    } else if (isInserting) {
      context.missing(_lastReviewMeta);
    }
    if (data.containsKey('review_duration_in_ms')) {
      context.handle(
          _reviewDurationInMsMeta,
          reviewDurationInMs.isAcceptableOrUnknown(
              data['review_duration_in_ms']!, _reviewDurationInMsMeta));
    } else if (isInserting) {
      context.missing(_reviewDurationInMsMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
          _stateMeta, state.isAcceptableOrUnknown(data['state']!, _stateMeta));
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(_ratingMeta,
          rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta));
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.ReviewLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.ReviewLog(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}id'])!,
      cardId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}card_id'])!,
      elapsedDays: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}elapsed_days'])!,
      scheduledDays: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}scheduled_days'])!,
      review: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.dateTime, data['${effectivePrefix}review'])!,
      lastReview: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime, data['${effectivePrefix}last_review'])!,
      reviewDurationInMs: attachedDatabase.typeMapping.read(i0.DriftSqlType.int,
          data['${effectivePrefix}review_duration_in_ms'])!,
      state: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}state'])!,
      rating: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}rating'])!,
    );
  }

  @override
  $ReviewLogsTable createAlias(String alias) {
    return $ReviewLogsTable(attachedDatabase, alias);
  }
}

class ReviewLog extends i0.DataClass implements i0.Insertable<i1.ReviewLog> {
  final String id;
  final String cardId;
  final int elapsedDays;
  final int scheduledDays;
  final DateTime review;
  final DateTime lastReview;
  final int reviewDurationInMs;
  final int state;
  final int rating;
  const ReviewLog(
      {required this.id,
      required this.cardId,
      required this.elapsedDays,
      required this.scheduledDays,
      required this.review,
      required this.lastReview,
      required this.reviewDurationInMs,
      required this.state,
      required this.rating});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<String>(id);
    map['card_id'] = i0.Variable<String>(cardId);
    map['elapsed_days'] = i0.Variable<int>(elapsedDays);
    map['scheduled_days'] = i0.Variable<int>(scheduledDays);
    map['review'] = i0.Variable<DateTime>(review);
    map['last_review'] = i0.Variable<DateTime>(lastReview);
    map['review_duration_in_ms'] = i0.Variable<int>(reviewDurationInMs);
    map['state'] = i0.Variable<int>(state);
    map['rating'] = i0.Variable<int>(rating);
    return map;
  }

  i1.ReviewLogsCompanion toCompanion(bool nullToAbsent) {
    return i1.ReviewLogsCompanion(
      id: i0.Value(id),
      cardId: i0.Value(cardId),
      elapsedDays: i0.Value(elapsedDays),
      scheduledDays: i0.Value(scheduledDays),
      review: i0.Value(review),
      lastReview: i0.Value(lastReview),
      reviewDurationInMs: i0.Value(reviewDurationInMs),
      state: i0.Value(state),
      rating: i0.Value(rating),
    );
  }

  factory ReviewLog.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return ReviewLog(
      id: serializer.fromJson<String>(json['id']),
      cardId: serializer.fromJson<String>(json['cardId']),
      elapsedDays: serializer.fromJson<int>(json['elapsedDays']),
      scheduledDays: serializer.fromJson<int>(json['scheduledDays']),
      review: serializer.fromJson<DateTime>(json['review']),
      lastReview: serializer.fromJson<DateTime>(json['lastReview']),
      reviewDurationInMs: serializer.fromJson<int>(json['reviewDurationInMs']),
      state: serializer.fromJson<int>(json['state']),
      rating: serializer.fromJson<int>(json['rating']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cardId': serializer.toJson<String>(cardId),
      'elapsedDays': serializer.toJson<int>(elapsedDays),
      'scheduledDays': serializer.toJson<int>(scheduledDays),
      'review': serializer.toJson<DateTime>(review),
      'lastReview': serializer.toJson<DateTime>(lastReview),
      'reviewDurationInMs': serializer.toJson<int>(reviewDurationInMs),
      'state': serializer.toJson<int>(state),
      'rating': serializer.toJson<int>(rating),
    };
  }

  i1.ReviewLog copyWith(
          {String? id,
          String? cardId,
          int? elapsedDays,
          int? scheduledDays,
          DateTime? review,
          DateTime? lastReview,
          int? reviewDurationInMs,
          int? state,
          int? rating}) =>
      i1.ReviewLog(
        id: id ?? this.id,
        cardId: cardId ?? this.cardId,
        elapsedDays: elapsedDays ?? this.elapsedDays,
        scheduledDays: scheduledDays ?? this.scheduledDays,
        review: review ?? this.review,
        lastReview: lastReview ?? this.lastReview,
        reviewDurationInMs: reviewDurationInMs ?? this.reviewDurationInMs,
        state: state ?? this.state,
        rating: rating ?? this.rating,
      );
  @override
  String toString() {
    return (StringBuffer('ReviewLog(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('elapsedDays: $elapsedDays, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('review: $review, ')
          ..write('lastReview: $lastReview, ')
          ..write('reviewDurationInMs: $reviewDurationInMs, ')
          ..write('state: $state, ')
          ..write('rating: $rating')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cardId, elapsedDays, scheduledDays,
      review, lastReview, reviewDurationInMs, state, rating);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.ReviewLog &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.elapsedDays == this.elapsedDays &&
          other.scheduledDays == this.scheduledDays &&
          other.review == this.review &&
          other.lastReview == this.lastReview &&
          other.reviewDurationInMs == this.reviewDurationInMs &&
          other.state == this.state &&
          other.rating == this.rating);
}

class ReviewLogsCompanion extends i0.UpdateCompanion<i1.ReviewLog> {
  final i0.Value<String> id;
  final i0.Value<String> cardId;
  final i0.Value<int> elapsedDays;
  final i0.Value<int> scheduledDays;
  final i0.Value<DateTime> review;
  final i0.Value<DateTime> lastReview;
  final i0.Value<int> reviewDurationInMs;
  final i0.Value<int> state;
  final i0.Value<int> rating;
  final i0.Value<int> rowid;
  const ReviewLogsCompanion({
    this.id = const i0.Value.absent(),
    this.cardId = const i0.Value.absent(),
    this.elapsedDays = const i0.Value.absent(),
    this.scheduledDays = const i0.Value.absent(),
    this.review = const i0.Value.absent(),
    this.lastReview = const i0.Value.absent(),
    this.reviewDurationInMs = const i0.Value.absent(),
    this.state = const i0.Value.absent(),
    this.rating = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  ReviewLogsCompanion.insert({
    required String id,
    required String cardId,
    required int elapsedDays,
    required int scheduledDays,
    required DateTime review,
    required DateTime lastReview,
    required int reviewDurationInMs,
    required int state,
    required int rating,
    this.rowid = const i0.Value.absent(),
  })  : id = i0.Value(id),
        cardId = i0.Value(cardId),
        elapsedDays = i0.Value(elapsedDays),
        scheduledDays = i0.Value(scheduledDays),
        review = i0.Value(review),
        lastReview = i0.Value(lastReview),
        reviewDurationInMs = i0.Value(reviewDurationInMs),
        state = i0.Value(state),
        rating = i0.Value(rating);
  static i0.Insertable<i1.ReviewLog> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? cardId,
    i0.Expression<int>? elapsedDays,
    i0.Expression<int>? scheduledDays,
    i0.Expression<DateTime>? review,
    i0.Expression<DateTime>? lastReview,
    i0.Expression<int>? reviewDurationInMs,
    i0.Expression<int>? state,
    i0.Expression<int>? rating,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (elapsedDays != null) 'elapsed_days': elapsedDays,
      if (scheduledDays != null) 'scheduled_days': scheduledDays,
      if (review != null) 'review': review,
      if (lastReview != null) 'last_review': lastReview,
      if (reviewDurationInMs != null)
        'review_duration_in_ms': reviewDurationInMs,
      if (state != null) 'state': state,
      if (rating != null) 'rating': rating,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.ReviewLogsCompanion copyWith(
      {i0.Value<String>? id,
      i0.Value<String>? cardId,
      i0.Value<int>? elapsedDays,
      i0.Value<int>? scheduledDays,
      i0.Value<DateTime>? review,
      i0.Value<DateTime>? lastReview,
      i0.Value<int>? reviewDurationInMs,
      i0.Value<int>? state,
      i0.Value<int>? rating,
      i0.Value<int>? rowid}) {
    return i1.ReviewLogsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      elapsedDays: elapsedDays ?? this.elapsedDays,
      scheduledDays: scheduledDays ?? this.scheduledDays,
      review: review ?? this.review,
      lastReview: lastReview ?? this.lastReview,
      reviewDurationInMs: reviewDurationInMs ?? this.reviewDurationInMs,
      state: state ?? this.state,
      rating: rating ?? this.rating,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<String>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = i0.Variable<String>(cardId.value);
    }
    if (elapsedDays.present) {
      map['elapsed_days'] = i0.Variable<int>(elapsedDays.value);
    }
    if (scheduledDays.present) {
      map['scheduled_days'] = i0.Variable<int>(scheduledDays.value);
    }
    if (review.present) {
      map['review'] = i0.Variable<DateTime>(review.value);
    }
    if (lastReview.present) {
      map['last_review'] = i0.Variable<DateTime>(lastReview.value);
    }
    if (reviewDurationInMs.present) {
      map['review_duration_in_ms'] = i0.Variable<int>(reviewDurationInMs.value);
    }
    if (state.present) {
      map['state'] = i0.Variable<int>(state.value);
    }
    if (rating.present) {
      map['rating'] = i0.Variable<int>(rating.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLogsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('elapsedDays: $elapsedDays, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('review: $review, ')
          ..write('lastReview: $lastReview, ')
          ..write('reviewDurationInMs: $reviewDurationInMs, ')
          ..write('state: $state, ')
          ..write('rating: $rating, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

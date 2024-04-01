// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:memori_app/db/tables/card_schedule_history.drift.dart' as i1;
import 'package:memori_app/db/tables/card_schedule_history.dart' as i2;
import 'package:drift/src/runtime/query_builder/query_builder.dart' as i3;

class $CardScheduleHistoriesTable extends i2.CardScheduleHistories
    with i0.TableInfo<$CardScheduleHistoriesTable, i1.CardScheduleHistory> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardScheduleHistoriesTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<String> id = i0.GeneratedColumn<String>(
      'id', aliasedName, false,
      type: i0.DriftSqlType.string, requiredDuringInsert: true);
  static const i0.VerificationMeta _lapsesMeta =
      const i0.VerificationMeta('lapses');
  @override
  late final i0.GeneratedColumn<int> lapses = i0.GeneratedColumn<int>(
      'lapses', aliasedName, false,
      type: i0.DriftSqlType.int, requiredDuringInsert: true);
  static const i0.VerificationMeta _repsMeta =
      const i0.VerificationMeta('reps');
  @override
  late final i0.GeneratedColumn<int> reps = i0.GeneratedColumn<int>(
      'reps', aliasedName, false,
      type: i0.DriftSqlType.int, requiredDuringInsert: true);
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
  static const i0.VerificationMeta _difficultyMeta =
      const i0.VerificationMeta('difficulty');
  @override
  late final i0.GeneratedColumn<double> difficulty = i0.GeneratedColumn<double>(
      'difficulty', aliasedName, false,
      type: i0.DriftSqlType.double, requiredDuringInsert: true);
  static const i0.VerificationMeta _stabilityMeta =
      const i0.VerificationMeta('stability');
  @override
  late final i0.GeneratedColumn<double> stability = i0.GeneratedColumn<double>(
      'stability', aliasedName, false,
      type: i0.DriftSqlType.double, requiredDuringInsert: true);
  static const i0.VerificationMeta _dueMeta = const i0.VerificationMeta('due');
  @override
  late final i0.GeneratedColumn<DateTime> due = i0.GeneratedColumn<DateTime>(
      'due', aliasedName, false,
      type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _lastReviewMeta =
      const i0.VerificationMeta('lastReview');
  @override
  late final i0.GeneratedColumn<DateTime> lastReview =
      i0.GeneratedColumn<DateTime>('last_review', aliasedName, false,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _reviewMeta =
      const i0.VerificationMeta('review');
  @override
  late final i0.GeneratedColumn<DateTime> review = i0.GeneratedColumn<DateTime>(
      'review', aliasedName, false,
      type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
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
  static const i0.VerificationMeta _cardIdMeta =
      const i0.VerificationMeta('cardId');
  @override
  late final i0.GeneratedColumn<String> cardId = i0.GeneratedColumn<String>(
      'card_id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          i0.GeneratedColumn.constraintIsAlways('REFERENCES cards (id)'));
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
        lapses,
        reps,
        elapsedDays,
        scheduledDays,
        difficulty,
        stability,
        due,
        lastReview,
        review,
        state,
        rating,
        cardId,
        userId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_schedule_histories';
  @override
  i0.VerificationContext validateIntegrity(
      i0.Insertable<i1.CardScheduleHistory> instance,
      {bool isInserting = false}) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lapses')) {
      context.handle(_lapsesMeta,
          lapses.isAcceptableOrUnknown(data['lapses']!, _lapsesMeta));
    } else if (isInserting) {
      context.missing(_lapsesMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
          _repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    } else if (isInserting) {
      context.missing(_repsMeta);
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
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('stability')) {
      context.handle(_stabilityMeta,
          stability.isAcceptableOrUnknown(data['stability']!, _stabilityMeta));
    } else if (isInserting) {
      context.missing(_stabilityMeta);
    }
    if (data.containsKey('due')) {
      context.handle(
          _dueMeta, due.isAcceptableOrUnknown(data['due']!, _dueMeta));
    } else if (isInserting) {
      context.missing(_dueMeta);
    }
    if (data.containsKey('last_review')) {
      context.handle(
          _lastReviewMeta,
          lastReview.isAcceptableOrUnknown(
              data['last_review']!, _lastReviewMeta));
    } else if (isInserting) {
      context.missing(_lastReviewMeta);
    }
    if (data.containsKey('review')) {
      context.handle(_reviewMeta,
          review.isAcceptableOrUnknown(data['review']!, _reviewMeta));
    } else if (isInserting) {
      context.missing(_reviewMeta);
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
    if (data.containsKey('card_id')) {
      context.handle(_cardIdMeta,
          cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta));
    } else if (isInserting) {
      context.missing(_cardIdMeta);
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
  i1.CardScheduleHistory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.CardScheduleHistory(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}id'])!,
      lapses: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}lapses'])!,
      reps: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}reps'])!,
      elapsedDays: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}elapsed_days'])!,
      scheduledDays: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}scheduled_days'])!,
      difficulty: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.double, data['${effectivePrefix}difficulty'])!,
      stability: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.double, data['${effectivePrefix}stability'])!,
      due: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.dateTime, data['${effectivePrefix}due'])!,
      lastReview: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime, data['${effectivePrefix}last_review'])!,
      review: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.dateTime, data['${effectivePrefix}review'])!,
      state: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}state'])!,
      rating: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}rating'])!,
      cardId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}card_id'])!,
      userId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}user_id'])!,
    );
  }

  @override
  $CardScheduleHistoriesTable createAlias(String alias) {
    return $CardScheduleHistoriesTable(attachedDatabase, alias);
  }
}

class CardScheduleHistory extends i0.DataClass
    implements i0.Insertable<i1.CardScheduleHistory> {
  final String id;
  final int lapses;
  final int reps;
  final int elapsedDays;
  final int scheduledDays;
  final double difficulty;
  final double stability;
  final DateTime due;
  final DateTime lastReview;
  final DateTime review;
  final int state;
  final int rating;
  final String cardId;
  final String userId;
  const CardScheduleHistory(
      {required this.id,
      required this.lapses,
      required this.reps,
      required this.elapsedDays,
      required this.scheduledDays,
      required this.difficulty,
      required this.stability,
      required this.due,
      required this.lastReview,
      required this.review,
      required this.state,
      required this.rating,
      required this.cardId,
      required this.userId});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<String>(id);
    map['lapses'] = i0.Variable<int>(lapses);
    map['reps'] = i0.Variable<int>(reps);
    map['elapsed_days'] = i0.Variable<int>(elapsedDays);
    map['scheduled_days'] = i0.Variable<int>(scheduledDays);
    map['difficulty'] = i0.Variable<double>(difficulty);
    map['stability'] = i0.Variable<double>(stability);
    map['due'] = i0.Variable<DateTime>(due);
    map['last_review'] = i0.Variable<DateTime>(lastReview);
    map['review'] = i0.Variable<DateTime>(review);
    map['state'] = i0.Variable<int>(state);
    map['rating'] = i0.Variable<int>(rating);
    map['card_id'] = i0.Variable<String>(cardId);
    map['user_id'] = i0.Variable<String>(userId);
    return map;
  }

  i1.CardScheduleHistoriesCompanion toCompanion(bool nullToAbsent) {
    return i1.CardScheduleHistoriesCompanion(
      id: i0.Value(id),
      lapses: i0.Value(lapses),
      reps: i0.Value(reps),
      elapsedDays: i0.Value(elapsedDays),
      scheduledDays: i0.Value(scheduledDays),
      difficulty: i0.Value(difficulty),
      stability: i0.Value(stability),
      due: i0.Value(due),
      lastReview: i0.Value(lastReview),
      review: i0.Value(review),
      state: i0.Value(state),
      rating: i0.Value(rating),
      cardId: i0.Value(cardId),
      userId: i0.Value(userId),
    );
  }

  factory CardScheduleHistory.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return CardScheduleHistory(
      id: serializer.fromJson<String>(json['id']),
      lapses: serializer.fromJson<int>(json['lapses']),
      reps: serializer.fromJson<int>(json['reps']),
      elapsedDays: serializer.fromJson<int>(json['elapsedDays']),
      scheduledDays: serializer.fromJson<int>(json['scheduledDays']),
      difficulty: serializer.fromJson<double>(json['difficulty']),
      stability: serializer.fromJson<double>(json['stability']),
      due: serializer.fromJson<DateTime>(json['due']),
      lastReview: serializer.fromJson<DateTime>(json['lastReview']),
      review: serializer.fromJson<DateTime>(json['review']),
      state: serializer.fromJson<int>(json['state']),
      rating: serializer.fromJson<int>(json['rating']),
      cardId: serializer.fromJson<String>(json['cardId']),
      userId: serializer.fromJson<String>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lapses': serializer.toJson<int>(lapses),
      'reps': serializer.toJson<int>(reps),
      'elapsedDays': serializer.toJson<int>(elapsedDays),
      'scheduledDays': serializer.toJson<int>(scheduledDays),
      'difficulty': serializer.toJson<double>(difficulty),
      'stability': serializer.toJson<double>(stability),
      'due': serializer.toJson<DateTime>(due),
      'lastReview': serializer.toJson<DateTime>(lastReview),
      'review': serializer.toJson<DateTime>(review),
      'state': serializer.toJson<int>(state),
      'rating': serializer.toJson<int>(rating),
      'cardId': serializer.toJson<String>(cardId),
      'userId': serializer.toJson<String>(userId),
    };
  }

  i1.CardScheduleHistory copyWith(
          {String? id,
          int? lapses,
          int? reps,
          int? elapsedDays,
          int? scheduledDays,
          double? difficulty,
          double? stability,
          DateTime? due,
          DateTime? lastReview,
          DateTime? review,
          int? state,
          int? rating,
          String? cardId,
          String? userId}) =>
      i1.CardScheduleHistory(
        id: id ?? this.id,
        lapses: lapses ?? this.lapses,
        reps: reps ?? this.reps,
        elapsedDays: elapsedDays ?? this.elapsedDays,
        scheduledDays: scheduledDays ?? this.scheduledDays,
        difficulty: difficulty ?? this.difficulty,
        stability: stability ?? this.stability,
        due: due ?? this.due,
        lastReview: lastReview ?? this.lastReview,
        review: review ?? this.review,
        state: state ?? this.state,
        rating: rating ?? this.rating,
        cardId: cardId ?? this.cardId,
        userId: userId ?? this.userId,
      );
  @override
  String toString() {
    return (StringBuffer('CardScheduleHistory(')
          ..write('id: $id, ')
          ..write('lapses: $lapses, ')
          ..write('reps: $reps, ')
          ..write('elapsedDays: $elapsedDays, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('difficulty: $difficulty, ')
          ..write('stability: $stability, ')
          ..write('due: $due, ')
          ..write('lastReview: $lastReview, ')
          ..write('review: $review, ')
          ..write('state: $state, ')
          ..write('rating: $rating, ')
          ..write('cardId: $cardId, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      lapses,
      reps,
      elapsedDays,
      scheduledDays,
      difficulty,
      stability,
      due,
      lastReview,
      review,
      state,
      rating,
      cardId,
      userId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.CardScheduleHistory &&
          other.id == this.id &&
          other.lapses == this.lapses &&
          other.reps == this.reps &&
          other.elapsedDays == this.elapsedDays &&
          other.scheduledDays == this.scheduledDays &&
          other.difficulty == this.difficulty &&
          other.stability == this.stability &&
          other.due == this.due &&
          other.lastReview == this.lastReview &&
          other.review == this.review &&
          other.state == this.state &&
          other.rating == this.rating &&
          other.cardId == this.cardId &&
          other.userId == this.userId);
}

class CardScheduleHistoriesCompanion
    extends i0.UpdateCompanion<i1.CardScheduleHistory> {
  final i0.Value<String> id;
  final i0.Value<int> lapses;
  final i0.Value<int> reps;
  final i0.Value<int> elapsedDays;
  final i0.Value<int> scheduledDays;
  final i0.Value<double> difficulty;
  final i0.Value<double> stability;
  final i0.Value<DateTime> due;
  final i0.Value<DateTime> lastReview;
  final i0.Value<DateTime> review;
  final i0.Value<int> state;
  final i0.Value<int> rating;
  final i0.Value<String> cardId;
  final i0.Value<String> userId;
  final i0.Value<int> rowid;
  const CardScheduleHistoriesCompanion({
    this.id = const i0.Value.absent(),
    this.lapses = const i0.Value.absent(),
    this.reps = const i0.Value.absent(),
    this.elapsedDays = const i0.Value.absent(),
    this.scheduledDays = const i0.Value.absent(),
    this.difficulty = const i0.Value.absent(),
    this.stability = const i0.Value.absent(),
    this.due = const i0.Value.absent(),
    this.lastReview = const i0.Value.absent(),
    this.review = const i0.Value.absent(),
    this.state = const i0.Value.absent(),
    this.rating = const i0.Value.absent(),
    this.cardId = const i0.Value.absent(),
    this.userId = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  CardScheduleHistoriesCompanion.insert({
    required String id,
    required int lapses,
    required int reps,
    required int elapsedDays,
    required int scheduledDays,
    required double difficulty,
    required double stability,
    required DateTime due,
    required DateTime lastReview,
    required DateTime review,
    required int state,
    required int rating,
    required String cardId,
    required String userId,
    this.rowid = const i0.Value.absent(),
  })  : id = i0.Value(id),
        lapses = i0.Value(lapses),
        reps = i0.Value(reps),
        elapsedDays = i0.Value(elapsedDays),
        scheduledDays = i0.Value(scheduledDays),
        difficulty = i0.Value(difficulty),
        stability = i0.Value(stability),
        due = i0.Value(due),
        lastReview = i0.Value(lastReview),
        review = i0.Value(review),
        state = i0.Value(state),
        rating = i0.Value(rating),
        cardId = i0.Value(cardId),
        userId = i0.Value(userId);
  static i0.Insertable<i1.CardScheduleHistory> custom({
    i0.Expression<String>? id,
    i0.Expression<int>? lapses,
    i0.Expression<int>? reps,
    i0.Expression<int>? elapsedDays,
    i0.Expression<int>? scheduledDays,
    i0.Expression<double>? difficulty,
    i0.Expression<double>? stability,
    i0.Expression<DateTime>? due,
    i0.Expression<DateTime>? lastReview,
    i0.Expression<DateTime>? review,
    i0.Expression<int>? state,
    i0.Expression<int>? rating,
    i0.Expression<String>? cardId,
    i0.Expression<String>? userId,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (lapses != null) 'lapses': lapses,
      if (reps != null) 'reps': reps,
      if (elapsedDays != null) 'elapsed_days': elapsedDays,
      if (scheduledDays != null) 'scheduled_days': scheduledDays,
      if (difficulty != null) 'difficulty': difficulty,
      if (stability != null) 'stability': stability,
      if (due != null) 'due': due,
      if (lastReview != null) 'last_review': lastReview,
      if (review != null) 'review': review,
      if (state != null) 'state': state,
      if (rating != null) 'rating': rating,
      if (cardId != null) 'card_id': cardId,
      if (userId != null) 'user_id': userId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.CardScheduleHistoriesCompanion copyWith(
      {i0.Value<String>? id,
      i0.Value<int>? lapses,
      i0.Value<int>? reps,
      i0.Value<int>? elapsedDays,
      i0.Value<int>? scheduledDays,
      i0.Value<double>? difficulty,
      i0.Value<double>? stability,
      i0.Value<DateTime>? due,
      i0.Value<DateTime>? lastReview,
      i0.Value<DateTime>? review,
      i0.Value<int>? state,
      i0.Value<int>? rating,
      i0.Value<String>? cardId,
      i0.Value<String>? userId,
      i0.Value<int>? rowid}) {
    return i1.CardScheduleHistoriesCompanion(
      id: id ?? this.id,
      lapses: lapses ?? this.lapses,
      reps: reps ?? this.reps,
      elapsedDays: elapsedDays ?? this.elapsedDays,
      scheduledDays: scheduledDays ?? this.scheduledDays,
      difficulty: difficulty ?? this.difficulty,
      stability: stability ?? this.stability,
      due: due ?? this.due,
      lastReview: lastReview ?? this.lastReview,
      review: review ?? this.review,
      state: state ?? this.state,
      rating: rating ?? this.rating,
      cardId: cardId ?? this.cardId,
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
    if (lapses.present) {
      map['lapses'] = i0.Variable<int>(lapses.value);
    }
    if (reps.present) {
      map['reps'] = i0.Variable<int>(reps.value);
    }
    if (elapsedDays.present) {
      map['elapsed_days'] = i0.Variable<int>(elapsedDays.value);
    }
    if (scheduledDays.present) {
      map['scheduled_days'] = i0.Variable<int>(scheduledDays.value);
    }
    if (difficulty.present) {
      map['difficulty'] = i0.Variable<double>(difficulty.value);
    }
    if (stability.present) {
      map['stability'] = i0.Variable<double>(stability.value);
    }
    if (due.present) {
      map['due'] = i0.Variable<DateTime>(due.value);
    }
    if (lastReview.present) {
      map['last_review'] = i0.Variable<DateTime>(lastReview.value);
    }
    if (review.present) {
      map['review'] = i0.Variable<DateTime>(review.value);
    }
    if (state.present) {
      map['state'] = i0.Variable<int>(state.value);
    }
    if (rating.present) {
      map['rating'] = i0.Variable<int>(rating.value);
    }
    if (cardId.present) {
      map['card_id'] = i0.Variable<String>(cardId.value);
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
    return (StringBuffer('CardScheduleHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('lapses: $lapses, ')
          ..write('reps: $reps, ')
          ..write('elapsedDays: $elapsedDays, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('difficulty: $difficulty, ')
          ..write('stability: $stability, ')
          ..write('due: $due, ')
          ..write('lastReview: $lastReview, ')
          ..write('review: $review, ')
          ..write('state: $state, ')
          ..write('rating: $rating, ')
          ..write('cardId: $cardId, ')
          ..write('userId: $userId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

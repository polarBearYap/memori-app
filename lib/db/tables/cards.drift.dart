// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:memori_app/db/tables/cards.drift.dart' as i1;
import 'package:memori_app/db/tables/cards.dart' as i2;
import 'package:drift/src/runtime/query_builder/query_builder.dart' as i3;

class $CardsTable extends i2.Cards with i0.TableInfo<$CardsTable, i1.Card> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<String> id = i0.GeneratedColumn<String>(
      'id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'REFERENCES sync_entities (id)'));
  static const i0.VerificationMeta _deckIdMeta =
      const i0.VerificationMeta('deckId');
  @override
  late final i0.GeneratedColumn<String> deckId = i0.GeneratedColumn<String>(
      'deck_id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          i0.GeneratedColumn.constraintIsAlways('REFERENCES deck (id)'));
  static const i0.VerificationMeta _frontMeta =
      const i0.VerificationMeta('front');
  @override
  late final i0.GeneratedColumn<String> front = i0.GeneratedColumn<String>(
      'front', aliasedName, false,
      type: i0.DriftSqlType.string, requiredDuringInsert: true);
  static const i0.VerificationMeta _backMeta =
      const i0.VerificationMeta('back');
  @override
  late final i0.GeneratedColumn<String> back = i0.GeneratedColumn<String>(
      'back', aliasedName, false,
      type: i0.DriftSqlType.string, requiredDuringInsert: true);
  static const i0.VerificationMeta _frontPlainTextMeta =
      const i0.VerificationMeta('frontPlainText');
  @override
  late final i0.GeneratedColumn<String> frontPlainText =
      i0.GeneratedColumn<String>('front_plain_text', aliasedName, false,
          type: i0.DriftSqlType.string, requiredDuringInsert: true);
  static const i0.VerificationMeta _backPlainTextMeta =
      const i0.VerificationMeta('backPlainText');
  @override
  late final i0.GeneratedColumn<String> backPlainText =
      i0.GeneratedColumn<String>('back_plain_text', aliasedName, false,
          type: i0.DriftSqlType.string, requiredDuringInsert: true);
  static const i0.VerificationMeta _explanationMeta =
      const i0.VerificationMeta('explanation');
  @override
  late final i0.GeneratedColumn<String> explanation =
      i0.GeneratedColumn<String>('explanation', aliasedName, false,
          type: i0.DriftSqlType.string, requiredDuringInsert: true);
  static const i0.VerificationMeta _displayOrderMeta =
      const i0.VerificationMeta('displayOrder');
  @override
  late final i0.GeneratedColumn<int> displayOrder = i0.GeneratedColumn<int>(
      'display_order', aliasedName, false,
      type: i0.DriftSqlType.int, requiredDuringInsert: true);
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
  static const i0.VerificationMeta _isSuspendedMeta =
      const i0.VerificationMeta('isSuspended');
  @override
  late final i0.GeneratedColumn<bool> isSuspended = i0.GeneratedColumn<bool>(
      'is_suspended', aliasedName, false,
      type: i0.DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'CHECK ("is_suspended" IN (0, 1))'));
  static const i0.VerificationMeta _dueMeta = const i0.VerificationMeta('due');
  @override
  late final i0.GeneratedColumn<DateTime> due = i0.GeneratedColumn<DateTime>(
      'due', aliasedName, false,
      type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _actualDueMeta =
      const i0.VerificationMeta('actualDue');
  @override
  late final i0.GeneratedColumn<DateTime> actualDue =
      i0.GeneratedColumn<DateTime>('actual_due', aliasedName, false,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _lastReviewMeta =
      const i0.VerificationMeta('lastReview');
  @override
  late final i0.GeneratedColumn<DateTime> lastReview =
      i0.GeneratedColumn<DateTime>('last_review', aliasedName, false,
          type: i0.DriftSqlType.dateTime, requiredDuringInsert: true);
  static const i0.VerificationMeta _stateMeta =
      const i0.VerificationMeta('state');
  @override
  late final i0.GeneratedColumn<int> state = i0.GeneratedColumn<int>(
      'state', aliasedName, false,
      check: () => state.isBetween(const i3.Constant(0), const i3.Constant(3)),
      type: i0.DriftSqlType.int,
      requiredDuringInsert: true);
  @override
  List<i0.GeneratedColumn> get $columns => [
        id,
        deckId,
        front,
        back,
        frontPlainText,
        backPlainText,
        explanation,
        displayOrder,
        lapses,
        reps,
        elapsedDays,
        scheduledDays,
        difficulty,
        stability,
        isSuspended,
        due,
        actualDue,
        lastReview,
        state
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards';
  @override
  i0.VerificationContext validateIntegrity(i0.Insertable<i1.Card> instance,
      {bool isInserting = false}) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('deck_id')) {
      context.handle(_deckIdMeta,
          deckId.isAcceptableOrUnknown(data['deck_id']!, _deckIdMeta));
    } else if (isInserting) {
      context.missing(_deckIdMeta);
    }
    if (data.containsKey('front')) {
      context.handle(
          _frontMeta, front.isAcceptableOrUnknown(data['front']!, _frontMeta));
    } else if (isInserting) {
      context.missing(_frontMeta);
    }
    if (data.containsKey('back')) {
      context.handle(
          _backMeta, back.isAcceptableOrUnknown(data['back']!, _backMeta));
    } else if (isInserting) {
      context.missing(_backMeta);
    }
    if (data.containsKey('front_plain_text')) {
      context.handle(
          _frontPlainTextMeta,
          frontPlainText.isAcceptableOrUnknown(
              data['front_plain_text']!, _frontPlainTextMeta));
    } else if (isInserting) {
      context.missing(_frontPlainTextMeta);
    }
    if (data.containsKey('back_plain_text')) {
      context.handle(
          _backPlainTextMeta,
          backPlainText.isAcceptableOrUnknown(
              data['back_plain_text']!, _backPlainTextMeta));
    } else if (isInserting) {
      context.missing(_backPlainTextMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
          _explanationMeta,
          explanation.isAcceptableOrUnknown(
              data['explanation']!, _explanationMeta));
    } else if (isInserting) {
      context.missing(_explanationMeta);
    }
    if (data.containsKey('display_order')) {
      context.handle(
          _displayOrderMeta,
          displayOrder.isAcceptableOrUnknown(
              data['display_order']!, _displayOrderMeta));
    } else if (isInserting) {
      context.missing(_displayOrderMeta);
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
    if (data.containsKey('is_suspended')) {
      context.handle(
          _isSuspendedMeta,
          isSuspended.isAcceptableOrUnknown(
              data['is_suspended']!, _isSuspendedMeta));
    } else if (isInserting) {
      context.missing(_isSuspendedMeta);
    }
    if (data.containsKey('due')) {
      context.handle(
          _dueMeta, due.isAcceptableOrUnknown(data['due']!, _dueMeta));
    } else if (isInserting) {
      context.missing(_dueMeta);
    }
    if (data.containsKey('actual_due')) {
      context.handle(_actualDueMeta,
          actualDue.isAcceptableOrUnknown(data['actual_due']!, _actualDueMeta));
    } else if (isInserting) {
      context.missing(_actualDueMeta);
    }
    if (data.containsKey('last_review')) {
      context.handle(
          _lastReviewMeta,
          lastReview.isAcceptableOrUnknown(
              data['last_review']!, _lastReviewMeta));
    } else if (isInserting) {
      context.missing(_lastReviewMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
          _stateMeta, state.isAcceptableOrUnknown(data['state']!, _stateMeta));
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.Card map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.Card(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}id'])!,
      deckId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}deck_id'])!,
      front: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}front'])!,
      back: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}back'])!,
      frontPlainText: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string, data['${effectivePrefix}front_plain_text'])!,
      backPlainText: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string, data['${effectivePrefix}back_plain_text'])!,
      explanation: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}explanation'])!,
      displayOrder: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}display_order'])!,
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
      isSuspended: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.bool, data['${effectivePrefix}is_suspended'])!,
      due: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.dateTime, data['${effectivePrefix}due'])!,
      actualDue: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime, data['${effectivePrefix}actual_due'])!,
      lastReview: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.dateTime, data['${effectivePrefix}last_review'])!,
      state: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}state'])!,
    );
  }

  @override
  $CardsTable createAlias(String alias) {
    return $CardsTable(attachedDatabase, alias);
  }
}

class Card extends i0.DataClass implements i0.Insertable<i1.Card> {
  final String id;
  final String deckId;
  final String front;
  final String back;
  final String frontPlainText;
  final String backPlainText;
  final String explanation;
  final int displayOrder;
  final int lapses;
  final int reps;
  final int elapsedDays;
  final int scheduledDays;
  final double difficulty;
  final double stability;
  final bool isSuspended;
  final DateTime due;
  final DateTime actualDue;
  final DateTime lastReview;
  final int state;
  const Card(
      {required this.id,
      required this.deckId,
      required this.front,
      required this.back,
      required this.frontPlainText,
      required this.backPlainText,
      required this.explanation,
      required this.displayOrder,
      required this.lapses,
      required this.reps,
      required this.elapsedDays,
      required this.scheduledDays,
      required this.difficulty,
      required this.stability,
      required this.isSuspended,
      required this.due,
      required this.actualDue,
      required this.lastReview,
      required this.state});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<String>(id);
    map['deck_id'] = i0.Variable<String>(deckId);
    map['front'] = i0.Variable<String>(front);
    map['back'] = i0.Variable<String>(back);
    map['front_plain_text'] = i0.Variable<String>(frontPlainText);
    map['back_plain_text'] = i0.Variable<String>(backPlainText);
    map['explanation'] = i0.Variable<String>(explanation);
    map['display_order'] = i0.Variable<int>(displayOrder);
    map['lapses'] = i0.Variable<int>(lapses);
    map['reps'] = i0.Variable<int>(reps);
    map['elapsed_days'] = i0.Variable<int>(elapsedDays);
    map['scheduled_days'] = i0.Variable<int>(scheduledDays);
    map['difficulty'] = i0.Variable<double>(difficulty);
    map['stability'] = i0.Variable<double>(stability);
    map['is_suspended'] = i0.Variable<bool>(isSuspended);
    map['due'] = i0.Variable<DateTime>(due);
    map['actual_due'] = i0.Variable<DateTime>(actualDue);
    map['last_review'] = i0.Variable<DateTime>(lastReview);
    map['state'] = i0.Variable<int>(state);
    return map;
  }

  i1.CardsCompanion toCompanion(bool nullToAbsent) {
    return i1.CardsCompanion(
      id: i0.Value(id),
      deckId: i0.Value(deckId),
      front: i0.Value(front),
      back: i0.Value(back),
      frontPlainText: i0.Value(frontPlainText),
      backPlainText: i0.Value(backPlainText),
      explanation: i0.Value(explanation),
      displayOrder: i0.Value(displayOrder),
      lapses: i0.Value(lapses),
      reps: i0.Value(reps),
      elapsedDays: i0.Value(elapsedDays),
      scheduledDays: i0.Value(scheduledDays),
      difficulty: i0.Value(difficulty),
      stability: i0.Value(stability),
      isSuspended: i0.Value(isSuspended),
      due: i0.Value(due),
      actualDue: i0.Value(actualDue),
      lastReview: i0.Value(lastReview),
      state: i0.Value(state),
    );
  }

  factory Card.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return Card(
      id: serializer.fromJson<String>(json['id']),
      deckId: serializer.fromJson<String>(json['deckId']),
      front: serializer.fromJson<String>(json['front']),
      back: serializer.fromJson<String>(json['back']),
      frontPlainText: serializer.fromJson<String>(json['frontPlainText']),
      backPlainText: serializer.fromJson<String>(json['backPlainText']),
      explanation: serializer.fromJson<String>(json['explanation']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      lapses: serializer.fromJson<int>(json['lapses']),
      reps: serializer.fromJson<int>(json['reps']),
      elapsedDays: serializer.fromJson<int>(json['elapsedDays']),
      scheduledDays: serializer.fromJson<int>(json['scheduledDays']),
      difficulty: serializer.fromJson<double>(json['difficulty']),
      stability: serializer.fromJson<double>(json['stability']),
      isSuspended: serializer.fromJson<bool>(json['isSuspended']),
      due: serializer.fromJson<DateTime>(json['due']),
      actualDue: serializer.fromJson<DateTime>(json['actualDue']),
      lastReview: serializer.fromJson<DateTime>(json['lastReview']),
      state: serializer.fromJson<int>(json['state']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deckId': serializer.toJson<String>(deckId),
      'front': serializer.toJson<String>(front),
      'back': serializer.toJson<String>(back),
      'frontPlainText': serializer.toJson<String>(frontPlainText),
      'backPlainText': serializer.toJson<String>(backPlainText),
      'explanation': serializer.toJson<String>(explanation),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'lapses': serializer.toJson<int>(lapses),
      'reps': serializer.toJson<int>(reps),
      'elapsedDays': serializer.toJson<int>(elapsedDays),
      'scheduledDays': serializer.toJson<int>(scheduledDays),
      'difficulty': serializer.toJson<double>(difficulty),
      'stability': serializer.toJson<double>(stability),
      'isSuspended': serializer.toJson<bool>(isSuspended),
      'due': serializer.toJson<DateTime>(due),
      'actualDue': serializer.toJson<DateTime>(actualDue),
      'lastReview': serializer.toJson<DateTime>(lastReview),
      'state': serializer.toJson<int>(state),
    };
  }

  i1.Card copyWith(
          {String? id,
          String? deckId,
          String? front,
          String? back,
          String? frontPlainText,
          String? backPlainText,
          String? explanation,
          int? displayOrder,
          int? lapses,
          int? reps,
          int? elapsedDays,
          int? scheduledDays,
          double? difficulty,
          double? stability,
          bool? isSuspended,
          DateTime? due,
          DateTime? actualDue,
          DateTime? lastReview,
          int? state}) =>
      i1.Card(
        id: id ?? this.id,
        deckId: deckId ?? this.deckId,
        front: front ?? this.front,
        back: back ?? this.back,
        frontPlainText: frontPlainText ?? this.frontPlainText,
        backPlainText: backPlainText ?? this.backPlainText,
        explanation: explanation ?? this.explanation,
        displayOrder: displayOrder ?? this.displayOrder,
        lapses: lapses ?? this.lapses,
        reps: reps ?? this.reps,
        elapsedDays: elapsedDays ?? this.elapsedDays,
        scheduledDays: scheduledDays ?? this.scheduledDays,
        difficulty: difficulty ?? this.difficulty,
        stability: stability ?? this.stability,
        isSuspended: isSuspended ?? this.isSuspended,
        due: due ?? this.due,
        actualDue: actualDue ?? this.actualDue,
        lastReview: lastReview ?? this.lastReview,
        state: state ?? this.state,
      );
  @override
  String toString() {
    return (StringBuffer('Card(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('front: $front, ')
          ..write('back: $back, ')
          ..write('frontPlainText: $frontPlainText, ')
          ..write('backPlainText: $backPlainText, ')
          ..write('explanation: $explanation, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('lapses: $lapses, ')
          ..write('reps: $reps, ')
          ..write('elapsedDays: $elapsedDays, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('difficulty: $difficulty, ')
          ..write('stability: $stability, ')
          ..write('isSuspended: $isSuspended, ')
          ..write('due: $due, ')
          ..write('actualDue: $actualDue, ')
          ..write('lastReview: $lastReview, ')
          ..write('state: $state')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      deckId,
      front,
      back,
      frontPlainText,
      backPlainText,
      explanation,
      displayOrder,
      lapses,
      reps,
      elapsedDays,
      scheduledDays,
      difficulty,
      stability,
      isSuspended,
      due,
      actualDue,
      lastReview,
      state);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.Card &&
          other.id == this.id &&
          other.deckId == this.deckId &&
          other.front == this.front &&
          other.back == this.back &&
          other.frontPlainText == this.frontPlainText &&
          other.backPlainText == this.backPlainText &&
          other.explanation == this.explanation &&
          other.displayOrder == this.displayOrder &&
          other.lapses == this.lapses &&
          other.reps == this.reps &&
          other.elapsedDays == this.elapsedDays &&
          other.scheduledDays == this.scheduledDays &&
          other.difficulty == this.difficulty &&
          other.stability == this.stability &&
          other.isSuspended == this.isSuspended &&
          other.due == this.due &&
          other.actualDue == this.actualDue &&
          other.lastReview == this.lastReview &&
          other.state == this.state);
}

class CardsCompanion extends i0.UpdateCompanion<i1.Card> {
  final i0.Value<String> id;
  final i0.Value<String> deckId;
  final i0.Value<String> front;
  final i0.Value<String> back;
  final i0.Value<String> frontPlainText;
  final i0.Value<String> backPlainText;
  final i0.Value<String> explanation;
  final i0.Value<int> displayOrder;
  final i0.Value<int> lapses;
  final i0.Value<int> reps;
  final i0.Value<int> elapsedDays;
  final i0.Value<int> scheduledDays;
  final i0.Value<double> difficulty;
  final i0.Value<double> stability;
  final i0.Value<bool> isSuspended;
  final i0.Value<DateTime> due;
  final i0.Value<DateTime> actualDue;
  final i0.Value<DateTime> lastReview;
  final i0.Value<int> state;
  final i0.Value<int> rowid;
  const CardsCompanion({
    this.id = const i0.Value.absent(),
    this.deckId = const i0.Value.absent(),
    this.front = const i0.Value.absent(),
    this.back = const i0.Value.absent(),
    this.frontPlainText = const i0.Value.absent(),
    this.backPlainText = const i0.Value.absent(),
    this.explanation = const i0.Value.absent(),
    this.displayOrder = const i0.Value.absent(),
    this.lapses = const i0.Value.absent(),
    this.reps = const i0.Value.absent(),
    this.elapsedDays = const i0.Value.absent(),
    this.scheduledDays = const i0.Value.absent(),
    this.difficulty = const i0.Value.absent(),
    this.stability = const i0.Value.absent(),
    this.isSuspended = const i0.Value.absent(),
    this.due = const i0.Value.absent(),
    this.actualDue = const i0.Value.absent(),
    this.lastReview = const i0.Value.absent(),
    this.state = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  CardsCompanion.insert({
    required String id,
    required String deckId,
    required String front,
    required String back,
    required String frontPlainText,
    required String backPlainText,
    required String explanation,
    required int displayOrder,
    required int lapses,
    required int reps,
    required int elapsedDays,
    required int scheduledDays,
    required double difficulty,
    required double stability,
    required bool isSuspended,
    required DateTime due,
    required DateTime actualDue,
    required DateTime lastReview,
    required int state,
    this.rowid = const i0.Value.absent(),
  })  : id = i0.Value(id),
        deckId = i0.Value(deckId),
        front = i0.Value(front),
        back = i0.Value(back),
        frontPlainText = i0.Value(frontPlainText),
        backPlainText = i0.Value(backPlainText),
        explanation = i0.Value(explanation),
        displayOrder = i0.Value(displayOrder),
        lapses = i0.Value(lapses),
        reps = i0.Value(reps),
        elapsedDays = i0.Value(elapsedDays),
        scheduledDays = i0.Value(scheduledDays),
        difficulty = i0.Value(difficulty),
        stability = i0.Value(stability),
        isSuspended = i0.Value(isSuspended),
        due = i0.Value(due),
        actualDue = i0.Value(actualDue),
        lastReview = i0.Value(lastReview),
        state = i0.Value(state);
  static i0.Insertable<i1.Card> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? deckId,
    i0.Expression<String>? front,
    i0.Expression<String>? back,
    i0.Expression<String>? frontPlainText,
    i0.Expression<String>? backPlainText,
    i0.Expression<String>? explanation,
    i0.Expression<int>? displayOrder,
    i0.Expression<int>? lapses,
    i0.Expression<int>? reps,
    i0.Expression<int>? elapsedDays,
    i0.Expression<int>? scheduledDays,
    i0.Expression<double>? difficulty,
    i0.Expression<double>? stability,
    i0.Expression<bool>? isSuspended,
    i0.Expression<DateTime>? due,
    i0.Expression<DateTime>? actualDue,
    i0.Expression<DateTime>? lastReview,
    i0.Expression<int>? state,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (deckId != null) 'deck_id': deckId,
      if (front != null) 'front': front,
      if (back != null) 'back': back,
      if (frontPlainText != null) 'front_plain_text': frontPlainText,
      if (backPlainText != null) 'back_plain_text': backPlainText,
      if (explanation != null) 'explanation': explanation,
      if (displayOrder != null) 'display_order': displayOrder,
      if (lapses != null) 'lapses': lapses,
      if (reps != null) 'reps': reps,
      if (elapsedDays != null) 'elapsed_days': elapsedDays,
      if (scheduledDays != null) 'scheduled_days': scheduledDays,
      if (difficulty != null) 'difficulty': difficulty,
      if (stability != null) 'stability': stability,
      if (isSuspended != null) 'is_suspended': isSuspended,
      if (due != null) 'due': due,
      if (actualDue != null) 'actual_due': actualDue,
      if (lastReview != null) 'last_review': lastReview,
      if (state != null) 'state': state,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.CardsCompanion copyWith(
      {i0.Value<String>? id,
      i0.Value<String>? deckId,
      i0.Value<String>? front,
      i0.Value<String>? back,
      i0.Value<String>? frontPlainText,
      i0.Value<String>? backPlainText,
      i0.Value<String>? explanation,
      i0.Value<int>? displayOrder,
      i0.Value<int>? lapses,
      i0.Value<int>? reps,
      i0.Value<int>? elapsedDays,
      i0.Value<int>? scheduledDays,
      i0.Value<double>? difficulty,
      i0.Value<double>? stability,
      i0.Value<bool>? isSuspended,
      i0.Value<DateTime>? due,
      i0.Value<DateTime>? actualDue,
      i0.Value<DateTime>? lastReview,
      i0.Value<int>? state,
      i0.Value<int>? rowid}) {
    return i1.CardsCompanion(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      front: front ?? this.front,
      back: back ?? this.back,
      frontPlainText: frontPlainText ?? this.frontPlainText,
      backPlainText: backPlainText ?? this.backPlainText,
      explanation: explanation ?? this.explanation,
      displayOrder: displayOrder ?? this.displayOrder,
      lapses: lapses ?? this.lapses,
      reps: reps ?? this.reps,
      elapsedDays: elapsedDays ?? this.elapsedDays,
      scheduledDays: scheduledDays ?? this.scheduledDays,
      difficulty: difficulty ?? this.difficulty,
      stability: stability ?? this.stability,
      isSuspended: isSuspended ?? this.isSuspended,
      due: due ?? this.due,
      actualDue: actualDue ?? this.actualDue,
      lastReview: lastReview ?? this.lastReview,
      state: state ?? this.state,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<String>(id.value);
    }
    if (deckId.present) {
      map['deck_id'] = i0.Variable<String>(deckId.value);
    }
    if (front.present) {
      map['front'] = i0.Variable<String>(front.value);
    }
    if (back.present) {
      map['back'] = i0.Variable<String>(back.value);
    }
    if (frontPlainText.present) {
      map['front_plain_text'] = i0.Variable<String>(frontPlainText.value);
    }
    if (backPlainText.present) {
      map['back_plain_text'] = i0.Variable<String>(backPlainText.value);
    }
    if (explanation.present) {
      map['explanation'] = i0.Variable<String>(explanation.value);
    }
    if (displayOrder.present) {
      map['display_order'] = i0.Variable<int>(displayOrder.value);
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
    if (isSuspended.present) {
      map['is_suspended'] = i0.Variable<bool>(isSuspended.value);
    }
    if (due.present) {
      map['due'] = i0.Variable<DateTime>(due.value);
    }
    if (actualDue.present) {
      map['actual_due'] = i0.Variable<DateTime>(actualDue.value);
    }
    if (lastReview.present) {
      map['last_review'] = i0.Variable<DateTime>(lastReview.value);
    }
    if (state.present) {
      map['state'] = i0.Variable<int>(state.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsCompanion(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('front: $front, ')
          ..write('back: $back, ')
          ..write('frontPlainText: $frontPlainText, ')
          ..write('backPlainText: $backPlainText, ')
          ..write('explanation: $explanation, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('lapses: $lapses, ')
          ..write('reps: $reps, ')
          ..write('elapsedDays: $elapsedDays, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('difficulty: $difficulty, ')
          ..write('stability: $stability, ')
          ..write('isSuspended: $isSuspended, ')
          ..write('due: $due, ')
          ..write('actualDue: $actualDue, ')
          ..write('lastReview: $lastReview, ')
          ..write('state: $state, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:memori_app/db/tables/deck_settings.drift.dart' as i1;
import 'package:memori_app/db/tables/deck_settings.dart' as i2;
import 'package:drift/src/runtime/query_builder/query_builder.dart' as i3;

class $DeckSettingsTable extends i2.DeckSettings
    with i0.TableInfo<$DeckSettingsTable, i1.DeckSetting> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeckSettingsTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<String> id = i0.GeneratedColumn<String>(
      'id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'REFERENCES sync_entities (id)'));
  static const i0.VerificationMeta _learningStepsMeta =
      const i0.VerificationMeta('learningSteps');
  @override
  late final i0.GeneratedColumn<String> learningSteps =
      i0.GeneratedColumn<String>('learning_steps', aliasedName, false,
          type: i0.DriftSqlType.string, requiredDuringInsert: true);
  static const i0.VerificationMeta _reLearningStepsMeta =
      const i0.VerificationMeta('reLearningSteps');
  @override
  late final i0.GeneratedColumn<String> reLearningSteps =
      i0.GeneratedColumn<String>('re_learning_steps', aliasedName, false,
          type: i0.DriftSqlType.string, requiredDuringInsert: true);
  static const i0.VerificationMeta _desiredRetentionMeta =
      const i0.VerificationMeta('desiredRetention');
  @override
  late final i0.GeneratedColumn<double> desiredRetention =
      i0.GeneratedColumn<double>('desired_retention', aliasedName, false,
          type: i0.DriftSqlType.double, requiredDuringInsert: true);
  static const i0.VerificationMeta _isDefaultMeta =
      const i0.VerificationMeta('isDefault');
  @override
  late final i0.GeneratedColumn<bool> isDefault = i0.GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: i0.DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'CHECK ("is_default" IN (0, 1))'));
  static const i0.VerificationMeta _maxNewCardsPerDayMeta =
      const i0.VerificationMeta('maxNewCardsPerDay');
  @override
  late final i0.GeneratedColumn<int> maxNewCardsPerDay =
      i0.GeneratedColumn<int>('max_new_cards_per_day', aliasedName, false,
          type: i0.DriftSqlType.int, requiredDuringInsert: true);
  static const i0.VerificationMeta _maxReviewPerDayMeta =
      const i0.VerificationMeta('maxReviewPerDay');
  @override
  late final i0.GeneratedColumn<int> maxReviewPerDay = i0.GeneratedColumn<int>(
      'max_review_per_day', aliasedName, false,
      type: i0.DriftSqlType.int, requiredDuringInsert: true);
  static const i0.VerificationMeta _maximumAnswerSecondsMeta =
      const i0.VerificationMeta('maximumAnswerSeconds');
  @override
  late final i0.GeneratedColumn<int> maximumAnswerSeconds =
      i0.GeneratedColumn<int>('maximum_answer_seconds', aliasedName, false,
          type: i0.DriftSqlType.int, requiredDuringInsert: true);
  static const i0.VerificationMeta _skipNewCardMeta =
      const i0.VerificationMeta('skipNewCard');
  @override
  late final i0.GeneratedColumn<bool> skipNewCard = i0.GeneratedColumn<bool>(
      'skip_new_card', aliasedName, false,
      type: i0.DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'CHECK ("skip_new_card" IN (0, 1))'));
  static const i0.VerificationMeta _skipLearningCardMeta =
      const i0.VerificationMeta('skipLearningCard');
  @override
  late final i0.GeneratedColumn<bool> skipLearningCard =
      i0.GeneratedColumn<bool>('skip_learning_card', aliasedName, false,
          type: i0.DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
              'CHECK ("skip_learning_card" IN (0, 1))'));
  static const i0.VerificationMeta _skipReviewCardMeta =
      const i0.VerificationMeta('skipReviewCard');
  @override
  late final i0.GeneratedColumn<bool> skipReviewCard = i0.GeneratedColumn<bool>(
      'skip_review_card', aliasedName, false,
      type: i0.DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'CHECK ("skip_review_card" IN (0, 1))'));
  static const i0.VerificationMeta _newPriorityMeta =
      const i0.VerificationMeta('newPriority');
  @override
  late final i0.GeneratedColumn<int> newPriority = i0.GeneratedColumn<int>(
      'new_priority', aliasedName, false,
      check: () =>
          newPriority.isBetween(const i3.Constant(1), const i3.Constant(4)),
      type: i0.DriftSqlType.int,
      requiredDuringInsert: true);
  static const i0.VerificationMeta _interdayPriorityMeta =
      const i0.VerificationMeta('interdayPriority');
  @override
  late final i0.GeneratedColumn<int> interdayPriority = i0.GeneratedColumn<int>(
      'interday_priority', aliasedName, false,
      check: () => interdayPriority.isBetween(
          const i3.Constant(1), const i3.Constant(4)),
      type: i0.DriftSqlType.int,
      requiredDuringInsert: true);
  static const i0.VerificationMeta _reviewPriorityMeta =
      const i0.VerificationMeta('reviewPriority');
  @override
  late final i0.GeneratedColumn<int> reviewPriority = i0.GeneratedColumn<int>(
      'review_priority', aliasedName, false,
      check: () =>
          reviewPriority.isBetween(const i3.Constant(1), const i3.Constant(4)),
      type: i0.DriftSqlType.int,
      requiredDuringInsert: true);
  @override
  List<i0.GeneratedColumn> get $columns => [
        id,
        learningSteps,
        reLearningSteps,
        desiredRetention,
        isDefault,
        maxNewCardsPerDay,
        maxReviewPerDay,
        maximumAnswerSeconds,
        skipNewCard,
        skipLearningCard,
        skipReviewCard,
        newPriority,
        interdayPriority,
        reviewPriority
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deck_settings';
  @override
  i0.VerificationContext validateIntegrity(
      i0.Insertable<i1.DeckSetting> instance,
      {bool isInserting = false}) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('learning_steps')) {
      context.handle(
          _learningStepsMeta,
          learningSteps.isAcceptableOrUnknown(
              data['learning_steps']!, _learningStepsMeta));
    } else if (isInserting) {
      context.missing(_learningStepsMeta);
    }
    if (data.containsKey('re_learning_steps')) {
      context.handle(
          _reLearningStepsMeta,
          reLearningSteps.isAcceptableOrUnknown(
              data['re_learning_steps']!, _reLearningStepsMeta));
    } else if (isInserting) {
      context.missing(_reLearningStepsMeta);
    }
    if (data.containsKey('desired_retention')) {
      context.handle(
          _desiredRetentionMeta,
          desiredRetention.isAcceptableOrUnknown(
              data['desired_retention']!, _desiredRetentionMeta));
    } else if (isInserting) {
      context.missing(_desiredRetentionMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    } else if (isInserting) {
      context.missing(_isDefaultMeta);
    }
    if (data.containsKey('max_new_cards_per_day')) {
      context.handle(
          _maxNewCardsPerDayMeta,
          maxNewCardsPerDay.isAcceptableOrUnknown(
              data['max_new_cards_per_day']!, _maxNewCardsPerDayMeta));
    } else if (isInserting) {
      context.missing(_maxNewCardsPerDayMeta);
    }
    if (data.containsKey('max_review_per_day')) {
      context.handle(
          _maxReviewPerDayMeta,
          maxReviewPerDay.isAcceptableOrUnknown(
              data['max_review_per_day']!, _maxReviewPerDayMeta));
    } else if (isInserting) {
      context.missing(_maxReviewPerDayMeta);
    }
    if (data.containsKey('maximum_answer_seconds')) {
      context.handle(
          _maximumAnswerSecondsMeta,
          maximumAnswerSeconds.isAcceptableOrUnknown(
              data['maximum_answer_seconds']!, _maximumAnswerSecondsMeta));
    } else if (isInserting) {
      context.missing(_maximumAnswerSecondsMeta);
    }
    if (data.containsKey('skip_new_card')) {
      context.handle(
          _skipNewCardMeta,
          skipNewCard.isAcceptableOrUnknown(
              data['skip_new_card']!, _skipNewCardMeta));
    } else if (isInserting) {
      context.missing(_skipNewCardMeta);
    }
    if (data.containsKey('skip_learning_card')) {
      context.handle(
          _skipLearningCardMeta,
          skipLearningCard.isAcceptableOrUnknown(
              data['skip_learning_card']!, _skipLearningCardMeta));
    } else if (isInserting) {
      context.missing(_skipLearningCardMeta);
    }
    if (data.containsKey('skip_review_card')) {
      context.handle(
          _skipReviewCardMeta,
          skipReviewCard.isAcceptableOrUnknown(
              data['skip_review_card']!, _skipReviewCardMeta));
    } else if (isInserting) {
      context.missing(_skipReviewCardMeta);
    }
    if (data.containsKey('new_priority')) {
      context.handle(
          _newPriorityMeta,
          newPriority.isAcceptableOrUnknown(
              data['new_priority']!, _newPriorityMeta));
    } else if (isInserting) {
      context.missing(_newPriorityMeta);
    }
    if (data.containsKey('interday_priority')) {
      context.handle(
          _interdayPriorityMeta,
          interdayPriority.isAcceptableOrUnknown(
              data['interday_priority']!, _interdayPriorityMeta));
    } else if (isInserting) {
      context.missing(_interdayPriorityMeta);
    }
    if (data.containsKey('review_priority')) {
      context.handle(
          _reviewPriorityMeta,
          reviewPriority.isAcceptableOrUnknown(
              data['review_priority']!, _reviewPriorityMeta));
    } else if (isInserting) {
      context.missing(_reviewPriorityMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.DeckSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.DeckSetting(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}id'])!,
      learningSteps: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string, data['${effectivePrefix}learning_steps'])!,
      reLearningSteps: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string, data['${effectivePrefix}re_learning_steps'])!,
      desiredRetention: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.double, data['${effectivePrefix}desired_retention'])!,
      isDefault: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      maxNewCardsPerDay: attachedDatabase.typeMapping.read(i0.DriftSqlType.int,
          data['${effectivePrefix}max_new_cards_per_day'])!,
      maxReviewPerDay: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.int, data['${effectivePrefix}max_review_per_day'])!,
      maximumAnswerSeconds: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.int,
          data['${effectivePrefix}maximum_answer_seconds'])!,
      skipNewCard: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.bool, data['${effectivePrefix}skip_new_card'])!,
      skipLearningCard: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.bool, data['${effectivePrefix}skip_learning_card'])!,
      skipReviewCard: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.bool, data['${effectivePrefix}skip_review_card'])!,
      newPriority: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}new_priority'])!,
      interdayPriority: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.int, data['${effectivePrefix}interday_priority'])!,
      reviewPriority: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.int, data['${effectivePrefix}review_priority'])!,
    );
  }

  @override
  $DeckSettingsTable createAlias(String alias) {
    return $DeckSettingsTable(attachedDatabase, alias);
  }
}

class DeckSetting extends i0.DataClass
    implements i0.Insertable<i1.DeckSetting> {
  final String id;
  final String learningSteps;
  final String reLearningSteps;
  final double desiredRetention;
  final bool isDefault;
  final int maxNewCardsPerDay;
  final int maxReviewPerDay;
  final int maximumAnswerSeconds;
  final bool skipNewCard;
  final bool skipLearningCard;
  final bool skipReviewCard;
  final int newPriority;
  final int interdayPriority;
  final int reviewPriority;
  const DeckSetting(
      {required this.id,
      required this.learningSteps,
      required this.reLearningSteps,
      required this.desiredRetention,
      required this.isDefault,
      required this.maxNewCardsPerDay,
      required this.maxReviewPerDay,
      required this.maximumAnswerSeconds,
      required this.skipNewCard,
      required this.skipLearningCard,
      required this.skipReviewCard,
      required this.newPriority,
      required this.interdayPriority,
      required this.reviewPriority});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<String>(id);
    map['learning_steps'] = i0.Variable<String>(learningSteps);
    map['re_learning_steps'] = i0.Variable<String>(reLearningSteps);
    map['desired_retention'] = i0.Variable<double>(desiredRetention);
    map['is_default'] = i0.Variable<bool>(isDefault);
    map['max_new_cards_per_day'] = i0.Variable<int>(maxNewCardsPerDay);
    map['max_review_per_day'] = i0.Variable<int>(maxReviewPerDay);
    map['maximum_answer_seconds'] = i0.Variable<int>(maximumAnswerSeconds);
    map['skip_new_card'] = i0.Variable<bool>(skipNewCard);
    map['skip_learning_card'] = i0.Variable<bool>(skipLearningCard);
    map['skip_review_card'] = i0.Variable<bool>(skipReviewCard);
    map['new_priority'] = i0.Variable<int>(newPriority);
    map['interday_priority'] = i0.Variable<int>(interdayPriority);
    map['review_priority'] = i0.Variable<int>(reviewPriority);
    return map;
  }

  i1.DeckSettingsCompanion toCompanion(bool nullToAbsent) {
    return i1.DeckSettingsCompanion(
      id: i0.Value(id),
      learningSteps: i0.Value(learningSteps),
      reLearningSteps: i0.Value(reLearningSteps),
      desiredRetention: i0.Value(desiredRetention),
      isDefault: i0.Value(isDefault),
      maxNewCardsPerDay: i0.Value(maxNewCardsPerDay),
      maxReviewPerDay: i0.Value(maxReviewPerDay),
      maximumAnswerSeconds: i0.Value(maximumAnswerSeconds),
      skipNewCard: i0.Value(skipNewCard),
      skipLearningCard: i0.Value(skipLearningCard),
      skipReviewCard: i0.Value(skipReviewCard),
      newPriority: i0.Value(newPriority),
      interdayPriority: i0.Value(interdayPriority),
      reviewPriority: i0.Value(reviewPriority),
    );
  }

  factory DeckSetting.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return DeckSetting(
      id: serializer.fromJson<String>(json['id']),
      learningSteps: serializer.fromJson<String>(json['learningSteps']),
      reLearningSteps: serializer.fromJson<String>(json['reLearningSteps']),
      desiredRetention: serializer.fromJson<double>(json['desiredRetention']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      maxNewCardsPerDay: serializer.fromJson<int>(json['maxNewCardsPerDay']),
      maxReviewPerDay: serializer.fromJson<int>(json['maxReviewPerDay']),
      maximumAnswerSeconds:
          serializer.fromJson<int>(json['maximumAnswerSeconds']),
      skipNewCard: serializer.fromJson<bool>(json['skipNewCard']),
      skipLearningCard: serializer.fromJson<bool>(json['skipLearningCard']),
      skipReviewCard: serializer.fromJson<bool>(json['skipReviewCard']),
      newPriority: serializer.fromJson<int>(json['newPriority']),
      interdayPriority: serializer.fromJson<int>(json['interdayPriority']),
      reviewPriority: serializer.fromJson<int>(json['reviewPriority']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'learningSteps': serializer.toJson<String>(learningSteps),
      'reLearningSteps': serializer.toJson<String>(reLearningSteps),
      'desiredRetention': serializer.toJson<double>(desiredRetention),
      'isDefault': serializer.toJson<bool>(isDefault),
      'maxNewCardsPerDay': serializer.toJson<int>(maxNewCardsPerDay),
      'maxReviewPerDay': serializer.toJson<int>(maxReviewPerDay),
      'maximumAnswerSeconds': serializer.toJson<int>(maximumAnswerSeconds),
      'skipNewCard': serializer.toJson<bool>(skipNewCard),
      'skipLearningCard': serializer.toJson<bool>(skipLearningCard),
      'skipReviewCard': serializer.toJson<bool>(skipReviewCard),
      'newPriority': serializer.toJson<int>(newPriority),
      'interdayPriority': serializer.toJson<int>(interdayPriority),
      'reviewPriority': serializer.toJson<int>(reviewPriority),
    };
  }

  i1.DeckSetting copyWith(
          {String? id,
          String? learningSteps,
          String? reLearningSteps,
          double? desiredRetention,
          bool? isDefault,
          int? maxNewCardsPerDay,
          int? maxReviewPerDay,
          int? maximumAnswerSeconds,
          bool? skipNewCard,
          bool? skipLearningCard,
          bool? skipReviewCard,
          int? newPriority,
          int? interdayPriority,
          int? reviewPriority}) =>
      i1.DeckSetting(
        id: id ?? this.id,
        learningSteps: learningSteps ?? this.learningSteps,
        reLearningSteps: reLearningSteps ?? this.reLearningSteps,
        desiredRetention: desiredRetention ?? this.desiredRetention,
        isDefault: isDefault ?? this.isDefault,
        maxNewCardsPerDay: maxNewCardsPerDay ?? this.maxNewCardsPerDay,
        maxReviewPerDay: maxReviewPerDay ?? this.maxReviewPerDay,
        maximumAnswerSeconds: maximumAnswerSeconds ?? this.maximumAnswerSeconds,
        skipNewCard: skipNewCard ?? this.skipNewCard,
        skipLearningCard: skipLearningCard ?? this.skipLearningCard,
        skipReviewCard: skipReviewCard ?? this.skipReviewCard,
        newPriority: newPriority ?? this.newPriority,
        interdayPriority: interdayPriority ?? this.interdayPriority,
        reviewPriority: reviewPriority ?? this.reviewPriority,
      );
  @override
  String toString() {
    return (StringBuffer('DeckSetting(')
          ..write('id: $id, ')
          ..write('learningSteps: $learningSteps, ')
          ..write('reLearningSteps: $reLearningSteps, ')
          ..write('desiredRetention: $desiredRetention, ')
          ..write('isDefault: $isDefault, ')
          ..write('maxNewCardsPerDay: $maxNewCardsPerDay, ')
          ..write('maxReviewPerDay: $maxReviewPerDay, ')
          ..write('maximumAnswerSeconds: $maximumAnswerSeconds, ')
          ..write('skipNewCard: $skipNewCard, ')
          ..write('skipLearningCard: $skipLearningCard, ')
          ..write('skipReviewCard: $skipReviewCard, ')
          ..write('newPriority: $newPriority, ')
          ..write('interdayPriority: $interdayPriority, ')
          ..write('reviewPriority: $reviewPriority')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      learningSteps,
      reLearningSteps,
      desiredRetention,
      isDefault,
      maxNewCardsPerDay,
      maxReviewPerDay,
      maximumAnswerSeconds,
      skipNewCard,
      skipLearningCard,
      skipReviewCard,
      newPriority,
      interdayPriority,
      reviewPriority);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.DeckSetting &&
          other.id == this.id &&
          other.learningSteps == this.learningSteps &&
          other.reLearningSteps == this.reLearningSteps &&
          other.desiredRetention == this.desiredRetention &&
          other.isDefault == this.isDefault &&
          other.maxNewCardsPerDay == this.maxNewCardsPerDay &&
          other.maxReviewPerDay == this.maxReviewPerDay &&
          other.maximumAnswerSeconds == this.maximumAnswerSeconds &&
          other.skipNewCard == this.skipNewCard &&
          other.skipLearningCard == this.skipLearningCard &&
          other.skipReviewCard == this.skipReviewCard &&
          other.newPriority == this.newPriority &&
          other.interdayPriority == this.interdayPriority &&
          other.reviewPriority == this.reviewPriority);
}

class DeckSettingsCompanion extends i0.UpdateCompanion<i1.DeckSetting> {
  final i0.Value<String> id;
  final i0.Value<String> learningSteps;
  final i0.Value<String> reLearningSteps;
  final i0.Value<double> desiredRetention;
  final i0.Value<bool> isDefault;
  final i0.Value<int> maxNewCardsPerDay;
  final i0.Value<int> maxReviewPerDay;
  final i0.Value<int> maximumAnswerSeconds;
  final i0.Value<bool> skipNewCard;
  final i0.Value<bool> skipLearningCard;
  final i0.Value<bool> skipReviewCard;
  final i0.Value<int> newPriority;
  final i0.Value<int> interdayPriority;
  final i0.Value<int> reviewPriority;
  final i0.Value<int> rowid;
  const DeckSettingsCompanion({
    this.id = const i0.Value.absent(),
    this.learningSteps = const i0.Value.absent(),
    this.reLearningSteps = const i0.Value.absent(),
    this.desiredRetention = const i0.Value.absent(),
    this.isDefault = const i0.Value.absent(),
    this.maxNewCardsPerDay = const i0.Value.absent(),
    this.maxReviewPerDay = const i0.Value.absent(),
    this.maximumAnswerSeconds = const i0.Value.absent(),
    this.skipNewCard = const i0.Value.absent(),
    this.skipLearningCard = const i0.Value.absent(),
    this.skipReviewCard = const i0.Value.absent(),
    this.newPriority = const i0.Value.absent(),
    this.interdayPriority = const i0.Value.absent(),
    this.reviewPriority = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  DeckSettingsCompanion.insert({
    required String id,
    required String learningSteps,
    required String reLearningSteps,
    required double desiredRetention,
    required bool isDefault,
    required int maxNewCardsPerDay,
    required int maxReviewPerDay,
    required int maximumAnswerSeconds,
    required bool skipNewCard,
    required bool skipLearningCard,
    required bool skipReviewCard,
    required int newPriority,
    required int interdayPriority,
    required int reviewPriority,
    this.rowid = const i0.Value.absent(),
  })  : id = i0.Value(id),
        learningSteps = i0.Value(learningSteps),
        reLearningSteps = i0.Value(reLearningSteps),
        desiredRetention = i0.Value(desiredRetention),
        isDefault = i0.Value(isDefault),
        maxNewCardsPerDay = i0.Value(maxNewCardsPerDay),
        maxReviewPerDay = i0.Value(maxReviewPerDay),
        maximumAnswerSeconds = i0.Value(maximumAnswerSeconds),
        skipNewCard = i0.Value(skipNewCard),
        skipLearningCard = i0.Value(skipLearningCard),
        skipReviewCard = i0.Value(skipReviewCard),
        newPriority = i0.Value(newPriority),
        interdayPriority = i0.Value(interdayPriority),
        reviewPriority = i0.Value(reviewPriority);
  static i0.Insertable<i1.DeckSetting> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? learningSteps,
    i0.Expression<String>? reLearningSteps,
    i0.Expression<double>? desiredRetention,
    i0.Expression<bool>? isDefault,
    i0.Expression<int>? maxNewCardsPerDay,
    i0.Expression<int>? maxReviewPerDay,
    i0.Expression<int>? maximumAnswerSeconds,
    i0.Expression<bool>? skipNewCard,
    i0.Expression<bool>? skipLearningCard,
    i0.Expression<bool>? skipReviewCard,
    i0.Expression<int>? newPriority,
    i0.Expression<int>? interdayPriority,
    i0.Expression<int>? reviewPriority,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (learningSteps != null) 'learning_steps': learningSteps,
      if (reLearningSteps != null) 're_learning_steps': reLearningSteps,
      if (desiredRetention != null) 'desired_retention': desiredRetention,
      if (isDefault != null) 'is_default': isDefault,
      if (maxNewCardsPerDay != null) 'max_new_cards_per_day': maxNewCardsPerDay,
      if (maxReviewPerDay != null) 'max_review_per_day': maxReviewPerDay,
      if (maximumAnswerSeconds != null)
        'maximum_answer_seconds': maximumAnswerSeconds,
      if (skipNewCard != null) 'skip_new_card': skipNewCard,
      if (skipLearningCard != null) 'skip_learning_card': skipLearningCard,
      if (skipReviewCard != null) 'skip_review_card': skipReviewCard,
      if (newPriority != null) 'new_priority': newPriority,
      if (interdayPriority != null) 'interday_priority': interdayPriority,
      if (reviewPriority != null) 'review_priority': reviewPriority,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.DeckSettingsCompanion copyWith(
      {i0.Value<String>? id,
      i0.Value<String>? learningSteps,
      i0.Value<String>? reLearningSteps,
      i0.Value<double>? desiredRetention,
      i0.Value<bool>? isDefault,
      i0.Value<int>? maxNewCardsPerDay,
      i0.Value<int>? maxReviewPerDay,
      i0.Value<int>? maximumAnswerSeconds,
      i0.Value<bool>? skipNewCard,
      i0.Value<bool>? skipLearningCard,
      i0.Value<bool>? skipReviewCard,
      i0.Value<int>? newPriority,
      i0.Value<int>? interdayPriority,
      i0.Value<int>? reviewPriority,
      i0.Value<int>? rowid}) {
    return i1.DeckSettingsCompanion(
      id: id ?? this.id,
      learningSteps: learningSteps ?? this.learningSteps,
      reLearningSteps: reLearningSteps ?? this.reLearningSteps,
      desiredRetention: desiredRetention ?? this.desiredRetention,
      isDefault: isDefault ?? this.isDefault,
      maxNewCardsPerDay: maxNewCardsPerDay ?? this.maxNewCardsPerDay,
      maxReviewPerDay: maxReviewPerDay ?? this.maxReviewPerDay,
      maximumAnswerSeconds: maximumAnswerSeconds ?? this.maximumAnswerSeconds,
      skipNewCard: skipNewCard ?? this.skipNewCard,
      skipLearningCard: skipLearningCard ?? this.skipLearningCard,
      skipReviewCard: skipReviewCard ?? this.skipReviewCard,
      newPriority: newPriority ?? this.newPriority,
      interdayPriority: interdayPriority ?? this.interdayPriority,
      reviewPriority: reviewPriority ?? this.reviewPriority,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<String>(id.value);
    }
    if (learningSteps.present) {
      map['learning_steps'] = i0.Variable<String>(learningSteps.value);
    }
    if (reLearningSteps.present) {
      map['re_learning_steps'] = i0.Variable<String>(reLearningSteps.value);
    }
    if (desiredRetention.present) {
      map['desired_retention'] = i0.Variable<double>(desiredRetention.value);
    }
    if (isDefault.present) {
      map['is_default'] = i0.Variable<bool>(isDefault.value);
    }
    if (maxNewCardsPerDay.present) {
      map['max_new_cards_per_day'] = i0.Variable<int>(maxNewCardsPerDay.value);
    }
    if (maxReviewPerDay.present) {
      map['max_review_per_day'] = i0.Variable<int>(maxReviewPerDay.value);
    }
    if (maximumAnswerSeconds.present) {
      map['maximum_answer_seconds'] =
          i0.Variable<int>(maximumAnswerSeconds.value);
    }
    if (skipNewCard.present) {
      map['skip_new_card'] = i0.Variable<bool>(skipNewCard.value);
    }
    if (skipLearningCard.present) {
      map['skip_learning_card'] = i0.Variable<bool>(skipLearningCard.value);
    }
    if (skipReviewCard.present) {
      map['skip_review_card'] = i0.Variable<bool>(skipReviewCard.value);
    }
    if (newPriority.present) {
      map['new_priority'] = i0.Variable<int>(newPriority.value);
    }
    if (interdayPriority.present) {
      map['interday_priority'] = i0.Variable<int>(interdayPriority.value);
    }
    if (reviewPriority.present) {
      map['review_priority'] = i0.Variable<int>(reviewPriority.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeckSettingsCompanion(')
          ..write('id: $id, ')
          ..write('learningSteps: $learningSteps, ')
          ..write('reLearningSteps: $reLearningSteps, ')
          ..write('desiredRetention: $desiredRetention, ')
          ..write('isDefault: $isDefault, ')
          ..write('maxNewCardsPerDay: $maxNewCardsPerDay, ')
          ..write('maxReviewPerDay: $maxReviewPerDay, ')
          ..write('maximumAnswerSeconds: $maximumAnswerSeconds, ')
          ..write('skipNewCard: $skipNewCard, ')
          ..write('skipLearningCard: $skipLearningCard, ')
          ..write('skipReviewCard: $skipReviewCard, ')
          ..write('newPriority: $newPriority, ')
          ..write('interdayPriority: $interdayPriority, ')
          ..write('reviewPriority: $reviewPriority, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

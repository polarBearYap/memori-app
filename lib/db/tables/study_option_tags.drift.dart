// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:memori_app/db/tables/study_option_tags.drift.dart' as i1;
import 'package:memori_app/db/tables/study_option_tags.dart' as i2;

class $StudyOptionTagsTable extends i2.StudyOptionTags
    with i0.TableInfo<$StudyOptionTagsTable, i1.StudyOptionTag> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyOptionTagsTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<String> id = i0.GeneratedColumn<String>(
      'id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'REFERENCES sync_entities (id)'));
  static const i0.VerificationMeta _studyOptionIdMeta =
      const i0.VerificationMeta('studyOptionId');
  @override
  late final i0.GeneratedColumn<String> studyOptionId =
      i0.GeneratedColumn<String>('study_option_id', aliasedName, false,
          type: i0.DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
              'REFERENCES study_options (id)'));
  static const i0.VerificationMeta _cardTagIdMeta =
      const i0.VerificationMeta('cardTagId');
  @override
  late final i0.GeneratedColumn<String> cardTagId = i0.GeneratedColumn<String>(
      'card_tag_id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          i0.GeneratedColumn.constraintIsAlways('REFERENCES card_tags (id)'));
  @override
  List<i0.GeneratedColumn> get $columns => [id, studyOptionId, cardTagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_option_tags';
  @override
  i0.VerificationContext validateIntegrity(
      i0.Insertable<i1.StudyOptionTag> instance,
      {bool isInserting = false}) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('study_option_id')) {
      context.handle(
          _studyOptionIdMeta,
          studyOptionId.isAcceptableOrUnknown(
              data['study_option_id']!, _studyOptionIdMeta));
    } else if (isInserting) {
      context.missing(_studyOptionIdMeta);
    }
    if (data.containsKey('card_tag_id')) {
      context.handle(
          _cardTagIdMeta,
          cardTagId.isAcceptableOrUnknown(
              data['card_tag_id']!, _cardTagIdMeta));
    } else if (isInserting) {
      context.missing(_cardTagIdMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.StudyOptionTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.StudyOptionTag(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}id'])!,
      studyOptionId: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string, data['${effectivePrefix}study_option_id'])!,
      cardTagId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}card_tag_id'])!,
    );
  }

  @override
  $StudyOptionTagsTable createAlias(String alias) {
    return $StudyOptionTagsTable(attachedDatabase, alias);
  }
}

class StudyOptionTag extends i0.DataClass
    implements i0.Insertable<i1.StudyOptionTag> {
  final String id;
  final String studyOptionId;
  final String cardTagId;
  const StudyOptionTag(
      {required this.id, required this.studyOptionId, required this.cardTagId});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<String>(id);
    map['study_option_id'] = i0.Variable<String>(studyOptionId);
    map['card_tag_id'] = i0.Variable<String>(cardTagId);
    return map;
  }

  i1.StudyOptionTagsCompanion toCompanion(bool nullToAbsent) {
    return i1.StudyOptionTagsCompanion(
      id: i0.Value(id),
      studyOptionId: i0.Value(studyOptionId),
      cardTagId: i0.Value(cardTagId),
    );
  }

  factory StudyOptionTag.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return StudyOptionTag(
      id: serializer.fromJson<String>(json['id']),
      studyOptionId: serializer.fromJson<String>(json['studyOptionId']),
      cardTagId: serializer.fromJson<String>(json['cardTagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studyOptionId': serializer.toJson<String>(studyOptionId),
      'cardTagId': serializer.toJson<String>(cardTagId),
    };
  }

  i1.StudyOptionTag copyWith(
          {String? id, String? studyOptionId, String? cardTagId}) =>
      i1.StudyOptionTag(
        id: id ?? this.id,
        studyOptionId: studyOptionId ?? this.studyOptionId,
        cardTagId: cardTagId ?? this.cardTagId,
      );
  @override
  String toString() {
    return (StringBuffer('StudyOptionTag(')
          ..write('id: $id, ')
          ..write('studyOptionId: $studyOptionId, ')
          ..write('cardTagId: $cardTagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, studyOptionId, cardTagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.StudyOptionTag &&
          other.id == this.id &&
          other.studyOptionId == this.studyOptionId &&
          other.cardTagId == this.cardTagId);
}

class StudyOptionTagsCompanion extends i0.UpdateCompanion<i1.StudyOptionTag> {
  final i0.Value<String> id;
  final i0.Value<String> studyOptionId;
  final i0.Value<String> cardTagId;
  final i0.Value<int> rowid;
  const StudyOptionTagsCompanion({
    this.id = const i0.Value.absent(),
    this.studyOptionId = const i0.Value.absent(),
    this.cardTagId = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  StudyOptionTagsCompanion.insert({
    required String id,
    required String studyOptionId,
    required String cardTagId,
    this.rowid = const i0.Value.absent(),
  })  : id = i0.Value(id),
        studyOptionId = i0.Value(studyOptionId),
        cardTagId = i0.Value(cardTagId);
  static i0.Insertable<i1.StudyOptionTag> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? studyOptionId,
    i0.Expression<String>? cardTagId,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (studyOptionId != null) 'study_option_id': studyOptionId,
      if (cardTagId != null) 'card_tag_id': cardTagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.StudyOptionTagsCompanion copyWith(
      {i0.Value<String>? id,
      i0.Value<String>? studyOptionId,
      i0.Value<String>? cardTagId,
      i0.Value<int>? rowid}) {
    return i1.StudyOptionTagsCompanion(
      id: id ?? this.id,
      studyOptionId: studyOptionId ?? this.studyOptionId,
      cardTagId: cardTagId ?? this.cardTagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<String>(id.value);
    }
    if (studyOptionId.present) {
      map['study_option_id'] = i0.Variable<String>(studyOptionId.value);
    }
    if (cardTagId.present) {
      map['card_tag_id'] = i0.Variable<String>(cardTagId.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyOptionTagsCompanion(')
          ..write('id: $id, ')
          ..write('studyOptionId: $studyOptionId, ')
          ..write('cardTagId: $cardTagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

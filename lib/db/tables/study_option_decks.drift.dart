// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:memori_app/db/tables/study_option_decks.drift.dart' as i1;
import 'package:memori_app/db/tables/study_option_decks.dart' as i2;

class $StudyOptionDecksTable extends i2.StudyOptionDecks
    with i0.TableInfo<$StudyOptionDecksTable, i1.StudyOptionDeck> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyOptionDecksTable(this.attachedDatabase, [this._alias]);
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
  static const i0.VerificationMeta _deckIdMeta =
      const i0.VerificationMeta('deckId');
  @override
  late final i0.GeneratedColumn<String> deckId = i0.GeneratedColumn<String>(
      'deck_id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          i0.GeneratedColumn.constraintIsAlways('REFERENCES deck (id)'));
  @override
  List<i0.GeneratedColumn> get $columns => [id, studyOptionId, deckId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_option_decks';
  @override
  i0.VerificationContext validateIntegrity(
      i0.Insertable<i1.StudyOptionDeck> instance,
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
    if (data.containsKey('deck_id')) {
      context.handle(_deckIdMeta,
          deckId.isAcceptableOrUnknown(data['deck_id']!, _deckIdMeta));
    } else if (isInserting) {
      context.missing(_deckIdMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.StudyOptionDeck map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.StudyOptionDeck(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}id'])!,
      studyOptionId: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string, data['${effectivePrefix}study_option_id'])!,
      deckId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}deck_id'])!,
    );
  }

  @override
  $StudyOptionDecksTable createAlias(String alias) {
    return $StudyOptionDecksTable(attachedDatabase, alias);
  }
}

class StudyOptionDeck extends i0.DataClass
    implements i0.Insertable<i1.StudyOptionDeck> {
  final String id;
  final String studyOptionId;
  final String deckId;
  const StudyOptionDeck(
      {required this.id, required this.studyOptionId, required this.deckId});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<String>(id);
    map['study_option_id'] = i0.Variable<String>(studyOptionId);
    map['deck_id'] = i0.Variable<String>(deckId);
    return map;
  }

  i1.StudyOptionDecksCompanion toCompanion(bool nullToAbsent) {
    return i1.StudyOptionDecksCompanion(
      id: i0.Value(id),
      studyOptionId: i0.Value(studyOptionId),
      deckId: i0.Value(deckId),
    );
  }

  factory StudyOptionDeck.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return StudyOptionDeck(
      id: serializer.fromJson<String>(json['id']),
      studyOptionId: serializer.fromJson<String>(json['studyOptionId']),
      deckId: serializer.fromJson<String>(json['deckId']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studyOptionId': serializer.toJson<String>(studyOptionId),
      'deckId': serializer.toJson<String>(deckId),
    };
  }

  i1.StudyOptionDeck copyWith(
          {String? id, String? studyOptionId, String? deckId}) =>
      i1.StudyOptionDeck(
        id: id ?? this.id,
        studyOptionId: studyOptionId ?? this.studyOptionId,
        deckId: deckId ?? this.deckId,
      );
  @override
  String toString() {
    return (StringBuffer('StudyOptionDeck(')
          ..write('id: $id, ')
          ..write('studyOptionId: $studyOptionId, ')
          ..write('deckId: $deckId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, studyOptionId, deckId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.StudyOptionDeck &&
          other.id == this.id &&
          other.studyOptionId == this.studyOptionId &&
          other.deckId == this.deckId);
}

class StudyOptionDecksCompanion extends i0.UpdateCompanion<i1.StudyOptionDeck> {
  final i0.Value<String> id;
  final i0.Value<String> studyOptionId;
  final i0.Value<String> deckId;
  final i0.Value<int> rowid;
  const StudyOptionDecksCompanion({
    this.id = const i0.Value.absent(),
    this.studyOptionId = const i0.Value.absent(),
    this.deckId = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  StudyOptionDecksCompanion.insert({
    required String id,
    required String studyOptionId,
    required String deckId,
    this.rowid = const i0.Value.absent(),
  })  : id = i0.Value(id),
        studyOptionId = i0.Value(studyOptionId),
        deckId = i0.Value(deckId);
  static i0.Insertable<i1.StudyOptionDeck> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? studyOptionId,
    i0.Expression<String>? deckId,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (studyOptionId != null) 'study_option_id': studyOptionId,
      if (deckId != null) 'deck_id': deckId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.StudyOptionDecksCompanion copyWith(
      {i0.Value<String>? id,
      i0.Value<String>? studyOptionId,
      i0.Value<String>? deckId,
      i0.Value<int>? rowid}) {
    return i1.StudyOptionDecksCompanion(
      id: id ?? this.id,
      studyOptionId: studyOptionId ?? this.studyOptionId,
      deckId: deckId ?? this.deckId,
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
    if (deckId.present) {
      map['deck_id'] = i0.Variable<String>(deckId.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyOptionDecksCompanion(')
          ..write('id: $id, ')
          ..write('studyOptionId: $studyOptionId, ')
          ..write('deckId: $deckId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

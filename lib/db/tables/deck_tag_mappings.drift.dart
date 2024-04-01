// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:memori_app/db/tables/deck_tag_mappings.drift.dart' as i1;
import 'package:memori_app/db/tables/deck_tag_mappings.dart' as i2;

class $DeckTagMappingsTable extends i2.DeckTagMappings
    with i0.TableInfo<$DeckTagMappingsTable, i1.DeckTagMapping> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeckTagMappingsTable(this.attachedDatabase, [this._alias]);
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
  static const i0.VerificationMeta _deckTagIdMeta =
      const i0.VerificationMeta('deckTagId');
  @override
  late final i0.GeneratedColumn<String> deckTagId = i0.GeneratedColumn<String>(
      'deck_tag_id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          i0.GeneratedColumn.constraintIsAlways('REFERENCES deck_tags (id)'));
  @override
  List<i0.GeneratedColumn> get $columns => [id, deckId, deckTagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deck_tag_mappings';
  @override
  i0.VerificationContext validateIntegrity(
      i0.Insertable<i1.DeckTagMapping> instance,
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
    if (data.containsKey('deck_tag_id')) {
      context.handle(
          _deckTagIdMeta,
          deckTagId.isAcceptableOrUnknown(
              data['deck_tag_id']!, _deckTagIdMeta));
    } else if (isInserting) {
      context.missing(_deckTagIdMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.DeckTagMapping map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.DeckTagMapping(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}id'])!,
      deckId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}deck_id'])!,
      deckTagId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}deck_tag_id'])!,
    );
  }

  @override
  $DeckTagMappingsTable createAlias(String alias) {
    return $DeckTagMappingsTable(attachedDatabase, alias);
  }
}

class DeckTagMapping extends i0.DataClass
    implements i0.Insertable<i1.DeckTagMapping> {
  final String id;
  final String deckId;
  final String deckTagId;
  const DeckTagMapping(
      {required this.id, required this.deckId, required this.deckTagId});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<String>(id);
    map['deck_id'] = i0.Variable<String>(deckId);
    map['deck_tag_id'] = i0.Variable<String>(deckTagId);
    return map;
  }

  i1.DeckTagMappingsCompanion toCompanion(bool nullToAbsent) {
    return i1.DeckTagMappingsCompanion(
      id: i0.Value(id),
      deckId: i0.Value(deckId),
      deckTagId: i0.Value(deckTagId),
    );
  }

  factory DeckTagMapping.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return DeckTagMapping(
      id: serializer.fromJson<String>(json['id']),
      deckId: serializer.fromJson<String>(json['deckId']),
      deckTagId: serializer.fromJson<String>(json['deckTagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deckId': serializer.toJson<String>(deckId),
      'deckTagId': serializer.toJson<String>(deckTagId),
    };
  }

  i1.DeckTagMapping copyWith({String? id, String? deckId, String? deckTagId}) =>
      i1.DeckTagMapping(
        id: id ?? this.id,
        deckId: deckId ?? this.deckId,
        deckTagId: deckTagId ?? this.deckTagId,
      );
  @override
  String toString() {
    return (StringBuffer('DeckTagMapping(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('deckTagId: $deckTagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, deckId, deckTagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.DeckTagMapping &&
          other.id == this.id &&
          other.deckId == this.deckId &&
          other.deckTagId == this.deckTagId);
}

class DeckTagMappingsCompanion extends i0.UpdateCompanion<i1.DeckTagMapping> {
  final i0.Value<String> id;
  final i0.Value<String> deckId;
  final i0.Value<String> deckTagId;
  final i0.Value<int> rowid;
  const DeckTagMappingsCompanion({
    this.id = const i0.Value.absent(),
    this.deckId = const i0.Value.absent(),
    this.deckTagId = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  DeckTagMappingsCompanion.insert({
    required String id,
    required String deckId,
    required String deckTagId,
    this.rowid = const i0.Value.absent(),
  })  : id = i0.Value(id),
        deckId = i0.Value(deckId),
        deckTagId = i0.Value(deckTagId);
  static i0.Insertable<i1.DeckTagMapping> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? deckId,
    i0.Expression<String>? deckTagId,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (deckId != null) 'deck_id': deckId,
      if (deckTagId != null) 'deck_tag_id': deckTagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.DeckTagMappingsCompanion copyWith(
      {i0.Value<String>? id,
      i0.Value<String>? deckId,
      i0.Value<String>? deckTagId,
      i0.Value<int>? rowid}) {
    return i1.DeckTagMappingsCompanion(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      deckTagId: deckTagId ?? this.deckTagId,
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
    if (deckTagId.present) {
      map['deck_tag_id'] = i0.Variable<String>(deckTagId.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeckTagMappingsCompanion(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('deckTagId: $deckTagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

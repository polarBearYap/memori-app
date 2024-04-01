// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:memori_app/db/tables/deck_tags.drift.dart' as i1;
import 'package:memori_app/db/tables/deck_tags.dart' as i2;

class $DeckTagsTable extends i2.DeckTags
    with i0.TableInfo<$DeckTagsTable, i1.DeckTag> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeckTagsTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<String> id = i0.GeneratedColumn<String>(
      'id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'REFERENCES sync_entities (id)'));
  static const i0.VerificationMeta _nameMeta =
      const i0.VerificationMeta('name');
  @override
  late final i0.GeneratedColumn<String> name = i0.GeneratedColumn<String>(
      'name', aliasedName, false,
      type: i0.DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<i0.GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deck_tags';
  @override
  i0.VerificationContext validateIntegrity(i0.Insertable<i1.DeckTag> instance,
      {bool isInserting = false}) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.DeckTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.DeckTag(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $DeckTagsTable createAlias(String alias) {
    return $DeckTagsTable(attachedDatabase, alias);
  }
}

class DeckTag extends i0.DataClass implements i0.Insertable<i1.DeckTag> {
  final String id;
  final String name;
  const DeckTag({required this.id, required this.name});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<String>(id);
    map['name'] = i0.Variable<String>(name);
    return map;
  }

  i1.DeckTagsCompanion toCompanion(bool nullToAbsent) {
    return i1.DeckTagsCompanion(
      id: i0.Value(id),
      name: i0.Value(name),
    );
  }

  factory DeckTag.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return DeckTag(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  i1.DeckTag copyWith({String? id, String? name}) => i1.DeckTag(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('DeckTag(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.DeckTag && other.id == this.id && other.name == this.name);
}

class DeckTagsCompanion extends i0.UpdateCompanion<i1.DeckTag> {
  final i0.Value<String> id;
  final i0.Value<String> name;
  final i0.Value<int> rowid;
  const DeckTagsCompanion({
    this.id = const i0.Value.absent(),
    this.name = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  DeckTagsCompanion.insert({
    required String id,
    required String name,
    this.rowid = const i0.Value.absent(),
  })  : id = i0.Value(id),
        name = i0.Value(name);
  static i0.Insertable<i1.DeckTag> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? name,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.DeckTagsCompanion copyWith(
      {i0.Value<String>? id, i0.Value<String>? name, i0.Value<int>? rowid}) {
    return i1.DeckTagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = i0.Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeckTagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

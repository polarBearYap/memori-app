// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:memori_app/db/tables/conflicted_rows.drift.dart' as i1;
import 'package:memori_app/db/tables/conflicted_rows.dart' as i2;
import 'package:drift/src/runtime/query_builder/query_builder.dart' as i3;

class $ConflictedRowsTable extends i2.ConflictedRows
    with i0.TableInfo<$ConflictedRowsTable, i1.ConflictedRow> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConflictedRowsTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<String> id = i0.GeneratedColumn<String>(
      'id', aliasedName, false,
      type: i0.DriftSqlType.string, requiredDuringInsert: true);
  static const i0.VerificationMeta _sourceMeta =
      const i0.VerificationMeta('source');
  @override
  late final i0.GeneratedColumn<int> source = i0.GeneratedColumn<int>(
      'source', aliasedName, false,
      check: () => source.isBetween(const i3.Constant(1), const i3.Constant(2)),
      type: i0.DriftSqlType.int,
      requiredDuringInsert: true);
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
  List<i0.GeneratedColumn> get $columns => [id, source, userId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conflicted_rows';
  @override
  i0.VerificationContext validateIntegrity(
      i0.Insertable<i1.ConflictedRow> instance,
      {bool isInserting = false}) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
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
  i1.ConflictedRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.ConflictedRow(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}id'])!,
      source: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}source'])!,
      userId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}user_id'])!,
    );
  }

  @override
  $ConflictedRowsTable createAlias(String alias) {
    return $ConflictedRowsTable(attachedDatabase, alias);
  }
}

class ConflictedRow extends i0.DataClass
    implements i0.Insertable<i1.ConflictedRow> {
  final String id;
  final int source;
  final String userId;
  const ConflictedRow(
      {required this.id, required this.source, required this.userId});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<String>(id);
    map['source'] = i0.Variable<int>(source);
    map['user_id'] = i0.Variable<String>(userId);
    return map;
  }

  i1.ConflictedRowsCompanion toCompanion(bool nullToAbsent) {
    return i1.ConflictedRowsCompanion(
      id: i0.Value(id),
      source: i0.Value(source),
      userId: i0.Value(userId),
    );
  }

  factory ConflictedRow.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return ConflictedRow(
      id: serializer.fromJson<String>(json['id']),
      source: serializer.fromJson<int>(json['source']),
      userId: serializer.fromJson<String>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'source': serializer.toJson<int>(source),
      'userId': serializer.toJson<String>(userId),
    };
  }

  i1.ConflictedRow copyWith({String? id, int? source, String? userId}) =>
      i1.ConflictedRow(
        id: id ?? this.id,
        source: source ?? this.source,
        userId: userId ?? this.userId,
      );
  @override
  String toString() {
    return (StringBuffer('ConflictedRow(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, source, userId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.ConflictedRow &&
          other.id == this.id &&
          other.source == this.source &&
          other.userId == this.userId);
}

class ConflictedRowsCompanion extends i0.UpdateCompanion<i1.ConflictedRow> {
  final i0.Value<String> id;
  final i0.Value<int> source;
  final i0.Value<String> userId;
  final i0.Value<int> rowid;
  const ConflictedRowsCompanion({
    this.id = const i0.Value.absent(),
    this.source = const i0.Value.absent(),
    this.userId = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  ConflictedRowsCompanion.insert({
    required String id,
    required int source,
    required String userId,
    this.rowid = const i0.Value.absent(),
  })  : id = i0.Value(id),
        source = i0.Value(source),
        userId = i0.Value(userId);
  static i0.Insertable<i1.ConflictedRow> custom({
    i0.Expression<String>? id,
    i0.Expression<int>? source,
    i0.Expression<String>? userId,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (source != null) 'source': source,
      if (userId != null) 'user_id': userId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.ConflictedRowsCompanion copyWith(
      {i0.Value<String>? id,
      i0.Value<int>? source,
      i0.Value<String>? userId,
      i0.Value<int>? rowid}) {
    return i1.ConflictedRowsCompanion(
      id: id ?? this.id,
      source: source ?? this.source,
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
    if (source.present) {
      map['source'] = i0.Variable<int>(source.value);
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
    return (StringBuffer('ConflictedRowsCompanion(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('userId: $userId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

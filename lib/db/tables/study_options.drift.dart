// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:memori_app/db/tables/study_options.drift.dart' as i1;
import 'package:memori_app/db/tables/study_options.dart' as i2;
import 'package:drift/src/runtime/query_builder/query_builder.dart' as i3;

class $StudyOptionsTable extends i2.StudyOptions
    with i0.TableInfo<$StudyOptionsTable, i1.StudyOption> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyOptionsTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<String> id = i0.GeneratedColumn<String>(
      'id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'REFERENCES sync_entities (id)'));
  static const i0.VerificationMeta _modeMeta =
      const i0.VerificationMeta('mode');
  @override
  late final i0.GeneratedColumn<int> mode = i0.GeneratedColumn<int>(
      'mode', aliasedName, false,
      check: () => mode.isBetween(const i3.Constant(1), const i3.Constant(2)),
      type: i0.DriftSqlType.int,
      requiredDuringInsert: true);
  static const i0.VerificationMeta _sortOptionMeta =
      const i0.VerificationMeta('sortOption');
  @override
  late final i0.GeneratedColumn<int> sortOption = i0.GeneratedColumn<int>(
      'sort_option', aliasedName, false,
      check: () =>
          sortOption.isBetween(const i3.Constant(1), const i3.Constant(9)),
      type: i0.DriftSqlType.int,
      requiredDuringInsert: true);
  @override
  List<i0.GeneratedColumn> get $columns => [id, mode, sortOption];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_options';
  @override
  i0.VerificationContext validateIntegrity(
      i0.Insertable<i1.StudyOption> instance,
      {bool isInserting = false}) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
          _modeMeta, mode.isAcceptableOrUnknown(data['mode']!, _modeMeta));
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('sort_option')) {
      context.handle(
          _sortOptionMeta,
          sortOption.isAcceptableOrUnknown(
              data['sort_option']!, _sortOptionMeta));
    } else if (isInserting) {
      context.missing(_sortOptionMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.StudyOption map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.StudyOption(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}id'])!,
      mode: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}mode'])!,
      sortOption: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}sort_option'])!,
    );
  }

  @override
  $StudyOptionsTable createAlias(String alias) {
    return $StudyOptionsTable(attachedDatabase, alias);
  }
}

class StudyOption extends i0.DataClass
    implements i0.Insertable<i1.StudyOption> {
  final String id;
  final int mode;
  final int sortOption;
  const StudyOption(
      {required this.id, required this.mode, required this.sortOption});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<String>(id);
    map['mode'] = i0.Variable<int>(mode);
    map['sort_option'] = i0.Variable<int>(sortOption);
    return map;
  }

  i1.StudyOptionsCompanion toCompanion(bool nullToAbsent) {
    return i1.StudyOptionsCompanion(
      id: i0.Value(id),
      mode: i0.Value(mode),
      sortOption: i0.Value(sortOption),
    );
  }

  factory StudyOption.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return StudyOption(
      id: serializer.fromJson<String>(json['id']),
      mode: serializer.fromJson<int>(json['mode']),
      sortOption: serializer.fromJson<int>(json['sortOption']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mode': serializer.toJson<int>(mode),
      'sortOption': serializer.toJson<int>(sortOption),
    };
  }

  i1.StudyOption copyWith({String? id, int? mode, int? sortOption}) =>
      i1.StudyOption(
        id: id ?? this.id,
        mode: mode ?? this.mode,
        sortOption: sortOption ?? this.sortOption,
      );
  @override
  String toString() {
    return (StringBuffer('StudyOption(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('sortOption: $sortOption')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mode, sortOption);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.StudyOption &&
          other.id == this.id &&
          other.mode == this.mode &&
          other.sortOption == this.sortOption);
}

class StudyOptionsCompanion extends i0.UpdateCompanion<i1.StudyOption> {
  final i0.Value<String> id;
  final i0.Value<int> mode;
  final i0.Value<int> sortOption;
  final i0.Value<int> rowid;
  const StudyOptionsCompanion({
    this.id = const i0.Value.absent(),
    this.mode = const i0.Value.absent(),
    this.sortOption = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  StudyOptionsCompanion.insert({
    required String id,
    required int mode,
    required int sortOption,
    this.rowid = const i0.Value.absent(),
  })  : id = i0.Value(id),
        mode = i0.Value(mode),
        sortOption = i0.Value(sortOption);
  static i0.Insertable<i1.StudyOption> custom({
    i0.Expression<String>? id,
    i0.Expression<int>? mode,
    i0.Expression<int>? sortOption,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (mode != null) 'mode': mode,
      if (sortOption != null) 'sort_option': sortOption,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.StudyOptionsCompanion copyWith(
      {i0.Value<String>? id,
      i0.Value<int>? mode,
      i0.Value<int>? sortOption,
      i0.Value<int>? rowid}) {
    return i1.StudyOptionsCompanion(
      id: id ?? this.id,
      mode: mode ?? this.mode,
      sortOption: sortOption ?? this.sortOption,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<String>(id.value);
    }
    if (mode.present) {
      map['mode'] = i0.Variable<int>(mode.value);
    }
    if (sortOption.present) {
      map['sort_option'] = i0.Variable<int>(sortOption.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyOptionsCompanion(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('sortOption: $sortOption, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

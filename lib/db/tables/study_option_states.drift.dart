// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:memori_app/db/tables/study_option_states.drift.dart' as i1;
import 'package:memori_app/db/tables/study_option_states.dart' as i2;
import 'package:drift/src/runtime/query_builder/query_builder.dart' as i3;

class $StudyOptionStatesTable extends i2.StudyOptionStates
    with i0.TableInfo<$StudyOptionStatesTable, i1.StudyOptionState> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyOptionStatesTable(this.attachedDatabase, [this._alias]);
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
  static const i0.VerificationMeta _stateMeta =
      const i0.VerificationMeta('state');
  @override
  late final i0.GeneratedColumn<int> state = i0.GeneratedColumn<int>(
      'state', aliasedName, false,
      check: () => state.isBetween(const i3.Constant(0), const i3.Constant(3)),
      type: i0.DriftSqlType.int,
      requiredDuringInsert: true);
  @override
  List<i0.GeneratedColumn> get $columns => [id, studyOptionId, state];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_option_states';
  @override
  i0.VerificationContext validateIntegrity(
      i0.Insertable<i1.StudyOptionState> instance,
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
  i1.StudyOptionState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.StudyOptionState(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}id'])!,
      studyOptionId: attachedDatabase.typeMapping.read(
          i0.DriftSqlType.string, data['${effectivePrefix}study_option_id'])!,
      state: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}state'])!,
    );
  }

  @override
  $StudyOptionStatesTable createAlias(String alias) {
    return $StudyOptionStatesTable(attachedDatabase, alias);
  }
}

class StudyOptionState extends i0.DataClass
    implements i0.Insertable<i1.StudyOptionState> {
  final String id;
  final String studyOptionId;
  final int state;
  const StudyOptionState(
      {required this.id, required this.studyOptionId, required this.state});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<String>(id);
    map['study_option_id'] = i0.Variable<String>(studyOptionId);
    map['state'] = i0.Variable<int>(state);
    return map;
  }

  i1.StudyOptionStatesCompanion toCompanion(bool nullToAbsent) {
    return i1.StudyOptionStatesCompanion(
      id: i0.Value(id),
      studyOptionId: i0.Value(studyOptionId),
      state: i0.Value(state),
    );
  }

  factory StudyOptionState.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return StudyOptionState(
      id: serializer.fromJson<String>(json['id']),
      studyOptionId: serializer.fromJson<String>(json['studyOptionId']),
      state: serializer.fromJson<int>(json['state']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studyOptionId': serializer.toJson<String>(studyOptionId),
      'state': serializer.toJson<int>(state),
    };
  }

  i1.StudyOptionState copyWith(
          {String? id, String? studyOptionId, int? state}) =>
      i1.StudyOptionState(
        id: id ?? this.id,
        studyOptionId: studyOptionId ?? this.studyOptionId,
        state: state ?? this.state,
      );
  @override
  String toString() {
    return (StringBuffer('StudyOptionState(')
          ..write('id: $id, ')
          ..write('studyOptionId: $studyOptionId, ')
          ..write('state: $state')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, studyOptionId, state);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.StudyOptionState &&
          other.id == this.id &&
          other.studyOptionId == this.studyOptionId &&
          other.state == this.state);
}

class StudyOptionStatesCompanion
    extends i0.UpdateCompanion<i1.StudyOptionState> {
  final i0.Value<String> id;
  final i0.Value<String> studyOptionId;
  final i0.Value<int> state;
  final i0.Value<int> rowid;
  const StudyOptionStatesCompanion({
    this.id = const i0.Value.absent(),
    this.studyOptionId = const i0.Value.absent(),
    this.state = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  StudyOptionStatesCompanion.insert({
    required String id,
    required String studyOptionId,
    required int state,
    this.rowid = const i0.Value.absent(),
  })  : id = i0.Value(id),
        studyOptionId = i0.Value(studyOptionId),
        state = i0.Value(state);
  static i0.Insertable<i1.StudyOptionState> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? studyOptionId,
    i0.Expression<int>? state,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (studyOptionId != null) 'study_option_id': studyOptionId,
      if (state != null) 'state': state,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.StudyOptionStatesCompanion copyWith(
      {i0.Value<String>? id,
      i0.Value<String>? studyOptionId,
      i0.Value<int>? state,
      i0.Value<int>? rowid}) {
    return i1.StudyOptionStatesCompanion(
      id: id ?? this.id,
      studyOptionId: studyOptionId ?? this.studyOptionId,
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
    if (studyOptionId.present) {
      map['study_option_id'] = i0.Variable<String>(studyOptionId.value);
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
    return (StringBuffer('StudyOptionStatesCompanion(')
          ..write('id: $id, ')
          ..write('studyOptionId: $studyOptionId, ')
          ..write('state: $state, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

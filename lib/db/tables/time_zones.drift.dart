// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:memori_app/db/tables/time_zones.drift.dart' as i1;
import 'package:memori_app/db/tables/time_zones.dart' as i2;

i0.Index get idxRegion =>
    i0.Index('idx_region', 'CREATE INDEX idx_region ON time_zones (region)');

class $TimeZonesTable extends i2.TimeZones
    with i0.TableInfo<$TimeZonesTable, i1.TimeZone> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimeZonesTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<int> id = i0.GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: i0.DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          i0.GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const i0.VerificationMeta _regionMeta =
      const i0.VerificationMeta('region');
  @override
  late final i0.GeneratedColumn<String> region = i0.GeneratedColumn<String>(
      'region', aliasedName, false,
      type: i0.DriftSqlType.string, requiredDuringInsert: true);
  static const i0.VerificationMeta _cityMeta =
      const i0.VerificationMeta('city');
  @override
  late final i0.GeneratedColumn<String> city = i0.GeneratedColumn<String>(
      'city', aliasedName, false,
      type: i0.DriftSqlType.string, requiredDuringInsert: true);
  static const i0.VerificationMeta _codeMeta =
      const i0.VerificationMeta('code');
  @override
  late final i0.GeneratedColumn<String> code = i0.GeneratedColumn<String>(
      'code', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  List<i0.GeneratedColumn> get $columns => [id, region, city, code];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'time_zones';
  @override
  i0.VerificationContext validateIntegrity(i0.Insertable<i1.TimeZone> instance,
      {bool isInserting = false}) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('region')) {
      context.handle(_regionMeta,
          region.isAcceptableOrUnknown(data['region']!, _regionMeta));
    } else if (isInserting) {
      context.missing(_regionMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    } else if (isInserting) {
      context.missing(_cityMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.TimeZone map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.TimeZone(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}id'])!,
      region: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}region'])!,
      city: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}city'])!,
      code: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}code'])!,
    );
  }

  @override
  $TimeZonesTable createAlias(String alias) {
    return $TimeZonesTable(attachedDatabase, alias);
  }
}

class TimeZone extends i0.DataClass implements i0.Insertable<i1.TimeZone> {
  final int id;
  final String region;
  final String city;
  final String code;
  const TimeZone(
      {required this.id,
      required this.region,
      required this.city,
      required this.code});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<int>(id);
    map['region'] = i0.Variable<String>(region);
    map['city'] = i0.Variable<String>(city);
    map['code'] = i0.Variable<String>(code);
    return map;
  }

  i1.TimeZonesCompanion toCompanion(bool nullToAbsent) {
    return i1.TimeZonesCompanion(
      id: i0.Value(id),
      region: i0.Value(region),
      city: i0.Value(city),
      code: i0.Value(code),
    );
  }

  factory TimeZone.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return TimeZone(
      id: serializer.fromJson<int>(json['id']),
      region: serializer.fromJson<String>(json['region']),
      city: serializer.fromJson<String>(json['city']),
      code: serializer.fromJson<String>(json['code']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'region': serializer.toJson<String>(region),
      'city': serializer.toJson<String>(city),
      'code': serializer.toJson<String>(code),
    };
  }

  i1.TimeZone copyWith({int? id, String? region, String? city, String? code}) =>
      i1.TimeZone(
        id: id ?? this.id,
        region: region ?? this.region,
        city: city ?? this.city,
        code: code ?? this.code,
      );
  @override
  String toString() {
    return (StringBuffer('TimeZone(')
          ..write('id: $id, ')
          ..write('region: $region, ')
          ..write('city: $city, ')
          ..write('code: $code')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, region, city, code);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.TimeZone &&
          other.id == this.id &&
          other.region == this.region &&
          other.city == this.city &&
          other.code == this.code);
}

class TimeZonesCompanion extends i0.UpdateCompanion<i1.TimeZone> {
  final i0.Value<int> id;
  final i0.Value<String> region;
  final i0.Value<String> city;
  final i0.Value<String> code;
  const TimeZonesCompanion({
    this.id = const i0.Value.absent(),
    this.region = const i0.Value.absent(),
    this.city = const i0.Value.absent(),
    this.code = const i0.Value.absent(),
  });
  TimeZonesCompanion.insert({
    this.id = const i0.Value.absent(),
    required String region,
    required String city,
    required String code,
  })  : region = i0.Value(region),
        city = i0.Value(city),
        code = i0.Value(code);
  static i0.Insertable<i1.TimeZone> custom({
    i0.Expression<int>? id,
    i0.Expression<String>? region,
    i0.Expression<String>? city,
    i0.Expression<String>? code,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (region != null) 'region': region,
      if (city != null) 'city': city,
      if (code != null) 'code': code,
    });
  }

  i1.TimeZonesCompanion copyWith(
      {i0.Value<int>? id,
      i0.Value<String>? region,
      i0.Value<String>? city,
      i0.Value<String>? code}) {
    return i1.TimeZonesCompanion(
      id: id ?? this.id,
      region: region ?? this.region,
      city: city ?? this.city,
      code: code ?? this.code,
    );
  }

  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    if (id.present) {
      map['id'] = i0.Variable<int>(id.value);
    }
    if (region.present) {
      map['region'] = i0.Variable<String>(region.value);
    }
    if (city.present) {
      map['city'] = i0.Variable<String>(city.value);
    }
    if (code.present) {
      map['code'] = i0.Variable<String>(code.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimeZonesCompanion(')
          ..write('id: $id, ')
          ..write('region: $region, ')
          ..write('city: $city, ')
          ..write('code: $code')
          ..write(')'))
        .toString();
  }
}

i0.Index get idCode =>
    i0.Index('id_code', 'CREATE UNIQUE INDEX id_code ON time_zones (code)');

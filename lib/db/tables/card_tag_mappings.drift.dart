// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:memori_app/db/tables/card_tag_mappings.drift.dart' as i1;
import 'package:memori_app/db/tables/card_tag_mappings.dart' as i2;

class $CardTagMappingsTable extends i2.CardTagMappings
    with i0.TableInfo<$CardTagMappingsTable, i1.CardTagMapping> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardTagMappingsTable(this.attachedDatabase, [this._alias]);
  static const i0.VerificationMeta _idMeta = const i0.VerificationMeta('id');
  @override
  late final i0.GeneratedColumn<String> id = i0.GeneratedColumn<String>(
      'id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: i0.GeneratedColumn.constraintIsAlways(
          'REFERENCES sync_entities (id)'));
  static const i0.VerificationMeta _cardIdMeta =
      const i0.VerificationMeta('cardId');
  @override
  late final i0.GeneratedColumn<String> cardId = i0.GeneratedColumn<String>(
      'card_id', aliasedName, false,
      type: i0.DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          i0.GeneratedColumn.constraintIsAlways('REFERENCES cards (id)'));
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
  List<i0.GeneratedColumn> get $columns => [id, cardId, cardTagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_tag_mappings';
  @override
  i0.VerificationContext validateIntegrity(
      i0.Insertable<i1.CardTagMapping> instance,
      {bool isInserting = false}) {
    final context = i0.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(_cardIdMeta,
          cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta));
    } else if (isInserting) {
      context.missing(_cardIdMeta);
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
  i1.CardTagMapping map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.CardTagMapping(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}id'])!,
      cardId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}card_id'])!,
      cardTagId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}card_tag_id'])!,
    );
  }

  @override
  $CardTagMappingsTable createAlias(String alias) {
    return $CardTagMappingsTable(attachedDatabase, alias);
  }
}

class CardTagMapping extends i0.DataClass
    implements i0.Insertable<i1.CardTagMapping> {
  final String id;
  final String cardId;
  final String cardTagId;
  const CardTagMapping(
      {required this.id, required this.cardId, required this.cardTagId});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<String>(id);
    map['card_id'] = i0.Variable<String>(cardId);
    map['card_tag_id'] = i0.Variable<String>(cardTagId);
    return map;
  }

  i1.CardTagMappingsCompanion toCompanion(bool nullToAbsent) {
    return i1.CardTagMappingsCompanion(
      id: i0.Value(id),
      cardId: i0.Value(cardId),
      cardTagId: i0.Value(cardTagId),
    );
  }

  factory CardTagMapping.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return CardTagMapping(
      id: serializer.fromJson<String>(json['id']),
      cardId: serializer.fromJson<String>(json['cardId']),
      cardTagId: serializer.fromJson<String>(json['cardTagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cardId': serializer.toJson<String>(cardId),
      'cardTagId': serializer.toJson<String>(cardTagId),
    };
  }

  i1.CardTagMapping copyWith({String? id, String? cardId, String? cardTagId}) =>
      i1.CardTagMapping(
        id: id ?? this.id,
        cardId: cardId ?? this.cardId,
        cardTagId: cardTagId ?? this.cardTagId,
      );
  @override
  String toString() {
    return (StringBuffer('CardTagMapping(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('cardTagId: $cardTagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cardId, cardTagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.CardTagMapping &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.cardTagId == this.cardTagId);
}

class CardTagMappingsCompanion extends i0.UpdateCompanion<i1.CardTagMapping> {
  final i0.Value<String> id;
  final i0.Value<String> cardId;
  final i0.Value<String> cardTagId;
  final i0.Value<int> rowid;
  const CardTagMappingsCompanion({
    this.id = const i0.Value.absent(),
    this.cardId = const i0.Value.absent(),
    this.cardTagId = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  CardTagMappingsCompanion.insert({
    required String id,
    required String cardId,
    required String cardTagId,
    this.rowid = const i0.Value.absent(),
  })  : id = i0.Value(id),
        cardId = i0.Value(cardId),
        cardTagId = i0.Value(cardTagId);
  static i0.Insertable<i1.CardTagMapping> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? cardId,
    i0.Expression<String>? cardTagId,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (cardTagId != null) 'card_tag_id': cardTagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.CardTagMappingsCompanion copyWith(
      {i0.Value<String>? id,
      i0.Value<String>? cardId,
      i0.Value<String>? cardTagId,
      i0.Value<int>? rowid}) {
    return i1.CardTagMappingsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
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
    if (cardId.present) {
      map['card_id'] = i0.Variable<String>(cardId.value);
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
    return (StringBuffer('CardTagMappingsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('cardTagId: $cardTagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:memori_app/db/tables/card_hints.drift.dart' as i1;
import 'dart:typed_data' as i2;
import 'package:memori_app/db/tables/card_hints.dart' as i3;

class $CardHintsTable extends i3.CardHints
    with i0.TableInfo<$CardHintsTable, i1.CardHint> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardHintsTable(this.attachedDatabase, [this._alias]);
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
  static const i0.VerificationMeta _hintTextMeta =
      const i0.VerificationMeta('hintText');
  @override
  late final i0.GeneratedColumn<i2.Uint8List> hintText =
      i0.GeneratedColumn<i2.Uint8List>('hint_text', aliasedName, false,
          type: i0.DriftSqlType.blob, requiredDuringInsert: true);
  static const i0.VerificationMeta _displayOrderMeta =
      const i0.VerificationMeta('displayOrder');
  @override
  late final i0.GeneratedColumn<int> displayOrder = i0.GeneratedColumn<int>(
      'display_order', aliasedName, false,
      type: i0.DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<i0.GeneratedColumn> get $columns => [id, cardId, hintText, displayOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_hints';
  @override
  i0.VerificationContext validateIntegrity(i0.Insertable<i1.CardHint> instance,
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
    if (data.containsKey('hint_text')) {
      context.handle(_hintTextMeta,
          hintText.isAcceptableOrUnknown(data['hint_text']!, _hintTextMeta));
    } else if (isInserting) {
      context.missing(_hintTextMeta);
    }
    if (data.containsKey('display_order')) {
      context.handle(
          _displayOrderMeta,
          displayOrder.isAcceptableOrUnknown(
              data['display_order']!, _displayOrderMeta));
    } else if (isInserting) {
      context.missing(_displayOrderMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.CardHint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.CardHint(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}id'])!,
      cardId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}card_id'])!,
      hintText: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.blob, data['${effectivePrefix}hint_text'])!,
      displayOrder: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}display_order'])!,
    );
  }

  @override
  $CardHintsTable createAlias(String alias) {
    return $CardHintsTable(attachedDatabase, alias);
  }
}

class CardHint extends i0.DataClass implements i0.Insertable<i1.CardHint> {
  final String id;
  final String cardId;
  final i2.Uint8List hintText;
  final int displayOrder;
  const CardHint(
      {required this.id,
      required this.cardId,
      required this.hintText,
      required this.displayOrder});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<String>(id);
    map['card_id'] = i0.Variable<String>(cardId);
    map['hint_text'] = i0.Variable<i2.Uint8List>(hintText);
    map['display_order'] = i0.Variable<int>(displayOrder);
    return map;
  }

  i1.CardHintsCompanion toCompanion(bool nullToAbsent) {
    return i1.CardHintsCompanion(
      id: i0.Value(id),
      cardId: i0.Value(cardId),
      hintText: i0.Value(hintText),
      displayOrder: i0.Value(displayOrder),
    );
  }

  factory CardHint.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return CardHint(
      id: serializer.fromJson<String>(json['id']),
      cardId: serializer.fromJson<String>(json['cardId']),
      hintText: serializer.fromJson<i2.Uint8List>(json['hintText']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cardId': serializer.toJson<String>(cardId),
      'hintText': serializer.toJson<i2.Uint8List>(hintText),
      'displayOrder': serializer.toJson<int>(displayOrder),
    };
  }

  i1.CardHint copyWith(
          {String? id,
          String? cardId,
          i2.Uint8List? hintText,
          int? displayOrder}) =>
      i1.CardHint(
        id: id ?? this.id,
        cardId: cardId ?? this.cardId,
        hintText: hintText ?? this.hintText,
        displayOrder: displayOrder ?? this.displayOrder,
      );
  @override
  String toString() {
    return (StringBuffer('CardHint(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('hintText: $hintText, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, cardId, i0.$driftBlobEquality.hash(hintText), displayOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.CardHint &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          i0.$driftBlobEquality.equals(other.hintText, this.hintText) &&
          other.displayOrder == this.displayOrder);
}

class CardHintsCompanion extends i0.UpdateCompanion<i1.CardHint> {
  final i0.Value<String> id;
  final i0.Value<String> cardId;
  final i0.Value<i2.Uint8List> hintText;
  final i0.Value<int> displayOrder;
  final i0.Value<int> rowid;
  const CardHintsCompanion({
    this.id = const i0.Value.absent(),
    this.cardId = const i0.Value.absent(),
    this.hintText = const i0.Value.absent(),
    this.displayOrder = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  CardHintsCompanion.insert({
    required String id,
    required String cardId,
    required i2.Uint8List hintText,
    required int displayOrder,
    this.rowid = const i0.Value.absent(),
  })  : id = i0.Value(id),
        cardId = i0.Value(cardId),
        hintText = i0.Value(hintText),
        displayOrder = i0.Value(displayOrder);
  static i0.Insertable<i1.CardHint> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? cardId,
    i0.Expression<i2.Uint8List>? hintText,
    i0.Expression<int>? displayOrder,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (hintText != null) 'hint_text': hintText,
      if (displayOrder != null) 'display_order': displayOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.CardHintsCompanion copyWith(
      {i0.Value<String>? id,
      i0.Value<String>? cardId,
      i0.Value<i2.Uint8List>? hintText,
      i0.Value<int>? displayOrder,
      i0.Value<int>? rowid}) {
    return i1.CardHintsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      hintText: hintText ?? this.hintText,
      displayOrder: displayOrder ?? this.displayOrder,
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
    if (hintText.present) {
      map['hint_text'] = i0.Variable<i2.Uint8List>(hintText.value);
    }
    if (displayOrder.present) {
      map['display_order'] = i0.Variable<int>(displayOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardHintsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('hintText: $hintText, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

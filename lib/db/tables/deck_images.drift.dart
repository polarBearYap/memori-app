// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:memori_app/db/tables/deck_images.drift.dart' as i1;
import 'dart:typed_data' as i2;
import 'package:memori_app/db/tables/deck_images.dart' as i3;

class $DeckImagesTable extends i3.DeckImages
    with i0.TableInfo<$DeckImagesTable, i1.DeckImage> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeckImagesTable(this.attachedDatabase, [this._alias]);
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
  static const i0.VerificationMeta _imageDataMeta =
      const i0.VerificationMeta('imageData');
  @override
  late final i0.GeneratedColumn<i2.Uint8List> imageData =
      i0.GeneratedColumn<i2.Uint8List>('image_data', aliasedName, true,
          type: i0.DriftSqlType.blob, requiredDuringInsert: false);
  @override
  List<i0.GeneratedColumn> get $columns => [id, deckId, imageData];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deck_images';
  @override
  i0.VerificationContext validateIntegrity(i0.Insertable<i1.DeckImage> instance,
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
    if (data.containsKey('image_data')) {
      context.handle(_imageDataMeta,
          imageData.isAcceptableOrUnknown(data['image_data']!, _imageDataMeta));
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.DeckImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.DeckImage(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}id'])!,
      deckId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}deck_id'])!,
      imageData: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.blob, data['${effectivePrefix}image_data']),
    );
  }

  @override
  $DeckImagesTable createAlias(String alias) {
    return $DeckImagesTable(attachedDatabase, alias);
  }
}

class DeckImage extends i0.DataClass implements i0.Insertable<i1.DeckImage> {
  final String id;
  final String deckId;
  final i2.Uint8List? imageData;
  const DeckImage({required this.id, required this.deckId, this.imageData});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<String>(id);
    map['deck_id'] = i0.Variable<String>(deckId);
    if (!nullToAbsent || imageData != null) {
      map['image_data'] = i0.Variable<i2.Uint8List>(imageData);
    }
    return map;
  }

  i1.DeckImagesCompanion toCompanion(bool nullToAbsent) {
    return i1.DeckImagesCompanion(
      id: i0.Value(id),
      deckId: i0.Value(deckId),
      imageData: imageData == null && nullToAbsent
          ? const i0.Value.absent()
          : i0.Value(imageData),
    );
  }

  factory DeckImage.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return DeckImage(
      id: serializer.fromJson<String>(json['id']),
      deckId: serializer.fromJson<String>(json['deckId']),
      imageData: serializer.fromJson<i2.Uint8List?>(json['imageData']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deckId': serializer.toJson<String>(deckId),
      'imageData': serializer.toJson<i2.Uint8List?>(imageData),
    };
  }

  i1.DeckImage copyWith(
          {String? id,
          String? deckId,
          i0.Value<i2.Uint8List?> imageData = const i0.Value.absent()}) =>
      i1.DeckImage(
        id: id ?? this.id,
        deckId: deckId ?? this.deckId,
        imageData: imageData.present ? imageData.value : this.imageData,
      );
  @override
  String toString() {
    return (StringBuffer('DeckImage(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('imageData: $imageData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, deckId, i0.$driftBlobEquality.hash(imageData));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.DeckImage &&
          other.id == this.id &&
          other.deckId == this.deckId &&
          i0.$driftBlobEquality.equals(other.imageData, this.imageData));
}

class DeckImagesCompanion extends i0.UpdateCompanion<i1.DeckImage> {
  final i0.Value<String> id;
  final i0.Value<String> deckId;
  final i0.Value<i2.Uint8List?> imageData;
  final i0.Value<int> rowid;
  const DeckImagesCompanion({
    this.id = const i0.Value.absent(),
    this.deckId = const i0.Value.absent(),
    this.imageData = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  DeckImagesCompanion.insert({
    required String id,
    required String deckId,
    this.imageData = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  })  : id = i0.Value(id),
        deckId = i0.Value(deckId);
  static i0.Insertable<i1.DeckImage> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? deckId,
    i0.Expression<i2.Uint8List>? imageData,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (deckId != null) 'deck_id': deckId,
      if (imageData != null) 'image_data': imageData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.DeckImagesCompanion copyWith(
      {i0.Value<String>? id,
      i0.Value<String>? deckId,
      i0.Value<i2.Uint8List?>? imageData,
      i0.Value<int>? rowid}) {
    return i1.DeckImagesCompanion(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      imageData: imageData ?? this.imageData,
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
    if (imageData.present) {
      map['image_data'] = i0.Variable<i2.Uint8List>(imageData.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeckImagesCompanion(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('imageData: $imageData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

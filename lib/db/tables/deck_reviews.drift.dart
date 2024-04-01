// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:memori_app/db/tables/deck_reviews.drift.dart' as i1;
import 'dart:typed_data' as i2;
import 'package:memori_app/db/tables/deck_reviews.dart' as i3;
import 'package:drift/src/runtime/query_builder/query_builder.dart' as i4;

class $DeckReviewsTable extends i3.DeckReviews
    with i0.TableInfo<$DeckReviewsTable, i1.DeckReview> {
  @override
  final i0.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeckReviewsTable(this.attachedDatabase, [this._alias]);
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
  static const i0.VerificationMeta _commentMeta =
      const i0.VerificationMeta('comment');
  @override
  late final i0.GeneratedColumn<i2.Uint8List> comment =
      i0.GeneratedColumn<i2.Uint8List>('comment', aliasedName, false,
          type: i0.DriftSqlType.blob, requiredDuringInsert: true);
  static const i0.VerificationMeta _ratingMeta =
      const i0.VerificationMeta('rating');
  @override
  late final i0.GeneratedColumn<int> rating = i0.GeneratedColumn<int>(
      'rating', aliasedName, false,
      check: () => rating.isBetween(const i4.Constant(1), const i4.Constant(5)),
      type: i0.DriftSqlType.int,
      requiredDuringInsert: true);
  @override
  List<i0.GeneratedColumn> get $columns => [id, deckId, comment, rating];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deck_reviews';
  @override
  i0.VerificationContext validateIntegrity(
      i0.Insertable<i1.DeckReview> instance,
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
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    } else if (isInserting) {
      context.missing(_commentMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(_ratingMeta,
          rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta));
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    return context;
  }

  @override
  Set<i0.GeneratedColumn> get $primaryKey => {id};
  @override
  i1.DeckReview map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return i1.DeckReview(
      id: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}id'])!,
      deckId: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.string, data['${effectivePrefix}deck_id'])!,
      comment: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.blob, data['${effectivePrefix}comment'])!,
      rating: attachedDatabase.typeMapping
          .read(i0.DriftSqlType.int, data['${effectivePrefix}rating'])!,
    );
  }

  @override
  $DeckReviewsTable createAlias(String alias) {
    return $DeckReviewsTable(attachedDatabase, alias);
  }
}

class DeckReview extends i0.DataClass implements i0.Insertable<i1.DeckReview> {
  final String id;
  final String deckId;
  final i2.Uint8List comment;
  final int rating;
  const DeckReview(
      {required this.id,
      required this.deckId,
      required this.comment,
      required this.rating});
  @override
  Map<String, i0.Expression> toColumns(bool nullToAbsent) {
    final map = <String, i0.Expression>{};
    map['id'] = i0.Variable<String>(id);
    map['deck_id'] = i0.Variable<String>(deckId);
    map['comment'] = i0.Variable<i2.Uint8List>(comment);
    map['rating'] = i0.Variable<int>(rating);
    return map;
  }

  i1.DeckReviewsCompanion toCompanion(bool nullToAbsent) {
    return i1.DeckReviewsCompanion(
      id: i0.Value(id),
      deckId: i0.Value(deckId),
      comment: i0.Value(comment),
      rating: i0.Value(rating),
    );
  }

  factory DeckReview.fromJson(Map<String, dynamic> json,
      {i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return DeckReview(
      id: serializer.fromJson<String>(json['id']),
      deckId: serializer.fromJson<String>(json['deckId']),
      comment: serializer.fromJson<i2.Uint8List>(json['comment']),
      rating: serializer.fromJson<int>(json['rating']),
    );
  }
  @override
  Map<String, dynamic> toJson({i0.ValueSerializer? serializer}) {
    serializer ??= i0.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deckId': serializer.toJson<String>(deckId),
      'comment': serializer.toJson<i2.Uint8List>(comment),
      'rating': serializer.toJson<int>(rating),
    };
  }

  i1.DeckReview copyWith(
          {String? id, String? deckId, i2.Uint8List? comment, int? rating}) =>
      i1.DeckReview(
        id: id ?? this.id,
        deckId: deckId ?? this.deckId,
        comment: comment ?? this.comment,
        rating: rating ?? this.rating,
      );
  @override
  String toString() {
    return (StringBuffer('DeckReview(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('comment: $comment, ')
          ..write('rating: $rating')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, deckId, i0.$driftBlobEquality.hash(comment), rating);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is i1.DeckReview &&
          other.id == this.id &&
          other.deckId == this.deckId &&
          i0.$driftBlobEquality.equals(other.comment, this.comment) &&
          other.rating == this.rating);
}

class DeckReviewsCompanion extends i0.UpdateCompanion<i1.DeckReview> {
  final i0.Value<String> id;
  final i0.Value<String> deckId;
  final i0.Value<i2.Uint8List> comment;
  final i0.Value<int> rating;
  final i0.Value<int> rowid;
  const DeckReviewsCompanion({
    this.id = const i0.Value.absent(),
    this.deckId = const i0.Value.absent(),
    this.comment = const i0.Value.absent(),
    this.rating = const i0.Value.absent(),
    this.rowid = const i0.Value.absent(),
  });
  DeckReviewsCompanion.insert({
    required String id,
    required String deckId,
    required i2.Uint8List comment,
    required int rating,
    this.rowid = const i0.Value.absent(),
  })  : id = i0.Value(id),
        deckId = i0.Value(deckId),
        comment = i0.Value(comment),
        rating = i0.Value(rating);
  static i0.Insertable<i1.DeckReview> custom({
    i0.Expression<String>? id,
    i0.Expression<String>? deckId,
    i0.Expression<i2.Uint8List>? comment,
    i0.Expression<int>? rating,
    i0.Expression<int>? rowid,
  }) {
    return i0.RawValuesInsertable({
      if (id != null) 'id': id,
      if (deckId != null) 'deck_id': deckId,
      if (comment != null) 'comment': comment,
      if (rating != null) 'rating': rating,
      if (rowid != null) 'rowid': rowid,
    });
  }

  i1.DeckReviewsCompanion copyWith(
      {i0.Value<String>? id,
      i0.Value<String>? deckId,
      i0.Value<i2.Uint8List>? comment,
      i0.Value<int>? rating,
      i0.Value<int>? rowid}) {
    return i1.DeckReviewsCompanion(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      comment: comment ?? this.comment,
      rating: rating ?? this.rating,
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
    if (comment.present) {
      map['comment'] = i0.Variable<i2.Uint8List>(comment.value);
    }
    if (rating.present) {
      map['rating'] = i0.Variable<int>(rating.value);
    }
    if (rowid.present) {
      map['rowid'] = i0.Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeckReviewsCompanion(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('comment: $comment, ')
          ..write('rating: $rating, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

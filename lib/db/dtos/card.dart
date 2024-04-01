import 'package:memori_app/db/dtos/pagination.dart';
import 'package:memori_app/db/tables/cards.drift.dart';
import 'package:memori_app/db/tables/decks.drift.dart';
import 'package:memori_app/db/tables/sync_entities.drift.dart';

class PaginatedCardDto {
  final PaginationResult pagination;
  final List<CardDto> dtos;

  PaginatedCardDto({
    required this.pagination,
    required this.dtos,
  });
}

class CardDto {
  final SyncEntity syncEntity;
  final Card card;
  final Deck deck;

  CardDto({
    required this.syncEntity,
    required this.card,
    required this.deck,
  });
}

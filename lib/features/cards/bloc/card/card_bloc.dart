import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:memori_app/db/repositories/db_repository.dart';
import 'package:memori_app/features/cards/models/card_list_view.dart';

part 'card_event.dart';
part 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final DbRepository _dbRepository;

  CardBloc(final DbRepository dbRepository)
      : _dbRepository = dbRepository,
        super(const CardState(cards: [])) {
    on<CardReloaded>(_onCardReloaded);
    on<CardScrolledDown>(_onCardScrolledDown);
  }

  void _onCardReloaded(
    final CardReloaded event,
    final Emitter<CardState> emit,
  ) {
    emit(
      const CardState(
        cards: [],
        status: CardListStatus.forceRefresh,
      ),
    );
  }

  void _onCardScrolledDown(
    final CardScrolledDown event,
    final Emitter<CardState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CardListStatus.loading,
      ),
    );
    try {
      final dto = await _dbRepository.pagesOfCards(
        page: event.pageNumber,
        pageSize: event.pageSize,
        searchText: event.searchText,
        selectedDecks: event.selectedDecks.isEmpty ? null : event.selectedDecks,
        selectedTags: event.selectedTags.isEmpty ? null : event.selectedTags,
        sortOption: event.cardSortOption,
      );
      final hasNextPage = dto.pagination.nextPageSize > 0;
      emit(
        state.copyWith(
          status: CardListStatus.completed,
          hasNextPage: hasNextPage,
          currentPageNo: event.pageNumber,
          currentPageSize: event.pageSize,
          totalRecords: dto.pagination.totalRecords,
          cards: await Future.wait(
            dto.dtos.map((final e) async {
              final tags = await _dbRepository.getCardTagByCardId(
                cardId: e.card.id,
              );

              return CardListViewItem(
                id: e.card.id,
                deckname: e.deck.name,
                frontDocument: Document.fromJson(json.decode(e.card.front)),
                backDocument: Document.fromJson(json.decode(e.card.back)),
                frontPlainText: e.card.frontPlainText,
                backPlainText: e.card.backPlainText,
                lastCreatedAt: e.syncEntity.createdAt,
                lastModifiedAt: e.syncEntity.lastModified,
                tagNames: tags.map((final e) => e.name).toList(),
              );
            }).toList(),
          ),
        ),
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(
        state.copyWith(
          cards: [],
          status: CardListStatus.failed,
        ),
      );
    }
  }
}

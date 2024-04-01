import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memori_app/db/repositories/db_repository.dart';
import 'package:memori_app/features/cards/models/card_tag_list_view.dart';

part 'card_tag_event.dart';
part 'card_tag_state.dart';

class CardTagBloc extends Bloc<CardTagEvent, CardTagState> {
  final DbRepository _dbRepository;

  CardTagBloc(final DbRepository dbRepository)
      : _dbRepository = dbRepository,
        super(const CardTagState(cardTags: [])) {
    on<CardTagReloaded>(_onCardTagReloaded);
    on<CardTagScrolledDown>(_onCardTagScrolledDown);
  }

  void _onCardTagReloaded(
    final CardTagReloaded event,
    final Emitter<CardTagState> emit,
  ) {
    emit(
      const CardTagState(
        cardTags: [],
        status: CardTagListStatus.forceRefresh,
      ),
    );
  }

  void _onCardTagScrolledDown(
    final CardTagScrolledDown event,
    final Emitter<CardTagState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CardTagListStatus.loading,
      ),
    );
    try {
      final cardTags = await _dbRepository.pagesOfCardTags(
        page: event.pageNumber,
        pageSize: event.pageSize,
        searchText: event.searchText,
      );
      final paginatedResult = await _dbRepository.nextCardTagPageCount(
        page: event.pageNumber,
        pageSize: event.pageSize,
        searchText: event.searchText,
      );
      final hasNextPage = paginatedResult.nextPageSize > 0;
      emit(
        state.copyWith(
          status: CardTagListStatus.completed,
          hasNextPage: hasNextPage,
          currentPageNo: event.pageNumber,
          currentPageSize: event.pageSize,
          totalRecords: paginatedResult.totalRecords,
          cardTags: cardTags
              .map(
                (final e) => CardTagListViewItem(
                  id: e.id,
                  name: e.name,
                ),
              )
              .toList(),
        ),
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(
        state.copyWith(
          cardTags: [],
          status: CardTagListStatus.failed,
        ),
      );
    }
  }
}

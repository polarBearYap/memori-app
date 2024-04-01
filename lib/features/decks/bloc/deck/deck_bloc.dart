import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memori_app/db/repositories/db_repository.dart';
import 'package:memori_app/features/decks/models/deck_list_view.dart';

part 'deck_event.dart';
part 'deck_state.dart';

class DeckBloc extends Bloc<DeckEvent, DeckState> {
  final DbRepository _dbRepository;

  DeckBloc(final DbRepository dbRepository)
      : _dbRepository = dbRepository,
        super(const DeckState(decks: [])) {
    on<DeckReloaded>(_onDeckReloaded);
    on<DeckScrolledDown>(_onDeckScrolledDown);
  }

  void _onDeckReloaded(
    final DeckReloaded event,
    final Emitter<DeckState> emit,
  ) {
    emit(
      DeckState(
        eventSource: DeckScrollEventSource.all,
        decks: const [],
        status: DeckListStatus.forceRefresh,
        newlyAddedDeckId: event.newlyAddedDeckId,
        newlyEditedDeckId: event.newlyEditedDeckId,
      ),
    );
  }

  void _onDeckScrolledDown(
    final DeckScrolledDown event,
    final Emitter<DeckState> emit,
  ) async {
    emit(
      state.copyWith(
        eventSource: event.eventSource,
        status: DeckListStatus.loading,
      ),
    );
    try {
      final decks = await _dbRepository.pagesOfDecks(
        page: event.pageNumber,
        pageSize: event.pageSize,
        searchText: event.searchText,
      );
      final hasNextPage = (await _dbRepository.nextDeckPageCount(
            page: event.pageNumber,
            pageSize: event.pageSize,
            searchText: event.searchText,
          )) >
          0;
      emit(
        state.copyWith(
          eventSource: event.eventSource,
          status: DeckListStatus.completed,
          hasNextPage: hasNextPage,
          currentPageNo: event.pageNumber,
          currentPageSize: event.pageSize,
          decks: await Future.wait(
            decks.map(
              (final e) async {
                final stats = await _dbRepository.getStatsByDeckId(e.id);
                return DeckListViewItem(
                  id: e.id,
                  deckName: e.name,
                  newCount: stats.newCount,
                  learningCount: stats.learningCount,
                  reviewCount: stats.reviewCount,
                  lastReviewedTime: e.lastReviewTime,
                  // lastReviewedTime: getReviewTimePassed(e.lastReviewTime),
                );
              },
            ).toList(),
          ),
        ),
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(
        state.copyWith(
          eventSource: event.eventSource,
          decks: [],
          status: DeckListStatus.failed,
        ),
      );
    }
  }
}

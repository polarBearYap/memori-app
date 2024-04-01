import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, BottomNavigationState> {
  NavigationBloc() : super(const BottomNavigationState()) {
    on<BottomNavigationChanged>(_onBottomNavigationChanged);
    on<PageViewChanged>(_onPageViewChanged);
  }

  Future<void> _onBottomNavigationChanged(
    final BottomNavigationChanged event,
    final Emitter<BottomNavigationState> emit,
  ) async {
    int? pageNumber;
    switch (event.navigationItem) {
      case BottomNavigationItem.home:
        pageNumber = 0;
        break;
      /*
      case BottomNavigationItem.browse:
        pageNumber = 1;
        break;
      case BottomNavigationItem.statistics:
        pageNumber = 2;
        break;
      */
      case BottomNavigationItem.profile:
        pageNumber = 1;
        break;
    }
    emit(
      state.copyWith(
        navigationItem: event.navigationItem,
        pageNumber: pageNumber,
        triggerSource: TriggerSource.bottomnavbar,
      ),
    );
  }

  Future<void> _onPageViewChanged(
    final PageViewChanged event,
    final Emitter<BottomNavigationState> emit,
  ) async {
    BottomNavigationItem? navigationItem;
    switch (event.pageNumber) {
      case 0:
        navigationItem = BottomNavigationItem.home;
        break;
      /*
      case 1:
        navigationItem = BottomNavigationItem.browse;
        break;
      case 2:
        navigationItem = BottomNavigationItem.statistics;
        break;
      */
      case 1:
        navigationItem = BottomNavigationItem.profile;
        break;
    }
    emit(
      state.copyWith(
        navigationItem: navigationItem,
        pageNumber: event.pageNumber,
      ),
    );
  }
}

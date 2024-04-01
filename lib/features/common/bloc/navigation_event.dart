part of 'navigation_bloc.dart';

sealed class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

enum BottomNavigationItem {
  home,
  // browse,
  // statistics,
  profile,
}

final class BottomNavigationChanged extends NavigationEvent {
  const BottomNavigationChanged({required this.navigationItem});

  final BottomNavigationItem navigationItem;

  @override
  List<Object> get props => [navigationItem];
}

final class PageViewChanged extends NavigationEvent {
  const PageViewChanged({required this.pageNumber});

  final int pageNumber;

  @override
  List<Object> get props => [pageNumber];
}

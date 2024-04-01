part of 'navigation_bloc.dart';

enum TriggerSource {
  bottomnavbar,
  userswipe,
}

final class BottomNavigationState extends Equatable {
  const BottomNavigationState({
    this.navigationItem = BottomNavigationItem.home,
    this.pageNumber = 0,
    this.triggerSource = TriggerSource.userswipe,
  });

  final BottomNavigationItem navigationItem;
  final int pageNumber;
  final TriggerSource triggerSource;

  BottomNavigationState copyWith({
    final BottomNavigationItem? navigationItem,
    final int? pageNumber,
    final TriggerSource? triggerSource,
  }) =>
      BottomNavigationState(
        navigationItem: navigationItem ?? this.navigationItem,
        pageNumber: pageNumber ?? this.pageNumber,
        triggerSource: triggerSource ?? this.triggerSource,
      );

  @override
  List<Object> get props => [
        navigationItem,
        pageNumber,
        triggerSource,
      ];
}

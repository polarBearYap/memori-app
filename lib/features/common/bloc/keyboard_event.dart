part of 'keyboard_bloc.dart';

sealed class KeyboardVisibilityEvent extends Equatable {
  const KeyboardVisibilityEvent();

  @override
  List<Object> get props => [];
}

final class KeyboardVisibilityChanged extends KeyboardVisibilityEvent {
  const KeyboardVisibilityChanged({required this.isVisible});

  final bool isVisible;

  @override
  List<Object> get props => [isVisible];
}

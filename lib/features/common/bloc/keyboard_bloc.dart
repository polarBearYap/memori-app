import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

part 'keyboard_event.dart';
part 'keyboard_state.dart';

class KeyboardVisibilityBloc
    extends Bloc<KeyboardVisibilityEvent, KeyboardVisibilityState> {
  final KeyboardVisibilityController _controller =
      KeyboardVisibilityController();
  late StreamSubscription<bool> _subscription;

  KeyboardVisibilityBloc() : super(KeyboardHidden()) {
    _subscription = _controller.onChange.listen((final bool visible) {
      add(KeyboardVisibilityChanged(isVisible: visible));
    });

    // Handle the events
    on<KeyboardVisibilityChanged>((final event, final emit) {
      if (event.isVisible) {
        emit(KeyboardVisible());
      } else {
        emit(KeyboardHidden());
      }
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}

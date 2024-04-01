import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences _prefs;
  static const String key = 'preferredTheme';
  static const String light = 'LIGHT';
  static const String dark = 'DARK';
  static const String system = 'SYSTEM';

  ThemeBloc({
    required final SharedPreferences prefs,
  })  : _prefs = prefs,
        super(
          ThemeState(
            themeMode: () {
              final theme = prefs.getString(key);
              switch (theme) {
                case null:
                  return ThemeMode.system;
                case light:
                  return ThemeMode.light;
                case dark:
                  return ThemeMode.dark;
                case system:
                  return ThemeMode.system;
                default:
                  return ThemeMode.system;
              }
            }(),
          ),
        ) {
    on<ThemeChanged>(_onThemeChanged);
  }

  void _onThemeChanged(
    final ThemeChanged event,
    final Emitter<ThemeState> emit,
  ) async {
    switch (event.themeMode) {
      case ThemeMode.system:
        await _prefs.setString(key, system);
        break;
      case ThemeMode.light:
        await _prefs.setString(key, light);
        break;
      case ThemeMode.dark:
        await _prefs.setString(key, dark);
        break;
    }
    emit(
      state.copyWith(
        themeMode: event.themeMode,
      ),
    );
  }
}

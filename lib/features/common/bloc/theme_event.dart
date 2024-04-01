part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

final class ThemeChanged extends ThemeEvent {
  final ThemeMode themeMode;

  const ThemeChanged({required this.themeMode});

  @override
  List<Object> get props => [themeMode];
}

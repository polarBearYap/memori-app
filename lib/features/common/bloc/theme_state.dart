part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState({required this.themeMode});

  ThemeState copyWith({
    final ThemeMode? themeMode,
  }) =>
      ThemeState(
        themeMode: themeMode ?? this.themeMode,
      );

  @override
  List<Object> get props => [
        themeMode,
      ];
}

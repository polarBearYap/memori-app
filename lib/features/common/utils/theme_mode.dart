import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memori_app/features/common/bloc/theme_bloc.dart';

bool checkIsDarkMode({
  required final BuildContext context,
}) {
  final themeMode = BlocProvider.of<ThemeBloc>(context).state.themeMode;
  return themeMode == ThemeMode.system
      ? MediaQuery.of(context).platformBrightness == Brightness.dark
      : themeMode == ThemeMode.dark;
}

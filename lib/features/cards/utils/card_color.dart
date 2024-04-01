import 'package:flutter/material.dart';

Color getNewChipColor(final ThemeData theme) =>
    theme.colorScheme.primaryContainer;
Color getLearningColor({required final bool isDarkMode}) =>
    !isDarkMode ? Colors.greenAccent : Colors.green;
Color getReviewColor({required final bool isDarkMode}) =>
    !isDarkMode ? Colors.orangeAccent : Colors.deepOrange;

Color getEasyColor({
  required final ThemeData theme,
  required final bool isDarkMode,
}) =>
    !isDarkMode ? theme.colorScheme.tertiary : Colors.blue;
Color getGoodColor({required final bool isDarkMode}) =>
    !isDarkMode ? Colors.green : Colors.green;
Color getHardColor({required final bool isDarkMode}) =>
    !isDarkMode ? Colors.orange : Colors.deepOrange;
Color getAgainColor({required final bool isDarkMode}) =>
    !isDarkMode ? Colors.grey : Colors.grey;

Color getColorOnHover({required final bool isDarkMode}) =>
    !isDarkMode ? Colors.white24 : Colors.black12;
/*
Color getGoodColorOnHover({required final bool isDarkMode}) =>
    !isDarkMode ? Colors.white24 : Colors.black12;
Color getHardColorOnHover({required final bool isDarkMode}) =>
    !isDarkMode ? Colors.white24 : Colors.black12;
Color getAgainColorOnHover({required final bool isDarkMode}) =>
    !isDarkMode ? Colors.white24 : Colors.black12;
*/
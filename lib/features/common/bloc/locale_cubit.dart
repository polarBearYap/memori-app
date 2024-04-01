import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  final SharedPreferences _prefs;
  static const String key = 'preferredLanguage';
  static const String english = 'en';
  static const String chinese = 'zh';

  LocaleCubit({
    required final SharedPreferences prefs,
  })  : _prefs = prefs,
        super(
          Locale(() {
            final language = prefs.getString(key);
            switch (language) {
              case null:
                return english;
              case english:
                return english;
              case chinese:
                return chinese;
              default:
                return english;
            }
          }()),
        );

  void setLocale(final Locale locale) async {
    switch (locale.languageCode) {
      case english:
        await _prefs.setString(key, english);
        break;
      case chinese:
        await _prefs.setString(key, chinese);
        break;
    }
    emit(locale);
  }
}

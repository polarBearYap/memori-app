import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

AppLocalizations localized(final BuildContext context) {
  try {
    return AppLocalizations.of(context)!;
  } on Exception catch (e, stackTrace) {
    if (kDebugMode) {
      print('Exception: $e');
      print('Stack Trace: $stackTrace');
    }
    rethrow;
  }
}

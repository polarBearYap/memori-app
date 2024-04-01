import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String fontSizeScaleKey = 'preferredFontSizeScale';
const String fontSizeSliderKey = 'preferredFontSizeScaleSliderValue';

void initFontSizeScale(final SharedPreferences prefs) {
  final scaleFactor = prefs.getDouble(fontSizeScaleKey) ?? 1.0;
  FontSizeScale().scaleFactor = scaleFactor;

  final sliderValue = prefs.getDouble(fontSizeSliderKey) ?? 3.0;
  FontSizeScale().sliderValue = sliderValue;

  FontSizeScale().factorDesc = FontSizeScaleFactorExtension.fromScaleFactor(
    sliderValue,
  );
}

class FontSizeScale {
  static final FontSizeScale _instance = FontSizeScale._internal();
  factory FontSizeScale() => _instance;

  FontSizeScale._internal();

  double scaleFactor = 1.0;
  double sliderValue = 3.0;
  FontSizeScaleFactor factorDesc = FontSizeScaleFactor.normal;
}

extension AppSizeExtension on num {
  // double get scaledSp =>
  //     ScreenUtil().setSp(toDouble()) * FontSizeScale().scaleFactor;
  double get scaledSp => ScreenUtil().setSp(this) * FontSizeScale().scaleFactor;
}

enum FontSizeScaleFactor {
  smallest,
  smaller,
  normal,
  bigger,
  biggest,
}

extension FontSizeScaleFactorExtension on FontSizeScaleFactor {
  static FontSizeScaleFactor fromScaleFactor(final double sliderValue) {
    switch (sliderValue) {
      case 1.0:
        return FontSizeScaleFactor.smallest;
      case 2.0:
        return FontSizeScaleFactor.smaller;
      case 3.0:
        return FontSizeScaleFactor.normal;
      case 4.0:
        return FontSizeScaleFactor.bigger;
      case 5.0:
        return FontSizeScaleFactor.biggest;
      default:
        return FontSizeScaleFactor.normal;
    }
  }

  static double toScaleFactor(final double sliderValue) {
    late double finalFactor;
    switch (sliderValue) {
      case 1.0:
        finalFactor = 0.50;
        break;
      case 2.0:
        finalFactor = 0.75;
        break;
      case 3.0:
        finalFactor = 1.0;
        break;
      case 4.0:
        finalFactor = 1.50;
        break;
      case 5.0:
        finalFactor = 1.75;
        break;
      default:
        finalFactor = 1.0;
        break;
    }
    return finalFactor;
  }

  static String toDisplay({
    required final FontSizeScaleFactor factorDesc,
    required final BuildContext context,
  }) {
    switch (factorDesc) {
      case FontSizeScaleFactor.smallest:
        return localized(context).settings_font_size_scale_smallest;
      case FontSizeScaleFactor.smaller:
        return localized(context).settings_font_size_scale_smaller;
      case FontSizeScaleFactor.normal:
        return localized(context).settings_font_size_scale_normal;
      case FontSizeScaleFactor.bigger:
        return localized(context).settings_font_size_scale_bigger;
      case FontSizeScaleFactor.biggest:
        return localized(context).settings_font_size_scale_biggest;
    }
  }
}

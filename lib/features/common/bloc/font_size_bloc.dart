import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'font_size_event.dart';
part 'font_size_state.dart';

class FontSizeCubit extends Cubit<FontSizeState> {
  final SharedPreferences _prefs;

  FontSizeCubit({
    required final SharedPreferences prefs,
  })  : _prefs = prefs,
        super(() {
          initFontSizeScale(prefs);

          return FontSizeState(
            scaleFactor: FontSizeScale().scaleFactor,
            sliderValue: FontSizeScale().sliderValue,
            factorDesc: FontSizeScale().factorDesc,
          );
        }());

  void setScaleFactor(final double sliderValue) async {
    late double scaleFactor = FontSizeScaleFactorExtension.toScaleFactor(
      sliderValue,
    );
    await _prefs.setDouble(fontSizeScaleKey, scaleFactor);
    await _prefs.setDouble(fontSizeSliderKey, sliderValue);
    FontSizeScale().scaleFactor = scaleFactor;
    FontSizeScale().sliderValue = sliderValue;
    FontSizeScale().factorDesc = FontSizeScaleFactorExtension.fromScaleFactor(
      sliderValue,
    );
    emit(
      FontSizeState(
        scaleFactor: scaleFactor,
        sliderValue: sliderValue,
        factorDesc: FontSizeScale().factorDesc,
      ),
    );
  }
}

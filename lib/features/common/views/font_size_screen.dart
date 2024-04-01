import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memori_app/features/common/bloc/font_size_bloc.dart';
import 'package:memori_app/features/decks/bloc/deck/deck_bloc.dart';

class FontSizeAdjuster extends StatefulWidget {
  const FontSizeAdjuster({
    required final double initSliderValue,
    super.key,
  }) : _initFontSizeScaleFactor = initSliderValue;

  final double _initFontSizeScaleFactor;

  @override
  State<FontSizeAdjuster> createState() => _FontSizeAdjusterState();
}

class _FontSizeAdjusterState extends State<FontSizeAdjuster> {
  double _currentSliderValue = 3;

  @override
  void initState() {
    super.initState();
    _currentSliderValue = widget._initFontSizeScaleFactor;
  }

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: colorScheme.primary,
          inactiveTrackColor: colorScheme.primary.withAlpha(100),
          trackShape: const RoundedRectSliderTrackShape(),
          trackHeight: 10,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10), //
          thumbColor: colorScheme.primary,
          overlayColor: colorScheme.primary.withAlpha(50),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 28), //
          tickMarkShape: const RoundSliderTickMarkShape(
            tickMarkRadius: 3,
          ),
          activeTickMarkColor: colorScheme.onPrimary,
          inactiveTickMarkColor: colorScheme.onPrimary,
          valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
          valueIndicatorColor: colorScheme.primary.withAlpha(200),
          valueIndicatorTextStyle: const TextStyle(
            color: Colors.white,
          ),
        ),
        child: Slider(
          value: _currentSliderValue,
          min: 1,
          max: 5,
          divisions: 4,
          label: '${_currentSliderValue.round()} \u2715',
          onChanged: (final value) {
            setState(() {
              context.read<FontSizeCubit>().setScaleFactor(value);
              context.read<DeckBloc>().add(
                    const DeckReloaded(
                      newlyEditedDeckId: '',
                    ),
                  );
              _currentSliderValue = value;
            });
          },
        ),
      ),
    );
  }
}

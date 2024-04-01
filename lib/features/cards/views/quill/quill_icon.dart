import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:memori_app/features/cards/utils/color_utils.dart';
import 'package:memori_app/features/common/bloc/theme_bloc.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/theme_mode.dart';

class HightlightColor extends StatelessWidget {
  HightlightColor({
    super.key,
    required final double width,
    required final Color? color,
    required final VoidCallback? onPressed,
  })  : scaleFactor = width / 90.scaledSp,
        _color = color,
        _onPressed = onPressed;

  final double scaleFactor;
  final Color? _color;
  final VoidCallback? _onPressed;

  @override
  Widget build(final BuildContext context) => InkWell(
        onTap: _onPressed,
        child: LayoutBuilder(
          builder: (final context, final constraints) => Padding(
            padding: const EdgeInsets.only(
              left: 0,
              right: 0,
              /*
                left: isFontSizeBig()
                    ? 0
                    : isPortrait
                        ? 6.w
                        : 3.w,
                right: isFontSizeBig()
                    ? 0
                    : isPortrait
                        ? 9.w
                        : 3.w,
                */
            ),
            child: SizedBox(
              width: 90.scaledSp * scaleFactor,
              height: 90.scaledSp * scaleFactor,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    top: 2.scaledSp * scaleFactor,
                    left: 15.scaledSp * scaleFactor,
                    child: BlocBuilder<ThemeBloc, ThemeState>(
                      buildWhen: (final previous, final current) =>
                          previous.themeMode != current.themeMode,
                      builder: (final context, final state) => Icon(
                        Symbols.ink_highlighter,
                        color: checkIsDarkMode(context: context)
                            ? Colors.white
                            : Colors.black,
                        size: 70.scaledSp * scaleFactor,
                        weight: 350.0,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20.scaledSp * scaleFactor,
                    left: 0,
                    child: Icon(
                      Symbols.horizontal_rule,
                      color: _color,
                      size: 90.scaledSp * scaleFactor,
                      weight: 650.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class TextColor extends StatelessWidget {
  TextColor({
    super.key,
    required final double width,
    required final Color? color,
    required final VoidCallback? onPressed,
    required final QuillController controller,
  })  : scaleFactor = width / 90.scaledSp,
        // _color = color,
        _onPressed = onPressed,
        _controller = controller;

  final double scaleFactor;
  // final Color? _color;
  final VoidCallback? _onPressed;
  final QuillController _controller;

  @override
  Widget build(final BuildContext context) => InkWell(
        onTap: _onPressed,
        child: LayoutBuilder(
          builder: (final context, final constraints) => Padding(
            padding: const EdgeInsets.only(
              left: 0,
              right: 0,
              /*
                left: isFontSizeBig()
                    ? 0
                    : isPortrait
                        ? 6.w
                        : 3.w,
                right: isFontSizeBig()
                    ? 0
                    : isPortrait
                        ? 9.w
                        : 3.w,
                */
            ),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SizedBox(
                  width: 90.scaledSp * scaleFactor,
                  height: 90.scaledSp * scaleFactor,
                  child: BlocBuilder<ThemeBloc, ThemeState>(
                    buildWhen: (final previous, final current) =>
                        previous.themeMode != current.themeMode,
                    builder: (final context, final state) => Icon(
                      Symbols.text_format,
                      color: checkIsDarkMode(context: context)
                          ? Colors.white
                          : Colors.black,
                      size: 90.scaledSp * scaleFactor,
                      weight: 450.0,
                    ),
                  ),
                ),
                Positioned(
                  top: 30.scaledSp * scaleFactor,
                  child: Icon(
                    Symbols.horizontal_rule,
                    color: stringToColor(
                      _controller
                          .getSelectionStyle()
                          .attributes['color']
                          ?.value,
                    ),
                    size: 75.scaledSp * scaleFactor,
                    weight: 700.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

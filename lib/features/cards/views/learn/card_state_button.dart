import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/common/utils/font_size.dart';

class CardStateButton extends StatelessWidget {
  const CardStateButton({
    super.key,
    required final String stateText,
    required final String stateDue,
    required final Color fontColor,
    required final Color backgroundColor,
    required final Color backgroundColorOnHover,
    required final VoidCallback onPressed,
  })  : _stateText = stateText,
        _stateDue = stateDue,
        _fontColor = fontColor,
        _backgroundColor = backgroundColor,
        _backgroundColorOnHover = backgroundColorOnHover,
        _onPressed = onPressed;

  final String _stateText;
  final String _stateDue;
  final Color _fontColor;
  final Color _backgroundColor;
  final Color _backgroundColorOnHover;
  final VoidCallback _onPressed;

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final theme = Theme.of(context);
          final textTheme = theme.textTheme;
          final fontSize = isPortrait
              ? textTheme.bodyMedium!.fontSize!.scaledSp
              : textTheme.bodySmall!.fontSize!.scaledSp;
          final buttonStyle = ButtonStyle(
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(
                horizontal: 18.w,
              ),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0.scaledSp),
                ),
              ),
            ),
          );
          return FilledButton(
            style: buttonStyle.copyWith(
              backgroundColor: MaterialStateProperty.all(
                _backgroundColor,
              ),
              overlayColor: MaterialStateProperty.all(
                _backgroundColorOnHover,
              ),
            ),
            onPressed: _onPressed,
            child: Column(
              children: [
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  _stateText,
                  style: TextStyle(
                    color: _fontColor,
                    fontSize: fontSize,
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                if (_stateDue.isNotEmpty)
                  Text(
                    _stateDue,
                    style: TextStyle(
                      color: _fontColor,
                      fontSize: fontSize * 0.7,
                    ),
                  ),
                if (_stateDue.isNotEmpty)
                  SizedBox(
                    height: 3.h,
                  ),
              ],
            ),
          );
        },
      );
}

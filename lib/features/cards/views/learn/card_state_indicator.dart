import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/common/utils/font_size.dart';

class CardStateIndicator extends StatelessWidget {
  final Color _color;
  final String _cardState;
  final String _count;

  const CardStateIndicator({
    super.key,
    required final Color color,
    required final String cardState,
    required final String count,
  })  : _color = color,
        _cardState = cardState,
        _count = count;

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final textTheme = Theme.of(context).textTheme;
          final fontSize = isPortrait
              ? textTheme.labelMedium!.fontSize!.scaledSp
              : textTheme.labelSmall!.fontSize!.scaledSp * 0.6;
          final factor = FontSizeScale().factorDesc;
          final width = () {
            switch (factor) {
              case FontSizeScaleFactor.biggest:
              case FontSizeScaleFactor.bigger:
                return isPortrait ? 25.w : 15.w;
              case FontSizeScaleFactor.normal:
                return isPortrait ? 20.w : 12.w;
              case FontSizeScaleFactor.smaller:
                return isPortrait ? 20.w : 10.w;
              case FontSizeScaleFactor.smallest:
                return isPortrait ? 15.w : 5.w;
            }
          }();
          return Column(
            children: [
              Container(
                width: width,
                height: width,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _color,
                ),
              ),
              Text(
                _cardState,
                style: TextStyle(
                  fontSize: fontSize,
                ),
              ),
              Text(
                _count,
                style: TextStyle(
                  fontSize: fontSize,
                ),
              ),
            ],
          );
        },
      );
}

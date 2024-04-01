import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:showcaseview/showcaseview.dart';

void startShowcase(
  final BuildContext context,
  final List<GlobalKey> widgetIds,
) {
  ShowCaseWidget.of(
    context,
  ).startShowCase(widgetIds);
}

void dismissShowcase(
  final BuildContext context,
) {
  ShowCaseWidget.of(
    context,
  ).dismiss();
}

class CustomShowcaseWidget extends StatelessWidget {
  const CustomShowcaseWidget({
    required final String title,
    required final String desc,
    final EdgeInsets? padding,
    required final ShapeBorder targetShapeBorder,
    required final VoidCallback onTargetClick,
    final VoidCallback? onBarrierClick,
    final bool? disableDefaultTargetGestures,
    final bool onTargetClickApplyOnContainer = false,
    final TooltipPosition? tooltipPosition,
    final double? speechBubbleLeft,
    final double? speechBubbleRight,
    final double? containerMaxWidth,
    final int? containerFlexLeft,
    final int? containerFlexRight,
    final bool hideTooltip = false,
    required final GlobalKey showcaseKey,
    required final Widget child,
    super.key,
  })  : _title = title,
        _desc = desc,
        _padding = padding,
        _targetShapeBorder = targetShapeBorder,
        _onTargetClick = onTargetClick,
        _onBarrierClick = onBarrierClick,
        _disableDefaultTargetGestures = disableDefaultTargetGestures,
        _onTargetClickApplyOnContainer = onTargetClickApplyOnContainer,
        _tooltipPosition = tooltipPosition,
        _speechBubbleLeft = speechBubbleLeft,
        _speechBubbleRight = speechBubbleRight,
        _hideTooltip = hideTooltip,
        _containerMaxWidth = containerMaxWidth,
        _containerFlexLeft = containerFlexLeft,
        _containerFlexRight = containerFlexRight,
        _showcaseKey = showcaseKey,
        _child = child;

  final String _title;
  final String _desc;
  final EdgeInsets? _padding;
  final ShapeBorder _targetShapeBorder;
  final bool _onTargetClickApplyOnContainer;
  final VoidCallback _onTargetClick;
  final VoidCallback? _onBarrierClick;
  final bool? _disableDefaultTargetGestures;
  final TooltipPosition? _tooltipPosition;
  final double? _speechBubbleLeft;
  final double? _speechBubbleRight;
  final double? _containerMaxWidth;
  final int? _containerFlexLeft;
  final int? _containerFlexRight;
  final bool _hideTooltip;
  final GlobalKey _showcaseKey;
  final Widget _child;

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final colorScheme = Theme.of(context).colorScheme;
          final textTheme = Theme.of(context).textTheme;
          final titleFontSize = isPortrait
              ? textTheme.titleSmall!.fontSize!.scaledSp
              : textTheme.titleSmall!.fontSize!.scaledSp * 0.7;
          final descFontSize = isPortrait
              ? textTheme.labelSmall!.fontSize!.scaledSp
              : textTheme.labelSmall!.fontSize!.scaledSp * 0.7;
          final tooltipPosition = _tooltipPosition ?? TooltipPosition.top;

          final screenWidth = MediaQuery.of(context).size.width;

          final tooltipSize = isPortrait
              ? () {
                  final factor = FontSizeScale().factorDesc;
                  switch (factor) {
                    case FontSizeScaleFactor.biggest:
                    case FontSizeScaleFactor.bigger:
                      return 40.w;
                    case FontSizeScaleFactor.normal:
                      return 30.w;
                    case FontSizeScaleFactor.smaller:
                    case FontSizeScaleFactor.smallest:
                      return 20.w;
                  }
                }()
              : () {
                  final factor = FontSizeScale().factorDesc;
                  switch (factor) {
                    case FontSizeScaleFactor.biggest:
                    case FontSizeScaleFactor.bigger:
                      return 25.w;
                    case FontSizeScaleFactor.normal:
                      return 20.w;
                    case FontSizeScaleFactor.smaller:
                    case FontSizeScaleFactor.smallest:
                      return 15.w;
                  }
                }();

          return Showcase.withWidget(
            targetPadding: _padding ??
                EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 10.h,
                ),
            key: _showcaseKey,
            // title: _title,
            // description: _desc,
            // titleTextStyle: TextStyle(
            //   color: colorScheme.onPrimary,
            //   fontSize: titleFontSize,
            // ),
            // descTextStyle: TextStyle(
            //   color: colorScheme.onPrimary,
            //   fontSize: descFontSize,
            // ),
            // tooltipBackgroundColor: colorScheme.primary,
            // tooltipPadding: EdgeInsets.symmetric(
            //   horizontal: 5.w,
            //   vertical: 8.h,
            // ),
            // textColor: colorScheme.onPrimary,
            width: screenWidth,
            height: 100.h,
            container: GestureDetector(
              onTap: () {
                if (_onTargetClickApplyOnContainer) {
                  _onTargetClick();
                }
              },
              child: SizedBox(
                width: isScreenPhone(context) ? 330.w : 350.w,
                child: Row(
                  children: [
                    Spacer(
                      // flex: isPortrait ? 3 : 5,
                      flex: _containerFlexLeft ?? 1,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        if (!_hideTooltip &&
                            tooltipPosition == TooltipPosition.bottom)
                          Positioned(
                            top: -8.h,
                            left: _speechBubbleLeft,
                            right: _speechBubbleRight,
                            child: CustomPaint(
                              size: Size(
                                tooltipSize,
                                10.h,
                              ),
                              painter: SpeechBubbleUpPainter(
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: min(
                              _containerMaxWidth ?? screenWidth,
                              300.w,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: colorScheme.onPrimary,
                                  fontSize: titleFontSize,
                                ),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                _desc,
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: colorScheme.onPrimary,
                                  fontSize: descFontSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!_hideTooltip &&
                            tooltipPosition == TooltipPosition.top)
                          Positioned(
                            bottom: -8.h,
                            // right: 5.w,
                            left: _speechBubbleLeft,
                            right: _speechBubbleRight,
                            child: CustomPaint(
                              size: Size(
                                tooltipSize,
                                10.h,
                              ),
                              painter: SpeechBubbleDownPainter(
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Spacer(
                      flex: _containerFlexRight ?? 1,
                    ),
                  ],
                ),
              ),
            ),

            targetShapeBorder: _targetShapeBorder,
            disposeOnTap: true,
            onTargetClick: _onTargetClick,
            onBarrierClick: _onBarrierClick,
            disableDefaultTargetGestures:
                _disableDefaultTargetGestures ?? false,
            tooltipPosition: tooltipPosition,
            child: _child,
          );
        },
      );
}

class SpeechBubbleUpPainter extends CustomPainter {
  final Color color;

  SpeechBubbleUpPainter({required this.color});

  @override
  void paint(final Canvas canvas, final Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(
        size.width / 4,
        size.height,
      )
      ..lineTo(
        3 * size.width / 4,
        size.height,
      )
      ..lineTo(size.width / 2, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(final CustomPainter oldDelegate) => false;
}

class SpeechBubbleDownPainter extends CustomPainter {
  final Color color;

  SpeechBubbleDownPainter({required this.color});

  @override
  void paint(final Canvas canvas, final Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(
        size.width / 2,
        size.height,
      )
      ..lineTo(size.width / 4, 0)
      ..lineTo(3 * size.width / 4, 0)
      ..lineTo(
        size.width / 2,
        size.height,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(final CustomPainter oldDelegate) => false;
}

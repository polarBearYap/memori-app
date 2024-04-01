import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/theme_mode.dart';

class LearningLinearProgressIndicator extends StatefulWidget {
  final int totalSteps;
  final int currentSteps;

  const LearningLinearProgressIndicator({
    super.key,
    required this.totalSteps,
    required this.currentSteps,
  });

  @override
  State<LearningLinearProgressIndicator> createState() =>
      _LearningLinearProgressIndicatorState();
}

class _LearningLinearProgressIndicatorState
    extends State<LearningLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: _calculateProgress(widget.currentSteps, widget.totalSteps),
      end: widget.totalSteps.toDouble(),
    ).animate(_animationController);
  }

  @override
  void didUpdateWidget(
    covariant final LearningLinearProgressIndicator oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (widget.totalSteps != oldWidget.totalSteps) {
      double newProgress =
          _calculateProgress(widget.currentSteps, widget.totalSteps);
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: newProgress,
      ).animate(_animationController);
      _animationController.forward(from: 0.0);
    } else if (widget.currentSteps != oldWidget.currentSteps) {
      double newProgress =
          _calculateProgress(widget.currentSteps, widget.totalSteps);
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: newProgress,
      ).animate(_animationController);
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double _calculateProgress(final int currentSteps, final int totalSteps) =>
      totalSteps > 0 ? currentSteps / totalSteps : 0.0;

  @override
  Widget build(final BuildContext context) {
    final isDarkMode = checkIsDarkMode(context: context);
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 25.w,
        ),
        Expanded(
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (final context, final child) => LinearProgressIndicator(
              value: _progressAnimation.value,
              borderRadius: BorderRadius.circular(20.0.scaledSp),
              backgroundColor:
                  !isDarkMode ? Colors.grey[400] : colorScheme.onBackground,
              color: !isDarkMode ? colorScheme.tertiary : Colors.blue[500],
              minHeight: 5.h,
            ),
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        LayoutBuilder(
          builder: (final context, final constraints) {
            final isPortrait =
                MediaQuery.of(context).orientation == Orientation.portrait;
            final textTheme = Theme.of(context).textTheme;
            final fontSize = isPortrait
                ? textTheme.labelSmall!.fontSize!.scaledSp
                : textTheme.labelSmall!.fontSize!.scaledSp * 0.6;
            return Text(
              '${widget.currentSteps} / ${widget.totalSteps}',
              style: TextStyle(fontSize: fontSize),
            );
          },
        ),
        SizedBox(
          width: 25.w,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memori_app/features/common/bloc/theme_bloc.dart';
import 'package:memori_app/features/common/utils/theme_mode.dart';

class MemoriLogo extends StatelessWidget {
  const MemoriLogo({
    final double scaleFactor = 1.0,
    final bool includeText = true,
    super.key,
  })  : _scaleFactor = scaleFactor,
        _includeText = includeText;

  final double _scaleFactor;
  final bool _includeText;

  @override
  Widget build(final BuildContext context) =>
      BlocBuilder<ThemeBloc, ThemeState>(
        buildWhen: (final previous, final current) =>
            previous.themeMode != current.themeMode,
        builder: (final context, final state) {
          final isDarkMode = checkIsDarkMode(context: context);
          final String assetName =
              'assets/logos/memori_logo${_includeText ? '' : '_short'}${isDarkMode ? '_dark' : ''}.svg';
          return SvgPicture.asset(
            assetName,
            placeholderBuilder: (final BuildContext context) => Container(
              padding: const EdgeInsets.all(30.0),
              child: const CircularProgressIndicator(),
            ),
            // width: 280.w * _scaleFactor,
            height: 150.h * _scaleFactor,
          );
        },
      );
}

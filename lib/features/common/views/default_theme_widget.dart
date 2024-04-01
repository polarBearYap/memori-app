import 'package:flutter/material.dart';
import 'package:memori_app/features/common/utils/media_query.dart';

class DefaultTheme extends StatelessWidget {
  const DefaultTheme({
    required final Widget child,
    super.key,
  }) : _child = child;

  final Widget _child;

  @override
  Widget build(final BuildContext context) => Theme(
        data: getDefaultThemeData(
          context: context,
        ),
        child: _child,
      );
}

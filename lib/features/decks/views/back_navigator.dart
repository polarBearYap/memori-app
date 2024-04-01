import 'package:flutter/material.dart';
import 'package:memori_app/features/common/utils/font_size.dart';

class BackNavigator extends StatelessWidget {
  const BackNavigator({super.key});

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          return IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              size: isPortrait ? 20.scaledSp : 10.scaledSp,
            ),
          );
        },
      );
}

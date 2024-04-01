import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/media_query.dart';

class ExpandableFormField extends StatelessWidget {
  const ExpandableFormField({
    required final String title,
    required final IconData iconData,
    required final List<Widget> children,
    final EdgeInsetsGeometry? childrenPadding,
    final bool isInitExpanded = false,
    final ExpansionTileController? tileController,
    super.key,
  })  : _title = title,
        _iconData = iconData,
        _children = children,
        _childrenPadding = childrenPadding,
        _isInitExpanded = isInitExpanded,
        _tileController = tileController;

  final String _title;
  final IconData _iconData;
  final List<Widget> _children;
  final EdgeInsetsGeometry? _childrenPadding;
  final bool _isInitExpanded;
  final ExpansionTileController? _tileController;

  //TODO: When used with scrolling widgets like ListView, a unique PageStorageKey must be specified as the key, to enable the ExpansionTile to save and restore its expanded state when it is scrolled in and out of view.
  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final containerColor = Theme.of(context).colorScheme.surface;
          final shapeBorder = RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
            side: BorderSide(
              color: containerColor,
              width: 2.0,
            ),
          );
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          double iconSize = isPortrait ? 20.scaledSp : 12.scaledSp;
          if (isFontSizeBig()) {
            iconSize *= 0.8;
          }
          final textTheme = Theme.of(context).textTheme;
          final fontSize = isPortrait
              ? textTheme.bodyMedium!.fontSize!.scaledSp
              : textTheme.bodySmall!.fontSize!.scaledSp * 0.6;
          return Card(
            elevation: 4,
            shape: shapeBorder,
            child: ExpansionTile(
              initiallyExpanded: _isInitExpanded,
              controller: _tileController,
              visualDensity: getVisualDensity(),
              expansionAnimationStyle: AnimationStyle(
                curve: Curves.fastOutSlowIn,
                duration: const Duration(milliseconds: 300),
                reverseCurve: Curves.fastLinearToSlowEaseIn,
                reverseDuration: const Duration(milliseconds: 300),
              ),
              shape: shapeBorder,
              collapsedShape: shapeBorder,
              maintainState: true,
              // backgroundColor: Colors.white,
              // collapsedBackgroundColor: Colors.white,
              backgroundColor: containerColor,
              collapsedBackgroundColor: containerColor,
              textColor: containerColor,
              childrenPadding: _childrenPadding ??
                  EdgeInsets.only(
                    left: 15.w,
                    right: 15.w,
                  ),
              leading: Icon(
                _iconData,
                size: iconSize,
              ),
              title: Text(
                _title,
                style: TextStyle(
                  fontSize: fontSize,
                ),
              ),
              children: _children,
            ),
          );
        },
      );
}

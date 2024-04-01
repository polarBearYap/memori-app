import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';

class SelectedTagChip extends StatelessWidget {
  final String _label;
  final bool _disableDelete;
  final VoidCallback _onDelete;

  const SelectedTagChip({
    super.key,
    required final String label,
    required final VoidCallback onDelete,
    required final bool disableDelete,
  })  : _label = label,
        _onDelete = onDelete,
        _disableDelete = disableDelete;

  @override
  Widget build(final BuildContext context) {
    if (_disableDelete) {
      return LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final textTheme = Theme.of(context).textTheme;
          final fontSize = isPortrait
              ? textTheme.labelSmall!.fontSize!.scaledSp
              : textTheme.labelSmall!.fontSize!.scaledSp * 0.6;
          return Chip(
            label: Text(
              _label,
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
            labelPadding: EdgeInsets.only(
              left: 3.w,
              right: 3.w,
            ),
          );
        },
      );
    }
    return LayoutBuilder(
      builder: (final context, final constraints) {
        final isPortrait =
            MediaQuery.of(context).orientation == Orientation.portrait;
        final textTheme = Theme.of(context).textTheme;
        final fontSize = isPortrait
            ? textTheme.labelSmall!.fontSize!.scaledSp
            : textTheme.labelSmall!.fontSize!.scaledSp * 0.6;
        final iconSize = isPortrait ? 15.scaledSp : 8.scaledSp;
        return Chip(
          label: Text(
            _label,
            style: TextStyle(
              fontSize: fontSize,
            ),
          ),
          deleteIcon: Icon(
            Icons.close,
            size: iconSize,
          ),
          onDeleted: _onDelete,
          deleteButtonTooltipMessage:
              localized(context).card_tag_tooltip_delete,
          labelPadding: EdgeInsets.only(
            left: isPortrait ? 10.w : 5.w,
            right: 3.w,
          ),
          padding: EdgeInsets.zero,
        );
      },
    );
  }
}

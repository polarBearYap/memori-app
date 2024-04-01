import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/cards/views/quill/quill_screen.dart';
import 'package:memori_app/features/common/utils/font_size.dart';

typedef ShowcaseWidgetBuilderFunction = Widget Function(
  GlobalKey key,
  VoidCallback callback,
  Widget widget,
);

class CardPopupEditor extends StatelessWidget {
  const CardPopupEditor({
    super.key,
    required final void Function(Object?)? onClosed,
    required final Document document,
    required final Document documentView,
    required final String title,
    final double? editorMaxHeight,
    final bool disableEditPopup = false,
  })  : _onClosed = onClosed,
        _document = document,
        _documentView = documentView,
        _title = title,
        _editorMaxHeight = editorMaxHeight,
        _disableEditPopup = disableEditPopup;

  final void Function(Object?)? _onClosed;
  final Document _document;
  final Document _documentView;
  final String _title;
  final double? _editorMaxHeight;
  final bool _disableEditPopup;

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final openContainerColor = Theme.of(context).colorScheme.surface;
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          return OpenContainer(
            closedColor: openContainerColor,
            openColor: openContainerColor,
            transitionType: ContainerTransitionType.fadeThrough,
            transitionDuration: const Duration(
              milliseconds: 500,
            ),
            openBuilder: (
              final BuildContext context,
              final VoidCallback _,
            ) =>
                QuillScreen(
              title: _title,
              titleAlign: TextAlign.start,
              document: _document,
              disposeDocument: false,
            ),
            onClosed: _onClosed,
            tappable: false,
            closedBuilder: (
              final BuildContext _,
              final VoidCallback openContainer,
            ) =>
                QuillScreen(
              title: _title,
              titleAlign: TextAlign.start,
              document: _documentView,
              isReadOnly: true,
              isEditable: false,
              isWholeScreen: false,
              editorMaxHeight: _editorMaxHeight ?? 300.h,
              trailingActionButtons: [
                if (!_disableEditPopup)
                  IconButton(
                    onPressed: openContainer,
                    icon: Icon(
                      Icons.edit,
                      size: isPortrait ? 20.scaledSp : 12.scaledSp,
                    ),
                  ),
              ],
            ),
          );
        },
      );
}

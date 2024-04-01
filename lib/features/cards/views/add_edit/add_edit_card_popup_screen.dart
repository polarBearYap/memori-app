import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/cards/views/common/card_popup_editor.dart';
import 'package:memori_app/features/cards/views/common/expandable_form_field.dart';
import 'package:memori_app/features/cards/views/quill/quill_screen.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/views/showcase_widget.dart';

class AddEditCardPopupScreen extends StatelessWidget {
  const AddEditCardPopupScreen({
    required final ScrollController scrollController,
    required final ExpansionTileController tileController,
    required final String title,
    required final IconData iconData,
    required final Document document,
    required final Document documentView,
    required final bool isShowcasingEditButton,
    required final bool isShowcasingQuill,
    required final String showcaseTitle,
    required final String showcaseDescription,
    required final CardSide cardSide,
    required final VoidCallback onCloseEdit,
    super.key,
  })  : _tileController = tileController,
        _iconData = iconData,
        _title = title,
        _scrollController = scrollController,
        _isShowcasingEditButton = isShowcasingEditButton,
        _isShowcasingQuill = isShowcasingQuill,
        _showcaseTitle = showcaseTitle,
        _showcaseDescription = showcaseDescription,
        _cardSide = cardSide,
        _document = document,
        _documentView = documentView,
        _onCloseEdit = onCloseEdit;

  final ScrollController _scrollController;
  final ExpansionTileController _tileController;

  final String _title;
  final IconData _iconData;

  final Document _document;
  final Document _documentView;

  final bool _isShowcasingEditButton;
  final bool _isShowcasingQuill;
  final String _showcaseTitle;
  final String _showcaseDescription;

  final CardSide _cardSide;

  final VoidCallback _onCloseEdit;

  Widget buildShowcasingWidget({
    required final BuildContext context,
    required final bool isPortrait,
  }) {
    openContainer() {
      Navigator.of(context)
          .push(
        PageRouteBuilder(
          pageBuilder: (
            final context,
            final animation,
            final secondaryAnimation,
          ) =>
              QuillScreen(
            title: _title,
            titleAlign: TextAlign.start,
            document: _document,
            disposeDocument: false,
            isShowcasingQuill: _isShowcasingQuill,
          ),
          transitionsBuilder: (
            final context,
            final animation,
            final secondaryAnimation,
            final child,
          ) =>
              SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.scaled,
            child: child,
          ),
        ),
      )
          .then((final result) {
        _onCloseEdit();
      });
    }

    return QuillScreen(
      title: _title,
      titleAlign: TextAlign.start,
      document: _documentView,
      isReadOnly: true,
      isEditable: false,
      isWholeScreen: false,
      editorMaxHeight: 300.h,
      isShowcasingEditButton: _isShowcasingEditButton,
      cardSide: _cardSide,
      showcaseEditButton: (final key) => CustomShowcaseWidget(
        title: _showcaseTitle,
        desc: _showcaseDescription,
        showcaseKey: key,
        targetShapeBorder: const CircleBorder(),
        disableDefaultTargetGestures: false,
        speechBubbleRight: 0,
        containerFlexLeft: isPortrait ? 7 : 9,
        padding: EdgeInsets.symmetric(
          horizontal: 3.w,
          vertical: 3.w,
        ),
        onTargetClick: openContainer,
        child: IconButton(
          onPressed: openContainer,
          icon: Icon(
            Icons.edit,
            size: isPortrait ? 20.scaledSp : 12.scaledSp,
          ),
        ),
      ),
    );
  }

  Widget buildNormalWidget({
    required final BuildContext context,
    required final bool isPortrait,
  }) =>
      CardPopupEditor(
        title: _title,
        document: _document,
        documentView: _documentView,
        onClosed: (final value) {
          _onCloseEdit();
        },
      );

  @override
  Widget build(final BuildContext context) => ExpandableFormField(
        tileController: _tileController,
        iconData: _iconData,
        title: _title,
        childrenPadding: EdgeInsets.zero,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 350.h,
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: LayoutBuilder(
                builder: (final context, final constraints) {
                  final isPortrait = MediaQuery.of(context).orientation ==
                      Orientation.portrait;
                  if (_isShowcasingEditButton) {
                    return buildShowcasingWidget(
                      context: context,
                      isPortrait: isPortrait,
                    );
                  } else {
                    return buildNormalWidget(
                      context: context,
                      isPortrait: isPortrait,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      );
}

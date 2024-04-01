import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/cards/utils/default_quill_style.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';

class CustomQuillEditor extends StatelessWidget {
  const CustomQuillEditor({
    required final QuillEditorConfigurations configurations,
    required final ScrollController scrollController,
    required final FocusNode focusNode,
    super.key,
  })  : _configurations = configurations,
        _scrollController = scrollController,
        _focusNode = focusNode;

  final QuillEditorConfigurations _configurations;
  final ScrollController _scrollController;
  final FocusNode _focusNode;

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          return QuillEditor(
            scrollController: _scrollController,
            focusNode: _focusNode,
            configurations: _configurations.copyWith(
              elementOptions: const QuillEditorElementOptions(
                orderedList: QuillEditorOrderedListElementOptions(
                  useTextColorForDot: true,
                ),
                unorderedList: QuillEditorUnOrderedListElementOptions(
                  useTextColorForDot: true,
                ),
              ),
              scrollable: true,
              placeholder: localized(context).card_editor_placeholder,
              padding: EdgeInsets.all(16.w),
              customStyles: getAppDefaultStyle(
                context: context,
                fontScale: isPortrait ? 1.scaledSp : 1.scaledSp * 0.6,
              ),
            ),
          );
        },
      );
}

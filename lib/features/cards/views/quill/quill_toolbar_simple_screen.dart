import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/common/utils/localization.dart';

class SimpleQuillToolbar extends StatelessWidget {
  const SimpleQuillToolbar({
    required final QuillController controller,
    super.key,
  }) : _controller = controller;

  final QuillController _controller;

  @override
  Widget build(final BuildContext context) => QuillToolbar.simple(
        configurations: QuillSimpleToolbarConfigurations(
          buttonOptions: QuillSimpleToolbarButtonOptions(
            base: QuillToolbarBaseButtonOptions(
              iconTheme: QuillIconTheme(
                iconButtonSelectedData: IconButtonData(
                  iconSize: 25.w,
                  padding: EdgeInsets.all(3.w),
                  alignment: Alignment.center,
                  /*style: ButtonStyle(
                    backgroundColor: Theme.of(context)
                        .iconButtonTheme
                        .style!
                        .backgroundColor,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                    ),
                  ),*/
                ),
                iconButtonUnselectedData: IconButtonData(
                  iconSize: 25.w,
                  padding: EdgeInsets.all(3.w),
                  alignment: Alignment.center,
                  /*style: ButtonStyle(
                    backgroundColor: Theme.of(context)
                        .iconButtonTheme
                        .style!
                        .backgroundColor,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                    ),
                  ),*/
                ),
              ),
            ),
          ),
          // color: Theme.of(context).colorScheme.tertiary,
          controller: _controller,
          customButtons: const [
            /*
            QuillToolbarCustomButtonOptions(
                icon: const Icon(Icons.dashboard_customize),
                onPressed: () {
                  context.read<SettingsCubit>().updateSettings(
                      state.copyWith(useCustomQuillToolbar: true));
                },
              ),
             */
          ],
          fontFamilyValues: {
            localized(context).language_value_english: 'NotoSans',
            localized(context).language_value_chinese: 'NotoSansSC',
          },
          fontSizesValues: const {
            '8': '8.0',
            '9': '9.0',
            '10': '10.0',
            '11': '11.0',
            '12': '12.0',
            '14': '14.0',
            '16': '16.0',
            '18': '18.0',
            '20': '20.0',
            '22': '22.0',
            '24': '24.0',
            '26': '26.0',
            '28': '28.0',
            '36': '36.0',
            '48': '48.0',
            '72': '72.0',
          },
          headerStyleType: HeaderStyleType.original,
          linkStyleType: LinkStyleType.original,
          multiRowsDisplay: true,
          sectionDividerColor: Theme.of(context).colorScheme.onTertiary,
          sectionDividerSpace: 5.w,
          showAlignmentButtons: true,
          showBackgroundColorButton: true,
          showBoldButton: true,
          showCenterAlignment: true,
          showClearFormat: true,
          showCodeBlock: true,
          showColorButton: true,
          showDirection: true,
          showDividers: true,
          showFontFamily: true,
          showFontSize: true,
          showHeaderStyle: true,
          showIndent: true,
          showInlineCode: true,
          showItalicButton: true,
          showJustifyAlignment: true,
          showLeftAlignment: true,
          showLink: false,
          showListBullets: true,
          showListCheck: true,
          showListNumbers: true,
          showQuote: true,
          showRedo: true,
          showRightAlignment: true,
          showSearchButton: true,
          showSmallButton: true,
          showStrikeThrough: true,
          showSubscript: true,
          showSuperscript: true,
          showUnderLineButton: true,
          showUndo: true,
          toolbarIconAlignment: WrapAlignment.center,
          toolbarIconCrossAlignment: WrapCrossAlignment.center,
        ),
      );
}

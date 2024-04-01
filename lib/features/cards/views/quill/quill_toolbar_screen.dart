import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/cards/bloc/quill/quill_bloc.dart';
import 'package:memori_app/features/cards/views/quill/quill_fontsize_dropdown.dart';
import 'package:memori_app/features/cards/views/quill/quill_header_dropdown.dart';
import 'package:memori_app/features/cards/views/quill/quill_icon.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';

class BottomQuillToolBar extends StatefulWidget {
  const BottomQuillToolBar({
    required final QuillController controller,
    required final FocusNode editorFocusNode,
    final bool initExpand = false,
    super.key,
  })  : _controller = controller,
        _initExpand = initExpand;

  final QuillController _controller;
  // final FocusNode _editorFocusNode;
  final bool _initExpand;

  @override
  State<StatefulWidget> createState() => _BottomQuillToolBarState();
}

class _BottomQuillToolBarState extends State<BottomQuillToolBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotateAnimation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.fastLinearToSlowEaseIn,
      ),
    );
    if (widget._initExpand) {
      _toggleExpand();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(final BottomQuillToolBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._controller != oldWidget._controller ||
        widget._initExpand != oldWidget._initExpand) {
      if (widget._initExpand) {
        _toggleExpand();
      }
    }
  }

  void _toggleExpand() {
    setState(() {
      if (_isExpanded) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final iconSize = isPortrait ? 20.scaledSp : 12.scaledSp;
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: isPortrait ? 260.h : 270.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  height: isFontSizeBig()
                      ? 60.h
                      : isPortrait
                          ? 40.h
                          : 50.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _TopQuillToolBar(
                          controller: widget._controller,
                        ),
                      ),
                      VerticalDivider(
                        width: 0,
                        thickness: 1.5,
                        indent: 10,
                        endIndent: 10,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      RotationTransition(
                        turns: _rotateAnimation,
                        child: IconButton(
                          onPressed: _toggleExpand,
                          icon: Icon(
                            Icons.expand_more,
                            size: iconSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizeTransition(
                  sizeFactor: _animationController,
                  axis: Axis.vertical,
                  axisAlignment: -1.0,
                  child: SizedBox(
                    height: 200.h,
                    child: _BottomExpandedQuillToolBar(
                      controller: widget._controller,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
}

class _BottomExpandedQuillToolBar extends StatelessWidget {
  const _BottomExpandedQuillToolBar({
    required final QuillController controller,
  }) : _controller = controller;

  final QuillController _controller;

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final iconSize = isPortrait ? 12.scaledSp : 6.scaledSp;
          final listTileIconSize = isPortrait ? 18.scaledSp : 6.scaledSp;
          final textTheme = Theme.of(context).textTheme;
          final fontSize = isPortrait
              ? textTheme.labelMedium!.fontSize!.scaledSp
              : textTheme.labelSmall!.fontSize!.scaledSp * 0.6;

          final onSurfaceColor = Theme.of(context).colorScheme.onSurface;

          final quillIconTheme = getQuillIconTheme();
          final quillToggleOption = QuillToolbarToggleStyleButtonOptions(
            iconTheme: quillIconTheme,
            iconSize: iconSize,
          );
          final quillIndentOption = QuillToolbarIndentButtonOptions(
            iconTheme: quillIconTheme,
            iconSize: iconSize,
          );

          final scaleFactor = isPortrait ? 1.scaledSp : 0.7.scaledSp;

          return ListView(
            children: [
              SizedBox(
                height: isPortrait
                    ? (isFontSizeBig() ? 50.h : 35.h)
                    : (isFontSizeBig() ? 60.h : 35.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomQuillToolbarSelectHeaderStyleDropdownButton(
                        controller: _controller,
                      ),
                    ),
                    VerticalDivider(
                      width: 0,
                      thickness: 0.5,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    Expanded(
                      child: CustomQuillToolbarFontSizeButton(
                        controller: _controller,
                        options: QuillToolbarFontSizeButtonOptions(
                          defaultDisplayText: '12',
                          rawItemsMap: {
                            '8': '${8.0 * scaleFactor}',
                            '9': '${9.0 * scaleFactor}',
                            '10': '${10.0 * scaleFactor}',
                            '11': '${11.0 * scaleFactor}',
                            '12': '${12.0 * scaleFactor}',
                            '14': '${14.0 * scaleFactor}',
                            '16': '${16.0 * scaleFactor}',
                            '18': '${18.0 * scaleFactor}',
                            '20': '${20.0 * scaleFactor}',
                            '22': '${22.0 * scaleFactor}',
                            '24': '${24.0 * scaleFactor}',
                            '26': '${26.0 * scaleFactor}',
                            '28': '${28.0 * scaleFactor}',
                            '36': '${36.0 * scaleFactor}',
                            '48': '${48.0 * scaleFactor}',
                            '72': '${72.0 * scaleFactor}',
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                thickness: 0.5, // Adjust thickness as needed
                color: onSurfaceColor, // Adjust color as needed
              ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: QuillToolbarToggleStyleButton(
                        options: quillToggleOption,
                        controller: _controller,
                        attribute: Attribute.bold,
                      ),
                    ),
                    Expanded(
                      child: QuillToolbarToggleStyleButton(
                        options: quillToggleOption,
                        controller: _controller,
                        attribute: Attribute.italic,
                      ),
                    ),
                    Expanded(
                      child: QuillToolbarToggleStyleButton(
                        options: quillToggleOption,
                        controller: _controller,
                        attribute: Attribute.underline,
                      ),
                    ),
                    Expanded(
                      child: QuillToolbarToggleStyleButton(
                        options: quillToggleOption,
                        controller: _controller,
                        attribute: Attribute.strikeThrough,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                thickness: 0.5, // Adjust thickness as needed
                color: onSurfaceColor, // Adjust color as needed
              ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: QuillToolbarToggleStyleButton(
                        options: quillToggleOption,
                        controller: _controller,
                        attribute: Attribute.subscript,
                      ),
                    ),
                    Expanded(
                      child: QuillToolbarToggleStyleButton(
                        options: quillToggleOption,
                        controller: _controller,
                        attribute: Attribute.superscript,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                thickness: 0.5, // Adjust thickness as needed
                color: onSurfaceColor, // Adjust color as needed
              ),
              QuillToolbarColorButton(
                controller: _controller,
                isBackground: true,
                options: QuillToolbarColorButtonOptions(
                  childBuilder: (
                    final QuillToolbarColorButtonOptions options,
                    final QuillToolbarColorButtonExtraOptions extraOptions,
                  ) =>
                      InkWell(
                    onTap: extraOptions.onPressed,
                    child: ListTile(
                      dense: true,
                      titleAlignment: ListTileTitleAlignment.titleHeight,
                      visualDensity: getVisualDensity(),
                      leading: Padding(
                        padding: EdgeInsets.only(
                          left: isPortrait
                              ? 6.w
                              : (isFontSizeSmall() ? 5.w : 3.w),
                          right: isPortrait ? 10.w : 3.w,
                        ),
                        child: Transform.scale(
                          scale: () {
                            final factor = FontSizeScale().factorDesc;
                            switch (factor) {
                              case FontSizeScaleFactor.biggest:
                                return isPortrait ? 1.75 : 1.25;
                              case FontSizeScaleFactor.bigger:
                                return isPortrait ? 1.5 : 1.25;
                              case FontSizeScaleFactor.normal:
                                return isPortrait ? 1.75 : 1.50;
                              case FontSizeScaleFactor.smaller:
                                return isPortrait ? 1.50 : 1.0;
                              case FontSizeScaleFactor.smallest:
                                return isPortrait ? 1.50 : 1.0;
                            }
                          }(),
                          child: Transform.translate(
                            offset: Offset(1.scaledSp, 1.scaledSp),
                            child: HightlightColor(
                              width: iconSize,
                              color: extraOptions.iconColorBackground,
                              // onPressed: extraOptions.onPressed,
                              onPressed: null,
                            ),
                          ),
                        ),
                      ),
                      title: Padding(
                        padding: EdgeInsets.only(
                          left: isPortrait
                              ? (isFontSizeBig()
                                  ? 12.w
                                  : (FontSizeScale().factorDesc ==
                                          FontSizeScaleFactor.smallest
                                      ? 3.w
                                      : 6.w))
                              : (isFontSizeBig()
                                  ? 4.w
                                  : (isFontSizeSmall() ? 2.w : 4.w)),
                        ),
                        child: Text(
                          localized(context).card_editor_highlight,
                          style: TextStyle(
                            fontSize: fontSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                height: 0,
                thickness: 0.5, // Adjust thickness as needed
                color: onSurfaceColor, // Adjust color as needed
              ),
              QuillToolbarColorButton(
                controller: _controller,
                isBackground: false,
                options: QuillToolbarColorButtonOptions(
                  childBuilder: (
                    final QuillToolbarColorButtonOptions options,
                    final QuillToolbarColorButtonExtraOptions extraOptions,
                  ) =>
                      InkWell(
                    onTap: extraOptions.onPressed,
                    child: ListTile(
                      dense: true,
                      titleAlignment: ListTileTitleAlignment.titleHeight,
                      visualDensity: getVisualDensity(),
                      leading: Padding(
                        padding: EdgeInsets.only(
                          left: isPortrait
                              ? 6.w
                              : (isFontSizeSmall() ? 5.w : 3.w),
                          right: isPortrait ? 10.w : 3.w,
                        ),
                        child: Transform.scale(
                          scale: () {
                            final factor = FontSizeScale().factorDesc;
                            switch (factor) {
                              case FontSizeScaleFactor.biggest:
                                return isPortrait ? 1.75 : 1.25;
                              case FontSizeScaleFactor.bigger:
                                return isPortrait ? 1.5 : 1.25;
                              case FontSizeScaleFactor.normal:
                                return isPortrait ? 1.75 : 1.50;
                              case FontSizeScaleFactor.smaller:
                                return isPortrait ? 1.50 : 1.0;
                              case FontSizeScaleFactor.smallest:
                                return isPortrait ? 1.50 : 1.0;
                            }
                          }(),
                          child: Transform.translate(
                            offset: Offset(1.scaledSp, 1.scaledSp),
                            child: TextColor(
                              width: iconSize,
                              color: extraOptions.fillColor,
                              onPressed: extraOptions.onPressed,
                              controller: _controller,
                            ),
                          ),
                        ),
                      ),
                      title: Padding(
                        padding: EdgeInsets.only(
                          left: isPortrait
                              ? (isFontSizeBig()
                                  ? 12.w
                                  : (FontSizeScale().factorDesc ==
                                          FontSizeScaleFactor.smallest
                                      ? 3.w
                                      : 6.w))
                              : (isFontSizeBig()
                                  ? 4.w
                                  : (isFontSizeSmall() ? 2.w : 4.w)),
                        ),
                        child: Text(
                          localized(context).card_editor_font_color,
                          style: TextStyle(
                            fontSize: fontSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                height: 0,
                thickness: 0.5, // Adjust thickness as needed
                color: onSurfaceColor, // Adjust color as needed
              ),
              QuillToolbarClearFormatButton(
                controller: _controller,
                options: QuillToolbarBaseButtonOptions(
                  childBuilder: (final options, final extraOptions) => InkWell(
                    onTap: extraOptions.onPressed,
                    child: ListTile(
                      dense: true,
                      titleAlignment: ListTileTitleAlignment.titleHeight,
                      visualDensity: getVisualDensity(),
                      leading: Padding(
                        padding: EdgeInsets.only(
                          left: 6.w,
                          right: isPortrait ? 10.w : 3.w,
                        ),
                        child: Icon(
                          Icons.format_clear,
                          size: listTileIconSize,
                        ),
                      ),
                      title: Text(
                        localized(context).card_editor_clear_formatting,
                        style: TextStyle(
                          fontSize: fontSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                height: 0,
                thickness: 0.5, // Adjust thickness as needed
                color: onSurfaceColor, // Adjust color as needed
              ),
              Container(
                height: 10.h,
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              Divider(
                height: 0,
                thickness: 0.5, // Adjust thickness as needed
                color: onSurfaceColor, // Adjust color as needed
              ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: QuillToolbarToggleStyleButton(
                        options: quillToggleOption,
                        controller: _controller,
                        attribute: Attribute.ul,
                      ),
                    ),
                    Expanded(
                      child: QuillToolbarToggleStyleButton(
                        options: quillToggleOption,
                        controller: _controller,
                        attribute: Attribute.ol,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                thickness: 0.5, // Adjust thickness as needed
                color: onSurfaceColor, // Adjust color as needed
              ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: QuillToolbarIndentButton(
                        options: quillIndentOption,
                        controller: _controller,
                        isIncrease: true,
                      ),
                    ),
                    Expanded(
                      child: QuillToolbarIndentButton(
                        options: quillIndentOption,
                        controller: _controller,
                        isIncrease: false,
                      ),
                    ),
                    Expanded(
                      child: QuillToolbarToggleStyleButton(
                        options: quillToggleOption,
                        controller: _controller,
                        attribute: Attribute.rtl,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                thickness: 0.5, // Adjust thickness as needed
                color: onSurfaceColor, // Adjust color as needed
              ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: QuillToolbarToggleStyleButton(
                        options: quillToggleOption,
                        controller: _controller,
                        attribute: Attribute.leftAlignment,
                      ),
                    ),
                    Expanded(
                      child: QuillToolbarToggleStyleButton(
                        options: quillToggleOption,
                        controller: _controller,
                        attribute: Attribute.centerAlignment,
                      ),
                    ),
                    Expanded(
                      child: QuillToolbarToggleStyleButton(
                        options: quillToggleOption,
                        controller: _controller,
                        attribute: Attribute.rightAlignment,
                      ),
                    ),
                    Expanded(
                      child: QuillToolbarToggleStyleButton(
                        options: quillToggleOption,
                        controller: _controller,
                        attribute: Attribute.justifyAlignment,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                thickness: 0.5, // Adjust thickness as needed
                color: onSurfaceColor, // Adjust color as needed
              ),
              Container(
                height: 10.h,
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              Divider(
                height: 0,
                thickness: 0.5, // Adjust thickness as needed
                color: onSurfaceColor, // Adjust color as needed
              ),
              QuillToolbarSearchButton(
                controller: _controller,
                options: QuillToolbarSearchButtonOptions(
                  childBuilder: (final options, final extraOptions) => InkWell(
                    onTap: extraOptions.onPressed,
                    child: ListTile(
                      dense: true,
                      titleAlignment: ListTileTitleAlignment.titleHeight,
                      visualDensity: getVisualDensity(),
                      leading: Padding(
                        padding: EdgeInsets.only(
                          left: 6.w,
                          right: isPortrait ? 10.w : 3.w,
                        ),
                        child: Icon(
                          Icons.search,
                          size: listTileIconSize,
                        ),
                      ),
                      title: Text(
                        localized(context).card_editor_find_text,
                        style: TextStyle(
                          fontSize: fontSize,
                        ),
                      ),
                    ),
                  ),
                  customOnPressedCallback: (final controller) async {
                    context.read<CardScreenBloc>().add(SearchOpened());
                    return;
                  },
                ),
              ),
              Divider(
                height: 0,
                thickness: 0.5, // Adjust thickness as needed
                color: onSurfaceColor, // Adjust color as needed
              ),
            ],
          );
        },
      );
}

class _TopQuillToolBar extends StatelessWidget {
  const _TopQuillToolBar({
    required final QuillController controller,
  }) : _controller = controller;

  final QuillController _controller;

  @override
  Widget build(final BuildContext context) => QuillToolbar(
        configurations: const QuillToolbarConfigurations(),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: LayoutBuilder(
            builder: (final context, final constraints) {
              final isPortrait =
                  MediaQuery.of(context).orientation == Orientation.portrait;
              final iconSize = isPortrait ? 12.scaledSp : 6.scaledSp;
              final customIconSize = isPortrait ? 25.scaledSp : 12.scaledSp;
              return Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  QuillToolbarToggleStyleButton(
                    options: QuillToolbarToggleStyleButtonOptions(
                      iconSize: iconSize,
                    ),
                    controller: _controller,
                    attribute: Attribute.bold,
                  ),
                  QuillToolbarToggleStyleButton(
                    options: QuillToolbarToggleStyleButtonOptions(
                      iconSize: iconSize,
                    ),
                    controller: _controller,
                    attribute: Attribute.italic,
                  ),
                  QuillToolbarToggleStyleButton(
                    options: QuillToolbarToggleStyleButtonOptions(
                      iconSize: iconSize,
                    ),
                    controller: _controller,
                    attribute: Attribute.underline,
                  ),
                  /*QuillToolbarClearFormatButton(
                    controller: _controller,
                  ),*/
                  // const VerticalDivider(),
                  /*QuillToolbarColorButton(
                    controller: _controller,
                    isBackground: true,
                  ),
                  QuillToolbarColorButton(
                    controller: _controller,
                    isBackground: false,
                  ),*/
                  if (isFontSizeSmall())
                    SizedBox(
                      width: isPortrait ? 1.w : 3.w,
                    ),
                  if (isFontSizeNormal())
                    SizedBox(
                      width: isPortrait ? 0 : 2.w,
                    ),
                  QuillToolbarColorButton(
                    controller: _controller,
                    isBackground: true,
                    options: QuillToolbarColorButtonOptions(
                      childBuilder: (
                        final QuillToolbarColorButtonOptions options,
                        final QuillToolbarColorButtonExtraOptions extraOptions,
                      ) =>
                          HightlightColor(
                        width: customIconSize,
                        color: extraOptions.iconColorBackground,
                        onPressed: extraOptions.onPressed,
                      ),
                    ),
                  ),
                  if (isFontSizeSmall())
                    SizedBox(
                      width: isPortrait ? 3.w : 6.w,
                    ),
                  if (isFontSizeNormal())
                    SizedBox(
                      width: isPortrait ? 0 : 3.w,
                    ),
                  QuillToolbarColorButton(
                    controller: _controller,
                    isBackground: false,
                    options: QuillToolbarColorButtonOptions(
                      childBuilder: (
                        final QuillToolbarColorButtonOptions options,
                        final QuillToolbarColorButtonExtraOptions extraOptions,
                      ) =>
                          TextColor(
                        width: customIconSize,
                        color: extraOptions.fillColor,
                        onPressed: extraOptions.onPressed,
                        controller: _controller,
                      ),
                    ),
                  ),
                  if (isFontSizeSmall())
                    SizedBox(
                      width: isPortrait ? 1.w : 3.w,
                    ),
                  if (isFontSizeNormal())
                    SizedBox(
                      width: isPortrait ? 0 : 2.w,
                    ),
                  // const VerticalDivider(),
                  /*QuillToolbarSelectHeaderStyleDropdownButton(
                    controller: _controller,
                  ),*/
                  // const VerticalDivider(),
                  /*QuillToolbarToggleCheckListButton(
                    controller: _controller,
                  ),*/
                  QuillToolbarToggleStyleButton(
                    options: QuillToolbarToggleStyleButtonOptions(
                      iconSize: iconSize,
                    ),
                    controller: _controller,
                    attribute: Attribute.ul,
                  ),
                  QuillToolbarToggleStyleButton(
                    options: QuillToolbarToggleStyleButtonOptions(
                      iconSize: iconSize,
                    ),
                    controller: _controller,
                    attribute: Attribute.ol,
                  ),
                  /*QuillToolbarToggleStyleButton(
                    controller: _controller,
                    attribute: Attribute.inlineCode,
                  ),
                  QuillToolbarToggleStyleButton(
                    controller: _controller,
                    attribute: Attribute.blockQuote,
                  ),*/
                  QuillToolbarIndentButton(
                    options: QuillToolbarIndentButtonOptions(
                      iconSize: iconSize,
                    ),
                    controller: _controller,
                    isIncrease: true,
                  ),
                  QuillToolbarIndentButton(
                    options: QuillToolbarIndentButtonOptions(
                      iconSize: iconSize,
                    ),
                    controller: _controller,
                    isIncrease: false,
                  ),
                  // const VerticalDivider(),
                  /*QuillToolbarLinkStyleButton(
                    controller: _controller,
                  ),*/
                  QuillToolbarToggleStyleButton(
                    options: QuillToolbarToggleStyleButtonOptions(
                      iconSize: iconSize,
                    ),
                    controller: _controller,
                    attribute: Attribute.rtl,
                  ),
                  QuillToolbarHistoryButton(
                    options: QuillToolbarHistoryButtonOptions(
                      iconSize: iconSize,
                    ),
                    isUndo: true,
                    controller: _controller,
                  ),
                  QuillToolbarHistoryButton(
                    options: QuillToolbarHistoryButtonOptions(
                      iconSize: iconSize,
                    ),
                    isUndo: false,
                    controller: _controller,
                  ),
                ],
              );
            },
          ),
        ),
      );
}

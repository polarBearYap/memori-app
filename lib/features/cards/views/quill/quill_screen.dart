import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/cards/bloc/quill/quill_bloc.dart';
import 'package:memori_app/features/cards/views/quill/quill_editor_screen.dart';
import 'package:memori_app/features/cards/views/quill/quill_search_dialog.dart';
import 'package:memori_app/features/cards/views/quill/quill_toolbar_screen.dart';
import 'package:memori_app/features/common/models/showcase_keys.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/views/showcase_widget.dart';
import 'package:memori_app/features/decks/views/back_navigator.dart';
import 'package:showcaseview/showcaseview.dart';

enum CardSide {
  front,
  back,
}

typedef GlobalKeyWidgetBuilder = Widget Function(GlobalKey);

class QuillScreen extends StatefulWidget {
  const QuillScreen({
    required final Document document,
    final String? title,
    final TextAlign titleAlign = TextAlign.center,
    final bool isReadOnly = false,
    final bool isEditable = true,
    final List<Widget>? trailingActionButtons,
    final bool isWholeScreen = true,
    final double? editorMaxHeight,
    final bool disposeDocument = true,
    final bool hideTopBarInSmallScreen = false,
    final bool isShowcasingQuill = false,
    final bool isShowcasingEditButton = false,
    final CardSide? cardSide,
    final GlobalKeyWidgetBuilder? showcaseEditButton,
    super.key,
  })  : _document = document,
        _isReadOnly = isReadOnly,
        _title = title,
        _titleAlign = titleAlign,
        _isEditable = isEditable,
        _trailingActionButtons = trailingActionButtons,
        _isWholeScreen = isWholeScreen,
        _editorMaxHeight = editorMaxHeight,
        _disposeDocument = disposeDocument,
        _hideTopBarInSmallScreen = hideTopBarInSmallScreen,
        _isShowcasingQuill = isShowcasingQuill,
        _isShowcasingEditButton = isShowcasingEditButton,
        _cardSide = cardSide,
        _showcaseEditButton = showcaseEditButton;

  final Document _document;
  final String? _title;
  final TextAlign? _titleAlign;
  final bool _isReadOnly;
  final bool _isEditable;
  final bool _isWholeScreen;
  final List<Widget>? _trailingActionButtons;
  final double? _editorMaxHeight;
  final bool _disposeDocument;
  final bool _hideTopBarInSmallScreen;
  final bool _isShowcasingQuill;
  final bool _isShowcasingEditButton;
  final CardSide? _cardSide;
  final GlobalKeyWidgetBuilder? _showcaseEditButton;

  @override
  State<QuillScreen> createState() => _QuillScreenState();
}

class _QuillScreenState extends State<QuillScreen> {
  final _controller = QuillController.basic();
  final _editorFocusNode = FocusNode();
  final _editorScrollController = ScrollController();
  late bool _isReadOnly;
  late GlobalKey _editButtonGlobalKey;
  late BuildContext _showcasingContext;
  final GlobalKey _saveGlobalKey = GlobalKey();
  final GlobalKey _formatGlobalKey = GlobalKey();
  late bool _isBottomQuillExpanded;

  @override
  void initState() {
    super.initState();
    _isReadOnly = widget._isReadOnly;
    if (!widget._isEditable) {
      _editorFocusNode.canRequestFocus = false;
    }
    _controller.document = widget._document;
    _editButtonGlobalKey = GlobalKey();
    _isBottomQuillExpanded = false;
    initShowcasing();
  }

  void initShowcasing() {
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      if (widget._isShowcasingQuill) {
        Future.delayed(const Duration(milliseconds: 600), () {
          startShowcase(
            _showcasingContext,
            [
              _formatGlobalKey,
            ],
          );
        });
      }
    });
  }

  @override
  void didUpdateWidget(
    final QuillScreen oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (widget._document != oldWidget._document) {
      setState(() {
        _controller.document = widget._document;
      });
    }
  }

  @override
  void dispose() {
    if (!widget._disposeDocument) {
      _controller.document = Document();
    }
    _controller.dispose();
    _editorFocusNode.dispose();
    _editorScrollController.dispose();
    super.dispose();
  }

  void onFormatTargetClick() {
    if (!_isBottomQuillExpanded) {
      setState(() {
        _isBottomQuillExpanded = true;
        Future.delayed(const Duration(milliseconds: 600), () {
          startShowcase(
            _showcasingContext,
            [
              _formatGlobalKey,
              _saveGlobalKey,
            ],
          );
        });
      });
    }
  }

  @override
  Widget build(final BuildContext context) {
    final bottomQuillToolBar = AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _isReadOnly
          ? const SizedBox()
          : BottomQuillToolBar(
              controller: _controller,
              editorFocusNode: _editorFocusNode,
              initExpand: _isBottomQuillExpanded,
            ),
      transitionBuilder:
          (final Widget child, final Animation<double> animation) =>
              FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
          child: child,
        ),
      ),
    );

    Widget body = Column(
      children: [
        CustomQuillToolbarSearchDialog(
          controller: _controller,
        ),
        Expanded(
          child: CustomQuillEditor(
            configurations: QuillEditorConfigurations(
              controller: _controller,
              showCursor: !_isReadOnly,
              readOnly: _isReadOnly,
              autoFocus: !_isReadOnly,
            ),
            scrollController: _editorScrollController,
            focusNode: _editorFocusNode,
          ),
        ),
        if (!widget._isShowcasingQuill) bottomQuillToolBar,
        if (widget._isShowcasingQuill)
          CustomShowcaseWidget(
            title: _isBottomQuillExpanded
                ? localized(context).showcase_quill_format_more_title
                : localized(context).showcase_quill_format_title,
            desc: _isBottomQuillExpanded
                ? localized(context).showcase_quill_format_more_desc
                : localized(context).showcase_quill_format_desc,
            showcaseKey: _formatGlobalKey,
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
              vertical: 5.w,
            ),
            targetShapeBorder: const RoundedRectangleBorder(),
            tooltipPosition: TooltipPosition.top,
            onTargetClick: _isBottomQuillExpanded
                ? () {
                    dismissShowcase(_showcasingContext);
                    startShowcase(
                      _showcasingContext,
                      [
                        _saveGlobalKey,
                      ],
                    );
                  }
                : onFormatTargetClick,
            onBarrierClick: _isBottomQuillExpanded
                ? null
                : () {
                    dismissShowcase(_showcasingContext);
                    onFormatTargetClick();
                  },
            child: bottomQuillToolBar,
          ),
      ],
    );

    List<Widget> actions = [
      LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          return QuillToolbarSearchButton(
            controller: _controller,
            options: QuillToolbarSearchButtonOptions(
              childBuilder: (final options, final extraOptions) => IconButton(
                onPressed: extraOptions.onPressed,
                icon: Icon(
                  Icons.search,
                  size: isPortrait ? 20.scaledSp : 12.scaledSp,
                ),
              ),
              customOnPressedCallback: (final controller) async {
                context.read<CardScreenBloc>().add(SearchOpened());
                return;
              },
            ),
          );
        },
      ),
      if (!_isReadOnly)
        _QuillToolbarHistoryButton(
          isUndo: true,
          controller: _controller,
        ),
      if (!_isReadOnly)
        _QuillToolbarHistoryButton(
          isUndo: false,
          controller: _controller,
        ),
      if (widget._isEditable)
        LayoutBuilder(
          builder: (final context, final constraints) {
            final isPortrait =
                MediaQuery.of(context).orientation == Orientation.portrait;
            final iconSize = isPortrait ? 20.scaledSp : 12.scaledSp;
            return AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              firstChild: IconButton(
                onPressed: () => {
                  if (!_isReadOnly)
                    setState(() {
                      _isReadOnly = true;
                    }),
                },
                icon: Icon(
                  Icons.preview,
                  size: iconSize,
                ),
              ),
              secondChild: IconButton(
                onPressed: () {
                  if (kDebugMode) {
                    debugPrint(
                      jsonEncode(
                        _controller.document.toDelta().toJson(),
                      ),
                      wrapWidth: 1000,
                    );
                  }
                  if (_isReadOnly) {
                    setState(() {
                      _isReadOnly = false;
                    });
                  }
                },
                icon: Icon(
                  Icons.edit,
                  size: iconSize,
                ),
              ),
              crossFadeState: _isReadOnly
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            );
          },
        ),
      if (widget._trailingActionButtons != null)
        ...widget._trailingActionButtons!,
      if (widget._isShowcasingEditButton && widget._showcaseEditButton != null)
        _QuillShowcaseEditButton(
          cardSide: widget._cardSide,
          showcaseEditButton: widget._showcaseEditButton!,
          editButtonGlobalKey: _editButtonGlobalKey,
        ),
    ];

    return BlocProvider(
      create: (final context) => CardScreenBloc(),
      child: () {
        final child = widget._isWholeScreen
            ? LayoutBuilder(
                builder: (final context, final constraints) {
                  final isPortrait = MediaQuery.of(context).orientation ==
                      Orientation.portrait;
                  final textTheme = Theme.of(context).textTheme;
                  return Scaffold(
                    appBar: !widget._isWholeScreen
                        ? null
                        : AppBar(
                            leadingWidth:
                                getAppBarLeadingWidth(isPortrait: isPortrait),
                            toolbarHeight:
                                getAppBarHeight(isPortrait: isPortrait),
                            leading: widget._isEditable
                                ? (widget._isShowcasingQuill
                                    ? CustomShowcaseWidget(
                                        title: localized(context)
                                            .showcase_quill_save_title,
                                        desc: localized(context)
                                            .showcase_quill_save_desc,
                                        showcaseKey: _saveGlobalKey,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 3.w,
                                          vertical: 3.w,
                                        ),
                                        targetShapeBorder: const CircleBorder(),
                                        tooltipPosition: TooltipPosition.bottom,
                                        speechBubbleLeft:
                                            isPortrait ? -5.w : -3.w,
                                        containerFlexRight:
                                            isPortrait ? 100 : 102,
                                        onTargetClick: () => {},
                                        child: const BackNavigator(),
                                      )
                                    : const BackNavigator())
                                : null,
                            title: widget._title == null
                                ? null
                                : Padding(
                                    padding:
                                        widget._titleAlign == TextAlign.start
                                            ? EdgeInsets.only(left: 10.w)
                                            : EdgeInsets.zero,
                                    child: Text(
                                      widget._title!,
                                      textAlign: widget._titleAlign,
                                      style: TextStyle(
                                        fontSize: isPortrait
                                            ? textTheme
                                                .titleLarge!.fontSize!.scaledSp
                                            : textTheme.titleSmall!.fontSize!
                                                    .scaledSp *
                                                0.8,
                                      ),
                                    ),
                                  ),
                            centerTitle: widget._titleAlign == TextAlign.center
                                ? true
                                : widget._titleAlign == TextAlign.start ||
                                        widget._titleAlign == TextAlign.left
                                    ? false
                                    : null,
                            actions: actions,
                            elevation: 10.0,
                          ),
                    body: SafeArea(
                      child: body,
                    ),
                  );
                },
              )
            : Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  children: [
                    if (!widget._hideTopBarInSmallScreen)
                      Card(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        margin: EdgeInsets.zero,
                        elevation: 1,
                        // IntrinsicHeight
                        child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (widget._titleAlign == TextAlign.start ||
                                  widget._titleAlign == TextAlign.left)
                                SizedBox(
                                  width: 20.w,
                                ),
                              if (widget._title != null)
                                Expanded(
                                  child: LayoutBuilder(
                                    builder:
                                        (final context, final constraints) {
                                      final isPortrait =
                                          MediaQuery.of(context).orientation ==
                                              Orientation.portrait;
                                      final textTheme =
                                          Theme.of(context).textTheme;
                                      return Text(
                                        widget._title!,
                                        textAlign: widget._titleAlign,
                                        style: TextStyle(
                                          fontSize: isPortrait
                                              ? textTheme.titleMedium!.fontSize!
                                                  .scaledSp
                                              : textTheme.titleSmall!.fontSize!
                                                      .scaledSp *
                                                  0.6,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ...actions,
                            ],
                          ),
                        ),
                      ),
                    SizedBox(
                      height: widget._editorMaxHeight,
                      child: body,
                    ),
                  ],
                ),
              );
        if (!widget._isShowcasingQuill && !widget._isShowcasingEditButton) {
          return child;
        }
        return ShowCaseWidget(
          builder: Builder(
            builder: (final context) {
              _showcasingContext = context;
              return child;
            },
          ),
        );
      }(),
    );
  }
}

class _QuillToolbarHistoryButton extends StatelessWidget {
  const _QuillToolbarHistoryButton({
    required final QuillController controller,
    required final bool isUndo,
  })  : _controller = controller,
        _isUndo = isUndo;

  final bool _isUndo;
  final QuillController _controller;

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final iconSize = isPortrait ? 12.scaledSp : 10.scaledSp;

          final quillIconTheme = getQuillIconTheme();
          final quillHistoryOption = QuillToolbarHistoryButtonOptions(
            iconTheme: quillIconTheme,
            iconSize: iconSize,
          );

          return QuillToolbarHistoryButton(
            options: quillHistoryOption,
            isUndo: _isUndo,
            controller: _controller,
          );
        },
      );
}

class _QuillShowcaseEditButton extends StatelessWidget {
  const _QuillShowcaseEditButton({
    required final CardSide? cardSide,
    required final GlobalKeyWidgetBuilder showcaseEditButton,
    required final GlobalKey editButtonGlobalKey,
  })  : _cardSide = cardSide,
        _showcaseEditButton = showcaseEditButton,
        _editButtonGlobalKey = editButtonGlobalKey;

  final CardSide? _cardSide;
  final GlobalKeyWidgetBuilder _showcaseEditButton;
  final GlobalKey _editButtonGlobalKey;

  @override
  Widget build(final BuildContext context) => ShowCaseWidget(
        builder: Builder(
          builder: (final context) {
            if (_cardSide != null) {
              if (_cardSide == CardSide.front) {
                ShowcaseKey().addEditCardFrontContext = context;
                ShowcaseKey().addEditCardFrontFormField = _editButtonGlobalKey;
              } else if (_cardSide == CardSide.back) {
                ShowcaseKey().addEditCardBackContext = context;
                ShowcaseKey().addEditCardBackFormField = _editButtonGlobalKey;
              }
            }
            return _showcaseEditButton.call(_editButtonGlobalKey);
          },
        ),
      );
}

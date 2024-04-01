import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:memori_app/features/cards/bloc/card/learn_card_bloc.dart';
import 'package:memori_app/features/cards/utils/card_color.dart';
import 'package:memori_app/features/common/bloc/font_size_bloc.dart';
import 'package:memori_app/features/common/models/showcase_keys.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/utils/theme_mode.dart';
import 'package:memori_app/features/common/views/alert_dialog.dart';
import 'package:memori_app/features/common/views/delete_alert.dart';
import 'package:memori_app/features/common/views/independent_scroll_view.dart';
import 'package:memori_app/features/common/views/showcase_widget.dart';
import 'package:memori_app/features/decks/bloc/deck/deck_bloc.dart';
import 'package:memori_app/features/decks/bloc/deck/delete_deck_bloc.dart';
import 'package:memori_app/features/decks/bloc/deck/edit_deck_bloc.dart';
import 'package:memori_app/features/decks/models/deck_list_view.dart';
import 'package:memori_app/features/decks/views/edit_deck_screen.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:uuid/uuid.dart';

class DeckListViewScreen extends StatefulWidget {
  const DeckListViewScreen({required final int pageSize, super.key})
      : _pageSize = pageSize;

  final int _pageSize;

  @override
  State<DeckListViewScreen> createState() => _DeckListViewScreenState();
}

class _DeckListViewScreenState extends State<DeckListViewScreen> {
  late ScrollController _scrollController;
  late bool _isLoading;
  late bool _hideLoadingIcon;
  late int _nextPageNumber;
  late List<DeckListViewItem> _items;
  late Timer? _rateLimitTimer;
  late Key _widgetKey;

  late String _newlyAddedDeckId;
  late bool _isNewAddedDeckShowcaseShown;
  late String _newlyEditedDeckId;
  late BuildContext _deckListContext;
  final GlobalKey _newlyAddedDeckItemKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
    _widgetKey = Key(const Uuid().v4());
    _newlyAddedDeckId = '';
    _isNewAddedDeckShowcaseShown = true;
    _newlyEditedDeckId = '';
    _initPage();
  }

  void _initPage() {
    _rateLimitTimer = null;
    _hideLoadingIcon = false;
    _nextPageNumber = 0;
    _items = [];
    _isLoading = true;
    context.read<DeckBloc>().add(
          DeckScrolledDown(
            eventSource: DeckScrollEventSource.homepage,
            pageNumber: _nextPageNumber,
            pageSize: widget._pageSize,
          ),
        );
  }

  void _handleScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 50.h &&
        !_isLoading) {
      if (_rateLimitTimer == null || !_rateLimitTimer!.isActive) {
        _hideLoadingIcon = _items.length < 10;
        _isLoading = true;
        context.read<DeckBloc>().add(
              DeckScrolledDown(
                eventSource: DeckScrollEventSource.homepage,
                pageNumber: _nextPageNumber,
                pageSize: widget._pageSize,
              ),
            );
        _rateLimitTimer = Timer(const Duration(seconds: 2), () {});
      }
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    _rateLimitTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => MultiBlocListener(
        key: _widgetKey,
        listeners: [
          BlocListener<FontSizeCubit, FontSizeState>(
            listenWhen: (final previous, final current) => previous != current,
            listener: (final context, final state) {
              setState(() {
                _widgetKey = Key(const Uuid().v4());
              });
            },
          ),
          BlocListener<DeckBloc, DeckState>(
            listenWhen: (final previous, final current) =>
                current.eventSource == DeckScrollEventSource.homepage ||
                current.eventSource == DeckScrollEventSource.all,
            listener: (final context, final state) {
              if (state.status == DeckListStatus.forceRefresh) {
                setState(() {
                  _newlyAddedDeckId = state.newlyAddedDeckId;
                  _isNewAddedDeckShowcaseShown = false;
                  _newlyEditedDeckId = state.newlyEditedDeckId;
                  _initPage();
                });
                return;
              }
              if (state.status == DeckListStatus.loading) {
                setState(() {
                  _isLoading = true;
                });
                return;
              }
              // Completed or failed
              if (state.hasNextPage || state.decks.isNotEmpty) {
                _nextPageNumber++;
              }
              if (state.status == DeckListStatus.completed) {
                _items.addAll(state.decks);
                if (!_isNewAddedDeckShowcaseShown &&
                    _newlyAddedDeckId.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((final _) {
                    startShowcase(
                      _deckListContext,
                      [
                        _newlyAddedDeckItemKey,
                      ],
                    );
                  });
                  _isNewAddedDeckShowcaseShown = true;
                }
              } else if (state.status == DeckListStatus.failed) {
                showScaledSnackBar(
                  context,
                  localized(context).deck_loading_failed,
                );
              }
              setState(() {
                _isLoading = false;
              });
            },
          ),
        ],
        child: _items.isEmpty && !_isLoading
            ? const _DeckEmptyScreen()
            : ListView.separated(
                controller: _scrollController,
                itemCount:
                    _items.length + (!_hideLoadingIcon && _isLoading ? 1 : 0),
                separatorBuilder: (final context, final index) => SizedBox(
                  height: 15.h,
                ),
                itemBuilder: (final context, final index) {
                  if (index == _items.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final itemWidget = DeckListItemScreen(
                    key: Key(
                      _items[index].id,
                    ),
                    item: _items[index],
                  );
                  if (_items[index].id == _newlyAddedDeckId) {
                    _deckListContext = context;
                    void startShowcaseFab() {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      Future.delayed(const Duration(milliseconds: 500), () {
                        ShowcaseKey().isShowcasingAddDeck = false;
                        startShowcase(
                          ShowcaseKey().scaffoldContext ?? context,
                          [
                            ShowcaseKey().addFab,
                          ],
                        );
                      });
                    }

                    return CustomShowcaseWidget(
                      title: localized(context).showcase_deck_added_title,
                      desc: localized(context).showcase_deck_added_desc,
                      showcaseKey: _newlyAddedDeckItemKey,
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 5.w,
                      ),
                      targetShapeBorder: const RoundedRectangleBorder(),
                      tooltipPosition: TooltipPosition.bottom,
                      onTargetClick: startShowcaseFab,
                      onTargetClickApplyOnContainer: true,
                      onBarrierClick: startShowcaseFab,
                      child: itemWidget,
                    );
                  }
                  if (_items[index].id == _newlyEditedDeckId) {
                    return DeckListItemScreen(
                      key: Key(
                        _items[index].id,
                      ),
                      item: _items[index],
                      isShowcasing: true,
                    );
                  }
                  return itemWidget;
                },
              ),
      );
}

class DeckListItemScreen extends StatelessWidget {
  const DeckListItemScreen({
    required final DeckListViewItem item,
    final bool isShowcasing = false,
    super.key,
  })  : _item = item,
        _isShowcasing = isShowcasing;

  final DeckListViewItem _item;
  final bool _isShowcasing;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (final context, final constriants) {
        final isPortrait =
            MediaQuery.of(context).orientation == Orientation.portrait;
        final textTheme = theme.textTheme;
        final titleFontSize = isPortrait
            ? textTheme.titleMedium!.fontSize!.scaledSp
            : textTheme.titleSmall!.fontSize!.scaledSp * 0.8;
        final labelFontSize = isPortrait
            ? textTheme.labelMedium!.fontSize!.scaledSp
            : textTheme.labelSmall!.fontSize!.scaledSp * 0.7;

        return Card(
          elevation: 3.0,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              15.w,
              10.h,
              0,
              10.h,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        _item.deckName,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: titleFontSize,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    // const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(
                        right: 5.w,
                      ),
                      child: _DeckMenuAnchor(
                        item: _item,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 15.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: isPortrait ? 10.h : 15.h,
                      ),
                      _DeckChips(
                        item: _item,
                      ),
                      SizedBox(
                        height: isPortrait ? 10.h : 15.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: isPortrait ? 15.scaledSp : 12.scaledSp,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            getReviewTimePassed(
                              _item.lastReviewedTime,
                              context,
                            ),
                            style: TextStyle(
                              fontSize: labelFontSize * 0.85,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      const Divider(
                        thickness: 2.0,
                        indent: 5,
                        endIndent: 5,
                        height: 0,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      _DeckListItemBottomScreen(
                        isShowcasing: _isShowcasing,
                        itemId: _item.id,
                        deckName: _item.deckName,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DeckListItemBottomScreen extends StatefulWidget {
  const _DeckListItemBottomScreen({
    required final bool isShowcasing,
    required final String itemId,
    required final String deckName,
  })  : _isShowcasing = isShowcasing,
        _itemId = itemId,
        _deckName = deckName;

  final bool _isShowcasing;
  final String _itemId;
  final String _deckName;

  @override
  State<_DeckListItemBottomScreen> createState() =>
      _DeckListItemBottomScreenState();
}

class _DeckListItemBottomScreenState extends State<_DeckListItemBottomScreen> {
  late GlobalKey _globalKey;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _globalKey = GlobalKey();
    _scrollController = ScrollController();
    scrollToShowcase();
  }

  void scrollToShowcase() {
    if (widget._isShowcasing) {
      WidgetsBinding.instance.addPostFrameCallback((final _) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void didUpdateWidget(final _DeckListItemBottomScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._isShowcasing != oldWidget._isShowcasing ||
        widget._itemId != oldWidget._itemId ||
        widget._deckName != oldWidget._deckName) {
      setState(() {
        scrollToShowcase();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildScrollView({
    required final Widget child,
  }) {
    if (widget._isShowcasing) {
      return SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: child,
      );
    } else {
      return IndependentScrollView(
        scrollDirection: Axis.horizontal,
        child: child,
      );
    }
  }

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final textTheme = Theme.of(context).textTheme;
          final colorTheme = Theme.of(context).colorScheme;
          final labelFontSize = isPortrait
              ? textTheme.labelMedium!.fontSize!.scaledSp
              : textTheme.labelSmall!.fontSize!.scaledSp * 0.7;
          final iconSize = isPortrait ? 18.scaledSp : 12.scaledSp;
          return buildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => {
                    context.push(
                      '/deck/browse/${widget._itemId}?name=${Uri.encodeComponent(widget._deckName)}',
                    ),
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        size: iconSize,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        localized(context).deck_browse,
                        style: TextStyle(
                          fontSize: labelFontSize,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                TextButton(
                  onPressed: () => {
                    context.push('/deck/settings/${widget._itemId}'),
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.tune,
                        size: iconSize,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        localized(context).deck_option,
                        style: TextStyle(
                          fontSize: labelFontSize,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                BlocListener<LearnCardBloc, LearnCardState>(
                  listenWhen: (final previous, final current) =>
                      current.initStatus != LearnInitStatus.none &&
                      current.deckId == widget._itemId,
                  listener: (final context, final state) {
                    String snackBarText = '';
                    if (state.initStatus == LearnInitStatus.success) {
                      context.push('/deck/learn');
                    } else if (state.initStatus ==
                        LearnInitStatus.noCardCreated) {
                      snackBarText = localized(context).deck_no_card_created;
                    } else if (state.initStatus ==
                        LearnInitStatus.noCardMatchCriteria) {
                      snackBarText =
                          localized(context).deck_no_card_match_option;
                    } else if (state.initStatus == LearnInitStatus.noDueCard) {
                      snackBarText = localized(context).deck_no_card_due;
                      context.push('/deck/learn');
                    } else if (state.initStatus ==
                        LearnInitStatus.askResumeLearning) {
                      showDialog(
                        context: context,
                        builder: (final context) => CustomAlertDialog(
                          title: Text(
                            localized(context).deck_resume_title,
                            style: getDialogTitle(
                              isPortrait: isPortrait,
                              textTheme: textTheme,
                            ),
                          ),
                          content: Text(
                            localized(context).deck_resume_desc,
                            style: getDialogContent(
                              isPortrait: isPortrait,
                              textTheme: textTheme,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                localized(context).deck_resume_cancel,
                                style: getDialogLabel(
                                  isPortrait: isPortrait,
                                  textTheme: textTheme,
                                ).copyWith(
                                  color: colorTheme.onBackground.withAlpha(
                                    200,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                context.read<LearnCardBloc>().add(
                                      LearnCardInit(
                                        deckId: widget._itemId,
                                        resumeLearning: false,
                                        reviewTime: DateTime.now().toUtc(),
                                        isShowcasing: widget._isShowcasing,
                                      ),
                                    );
                              },
                              child: Text(
                                localized(context).deck_resume_confirm_reset,
                                style: getDialogLabel(
                                  isPortrait: isPortrait,
                                  textTheme: textTheme,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                context.read<LearnCardBloc>().add(
                                      LearnCardInit(
                                        deckId: widget._itemId,
                                        resumeLearning: true,
                                        reviewTime: DateTime.now().toUtc(),
                                        isShowcasing: widget._isShowcasing,
                                      ),
                                    );
                              },
                              child: Text(
                                localized(context).deck_resume_confirm_resume,
                                style: getDialogLabel(
                                  isPortrait: isPortrait,
                                  textTheme: textTheme,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (snackBarText.isNotEmpty) {
                      showScaledSnackBar(
                        context,
                        snackBarText,
                      );
                    }
                  },
                  child: BlocBuilder<LearnCardBloc, LearnCardState>(
                    buildWhen: (final previous, final current) =>
                        current.initStatus != LearnInitStatus.none &&
                        current.deckId == widget._itemId,
                    builder: (final context, final state) {
                      final button = FilledButton(
                        onPressed:
                            state.initStatus == LearnInitStatus.inProgress
                                ? null
                                : () {
                                    context.read<LearnCardBloc>().add(
                                          LearnCardInit(
                                            deckId: widget._itemId,
                                            resumeLearning: null,
                                            reviewTime: DateTime.now().toUtc(),
                                            isShowcasing: widget._isShowcasing,
                                          ),
                                        );
                                  },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                5.0.scaledSp,
                              ),
                            ),
                          ),
                        ),
                        child: state.initStatus == LearnInitStatus.inProgress
                            ? const CircularProgressIndicator()
                            : Text(
                                localized(context).deck_learn,
                                style: TextStyle(
                                  fontSize: labelFontSize,
                                ),
                              ),
                      );
                      if (!widget._isShowcasing) {
                        return button;
                      }
                      return ShowCaseWidget(
                        builder: Builder(
                          builder: (final context) {
                            WidgetsBinding.instance
                                .addPostFrameCallback((final _) {
                              Future.delayed(
                                  const Duration(
                                    milliseconds: 600,
                                  ), () {
                                startShowcase(
                                  context,
                                  [
                                    _globalKey,
                                  ],
                                );
                              });
                            });
                            return CustomShowcaseWidget(
                              title:
                                  localized(context).showcase_card_added_title,
                              desc: localized(context).showcase_card_added_desc,
                              showcaseKey: _globalKey,
                              padding: EdgeInsets.only(
                                top: isPortrait ? 20.h : 30.h,
                                left: 5.w,
                                right: 5.w,
                              ),
                              targetShapeBorder: const RoundedRectangleBorder(),
                              speechBubbleRight: isPortrait ? 25.w : 65.w,
                              containerFlexLeft: isPortrait ? 2 : 4,
                              hideTooltip: true,
                              onTargetClick: () {
                                context.read<LearnCardBloc>().add(
                                      LearnCardInit(
                                        deckId: widget._itemId,
                                        resumeLearning: false,
                                        reviewTime: DateTime.now().toUtc(),
                                        isShowcasing: widget._isShowcasing,
                                      ),
                                    );
                              },
                              child: button,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
}

class _DeckChips extends StatelessWidget {
  const _DeckChips({required final DeckListViewItem item}) : _item = item;

  final DeckListViewItem _item;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    const chipSize = StadiumBorder(
      side: BorderSide(),
    );
    final isDarkMode = checkIsDarkMode(context: context);

    final newChipColor = getNewChipColor(theme);
    final learningColor = getLearningColor(isDarkMode: isDarkMode);
    final reviewColor = getReviewColor(isDarkMode: isDarkMode);
    final newChipColorProperty = MaterialStateProperty.all(newChipColor);
    final learningColorProperty = MaterialStateProperty.all(learningColor);
    final reviewColorProperty = MaterialStateProperty.all(reviewColor);

    return LayoutBuilder(
      builder: (final context, final constraints) {
        final isPortrait =
            MediaQuery.of(context).orientation == Orientation.portrait;
        final textTheme = theme.textTheme;
        final labelFontSize = isPortrait
            ? textTheme.labelSmall!.fontSize!.scaledSp
            : textTheme.labelSmall!.fontSize!.scaledSp * 0.6;

        final children = [
          Chip(
            label: Text(
              '${_item.newCount} ${localized(context).deck_new}',
              style: TextStyle(fontSize: labelFontSize),
            ),
            shape: chipSize.copyWith(
              side: BorderSide(
                color: newChipColor,
              ),
            ),
            color: newChipColorProperty,
          ),
          Chip(
            label: Text(
              '${_item.learningCount} ${localized(context).deck_learning}',
              style: TextStyle(fontSize: labelFontSize),
            ),
            shape: chipSize.copyWith(
              side: BorderSide(
                color: learningColor,
              ),
            ),
            color: learningColorProperty,
          ),
          Chip(
            label: Text(
              '${_item.reviewCount} ${localized(context).deck_reviewing}',
              style: TextStyle(fontSize: labelFontSize),
            ),
            shape: chipSize.copyWith(
              side: BorderSide(
                color: reviewColor,
              ),
            ),
            color: reviewColorProperty,
          ),
        ];

        if (constraints.maxWidth > 400 || isFontSizeBig()) {
          return Wrap(
            spacing: isPortrait ? 20.w : 10.w,
            runSpacing: 15.h,
            children: children,
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: children,
          );
        }
      },
    );
  }
}

enum DeckMenuItem { rename, delete }

class _DeckMenuAnchor extends StatefulWidget {
  const _DeckMenuAnchor({required final DeckListViewItem item}) : _item = item;

  final DeckListViewItem _item;

  @override
  State<_DeckMenuAnchor> createState() => _DeckMenuAnchorState();
}

class _DeckMenuAnchorState extends State<_DeckMenuAnchor> {
  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final colorTheme = theme.colorScheme;
    return LayoutBuilder(
      builder: (final context, final constriants) {
        final isPortrait =
            MediaQuery.of(context).orientation == Orientation.portrait;
        final textTheme = theme.textTheme;

        return PopupMenuButton<DeckMenuItem>(
          icon: Icon(
            Icons.more_vert,
            size: getPopupIcon(
              isPortrait: isPortrait,
            ),
          ),
          constraints: getPopupMenuBoxConstraints(),
          offset: getPopupMenuOffset(
            isPortrait: isPortrait,
          ),
          onSelected: (final DeckMenuItem item) {
            if (item == DeckMenuItem.rename) {
              context.read<EditDeckBloc>().add(
                    EditDeckOpened(
                      widget._item.id,
                    ),
                  );
              showDialog(
                context: context,
                builder: (final context) => EditDeckDialog(
                  deckId: widget._item.id,
                ),
              );
            } else if (item == DeckMenuItem.delete) {
              showDialog(
                context: context,
                builder: (final BuildContext context) =>
                    BlocListener<DeleteDeckBloc, DeleteDeckState>(
                  listenWhen: (final previous, final current) =>
                      current.deckDeletedStatus !=
                          FormzSubmissionStatus.initial &&
                      current.deckDeletedStatus !=
                          FormzSubmissionStatus.inProgress,
                  listener: (final context, final state) {
                    showScaledSnackBar(
                      context,
                      state.deckDeletedStatus == FormzSubmissionStatus.success
                          ? localized(context).deck_delete_successful
                          : localized(context).deck_delete_failed,
                    );
                  },
                  child: DeleteConfirmationDialog(
                    title: localized(context).deck_delete_confirm_title,
                    content: localized(context)
                        .deck_delete_confirm_desc(widget._item.deckName),
                    confirmText: localized(context).deck_delete_confirm_ok,
                    dismissText: localized(context).deck_delete_confirm_cancel,
                    onConfirm: () {
                      context.read<DeleteDeckBloc>().add(
                            DeckDeleted(
                              widget._item.id,
                            ),
                          );
                    },
                  ),
                ),
              );
            }
          },
          itemBuilder: (final BuildContext context) =>
              <PopupMenuEntry<DeckMenuItem>>[
            PopupMenuItem<DeckMenuItem>(
              value: DeckMenuItem.rename,
              child: SizedBox(
                height: getPopupMenuItemHeight(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.badge,
                      size: getPopupIcon(
                        isPortrait: isPortrait,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      localized(context).deck_rename,
                      style: TextStyle(
                        fontSize: getPopupLabel(
                          isPortrait: isPortrait,
                          textTheme: textTheme,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuItem<DeckMenuItem>(
              value: DeckMenuItem.delete,
              child: SizedBox(
                height: getPopupMenuItemHeight(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.delete,
                      size: getPopupIcon(
                        isPortrait: isPortrait,
                      ),
                      color: colorTheme.error,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      localized(context).deck_delete,
                      style: TextStyle(
                        fontSize: getPopupLabel(
                          isPortrait: isPortrait,
                          textTheme: textTheme,
                        ),
                        color: colorTheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DeckEmptyScreen extends StatelessWidget {
  const _DeckEmptyScreen();

  @override
  Widget build(final BuildContext context) {
    final isDarkMode = checkIsDarkMode(context: context);
    final darkFilePrefix = isDarkMode ? '_dark' : '';

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 15.w,
        ),
        child: LayoutBuilder(
          builder: (final context, final constraints) {
            final isPortrait =
                MediaQuery.of(context).orientation == Orientation.portrait;
            final textTheme = Theme.of(context).textTheme;
            final displaySmall = isPortrait
                ? textTheme.headlineMedium!.fontSize!.scaledSp
                : textTheme.titleMedium!.fontSize!.scaledSp;
            final titleMedium = isPortrait
                ? textTheme.bodyLarge!.fontSize!.scaledSp
                : textTheme.bodySmall!.fontSize!.scaledSp * 0.75;
            return Column(
              children: <Widget>[
                SizedBox(
                  height: isPortrait ? 50.h : 20.h,
                ),
                // const Spacer(),
                SvgPicture.asset(
                  'assets/splash_screens/empty_deck_screen$darkFilePrefix.svg',
                  placeholderBuilder: (final BuildContext context) => Container(
                    padding: const EdgeInsets.all(30.0),
                    child: const CircularProgressIndicator(),
                  ),
                  width: isPortrait ? 300.w : 125.w,
                ),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  localized(context).deck_empty_title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: displaySmall,
                  ),
                  overflow: TextOverflow.visible,
                ),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  localized(context).deck_empty_desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleMedium,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

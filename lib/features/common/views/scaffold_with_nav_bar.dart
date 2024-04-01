import 'dart:async';

import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:memori_app/db/database.dart';
import 'package:memori_app/features/cards/bloc/card/add_edit_card_bloc.dart';
import 'package:memori_app/features/common/bloc/font_size_bloc.dart';
import 'package:memori_app/features/common/bloc/navigation_bloc.dart';
import 'package:memori_app/features/common/models/showcase_keys.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/views/showcase_widget.dart';
import 'package:memori_app/features/decks/bloc/deck/add_deck_bloc.dart';
import 'package:memori_app/features/decks/views/add_deck_screen.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uuid/uuid.dart';

class ScaffoldWithNavBar extends StatefulWidget {
  const ScaffoldWithNavBar({
    required final StatefulNavigationShell navigationShell,
    required final List<Widget> children,
    super.key,
  })  : _navigationShell = navigationShell,
        _children = children;

  final StatefulNavigationShell _navigationShell;
  final List<Widget> _children;

  @override
  State<StatefulWidget> createState() => ScaffoldWithNavBarState();
}

class ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  late PageController _pageViewController;
  late bool _animating;
  final Lock _lock = Lock();

  Future<void> safeUpdateAnimating({required final bool animating}) async {
    await _lock.synchronized(() => _animating = animating);
  }

  Future<bool> safeReadAnimating() async =>
      await _lock.synchronized(() => _animating);

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _animating = false;
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  @override
  Widget build(final BuildContext context) => BlocProvider(
        create: (final context) => NavigationBloc(),
        child: LayoutBuilder(
          builder: (final context, final constraints) {
            final isPortrait =
                MediaQuery.of(context).orientation == Orientation.portrait;

            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;

            double? notchMargin = isPortrait ? 6.scaledSp : 3.scaledSp;

            if (screenWidth <= 400 || (!isPortrait && screenHeight <= 400)) {
              notchMargin = isPortrait ? 3.scaledSp : 1.scaledSp;
            }

            final textTheme = Theme.of(context).textTheme;
            final colorScheme = Theme.of(context).colorScheme;
            final iconSize = getDefaultIconSize(
              isPortrait: isPortrait,
            );
            final textFieldHeight = getTextFieldHeight(
              isPortrait: isPortrait,
              hasErrorText: true,
            );
            final textFieldTextStyle = getTextFieldStyle(
              isPortrait: isPortrait,
              textTheme: textTheme,
            ).copyWith(
              color: colorScheme.onBackground,
            );
            if (kDebugMode) {
              print(
                'Current bottom sheet font size: Base: ${textTheme.labelMedium!.fontSize} Screen utils: ${ScreenUtil().setSp(textTheme.labelMedium!.fontSize!)} Scale factor: ${FontSizeScale().scaleFactor}',
              );
              print(
                'Icon size: $iconSize Text field height: $textFieldHeight Font size: ${textFieldTextStyle.fontSize}',
              );
            }

            return ShowCaseWidget(
              builder: Builder(
                builder: (final context) {
                  ShowcaseKey().scaffoldContext = context;
                  return Scaffold(
                    body: SafeArea(
                      child:
                          BlocListener<NavigationBloc, BottomNavigationState>(
                        listenWhen: (final previous, final current) =>
                            previous.pageNumber != current.pageNumber,
                        listener: (final context, final state) async {
                          widget._navigationShell.goBranch(state.pageNumber);
                          await safeUpdateAnimating(animating: true);
                          _pageViewController
                              .animateToPage(
                            state.pageNumber,
                            duration: const Duration(
                              milliseconds: 300,
                            ),
                            curve: Curves.easeInOut,
                          )
                              .then((final value) async {
                            await safeUpdateAnimating(animating: false);
                          });
                        },
                        child: Builder(
                          builder: (final context) => PageView(
                            controller: _pageViewController,
                            onPageChanged: (final int currentPageIndex) async {
                              if (!await safeReadAnimating()) {
                                if (context.mounted) {
                                  context.read<NavigationBloc>().add(
                                        PageViewChanged(
                                          pageNumber: currentPageIndex,
                                        ),
                                      );
                                }
                                widget._navigationShell
                                    .goBranch(currentPageIndex);
                              }
                            },
                            children: widget._children,
                          ),
                        ),
                      ),
                    ),
                    bottomNavigationBar:
                        BlocBuilder<FontSizeCubit, FontSizeState>(
                      builder: (final context, final state) => BottomAppBar(
                        shape: const CircularNotchedRectangle(),
                        // notchMargin: isPortrait ? 8.scaledSp : 5.scaledSp,
                        notchMargin: notchMargin ?? 4.0,
                        padding: EdgeInsets.zero,
                        height: isFontSizeBig()
                            ? 100.h
                            : constraints.maxHeight > 1000
                                ? (isPortrait ? 60.h : 80.h)
                                : (isPortrait ? 50.h : 60.h),
                        child: const BottomNavbar(),
                      ),
                    ),
                    extendBody: true,
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerDocked,
                    floatingActionButton:
                        BlocBuilder<FontSizeCubit, FontSizeState>(
                      builder: (final context, final state) {
                        onTargetClick() {
                          showModalBottomSheet(
                            context: context,
                            builder: (final BuildContext context) =>
                                const _AddBottomSheet(),
                          );
                          Future.delayed(const Duration(milliseconds: 500), () {
                            if (ShowcaseKey().isShowcasingAddDeck) {
                              startShowcase(
                                ShowcaseKey().addMenuContext ?? context,
                                [
                                  ShowcaseKey().addDeckMenu,
                                ],
                              );
                            } else {
                              startShowcase(
                                ShowcaseKey().addMenuContext ?? context,
                                [
                                  ShowcaseKey().addCardMenu,
                                ],
                              );
                            }
                          });
                        }

                        return CustomShowcaseWidget(
                          title: localized(context).showcase_add_fab_title,
                          desc: localized(context).showcase_add_fab_desc,
                          showcaseKey: ShowcaseKey().addFab,
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 5.w,
                          ),
                          targetShapeBorder: const CircleBorder(),
                          onTargetClick: onTargetClick,
                          child: const _AddFloatingButton(),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
}

class _AddFloatingButton extends StatelessWidget {
  const _AddFloatingButton();

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          // final textTheme = Theme.of(context).textTheme;

          const fabShape = CircleBorder();
          fapOnTap() {
            showModalBottomSheet(
              context: context,
              builder: (final BuildContext context) => const _AddBottomSheet(),
            );
          }

          double fabIconSize = isPortrait
              ? 20.scaledSp
              : (isFontSizeBig() ? 10.scaledSp : 15.scaledSp);

          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;

          Widget? floatingActionButton;
          if (screenWidth <= 400 || (!isPortrait && screenHeight <= 400)) {
            floatingActionButton = FloatingActionButton.small(
              onPressed: fapOnTap,
              elevation: 0,
              shape: fabShape,
              child: Icon(
                Icons.add,
                size: fabIconSize,
              ),
            );
          } /*else if (screenWidth >= 800 &&
                    (isPortrait || screenHeight >= 800))*/
          else if (screenWidth >= 800 && (isPortrait || isBigScreen(context))) {
            if (screenWidth > 1200) {
              fabIconSize *= 0.8;
            }
            floatingActionButton = FloatingActionButton.large(
              onPressed: fapOnTap,
              elevation: 0,
              shape: fabShape,
              child: Icon(
                Icons.add,
                size: fabIconSize,
              ),
            );
          } else {
            if (isPortrait) {
              fabIconSize = 25.scaledSp;
            }
            floatingActionButton = FloatingActionButton(
              onPressed: fapOnTap,
              elevation: 0,
              shape: fabShape,
              child: Icon(
                Icons.add,
                size: fabIconSize,
              ),
            );
          }
          return floatingActionButton;
        },
      );
}

class _AddBottomSheet extends StatelessWidget {
  const _AddBottomSheet();

  @override
  Widget build(final BuildContext context) =>
      BlocBuilder<FontSizeCubit, FontSizeState>(
        builder: (final context, final state) => LayoutBuilder(
          builder: (final context, final constraints) {
            final isPortrait =
                MediaQuery.of(context).orientation == Orientation.portrait;
            final textTheme = Theme.of(context).textTheme;
            final labelFontSize = isPortrait
                ? textTheme.labelMedium!.fontSize!.scaledSp
                : textTheme.labelSmall!.fontSize!.scaledSp * 0.8;
            final iconSize = isPortrait ? 18.scaledSp : 10.scaledSp;
            /*if (kDebugMode) {
              print(
                'Current bottom sheet font size: Base: ${textTheme.labelMedium!.fontSize} Scaled: $fontSize Screen utils: ${ScreenUtil().setSp(textTheme.labelMedium!.fontSize!)} Scale factor: ${FontSizeScale().scaleFactor}',
              );
            }*/

            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;
            final visualDensity = screenHeight <= 400
                ? const VisualDensity(vertical: -4)
                : screenHeight < 500
                    ? const VisualDensity(vertical: -2)
                    : screenHeight < 900
                        ? VisualDensity(
                            vertical: screenWidth > 1000 ? 4 : -4,
                          )
                        : screenHeight < 1000
                            ? VisualDensity(
                                vertical: screenWidth > 1000 ? 4 : -2,
                              )
                            : const VisualDensity(vertical: 4);

            addDeckOnTap({
              required final bool isShowcasing,
            }) {
              context.pop();
              context.read<AddDeckBloc>().add(
                    AddDeckOpened(),
                  );
              showDialog(
                context: context,
                builder: (final context) => AddDeckDialog(
                  isShowcasing: isShowcasing,
                ),
              );
            }

            addCardOnTap({
              required final bool isShowcasing,
            }) {
              Navigator.of(context).pop();
              context.read<AddEditCardBloc>().add(
                    AddEditCardFormInit(
                      cardId: '',
                      isShowcasing: isShowcasing,
                    ),
                  );
              context.push('/card/add');
            }

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  0,
                  5.h,
                  0,
                  10.h,
                ),
                child: ShowCaseWidget(
                  builder: Builder(
                    builder: (final context) {
                      ShowcaseKey().addMenuContext = context;
                      return Wrap(
                        children: <Widget>[
                          CustomShowcaseWidget(
                            title:
                                localized(context).showcase_add_card_menu_title,
                            desc:
                                localized(context).showcase_add_card_menu_desc,
                            showcaseKey: ShowcaseKey().addCardMenu,
                            targetShapeBorder: const RoundedRectangleBorder(),
                            onTargetClick: () {
                              addCardOnTap(isShowcasing: true);
                            },
                            child: ListTile(
                              leading: Padding(
                                padding: EdgeInsets.only(
                                  left: 16.w,
                                  right: 5.w,
                                ), // Adjust the padding as needed
                                child: Icon(
                                  Icons.add_box,
                                  size: iconSize,
                                ),
                              ),
                              title: Text(
                                localized(context).add_menu_add_card,
                                style: TextStyle(
                                  fontSize: labelFontSize,
                                ),
                              ),
                              onTap: () {
                                addCardOnTap(isShowcasing: false);
                              },
                              visualDensity: visualDensity,
                              titleAlignment: getListTileTitleAlignment(),
                            ),
                          ),
                          CustomShowcaseWidget(
                            title:
                                localized(context).showcase_add_deck_menu_title,
                            desc:
                                localized(context).showcase_add_deck_menu_desc,
                            showcaseKey: ShowcaseKey().addDeckMenu,
                            targetShapeBorder: const RoundedRectangleBorder(),
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 5.h,
                            ),
                            onTargetClick: () {
                              addDeckOnTap(
                                isShowcasing: true,
                              );
                            },
                            child: ListTile(
                              leading: Padding(
                                padding: EdgeInsets.only(
                                  left: 16.w,
                                  right: 5.w,
                                ),
                                child: Icon(
                                  Icons.library_add,
                                  size: iconSize,
                                ),
                              ),
                              title: Text(
                                localized(context).add_menu_add_deck,
                                style: TextStyle(
                                  fontSize: labelFontSize,
                                ),
                              ),
                              onTap: () {
                                addDeckOnTap(isShowcasing: false);
                              },
                              visualDensity: visualDensity,
                              titleAlignment: getListTileTitleAlignment(),
                            ),
                          ),
                          if (kDebugMode)
                            ListTile(
                              leading: Padding(
                                padding: EdgeInsets.only(
                                  left: 16.w,
                                  right: 5.w,
                                ),
                                child: Icon(
                                  Icons.storage,
                                  size: iconSize,
                                ),
                              ),
                              title: Text(
                                localized(context).add_menu_view_database,
                                style: TextStyle(
                                  fontSize: labelFontSize,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (final context) => DriftDbViewer(
                                      context.read<AppDb>(),
                                    ),
                                  ),
                                );
                              },
                              visualDensity: visualDensity,
                              titleAlignment: getListTileTitleAlignment(),
                            ),
                          /*ListTile(
                                  leading: Padding(
                                    padding: EdgeInsets.only(
                                      left: 16.w,
                                    ),
                                    child: const Icon(
                                      Icons.share,
                                    ),
                                  ),
                                  title: Text(
                                    localized(context).add_menu_get_shared_deck,
                                  ),
                                  onTap: () {
                                    // Handle Get Shared Decks tap
                                    context.go('/card/quill');
                                  },
                                ),*/
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      );
}

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(final BuildContext context) {
    Color color = Theme.of(context).iconTheme.color!;

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: _BottomNavBarItem(
            bottomNavigationItem: BottomNavigationItem.home,
            activeIcons: Icons.home,
            inactiveIcons: Icons.home_outlined,
            iconColor: color,
            text: localized(context).navigation_home,
            isActive: true,
          ),
        ),
        // Expanded(
        //   child: _BottomNavBarItem(
        //     bottomNavigationItem: BottomNavigationItem.browse,
        //     activeIcons: Icons.search,
        //     inactiveIcons: Icons.search_outlined,
        //     iconColor: color,
        //     text: localized(context).navigation_browse,
        //     isActive: false,
        //   ),
        // ),
        // The dummy child for the notch
        // SizedBox(width: 56.w),
        // Expanded(
        //   child: _BottomNavBarItem(
        //     bottomNavigationItem: BottomNavigationItem.statistics,
        //     activeIcons: Icons.insert_chart,
        //     inactiveIcons: Icons.insert_chart_outlined,
        //     iconColor: color,
        //     text: locaized(text).navigation_stats,
        //     isActive: false,
        //   ),
        // ),
        Expanded(
          child: _BottomNavBarItem(
            bottomNavigationItem: BottomNavigationItem.profile,
            activeIcons: Icons.account_circle,
            inactiveIcons: Icons.account_circle_outlined,
            iconColor: color,
            text: localized(context).navigation_profile,
            isActive: false,
          ),
        ),
      ],
    );
  }
}

class _BottomNavBarItem extends StatefulWidget {
  const _BottomNavBarItem({
    required final BottomNavigationItem bottomNavigationItem,
    required final IconData activeIcons,
    required final IconData inactiveIcons,
    required final Color iconColor,
    required final String text,
    required final bool isActive,
  })  : _bottomNavigationItem = bottomNavigationItem,
        _activeIcons = activeIcons,
        _inactiveIcons = inactiveIcons,
        _iconColor = iconColor,
        _text = text,
        _isActive = isActive;

  final BottomNavigationItem _bottomNavigationItem;
  final IconData _activeIcons;
  final IconData _inactiveIcons;
  final Color _iconColor;
  final String _text;
  final bool _isActive;

  @override
  State<StatefulWidget> createState() => _BottomNavBarItemState();
}

class _BottomNavBarItemState extends State<_BottomNavBarItem> {
  late final NavigationBloc _navBar;
  late final StreamSubscription<BottomNavigationState> _navStateSubscription;

  late bool isActive;

  late Key _widgetKey;

  @override
  void initState() {
    super.initState();

    isActive = widget._isActive;

    _navBar = context.read<NavigationBloc>();

    _navStateSubscription = _navBar.stream.listen((final signUpState) {
      bool isActiveNow =
          signUpState.navigationItem == widget._bottomNavigationItem;
      if (isActive != isActiveNow) {
        setState(() {
          isActive = isActiveNow;
        });
      }
    });

    if (widget._isActive) {
      context.read<NavigationBloc>().add(
            BottomNavigationChanged(
              navigationItem: widget._bottomNavigationItem,
            ),
          );
    }

    _widgetKey = Key(const Uuid().v4());
  }

  @override
  void dispose() {
    _navStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) =>
      BlocListener<FontSizeCubit, FontSizeState>(
        listenWhen: (final previous, final current) => previous != current,
        listener: (final context, final state) {
          setState(() {
            _widgetKey = Key(const Uuid().v4());
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Column(
                  key: _widgetKey,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*AnimatedContainer(
                    margin: EdgeInsets.only(bottom: 2.h),
                    duration: const Duration(milliseconds: 200),
                    height: 2.h,
                    width: isActive ? 40.w : 0,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        )),
                  ),*/
                    LayoutBuilder(
                      builder: (final context, final constraints) {
                        final isPortrait = MediaQuery.of(context).orientation ==
                            Orientation.portrait;
                        return Icon(
                          isActive
                              ? widget._activeIcons
                              : widget._inactiveIcons,
                          color: isActive
                              ? widget._iconColor
                              : widget._iconColor.withOpacity(0.5),
                          size: isActive
                              ? (isPortrait ? 20.scaledSp : 10.scaledSp)
                              : (isPortrait ? 25.scaledSp : 15.scaledSp),
                        );
                      },
                    ),
                    if (isActive)
                      _BottomNavBarItemText(
                        text: widget._text,
                      ),
                  ],
                ),
              ),
            ),
            Positioned(
              // Use Positioned.fill to make InkWell cover the container but its ripple is constrained by the inner Container
              child: Material(
                color: Colors.transparent, // Make Material widget transparent
                child: InkWell(
                  onTap: () {
                    _navBar.add(
                      BottomNavigationChanged(
                        navigationItem: widget._bottomNavigationItem,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(50.scaledSp),
                  child: Container(
                    width: 100.w, // Smaller size for the ripple effect
                    height: isFontSizeBig() ? 90.h : 60.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape
                          .circle, // Ensures the ripple effect is circular
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class _BottomNavBarItemText extends StatefulWidget {
  const _BottomNavBarItemText({
    required final String text,
  }) : _text = text;

  final String _text;

  @override
  State<StatefulWidget> createState() => _BottomNavBarItemTextState();
}

class _BottomNavBarItemTextState extends State<_BottomNavBarItemText>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => ScaleTransition(
        scale: _animation,
        child: LayoutBuilder(
          builder: (final context, final constraints) {
            final isPortrait =
                MediaQuery.of(context).orientation == Orientation.portrait;
            final fontSize = isPortrait
                ? Theme.of(context).textTheme.labelSmall!.fontSize!.scaledSp
                : Theme.of(context).textTheme.labelSmall!.fontSize!.scaledSp *
                    0.5;
            return Text(
              widget._text,
              style: TextStyle(
                fontSize: fontSize,
              ),
            );
          },
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:memori_app/features/authentication/views/login_tab_screen.dart';
import 'package:memori_app/features/authentication/views/signup_tab_screen.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/views/language_screen.dart';
import 'package:memori_app/features/common/views/memori_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.tab, super.key});

  final String tab;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    int initialIndex = getTabIndex();
    if (initialIndex == -1) {
      initialIndex = 0;
    }
    _tabController =
        TabController(vsync: this, length: 2, initialIndex: initialIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(final LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    int newIndex = getTabIndex();
    if (newIndex == -1) {
      newIndex = _tabController.index;
    }
    if (_tabController.index != newIndex) {
      if (newIndex >= 0 && newIndex < _tabController.length) {
        _tabController.animateTo(newIndex);
      }
    }
  }

  int getTabIndex() {
    int newIndex;
    switch (widget.tab) {
      case 'login':
        newIndex = 0;
        break;
      case 'signup':
        newIndex = 1;
        break;
      default:
        newIndex = -1; // Keep current index if tab is unknown
    }
    return newIndex;
  }

  void _handleTabTapped(final int index) {
    switch (index) {
      case 0:
        context.go('/userpage/login');
      case 1:
        context.go('/userpage/signup');
    }
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        floatingActionButton: const ChangeLanguageFloatingButton(),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: LayoutBuilder(
                      builder: (final context, final constraints) {
                        final orientation = MediaQuery.of(context).orientation;
                        final isPortrait = orientation == Orientation.portrait;
                        return MemoriLogo(
                          scaleFactor: isPortrait ? 0.5 : 0.7,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: LayoutBuilder(
                  builder: (final context, final constraints) {
                    final orientation = MediaQuery.of(context).orientation;
                    final isPortrait = orientation == Orientation.portrait;
                    final textTheme = Theme.of(context).textTheme;
                    final fontSize = isPortrait
                        ? textTheme.titleSmall!.fontSize!.scaledSp * 0.8
                        : textTheme.titleSmall!.fontSize!.scaledSp * 0.5;
                    final appBarHeight = getAppBarHeight(
                          isPortrait: isPortrait,
                        ) *
                        0.8;
                    return Scaffold(
                      appBar: PreferredSize(
                        preferredSize: Size.fromHeight(
                          appBarHeight,
                        ),
                        child: TabBar(
                          controller: _tabController,
                          onTap: _handleTabTapped,
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelStyle: TextStyle(
                            fontSize: fontSize,
                          ),
                          unselectedLabelStyle: TextStyle(
                            fontSize: fontSize,
                          ),
                          tabs: [
                            SizedBox(
                              height: appBarHeight,
                              child: Tab(
                                text: localized(context).user_login_tab_name,
                              ),
                            ),
                            SizedBox(
                              height: appBarHeight,
                              child: Tab(
                                text: localized(context).user_signup_tab_name,
                              ),
                            ),
                          ],
                        ),
                      ),
                      body: TabBarView(
                        controller: _tabController,
                        children: const [
                          LoginTabScreen(),
                          SignUpTabScreen(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
}

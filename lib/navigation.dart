import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:memori_app/features/authentication/views/login_screen.dart';
import 'package:memori_app/features/cards/views/add_edit/add_edit_card_screen.dart';
import 'package:memori_app/features/cards/views/add_edit/preview_card_screen.dart';
import 'package:memori_app/features/cards/views/browse/browse_card_screen.dart';
import 'package:memori_app/features/cards/views/learn/congratulation_screen.dart';
import 'package:memori_app/features/cards/views/learn/learn_card_screen.dart';
import 'package:memori_app/features/cards/views/quill/quill_screen.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/views/error_screen.dart';
import 'package:memori_app/features/common/views/fine_print_screen.dart';
import 'package:memori_app/features/common/views/homepage.dart';
import 'package:memori_app/features/common/views/language_screen.dart';
import 'package:memori_app/features/common/views/not_found_screen.dart';
import 'package:memori_app/features/common/views/profile_screen.dart';
import 'package:memori_app/features/common/views/scaffold_with_nav_bar.dart';
import 'package:memori_app/features/common/views/splash_screen.dart';
import 'package:memori_app/features/decks/views/deck_setting_screen.dart';

// #region Navigation observer

class AppNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> _routeHistory = [];

  List<Route<dynamic>> get routeHistory => _routeHistory;

  @override
  void didPush(
    final Route<dynamic> route,
    final Route<dynamic>? previousRoute,
  ) {
    _routeHistory.add(route);
    if (kDebugMode) {
      print('Current route name: ${route.settings.name}.');
    }
  }

  @override
  void didPop(
    final Route<dynamic> route,
    final Route<dynamic>? previousRoute,
  ) {
    _routeHistory.removeLast();
  }

  @override
  void didRemove(
    final Route<dynamic> route,
    final Route<dynamic>? previousRoute,
  ) {
    _routeHistory.remove(route);
  }

  @override
  void didReplace({
    final Route<dynamic>? newRoute,
    final Route<dynamic>? oldRoute,
  }) {
    if (oldRoute != null && newRoute != null) {
      final index = _routeHistory.indexOf(oldRoute);
      if (index != -1) {
        _routeHistory[index] = newRoute;
      }
    }
  }

  Route<dynamic>? get lastRoute =>
      _routeHistory.isNotEmpty ? _routeHistory.last : null;
}

// #endregion

// #region Page transition animation

Page<dynamic> fadeThroughStatelessPageBuilder(
  final BuildContext buildContext,
  final GoRouterState state,
  final Widget childWidget, {
  required final String routeName,
}) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      name: routeName,
      child: childWidget,
      transitionDuration: const Duration(milliseconds: 150),
      transitionsBuilder: (
        final BuildContext context,
        final Animation<double> animation,
        final Animation<double> secondaryAnimation,
        final Widget child,
      ) =>
          FadeThroughTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
      ),
    );

Page<dynamic> sharedAxisStatelessPageBuilder(
  final BuildContext buildContext,
  final GoRouterState state,
  final SharedAxisTransitionType trasitionType,
  final Widget childWidget, {
  required final String routeName,
}) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      name: routeName,
      child: childWidget,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (
        final BuildContext context,
        final Animation<double> animation,
        final Animation<double> secondaryAnimation,
        final Widget child,
      ) =>
          SharedAxisTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        transitionType: trasitionType,
        child: child,
      ),
    );

// #endregion

GoRouter getRouter({
  required final AppNavigatorObserver observer,
}) =>
    GoRouter(
      initialLocation:
          FirebaseAuth.instance.currentUser == null ? '/splashscreen' : '/home',
      observers: [
        observer,
      ],
      errorPageBuilder: (final context, final state) =>
          fadeThroughStatelessPageBuilder(
        context,
        state,
        const NotFoundScreen(),
        routeName: '/notfound',
      ),
      routes: [
        StatefulShellRoute(
          builder: (
            final BuildContext context,
            final GoRouterState state,
            final StatefulNavigationShell navigationShell,
          ) =>
              navigationShell,
          pageBuilder: (
            final BuildContext context,
            final GoRouterState state,
            final Widget child,
          ) =>
              CustomTransitionPage<void>(
            key: state.pageKey,
            name: '/home',
            child: child,
            transitionsBuilder: (
              final BuildContext context,
              final Animation<double> animation,
              final Animation<double> secondaryAnimation,
              final Widget child,
            ) =>
                FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
          ),
          navigatorContainerBuilder: (
            final BuildContext context,
            final StatefulNavigationShell navigationShell,
            final List<Widget> children,
          ) =>
              ScaffoldWithNavBar(
            navigationShell: navigationShell,
            children: children,
          ),
          branches: [
            StatefulShellBranch(
              routes: <GoRoute>[
                GoRoute(
                  path: '/home',
                  name: '/home',
                  builder: (final context, final state) => const HomePage(),
                  /*pageBuilder: (
                  final BuildContext context,
                  final GoRouterState state,
                ) =>
                    fadeThroughStatelessPageBuilder(
                  context,
                  state,
                  const HomePage(),
                  routeName: '/home',
                ),*/
                ),
              ],
            ),
            /*StatefulShellBranch(
          routes: <GoRoute>[
            GoRoute(
              path: '/browse',
              builder: (final context, final state) => const BrowseScreen(),
              /*pageBuilder: (
                final BuildContext context,
                final GoRouterState state,
              ) =>
                  fadeThroughTransition(context, state, const BrowseScreen()),*/
            ),
          ],
        ),*/
            /* StatefulShellBranch(
          routes: <GoRoute>[
            GoRoute(
              path: '/stats',
              builder: (final context, final state) => const StatsScreen(),
              /*pageBuilder: (
                final BuildContext context,
                final GoRouterState state,
              ) =>
                  fadeThroughTransition(context, state, const StatsScreen()),*/
            ),
          ],
        ),*/
            StatefulShellBranch(
              routes: <GoRoute>[
                GoRoute(
                  path: '/profile',
                  name: '/profile',
                  builder: (final context, final state) =>
                      const ProfileScreen(),
                  /*pageBuilder: (
                final BuildContext context,
                final GoRouterState state,
              ) =>
                  fadeThroughTransition(context, state, const ProfileScreen()),*/
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/userpage/:tab(login|signup)',
          pageBuilder: (final context, final state) =>
              fadeThroughStatelessPageBuilder(
            context,
            state,
            LoginScreen(tab: state.pathParameters['tab']!),
            routeName: '/userpage/:tab',
          ),
        ),
        GoRoute(
          path: '/splashscreen',
          pageBuilder: (final context, final state) =>
              fadeThroughStatelessPageBuilder(
            context,
            state,
            const SplashScreen(),
            routeName: '/splashscreen',
          ),
        ),
        GoRoute(
          path: '/splashscreen/changelanguage',
          pageBuilder: (final context, final state) =>
              sharedAxisStatelessPageBuilder(
            context,
            state,
            SharedAxisTransitionType.scaled,
            const ChangeLanguageScreen(),
            routeName: '/splashscreen/changelanguage',
          ),
        ),
        GoRoute(
          path: '/card/add',
          pageBuilder: (final context, final state) =>
              sharedAxisStatelessPageBuilder(
            context,
            state,
            SharedAxisTransitionType.scaled,
            const AddEditCardScreen(
              action: AddCardScreenAction.create,
              cardId: '',
            ),
            routeName: '/card/add',
          ),
        ),
        GoRoute(
          path: '/card/edit/:cardId',
          pageBuilder: (final context, final state) =>
              sharedAxisStatelessPageBuilder(
            context,
            state,
            SharedAxisTransitionType.scaled,
            AddEditCardScreen(
              action: AddCardScreenAction.update,
              cardId: state.pathParameters['cardId']!,
            ),
            routeName: '/card/edit/:cardId',
          ),
        ),
        GoRoute(
          path: '/card/preview',
          pageBuilder: (final context, final state) =>
              sharedAxisStatelessPageBuilder(
            context,
            state,
            SharedAxisTransitionType.scaled,
            const PreviewCardScreen(),
            routeName: '/card/preview',
          ),
        ),
        GoRoute(
          path: '/card/quill',
          pageBuilder: (final context, final state) =>
              sharedAxisStatelessPageBuilder(
            context,
            state,
            SharedAxisTransitionType.scaled,
            QuillScreen(
              title: localized(context).add_card_title,
              document: Document(),
            ),
            routeName: '/card/quill',
          ),
        ),
        GoRoute(
          path: '/deck/learn',
          pageBuilder: (final context, final state) =>
              sharedAxisStatelessPageBuilder(
            context,
            state,
            SharedAxisTransitionType.scaled,
            const LearnCardScreen(),
            routeName: '/deck/learn',
          ),
        ),
        GoRoute(
          path: '/deck/congratulate',
          pageBuilder: (final context, final state) =>
              fadeThroughStatelessPageBuilder(
            context,
            state,
            const CongratulationScreen(),
            routeName: '/deck/congratulate',
          ),
        ),
        GoRoute(
          path: '/deck/browse',
          pageBuilder: (final context, final state) =>
              fadeThroughStatelessPageBuilder(
            context,
            state,
            const BrowseCardScreen(),
            routeName: '/deck/browse',
          ),
        ),
        GoRoute(
          path: '/deck/browse/:deckId',
          pageBuilder: (final context, final state) =>
              fadeThroughStatelessPageBuilder(
            context,
            state,
            BrowseCardScreen(
              initialDeckId: state.pathParameters['deckId']!,
              initialDeckName: state.uri.queryParameters['name']!,
            ),
            routeName: '/deck/browse/:deckId',
          ),
        ),
        GoRoute(
          path: '/deck/settings/:deckId',
          pageBuilder: (final context, final state) =>
              sharedAxisStatelessPageBuilder(
            context,
            state,
            SharedAxisTransitionType.scaled,
            DeckSettings(
              deckId: state.pathParameters['deckId']!,
            ),
            routeName: '/deck/settings/:deckId',
          ),
        ),
        GoRoute(
          path: '/settings/changetheme',
          pageBuilder: (final context, final state) =>
              sharedAxisStatelessPageBuilder(
            context,
            state,
            SharedAxisTransitionType.scaled,
            const ChangeThemeScreen(),
            routeName: '/settings/changetheme',
          ),
        ),
        GoRoute(
          path: '/settings/privacypolicy',
          pageBuilder: (final context, final state) =>
              sharedAxisStatelessPageBuilder(
            context,
            state,
            SharedAxisTransitionType.scaled,
            const PrivacyPolicyScreen(),
            routeName: '/settings/privacypolicy',
          ),
        ),
        GoRoute(
          path: '/settings/termsofservice',
          pageBuilder: (final context, final state) =>
              sharedAxisStatelessPageBuilder(
            context,
            state,
            SharedAxisTransitionType.scaled,
            const TermsConditionScreen(),
            routeName: '/settings/termsofservice',
          ),
        ),
        /*GoRoute(
          path: '/settings/licenses',
          pageBuilder: (final context, final state) =>
              sharedAxisStatelessPageBuilder(
            context,
            state,
            SharedAxisTransitionType.scaled,
            LayoutBuilder(
              builder: (final context, final constraints) => DefaultTheme(
                child: LicensePage(
                  applicationName: localized(context).memori_app,
                  applicationVersion: '1.0.0',
                  applicationIcon: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.h,
                    ),
                    child: const MemoriLogo(
                      scaleFactor: 0.25,
                      includeText: false,
                    ),
                  ),
                  applicationLegalese: """
                  MIT License
                  
                  Copyright (c) 2024 Yap Jheng Khin
                  """,
                ),
              ),
            ),
            routeName: '/settings/licenses',
          ),
        ),*/
        GoRoute(
          path: '/error',
          pageBuilder: (final context, final state) =>
              sharedAxisStatelessPageBuilder(
            context,
            state,
            SharedAxisTransitionType.scaled,
            const ErrorScreen(),
            routeName: '/error',
          ),
        ),
      ],
    );

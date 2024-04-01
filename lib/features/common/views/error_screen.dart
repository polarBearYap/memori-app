import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:memori_app/features/authentication/bloc/logout_bloc.dart';
import 'package:memori_app/features/cards/views/common/card_scaffold_screen.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/utils/theme_mode.dart';
import 'package:memori_app/navigation.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final isDarkMode = checkIsDarkMode(context: context);
    final darkFilePrefix = isDarkMode ? '_dark' : '';

    final observer = context.read<AppNavigatorObserver>();
    final isErrorFromHome = observer.lastRoute?.settings.name == '/home';
    final isErrorFromNonLogin = FirebaseAuth.instance.currentUser == null;

    return CardScreenScaffold(
      scrollController: _scrollController,
      scrollbarKey: 'errorScrollBar',
      hideAppBar: true,
      bodyWidgets: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 15.w,
          ),
          child: LayoutBuilder(
            builder: (final context, final constraints) {
              final isPortrait =
                  MediaQuery.of(context).orientation == Orientation.portrait;
              final textTheme = Theme.of(context).textTheme;
              final displaySmall = TextStyle(
                fontSize: isPortrait
                    ? textTheme.titleLarge!.fontSize!.scaledSp
                    : textTheme.titleMedium!.fontSize!.scaledSp,
              );
              final titleMedium = TextStyle(
                fontSize: isPortrait
                    ? textTheme.bodyLarge!.fontSize!.scaledSp
                    : textTheme.bodySmall!.fontSize!.scaledSp * 0.8,
              );

              return Column(
                children: <Widget>[
                  SizedBox(
                    height: isPortrait ? 70.h : 30.h,
                  ),
                  // const Spacer(),
                  SvgPicture.asset(
                    'assets/splash_screens/500_screen$darkFilePrefix.svg',
                    placeholderBuilder: (final BuildContext context) =>
                        Container(
                      padding: const EdgeInsets.all(30.0),
                      child: const CircularProgressIndicator(),
                    ),
                    width: isPortrait ? 300.w : 125.w,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    localized(context).error_500_title,
                    textAlign: TextAlign.center,
                    style: displaySmall,
                    overflow: TextOverflow.visible,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    localized(context).error_500_description,
                    textAlign: TextAlign.center,
                    style: titleMedium,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  FilledButton(
                    onPressed: () {
                      if (isErrorFromNonLogin) {
                        context.go('/splashscreen');
                      } else if (isErrorFromHome) {
                        context.read<LogoutBloc>().add(const LogoutSubmitted());
                        context.go('/userpage/login');
                      } else {
                        context.go('/home');
                      }
                    },
                    style: getFilledButtonStyle(
                      isPortrait: isPortrait,
                    ),
                    child: Text(
                      () {
                        if (isErrorFromNonLogin) {
                          return localized(context).error_return_to_sign_up;
                        } else if (isErrorFromHome) {
                          return localized(context).error_return_to_login;
                        } else {
                          return localized(context).error_return_to_home;
                        }
                      }(),
                      style: getFilledButtonTextStyle(
                        isPortrait: isPortrait,
                        textTheme: textTheme,
                      ),
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
      ],
    );
  }
}

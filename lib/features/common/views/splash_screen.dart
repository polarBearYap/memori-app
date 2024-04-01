import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/utils/theme_mode.dart';
import 'package:memori_app/features/common/views/independent_scroll_view.dart';
import 'package:memori_app/features/common/views/language_screen.dart';
import 'package:memori_app/features/common/views/memori_logo.dart';

class SplashScreenArgs {
  final String title;
  final String description;
  final String image;
  final TextStyle titleStyle;
  final TextStyle descriptionStyle;

  SplashScreenArgs({
    required this.title,
    required this.description,
    required this.image,
    required this.titleStyle,
    required this.descriptionStyle,
  });
}

class SplashScreen extends StatefulWidget {
  static String routeName = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentPage = 0;
  late List<SplashScreenArgs> _splashData;

  @override
  void initState() {
    super.initState();
    _splashData = [];
  }

  Widget _buildSplashScreenPageView() => PageView.builder(
        onPageChanged: (final value) {
          setState(() {
            currentPage = value;
          });
        },
        itemCount: _splashData.length,
        itemBuilder: (final context, final index) => _SplashContent(
          args: _splashData[index],
        ),
      );

  Widget _buildSplashScreenPagination({required final bool isPortrait}) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _splashData.length,
                (final index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(right: 5),
                  height: 6.h,
                  width:
                      currentPage == index ? (isPortrait ? 20.w : 12.w) : 6.w,
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(3.0.scaledSp),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: isPortrait ? 20.h : 40.h,
            ),
            FilledButton(
              onPressed: () {
                context.go('/userpage/signup');
              },
              style: getFilledButtonStyle(
                isPortrait: isPortrait,
              ),
              child: Text(
                localized(context).splashscreen_getstarted,
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
        ),
      ),
    );
  }

  Widget _buildSplashScreenPortrait() => SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Expanded(
              child: _buildSplashScreenPageView(),
            ),
            _buildSplashScreenPagination(isPortrait: true),
            SizedBox(
              height: 30.h,
            ),
          ],
        ),
      );

  Widget _buildSplashScreenLandscape(final BuildContext context) => SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Expanded(
              child: _buildSplashScreenPageView(),
            ),
            _buildSplashScreenPagination(isPortrait: false),
            SizedBox(
              height: 30.h,
            ),
          ],
        ),
      );

  @override
  Widget build(final BuildContext context) => Scaffold(
        floatingActionButton: const ChangeLanguageFloatingButton(),
        body: LayoutBuilder(
          builder: (final context, final constraints) {
            final orientation = MediaQuery.of(context).orientation;
            final isPortrait = orientation == Orientation.portrait;

            final textTheme = Theme.of(context).textTheme;
            final baseTitleStyle =
                isPortrait ? textTheme.titleLarge! : textTheme.titleMedium!;
            final titleStyle = baseTitleStyle.copyWith(
              fontSize: baseTitleStyle.fontSize!.scaledSp * 0.9,
            );
            final baseDescStyle = textTheme.bodySmall!;
            final descStyle = baseDescStyle.copyWith(
              fontSize:
                  baseDescStyle.fontSize!.scaledSp * (isPortrait ? 1 : 0.6),
            );

            final isDarkMode = checkIsDarkMode(context: context);
            final darkFilePrefix = isDarkMode ? '_dark' : '';

            _splashData = [
              SplashScreenArgs(
                title: localized(context).splashscreen_title1,
                description: localized(context).splashscreen_desc1,
                image:
                    'assets/splash_screens/splash_screen_1$darkFilePrefix.svg',
                titleStyle: titleStyle,
                descriptionStyle: descStyle,
              ),
              SplashScreenArgs(
                title: localized(context).splashscreen_title2,
                description: localized(context).splashscreen_desc2,
                image:
                    'assets/splash_screens/splash_screen_2$darkFilePrefix.svg',
                titleStyle: titleStyle,
                descriptionStyle: descStyle,
              ),
              SplashScreenArgs(
                title: localized(context).splashscreen_title3,
                description: localized(context).splashscreen_desc3,
                image:
                    'assets/splash_screens/splash_screen_3$darkFilePrefix.svg',
                titleStyle: titleStyle.copyWith(
                  fontSize: isFontSizeBig()
                      ? baseTitleStyle.fontSize!.scaledSp * 0.75
                      : baseTitleStyle.fontSize!.scaledSp * 0.9,
                ),
                descriptionStyle: descStyle,
              ),
            ];

            return SafeArea(
              child: orientation == Orientation.portrait
                  ? _buildSplashScreenPortrait()
                  : _buildSplashScreenLandscape(context),
            );
          },
        ),
      );
}

class _SplashContent extends StatefulWidget {
  const _SplashContent({
    required final SplashScreenArgs args,
  }) : _args = args;

  final SplashScreenArgs _args;

  @override
  State<_SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<_SplashContent> {
  List<Widget> buildUpperPart({required final bool isPortrait}) => [
        SizedBox(
          height: 30.h,
        ),
        MemoriLogo(
          scaleFactor: isPortrait ? 0.4 : 0.5,
        ),
        SizedBox(
          height: 20.h,
        ),
        // const Spacer(),
        SvgPicture.asset(
          widget._args.image,
          placeholderBuilder: (final BuildContext context) => Container(
            padding: const EdgeInsets.all(30.0),
            child: const CircularProgressIndicator(),
          ),
          // width: 300.w,
          height: isPortrait ? 275.h : 350.h,
        ),
      ];

  List<Widget> buildLowerPart() => [
        SizedBox(
          height: 15.h,
        ),
        Text(
          widget._args.title,
          textAlign: TextAlign.center,
          style: widget._args.titleStyle,
          overflow: TextOverflow.visible,
        ),
        SizedBox(
          height: 15.h,
        ),
        Text(
          widget._args.description,
          textAlign: TextAlign.center,
          style: widget._args.descriptionStyle,
        ),
      ];

  Widget buildPortrait(
    final double? containerHeight,
  ) =>
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15.w,
        ),
        child: IndependentScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            height: containerHeight ?? 500.h,
            child: Column(
              children: <Widget>[
                ...buildUpperPart(isPortrait: true),
                ...buildLowerPart(),
              ],
            ),
          ),
        ),
      );

  Widget buildLandscape(
    final BuildContext context,
    final double? containerHeight,
  ) =>
      IndependentScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          // height: double.infinity,
          // height: MediaQuery.of(context).size.height,
          height: containerHeight ?? 500.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    const Spacer(),
                    ...buildUpperPart(isPortrait: false),
                    const Spacer(),
                  ],
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    const Spacer(
                      flex: 2,
                    ),
                    ...buildLowerPart(),
                    const Spacer(
                      flex: 3,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final orientation = MediaQuery.of(context).orientation;
          final screenHeight = MediaQuery.of(context).size.height;
          return orientation == Orientation.portrait
              ? buildPortrait(
                  isFontSizeBig()
                      ? (screenHeight > 1000 ? 750.h : 650.h)
                      : isFontSizeNormal()
                          ? 550.h
                          : 500.h,
                )
              : buildLandscape(
                  context,
                  isFontSizeBig()
                      ? (screenHeight > 600 ? 650.h : 550.h)
                      : 500.h,
                );
        },
      );
}

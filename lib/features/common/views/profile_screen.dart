import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:memori_app/features/authentication/bloc/logout_bloc.dart';
import 'package:memori_app/features/authentication/views/delete_account_screen.dart';
import 'package:memori_app/features/common/bloc/font_size_bloc.dart';
import 'package:memori_app/features/common/bloc/locale_cubit.dart';
import 'package:memori_app/features/common/bloc/theme_bloc.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/views/font_size_screen.dart';
import 'package:memori_app/features/common/views/language_screen.dart';
import 'package:memori_app/features/common/views/memori_logo.dart';
import 'package:memori_app/features/decks/views/back_navigator.dart';
import 'package:uuid/uuid.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ScrollController _scrollController;
  late Key _pageKey;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _pageKey = Key(const Uuid().v4());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorTheme = theme.colorScheme;
    final splashColor = theme.splashColor;

    final user = FirebaseAuth.instance.currentUser;

    final outlineButtonStyle = ButtonStyle(
      // foregroundColor: MaterialStateProperty.all(
      //   colorTheme.onBackground,
      // ),
      minimumSize: MaterialStateProperty.all(
        Size(
          double.infinity,
          30.h,
        ),
      ),
      // side: MaterialStateProperty.all(
      //   BorderSide(
      //     color: colorTheme.secondary.withAlpha(200),
      //     width: 2.0,
      //   ),
      // ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0.scaledSp),
        ),
      ),
      overlayColor: MaterialStateProperty.all(
        splashColor,
      ),
    );

    final profileMenu = [
      ProfileScreenSectionArgs(
        title: localized(context).settings_username,
        subTitle:
            user?.displayName ?? localized(context).settings_not_specified,
        onTap: () => {},
        showIcon: false,
      ),
      ProfileScreenSectionArgs(
        title: localized(context).settings_email,
        subTitle: user?.email ?? localized(context).settings_not_specified,
        onTap: () => {},
        showIcon: false,
      ),
      /*ProfileScreenSectionArgs(
        title: localized(context).settings_change_password,
        onTap: () => {},
      ),*/
    ];

    final aboutMenu = [
      ProfileScreenSectionArgs(
        title: localized(context).settings_privacy_policy,
        onTap: () => {
          context.push('/settings/privacypolicy'),
        },
      ),
      ProfileScreenSectionArgs(
        title: localized(context).settings_terms_of_service,
        onTap: () => {
          context.push('/settings/termsofservice'),
        },
      ),
      ProfileScreenSectionArgs(
        title: localized(context).settings_open_source_licenses,
        onTap: () => {
          // context.push('/settings/licenses'),
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (final context) => LayoutBuilder(
                builder: (final context, final constraints) {
                  final factor = FontSizeScale().factorDesc;
                  final isPortrait = MediaQuery.of(context).orientation ==
                      Orientation.portrait;
                  final defaultTheme = getDefaultThemeData(
                    context: context,
                    scaleFactor: factor == FontSizeScaleFactor.biggest
                        ? (isPortrait ? 0.25 : 0.30)
                        : factor == FontSizeScaleFactor.bigger
                            ? (isPortrait ? 0.30 : 0.35)
                            : factor == FontSizeScaleFactor.normal
                                ? (isPortrait ? 0.50 : 0.55)
                                : factor == FontSizeScaleFactor.smaller
                                    ? (isPortrait ? 0.65 : 0.7)
                                    : (isPortrait ? 0.65 : 0.7),
                  );

                  return Theme(
                    data: defaultTheme,
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
                      applicationLegalese:
                          localized(context).settings_open_source_licenses_desc,
                    ),
                  );
                },
              ),
            ),
          ),
        },
      ),
    ];

    return BlocListener<FontSizeCubit, FontSizeState>(
      listenWhen: (final previous, final current) => previous != current,
      listener: (final context, final state) {
        setState(() {
          _pageKey = Key(const Uuid().v4());
        });
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 30.h),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: Column(
              key: _pageKey,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                LayoutBuilder(
                  builder: (final context, final constraints) {
                    final isPortrait = MediaQuery.of(context).orientation ==
                        Orientation.portrait;
                    return Text(
                      localized(context).settings,
                      style: TextStyle(
                        fontSize: isPortrait
                            ? textTheme.headlineSmall!.fontSize!.scaledSp
                            : textTheme.headlineSmall!.fontSize!.scaledSp * 0.7,
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 15.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProfileScreenSectionTitle(
                      text: localized(context).settings_personal_info,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    _ProfileScreenSection(
                      args: profileMenu,
                      theme: theme,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    _ProfileScreenSectionTitle(
                      text: localized(context).settings_appearance,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    BlocBuilder<FontSizeCubit, FontSizeState>(
                      buildWhen: (final previous, final current) =>
                          previous.scaleFactor != current.scaleFactor,
                      builder: (final context, final fontState) =>
                          BlocBuilder<ThemeBloc, ThemeState>(
                        buildWhen: (final previous, final current) =>
                            previous.themeMode != current.themeMode,
                        builder: (final context, final state) {
                          final themeMode = BlocProvider.of<ThemeBloc>(context)
                              .state
                              .themeMode;
                          final appearanceMenu = [
                            ProfileScreenSectionArgs(
                              title: localized(context).settings_theme,
                              subTitle: themeMode == ThemeMode.light
                                  ? localized(context).settings_theme_light
                                  : themeMode == ThemeMode.dark
                                      ? localized(context).settings_theme_dark
                                      : localized(context)
                                          .settings_theme_system_default,
                              onTap: () => {
                                context.push('/settings/changetheme'),
                              },
                              isOpenContainerWidget: false,
                              openContainerBuilder:
                                  (final context, final action) =>
                                      const ChangeThemeScreen(),
                            ),
                            ProfileScreenSectionArgs(
                              title:
                                  localized(context).settings_font_size_scale,
                              subTitle: FontSizeScaleFactorExtension.toDisplay(
                                factorDesc: fontState.factorDesc,
                                context: context,
                              ),
                              onTap: () => {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (final BuildContext context) =>
                                      Container(
                                    height: 100.scaledSp,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'A',
                                          style: TextStyle(
                                            fontSize: 12.scaledSp,
                                            color: colorTheme.primary,
                                          ),
                                        ),
                                        Expanded(
                                          child: FontSizeAdjuster(
                                            initSliderValue:
                                                fontState.sliderValue,
                                          ),
                                        ),
                                        Text(
                                          'A',
                                          style: TextStyle(
                                            fontSize: 24.scaledSp,
                                            color: colorTheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              },
                            ),
                          ];
                          return _ProfileScreenSection(
                            args: appearanceMenu,
                            theme: theme,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    _ProfileScreenSectionTitle(
                      text: localized(context).settings_language,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    BlocBuilder<LocaleCubit, Locale>(
                      builder: (final context, final state) =>
                          _ProfileScreenSection(
                        args: [
                          ProfileScreenSectionArgs(
                            title: localized(context).settings_language,
                            subTitle: state.languageCode == 'zh'
                                ? localized(context).language_value_chinese
                                : localized(context).language_value_english,
                            onTap: () => {
                              showModalBottomSheet(
                                context: context,
                                builder: (final BuildContext context) =>
                                    const ChangeLanguageScreen(
                                  hideDescription: true,
                                ),
                              ),
                            },
                          ),
                        ],
                        theme: theme,
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    _ProfileScreenSectionTitle(
                      text: localized(context).settings_about,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    _ProfileScreenSection(
                      args: aboutMenu,
                      theme: theme,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    BlocListener<LogoutBloc, LogoutState>(
                      listener: (final context, final state) {
                        if (state.logoutStatus == LogoutStatus.success) {
                          context.go('/userpage/login');
                        } else if (state.logoutStatus == LogoutStatus.failed) {
                          showScaledSnackBar(
                            context,
                            localized(context).settings_logout_failed,
                          );
                        }
                      },
                      child: BlocBuilder<LogoutBloc, LogoutState>(
                        builder: (final context, final state) => FilledButton(
                          onPressed:
                              state.logoutStatus == LogoutStatus.inprogress
                                  ? null
                                  : () async {
                                      context
                                          .read<LogoutBloc>()
                                          .add(const LogoutSubmitted());
                                    },
                          style: outlineButtonStyle,
                          child: state.logoutStatus == LogoutStatus.inprogress
                              ? CircularProgressIndicator(
                                  color: colorTheme.onSurface,
                                )
                              : LayoutBuilder(
                                  builder: (final context, final constraints) {
                                    final isPortrait =
                                        MediaQuery.of(context).orientation ==
                                            Orientation.portrait;
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5.h,
                                      ),
                                      child: Text(
                                        localized(context).settings_logout,
                                        style: getFilledButtonTextStyle(
                                          isPortrait: isPortrait,
                                          textTheme: textTheme,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                    LayoutBuilder(
                      builder: (final context, final constraints) {
                        final isPortrait = MediaQuery.of(context).orientation ==
                            Orientation.portrait;
                        return SizedBox(
                          height: isPortrait ? 10.scaledSp : 8.scaledSp,
                        );
                      },
                    ),
                    LayoutBuilder(
                      builder: (final context, final constraints) {
                        final isPortrait = MediaQuery.of(context).orientation ==
                            Orientation.portrait;
                        return FilledButton(
                          style: outlineButtonStyle.copyWith(
                            foregroundColor: MaterialStateProperty.all(
                              colorTheme.onError,
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              colorTheme.error,
                            ),
                            side: MaterialStateProperty.all(
                              BorderSide(
                                color: colorTheme.error,
                                width: 2.0,
                              ),
                            ),
                          ),
                          onPressed: () => {
                            showModalBottomSheet(
                              context: context,
                              builder: (final BuildContext context) =>
                                  const DeleteAccountScreen(),
                            ),
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 5.h,
                            ),
                            child: Text(
                              localized(context).settings_delete_account,
                              style: getFilledButtonTextStyle(
                                isPortrait: isPortrait,
                                textTheme: textTheme,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    const Center(
                      child: MemoriLogo(
                        scaleFactor: 0.3,
                        includeText: false,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Center(
                      child: Text(
                        '1.0.0',
                        style: TextStyle(
                          fontSize: textTheme.labelSmall!.fontSize!.scaledSp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileScreenSectionTitle extends StatelessWidget {
  final String _text;

  const _ProfileScreenSectionTitle({required final String text}) : _text = text;

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final textTheme = Theme.of(context).textTheme;
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final sectionFontSize = textTheme.titleSmall!.fontSize!.scaledSp;
          return Text(
            _text,
            style: TextStyle(
              fontSize: isPortrait ? sectionFontSize : sectionFontSize * 0.8,
            ),
          );
        },
      );
}

class ProfileScreenSectionArgs {
  final String title;
  final String? subTitle;
  final VoidCallback onTap;
  final bool isOpenContainerWidget;
  final OpenContainerBuilder? openContainerBuilder;
  final bool showIcon;

  ProfileScreenSectionArgs({
    required this.title,
    this.subTitle,
    required this.onTap,
    this.isOpenContainerWidget = false,
    this.openContainerBuilder,
    this.showIcon = true,
  });
}

class _ProfileScreenSection extends StatelessWidget {
  final List<ProfileScreenSectionArgs> _args;
  final ThemeData _theme;

  const _ProfileScreenSection({
    required final List<ProfileScreenSectionArgs> args,
    required final ThemeData theme,
  })  : _args = args,
        _theme = theme;

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final colorTheme = _theme.colorScheme;
          // final borderColor = colorTheme.onBackground.withAlpha(80);
          final borderColor = colorTheme.secondary;
          final endIdx = _args.length - 1;
          const borderRadius = Radius.circular(20.0);
          // final titleTextColor = colorTheme.onSurface;
          // final subTitleTextColor = titleTextColor.withAlpha(180);
          final titleTextColor = colorTheme.primary;
          final subTitleTextColor = titleTextColor.withAlpha(200);
          const borderThickness = 2.0;

          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;

          final textTheme = Theme.of(context).textTheme;
          final titleFontSize = isPortrait
              ? textTheme.bodyMedium!.fontSize!.scaledSp
              : textTheme.labelSmall!.fontSize!.scaledSp * 0.7;
          final subTitleFontSize = titleFontSize * 0.8;

          List<Widget> widgets = [];

          closedContainer(
            final int i,
            final VoidCallback onTap,
          ) =>
              InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: i == 0 ? borderRadius : Radius.zero,
                    topRight: i == 0 ? borderRadius : Radius.zero,
                    bottomLeft: i == endIdx ? borderRadius : Radius.zero,
                    bottomRight: i == endIdx ? borderRadius : Radius.zero,
                  ),
                ),
                onTap: onTap,
                child: ListTile(
                  title: Text(
                    _args[i].title,
                    style: TextStyle(
                      color: titleTextColor,
                      fontSize: titleFontSize,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: _args[i].subTitle != null
                      ? Text(
                          _args[i].subTitle!,
                          style: TextStyle(
                            color: subTitleTextColor,
                            fontSize: subTitleFontSize,
                          ),
                        )
                      : null,
                  trailing: _args[i].showIcon
                      ? Icon(
                          Icons.navigate_next,
                          size: isPortrait ? 22.5.scaledSp : 15.scaledSp,
                          color: titleTextColor,
                        )
                      : null,
                  visualDensity: getVisualDensity(),
                ),
              );

          for (int i = 0; i <= endIdx; i++) {
            if (_args[i].isOpenContainerWidget) {
              widgets.add(
                OpenContainer(
                  closedColor: colorTheme.surface,
                  openColor: colorTheme.surface,
                  closedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: i == 0 ? borderRadius : Radius.zero,
                      topRight: i == 0 ? borderRadius : Radius.zero,
                      bottomLeft: i == endIdx ? borderRadius : Radius.zero,
                      bottomRight: i == endIdx ? borderRadius : Radius.zero,
                    ),
                  ),
                  transitionType: ContainerTransitionType.fadeThrough,
                  transitionDuration: const Duration(
                    milliseconds: 500,
                  ),
                  openBuilder: _args[i].openContainerBuilder!,
                  onClosed: null,
                  tappable: false,
                  closedBuilder: (
                    final BuildContext _,
                    final VoidCallback openContainer,
                  ) =>
                      closedContainer(i, openContainer),
                ),
              );
            } else {
              widgets.add(closedContainer(i, _args[i].onTap));
            }

            if (i != endIdx) {
              widgets.add(
                Divider(
                  height: 0,
                  thickness: borderThickness, // Adjust thickness as needed
                  color: borderColor, // Adjust color as needed
                ),
              );
            }
          }

          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor,
                width: borderThickness,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              children: widgets,
            ),
          );
        },
      );
}

class ChangeThemeScreen extends StatelessWidget {
  const ChangeThemeScreen({
    super.key,
  });

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final textTheme = Theme.of(context).textTheme;
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final titleFontSize = isPortrait
              ? textTheme.titleMedium!.fontSize!.scaledSp
              : textTheme.titleSmall!.fontSize!.scaledSp;
          final labelFontSize = isPortrait
              ? textTheme.bodyMedium!.fontSize!.scaledSp
              : textTheme.labelSmall!.fontSize!.scaledSp;
          final iconSize = isPortrait ? 20.scaledSp : 12.scaledSp;
          final titleAlignment = getListTileTitleAlignment();
          return Scaffold(
            appBar: AppBar(
              leading: const BackNavigator(),
              leadingWidth: getAppBarLeadingWidth(isPortrait: isPortrait),
              title: Text(
                localized(context).settings_theme_title,
                style: TextStyle(
                  fontSize: titleFontSize,
                ),
              ),
              toolbarHeight: getAppBarHeight(isPortrait: isPortrait),
            ),
            body: SafeArea(
              child: BlocBuilder<ThemeBloc, ThemeState>(
                buildWhen: (final previous, final current) =>
                    previous.themeMode != current.themeMode,
                builder: (final context, final state) => Column(
                  children: [
                    InkWell(
                      onTap: () => {
                        context.read<ThemeBloc>().add(
                              const ThemeChanged(
                                themeMode: ThemeMode.light,
                              ),
                            ),
                      },
                      child: ListTile(
                        titleAlignment: titleAlignment,
                        leading: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                          ),
                          child: Icon(
                            Icons.light_mode_outlined,
                            size: iconSize,
                          ),
                        ),
                        title: Text(
                          localized(context).settings_theme_light,
                          style: TextStyle(
                            fontSize: labelFontSize,
                          ),
                        ),
                        trailing: state.themeMode == ThemeMode.light
                            ? Icon(
                                Icons.done,
                                size: iconSize,
                              )
                            : null,
                      ),
                    ),
                    InkWell(
                      onTap: () => {
                        context.read<ThemeBloc>().add(
                              const ThemeChanged(
                                themeMode: ThemeMode.dark,
                              ),
                            ),
                      },
                      child: ListTile(
                        titleAlignment: titleAlignment,
                        leading: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                          ),
                          child: Icon(
                            Icons.dark_mode_outlined,
                            size: iconSize,
                          ),
                        ),
                        title: Text(
                          localized(context).settings_theme_dark,
                          style: TextStyle(
                            fontSize: labelFontSize,
                          ),
                        ),
                        trailing: state.themeMode == ThemeMode.dark
                            ? Icon(
                                Icons.done,
                                size: iconSize,
                              )
                            : null,
                      ),
                    ),
                    InkWell(
                      onTap: () => {
                        context.read<ThemeBloc>().add(
                              const ThemeChanged(
                                themeMode: ThemeMode.system,
                              ),
                            ),
                      },
                      child: ListTile(
                        titleAlignment: titleAlignment,
                        leading: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                          ),
                          child: Icon(
                            Icons.settings_outlined,
                            size: iconSize,
                          ),
                        ),
                        title: Text(
                          localized(context).settings_theme_system_default,
                          style: TextStyle(
                            fontSize: labelFontSize,
                          ),
                        ),
                        trailing: state.themeMode == ThemeMode.system
                            ? Icon(
                                Icons.done,
                                size: iconSize,
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}

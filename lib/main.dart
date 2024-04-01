import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_quill/translations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:memori_app/features/common/bloc/locale_cubit.dart';
import 'package:memori_app/features/common/bloc/theme_bloc.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/views/error_screen.dart';
import 'package:memori_app/features/sync/bloc/sync_bloc.dart';
import 'package:memori_app/firebase/remote_config/remote_config.dart';
import 'package:memori_app/firebase_options.dart';
import 'package:memori_app/navigation.dart';
import 'package:memori_app/provider.dart';
import 'package:memori_app/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Firebase setup
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval:
          kDebugMode ? const Duration(minutes: 5) : const Duration(hours: 1),
    ),
  );
  await remoteConfig.setDefaults({
    RemoteConfigKey.syncBackendUrl: "http://localhost:8080",
  });
  await remoteConfig.fetchAndActivate();

  /*if (kDebugMode) {
    try {
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } on Exception catch (e) {
      print(e);
    }
  }*/

  // Get the user's selected locale from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? selectedLocale = prefs.getString('preferredLanguage');
  // Set the locale if it's not null
  if (selectedLocale != null) {
    Intl.defaultLocale = selectedLocale;
  }

  // Default error fallback page
  ErrorWidget.builder =
      (final FlutterErrorDetails details) => const ErrorScreen();

  // Get the user's preferred font size
  initFontSizeScale(prefs);

  runApp(
    kDebugMode
        ? DevicePreview(
            // enabled: !kReleaseMode,
            enabled: false,
            builder: (final context) => Provider(
              prefs: prefs,
              child: const MemoriApp(),
            ),
          )
        : Provider(
            prefs: prefs,
            child: const MemoriApp(),
          ),
  );
}

class MemoriApp extends StatefulWidget {
  const MemoriApp({super.key});

  @override
  State<StatefulWidget> createState() => _MemoriAppState();
}

class _MemoriAppState extends State<MemoriApp> {
  late final GoRouter _routerConfig;

  @override
  void initState() {
    super.initState();
    context.read<SyncBloc>().add(UserAutoLogin());
    _routerConfig = getRouter(
      observer: context.read<AppNavigatorObserver>(),
    );
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(final BuildContext context) => ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        child: BlocBuilder<ThemeBloc, ThemeState>(
          buildWhen: (final previous, final current) =>
              previous.themeMode != current.themeMode,
          builder: (final context, final state) =>
              BlocBuilder<LocaleCubit, Locale>(
            builder: (final context, final localeState) => MaterialApp.router(
              builder: kDebugMode ? DevicePreview.appBuilder : null,
              // title: localized(context).memori_app,
              localizationsDelegates: const [
                // DefaultCupertinoLocalizations.delegate,
                // DefaultMaterialLocalizations.delegate,
                // DefaultWidgetsLocalizations.delegate,
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                FlutterQuillLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'), // English
                Locale('zh'), // Chinese
              ],
              // locale: Locale(Intl.getCurrentLocale()),
              locale: localeState,
              theme: FlexLightTheme,
              darkTheme: FlexDarkTheme,
              themeMode: state.themeMode,
              routerConfig: _routerConfig,
              debugShowCheckedModeBanner: false,
            ),
          ),
        ),
      );
}

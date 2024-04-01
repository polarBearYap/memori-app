import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:intl/intl.dart';

String getFontFamily() =>
    Intl.getCurrentLocale() == 'zh' ? 'NotoSansSC' : 'NotoSans';

// ignore: non_constant_identifier_names
final FlexLightTheme = FlexThemeData.light(
  scheme: FlexScheme.blue,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 7,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 10,
    blendOnColors: false,
    useTextTheme: true,
    useM2StyleDividerInM3: true,
    alignedDropdown: true,
    useInputDecoratorThemeInDialogs: true,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  fontFamily: getFontFamily(),
);

// ignore: non_constant_identifier_names
final FlexDarkTheme = FlexThemeData.dark(
  scheme: FlexScheme.blue,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 13,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 20,
    useTextTheme: true,
    useM2StyleDividerInM3: true,
    alignedDropdown: true,
    useInputDecoratorThemeInDialogs: true,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  fontFamily: getFontFamily(),
);

/*
extension LightThemeData on ThemeData {
  ThemeData get lightTheme {
    return ThemeData(
        colorScheme: LightTheme.scheme,
        fontFamily: getFontFamily(),
        inputDecorationTheme: Theme.inputDecorationTheme,
        outlinedButtonTheme: Theme.outlinedButtonTheme,
        textTheme: Theme.textTheme(LightTheme.textColor),
        useMaterial3: true);
  }
}

extension DarkThemeData on ThemeData {
  ThemeData get darkTheme {
    return ThemeData(
        colorScheme: DarkTheme.scheme,
        fontFamily: getFontFamily(),
        inputDecorationTheme: Theme.inputDecorationTheme,
        outlinedButtonTheme: Theme.outlinedButtonTheme,
        textTheme: Theme.textTheme(DarkTheme.textColor),
        useMaterial3: true);
  }
}

class Theme {
  static final inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static final outlinedButtonTheme = OutlinedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.all(24),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    ),
  );

  static TextTheme textTheme(Color textColor) => TextTheme(
        displayLarge: TextStyle(
          color: textColor,
          fontSize: 57,
          letterSpacing: -0.25,
          height: 1.12,
        ),
        displayMedium: TextStyle(
          color: textColor,
          fontSize: 45,
          letterSpacing: 0,
          height: 1.16,
        ),
        displaySmall: TextStyle(
          color: textColor,
          fontSize: 36,
          letterSpacing: 0,
          height: 1.22,
        ),
        headlineLarge: TextStyle(
          color: textColor,
          fontSize: 32,
          letterSpacing: 0,
          height: 1.25,
        ),
        headlineMedium: TextStyle(
          color: textColor,
          fontSize: 28,
          letterSpacing: 0,
          height: 1.29,
        ),
        headlineSmall: TextStyle(
          color: textColor,
          fontSize: 24,
          letterSpacing: 0,
          height: 1.33,
        ),
        titleLarge: TextStyle(
          color: textColor,
          fontSize: 22,
          letterSpacing: 0,
          height: 1.27,
        ),
        titleMedium: TextStyle(
          color: textColor,
          fontSize: 16,
          letterSpacing: 0.15,
          height: 1.50,
        ),
        titleSmall: TextStyle(
          color: textColor,
          fontSize: 14,
          letterSpacing: 0.10,
          height: 1.43,
        ),
        bodyLarge: TextStyle(
          color: textColor,
          fontSize: 16,
          letterSpacing: 0.50,
          height: 1.50,
        ),
        bodyMedium: TextStyle(
          color: textColor,
          fontSize: 14,
          letterSpacing: 0.25,
          height: 1.43,
        ),
        bodySmall: TextStyle(
          color: textColor,
          fontSize: 12,
          letterSpacing: 0.40,
          height: 1.33,
        ),
        labelLarge: TextStyle(
          color: textColor,
          fontSize: 14,
          letterSpacing: 0.10,
          height: 1.43,
        ),
        labelMedium: TextStyle(
          color: textColor,
          fontSize: 12,
          letterSpacing: 0.50,
          height: 1.33,
        ),
        labelSmall: TextStyle(
          color: textColor,
          fontSize: 11,
          letterSpacing: 0.50,
          height: 1.45,
        ),
      );
}

// Color theme is picked from https://rydmike.com/flexcolorscheme/themesplayground-latest/
class LightTheme extends Theme {
  static const ColorScheme scheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff1565c0),
    onPrimary: Color(0xffffffff),
    primaryContainer: Color(0xff90caf9),
    onPrimaryContainer: Color(0xff0c1114),
    secondary: Color(0xff0277bd),
    onSecondary: Color(0xffffffff),
    secondaryContainer: Color(0xffbedcff),
    onSecondaryContainer: Color(0xff101214),
    tertiary: Color(0xff039be5),
    onTertiary: Color(0xffffffff),
    tertiaryContainer: Color(0xffcbe6ff),
    onTertiaryContainer: Color(0xff111314),
    error: Color(0xffb00020),
    onError: Color(0xffffffff),
    errorContainer: Color(0xfffcd8df),
    onErrorContainer: Color(0xff141213),
    background: Color(0xfff8fafd),
    onBackground: Color(0xff090909),
    surface: Color(0xfff8fafd),
    onSurface: Color(0xff090909),
    surfaceVariant: Color(0xffe2e6eb),
    onSurfaceVariant: Color(0xff111212),
    outline: Color(0xff7c7c7c),
    outlineVariant: Color(0xffc8c8c8),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xff111315),
    onInverseSurface: Color(0xfff5f5f5),
    inversePrimary: Color(0xffaedfff),
    surfaceTint: Color(0xff1565c0),
  );

  static const Color textColor = Color(0xfff8fafd);
}

class DarkTheme extends Theme {
  static const ColorScheme scheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xff90caf9),
    onPrimary: Color(0xff0f1314),
    primaryContainer: Color(0xff0d47a1),
    onPrimaryContainer: Color(0xffe1eaf9),
    secondary: Color(0xffe1f5fe),
    onSecondary: Color(0xff141414),
    secondaryContainer: Color(0xff1a567d),
    onSecondaryContainer: Color(0xffe3edf3),
    tertiary: Color(0xff81d4fa),
    onTertiary: Color(0xff0e1414),
    tertiaryContainer: Color(0xff004b73),
    onTertiaryContainer: Color(0xffdfebf1),
    error: Color(0xffcf6679),
    onError: Color(0xff140c0d),
    errorContainer: Color(0xffb1384e),
    onErrorContainer: Color(0xfffbe8ec),
    background: Color(0xff171a1c),
    onBackground: Color(0xffeceded),
    surface: Color(0xff171a1c),
    onSurface: Color(0xffeceded),
    surfaceVariant: Color(0xff3b4146),
    onSurfaceVariant: Color(0xffe0e1e1),
    outline: Color(0xff767d7d),
    outlineVariant: Color(0xff2c2e2e),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xfff9fcfe),
    onInverseSurface: Color(0xff131313),
    inversePrimary: Color(0xff4c6576),
    surfaceTint: Color(0xff90caf9),
  );

  static const Color textColor = Color(0xff171a1c);
}
*/
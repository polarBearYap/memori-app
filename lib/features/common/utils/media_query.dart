import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/common/utils/font_size.dart';

bool isBigScreen(
  final BuildContext context,
) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  return screenWidth > 1000 && screenHeight > 1000;
}

bool isScreenPhone(
  final BuildContext context,
) {
  final screenWidth = MediaQuery.of(context).size.shortestSide;
  return screenWidth < 600;
}

bool isScreenTablet(
  final BuildContext context,
) {
  final screenWidth = MediaQuery.of(context).size.shortestSide;
  return screenWidth >= 600;
}

bool isFontSizeBig() {
  final factor = FontSizeScale().factorDesc;
  return factor == FontSizeScaleFactor.bigger ||
      factor == FontSizeScaleFactor.biggest;
}

bool isFontSizeSmall() {
  final factor = FontSizeScale().factorDesc;
  return factor == FontSizeScaleFactor.smaller ||
      factor == FontSizeScaleFactor.smallest;
}

bool isFontSizeNormal() {
  final factor = FontSizeScale().factorDesc;
  return factor == FontSizeScaleFactor.normal;
}

double getAppBarLeadingWidth({
  required final bool isPortrait,
}) =>
    isFontSizeBig() ? (isPortrait ? 45.w : 30.w) : (isPortrait ? 30.w : 20.w);

double getAppBarHeight({
  required final bool isPortrait,
}) {
  final factor = FontSizeScale().factorDesc;

  return factor == FontSizeScaleFactor.biggest
      ? (isPortrait ? 60.h : 90.h)
      : factor == FontSizeScaleFactor.bigger
          ? (isPortrait ? 50.h : 80.h)
          : factor == FontSizeScaleFactor.smallest
              ? (isPortrait ? 40.h : 60.h)
              : isPortrait
                  ? 40.h
                  : 80.h;
}

double getCheckboxScale(
  final BuildContext context,
) {
  final factor = FontSizeScale().factorDesc;
  if (isScreenPhone(context)) {
    switch (factor) {
      case FontSizeScaleFactor.biggest:
        return 1.0;
      case FontSizeScaleFactor.bigger:
        return 1.0;
      case FontSizeScaleFactor.normal:
        return 0.7;
      case FontSizeScaleFactor.smaller:
        return 0.6;
      case FontSizeScaleFactor.smallest:
        return 0.5;
    }
  }
  switch (factor) {
    case FontSizeScaleFactor.biggest:
      return 2.0;
    case FontSizeScaleFactor.bigger:
      return 1.8;
    case FontSizeScaleFactor.normal:
      return 1.5;
    case FontSizeScaleFactor.smaller:
      return 1.0;
    case FontSizeScaleFactor.smallest:
      return 1.0;
  }
}

double getRadioScale(
  final BuildContext context,
) {
  final factor = FontSizeScale().factorDesc;
  if (isScreenPhone(context)) {
    switch (factor) {
      case FontSizeScaleFactor.biggest:
        return 1.0;
      case FontSizeScaleFactor.bigger:
        return 1.0;
      case FontSizeScaleFactor.normal:
        return 0.7;
      case FontSizeScaleFactor.smaller:
        return 0.6;
      case FontSizeScaleFactor.smallest:
        return 0.5;
    }
  }
  switch (factor) {
    case FontSizeScaleFactor.biggest:
      return 2.0;
    case FontSizeScaleFactor.bigger:
      return 1.8;
    case FontSizeScaleFactor.normal:
      return 1.5;
    case FontSizeScaleFactor.smaller:
      return 1.0;
    case FontSizeScaleFactor.smallest:
      return 1.0;
  }
}

double getSwitchScale(
  final BuildContext context,
) {
  final factor = FontSizeScale().factorDesc;
  if (isScreenPhone(context)) {
    switch (factor) {
      case FontSizeScaleFactor.biggest:
      case FontSizeScaleFactor.bigger:
      case FontSizeScaleFactor.normal:
        return 1.0;
      case FontSizeScaleFactor.smaller:
      case FontSizeScaleFactor.smallest:
        return 0.75;
    }
  }
  switch (factor) {
    case FontSizeScaleFactor.biggest:
      return 2.0;
    case FontSizeScaleFactor.bigger:
      return 1.8;
    case FontSizeScaleFactor.normal:
      return 1.5;
    case FontSizeScaleFactor.smaller:
      return 1.0;
    case FontSizeScaleFactor.smallest:
      return 1.0;
  }
}

ButtonStyle getFilledButtonStyle({
  required final bool isPortrait,
}) =>
    ButtonStyle(
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0.scaledSp),
        ),
      ),
      fixedSize: MaterialStateProperty.all(
        Size(
          isPortrait ? 300.w : 200.w,
          isFontSizeBig()
              ? (isPortrait ? 40.h : 50.h)
              : isPortrait
                  ? 30.h
                  : 40.h,
        ),
      ),
    );

TextStyle getFilledButtonTextStyle({
  required final bool isPortrait,
  required final TextTheme textTheme,
}) =>
    TextStyle(
      fontSize: isPortrait
          ? textTheme.labelMedium!.fontSize!.scaledSp
          : textTheme.labelSmall!.fontSize!.scaledSp * 0.7,
    );

VisualDensity getVisualDensity() => VisualDensity(
      vertical: isFontSizeBig() ? 4.0 : 1.0,
    );

QuillIconTheme getQuillIconTheme() => QuillIconTheme(
      iconButtonSelectedData: IconButtonData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
      ),
      iconButtonUnselectedData: IconButtonData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
      ),
    );

TextStyle getDialogTitle({
  required final bool isPortrait,
  required final TextTheme textTheme,
}) =>
    TextStyle(
      fontSize: isPortrait
          ? textTheme.titleSmall!.fontSize!.scaledSp
          : textTheme.titleSmall!.fontSize!.scaledSp * 0.8,
    );

TextStyle getDialogContent({
  required final bool isPortrait,
  required final TextTheme textTheme,
}) =>
    TextStyle(
      fontSize: isPortrait
          ? textTheme.bodySmall!.fontSize!.scaledSp
          : textTheme.bodySmall!.fontSize!.scaledSp * 0.6,
    );

TextStyle getDialogLabel({
  required final bool isPortrait,
  required final TextTheme textTheme,
}) =>
    TextStyle(
      fontSize: isPortrait
          ? textTheme.labelSmall!.fontSize!.scaledSp
          : textTheme.labelSmall!.fontSize!.scaledSp * 0.7,
    );

TextStyle getSnackbarText({
  required final bool isPortrait,
  required final TextTheme textTheme,
}) =>
    TextStyle(
      fontSize: isPortrait
          ? textTheme.labelSmall!.fontSize!.scaledSp
          : textTheme.labelSmall!.fontSize!.scaledSp * 0.7,
    );

void showScaledSnackBar(
  final BuildContext context,
  final String text,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final textTheme = Theme.of(context).textTheme;
          return Text(
            text,
            style: getSnackbarText(
              isPortrait: isPortrait,
              textTheme: textTheme,
            ),
          );
        },
      ),
    ),
  );
}

double getDefaultIconSize({
  required final bool isPortrait,
}) =>
    isFontSizeBig()
        ? (isPortrait ? 15.scaledSp : 15.scaledSp)
        : isPortrait
            ? 15.scaledSp
            : 10.scaledSp;

InputDecoration getTextFieldDecoration({
  required final bool isPortrait,
  required final TextTheme textTheme,
  final IconData? prefixIconData,
  final double? iconSize,
}) {
  final fontSize = isPortrait
      ? textTheme.bodySmall!.fontSize!.scaledSp
      : textTheme.bodySmall!.fontSize!.scaledSp * 0.6;
  final defaultIconSize = getDefaultIconSize(
    isPortrait: isPortrait,
  );
  return InputDecoration(
    prefixIcon: prefixIconData == null
        ? null
        : Padding(
            padding: EdgeInsets.only(
              left: 8.w,
              right: 5.w,
            ),
            child: Icon(
              prefixIconData,
              size: iconSize ?? defaultIconSize,
            ),
          ),
    border: const OutlineInputBorder(),
    focusedBorder: const OutlineInputBorder(),
    hintStyle: TextStyle(
      fontSize: fontSize,
    ),
    errorStyle: TextStyle(
      fontSize: fontSize * 0.8,
    ),
    labelStyle: TextStyle(
      fontSize: fontSize,
    ),
    floatingLabelStyle: TextStyle(
      fontSize: fontSize,
    ),
  );
}

TextStyle getTextFieldStyle({
  required final bool isPortrait,
  required final TextTheme textTheme,
}) {
  final fontSize = isPortrait
      ? textTheme.bodySmall!.fontSize!.scaledSp
      : textTheme.bodySmall!.fontSize!.scaledSp * 0.6;
  return TextStyle(
    fontSize: fontSize,
  );
}

double getTextFieldHeight({
  required final bool isPortrait,
  required final bool hasErrorText,
}) {
  final factor = FontSizeScale().factorDesc;
  if (hasErrorText) {
    return factor == FontSizeScaleFactor.biggest
        ? (isPortrait ? 110.h : 130.h)
        : factor == FontSizeScaleFactor.bigger
            ? (isPortrait ? 100.h : 130.h)
            : factor == FontSizeScaleFactor.normal
                ? (isPortrait ? 80.h : 100.h)
                : factor == FontSizeScaleFactor.smaller
                    ? (isPortrait ? 70.h : 90.h)
                    : (isPortrait ? 60.h : 70.h);
  } else {
    return isFontSizeBig()
        ? (isPortrait ? 70.h : 80.h)
        : factor == FontSizeScaleFactor.smallest
            ? (isPortrait ? 35.h : 50.h)
            : factor == FontSizeScaleFactor.smaller
                ? (isPortrait ? 40.h : 60.h)
                : (isPortrait ? 50.h : 60.h);
  }
}

BoxConstraints getPopupMenuBoxConstraints() => BoxConstraints(
      maxWidth: 200.w,
    );

Offset getPopupMenuOffset({
  required final bool isPortrait,
}) =>
    Offset(
      0,
      isFontSizeBig()
          ? 40.h
          : isPortrait
              ? 30.h
              : 40.h,
    );

double getPopupMenuItemHeight() => isFontSizeBig() ? 50.h : 30.h;

double getPopupIcon({
  required final bool isPortrait,
}) =>
    isPortrait ? 15.scaledSp : 10.scaledSp;

double getPopupLabel({
  required final bool isPortrait,
  required final TextTheme textTheme,
}) =>
    isPortrait
        ? textTheme.labelMedium!.fontSize!.scaledSp
        : textTheme.labelSmall!.fontSize!.scaledSp * 0.7;

ThemeData getDefaultThemeData({
  required final BuildContext context,
  final double? scaleFactor,
}) {
  final theme = Theme.of(context);
  final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
  final textTheme = Theme.of(context).textTheme;
  double iconSize = isPortrait ? 20.scaledSp : 15.scaledSp;
  getFontSize(final double fontSize) => isPortrait ? fontSize : fontSize * 0.7;
  final finalScaleFactor = scaleFactor ?? 1.0;
  iconSize *= finalScaleFactor;
  return theme.copyWith(
    appBarTheme: AppBarTheme(
      toolbarHeight: getAppBarHeight(
        isPortrait: isPortrait,
      ),
      iconTheme: theme.appBarTheme.iconTheme!.copyWith(
        size: iconSize,
      ),
    ),
    iconTheme: theme.iconTheme.copyWith(
      size: iconSize,
    ),
    primaryIconTheme: theme.primaryIconTheme.copyWith(
      size: iconSize,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0.scaledSp),
          ),
        ),
        iconSize: MaterialStateProperty.all(
          iconSize,
        ),
        fixedSize: MaterialStateProperty.all(
          Size(
            40.w,
            40.w,
          ),
        ),
      ),
    ),
    textTheme: Theme.of(context).textTheme.copyWith(
          titleLarge: TextStyle(
            fontSize: getFontSize(
              textTheme.titleLarge!.fontSize!.scaledSp * finalScaleFactor,
            ),
          ),
          titleMedium: TextStyle(
            fontSize: getFontSize(
              textTheme.titleMedium!.fontSize!.scaledSp * finalScaleFactor,
            ),
          ),
          titleSmall: TextStyle(
            fontSize: getFontSize(
              textTheme.titleSmall!.fontSize!.scaledSp * finalScaleFactor,
            ),
          ),
          bodyLarge: TextStyle(
            fontSize: getFontSize(
              textTheme.bodyLarge!.fontSize!.scaledSp * finalScaleFactor,
            ),
          ),
          bodyMedium: TextStyle(
            fontSize: getFontSize(
              textTheme.bodyMedium!.fontSize!.scaledSp * finalScaleFactor,
            ),
          ),
          bodySmall: TextStyle(
            fontSize: getFontSize(
              textTheme.bodySmall!.fontSize!.scaledSp * finalScaleFactor,
            ),
          ),
          labelLarge: TextStyle(
            fontSize: getFontSize(
              textTheme.labelLarge!.fontSize!.scaledSp * finalScaleFactor,
            ),
          ),
          labelMedium: TextStyle(
            fontSize: getFontSize(
              textTheme.labelMedium!.fontSize!.scaledSp * finalScaleFactor,
            ),
          ),
          labelSmall: TextStyle(
            fontSize: getFontSize(
              textTheme.labelSmall!.fontSize!.scaledSp * finalScaleFactor,
            ),
          ),
        ),
  );
}

ListTileTitleAlignment getListTileTitleAlignment() => isFontSizeBig()
    ? ListTileTitleAlignment.titleHeight
    : ListTileTitleAlignment.center;

import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart';

DefaultStyles getAppDefaultStyle({
  required final BuildContext context,
  required final double fontScale,
}) {
  final themeData = Theme.of(context);
  final defaultTextStyle = DefaultTextStyle.of(context);
  final baseStyle = defaultTextStyle.style.copyWith(
    fontSize: 16 * fontScale,
    height: 1.3,
    decoration: TextDecoration.none,
  );
  const baseSpacing = VerticalSpacing(6, 0);
  String fontFamily;
  if (isAppleOS(platform: themeData.platform, supportWeb: true)) {
    fontFamily = 'Menlo';
  } else {
    fontFamily = 'Roboto Mono';
  }

  final inlineCodeStyle = TextStyle(
    fontSize: 14 * fontScale,
    color: themeData.colorScheme.primary.withOpacity(0.8),
    fontFamily: fontFamily,
  );

  return DefaultStyles(
    h1: DefaultTextBlockStyle(
      defaultTextStyle.style.copyWith(
        fontSize: 34 * fontScale,
        color: defaultTextStyle.style.color,
        letterSpacing: -1,
        height: 1,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.none,
      ),
      const VerticalSpacing(16, 0),
      const VerticalSpacing(0, 0),
      null,
    ),
    h2: DefaultTextBlockStyle(
      defaultTextStyle.style.copyWith(
        fontSize: 30 * fontScale,
        color: defaultTextStyle.style.color,
        letterSpacing: -0.8,
        height: 1.067,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.none,
      ),
      const VerticalSpacing(8, 0),
      const VerticalSpacing(0, 0),
      null,
    ),
    h3: DefaultTextBlockStyle(
      defaultTextStyle.style.copyWith(
        fontSize: 24 * fontScale,
        color: defaultTextStyle.style.color,
        letterSpacing: -0.5,
        height: 1.083,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.none,
      ),
      const VerticalSpacing(8, 0),
      const VerticalSpacing(0, 0),
      null,
    ),
    h4: DefaultTextBlockStyle(
      defaultTextStyle.style.copyWith(
        fontSize: 20 * fontScale,
        color: defaultTextStyle.style.color,
        letterSpacing: -0.4,
        height: 1.1,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.none,
      ),
      const VerticalSpacing(6, 0),
      const VerticalSpacing(0, 0),
      null,
    ),
    h5: DefaultTextBlockStyle(
      defaultTextStyle.style.copyWith(
        fontSize: 18 * fontScale,
        color: defaultTextStyle.style.color,
        letterSpacing: -0.2,
        height: 1.11,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.none,
      ),
      const VerticalSpacing(6, 0),
      const VerticalSpacing(0, 0),
      null,
    ),
    h6: DefaultTextBlockStyle(
      defaultTextStyle.style.copyWith(
        fontSize: 16 * fontScale,
        color: defaultTextStyle.style.color,
        letterSpacing: -0.1,
        height: 1.125,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.none,
      ),
      const VerticalSpacing(4, 0),
      const VerticalSpacing(0, 0),
      null,
    ),
    paragraph: DefaultTextBlockStyle(
      baseStyle,
      const VerticalSpacing(0, 0),
      const VerticalSpacing(0, 0),
      null,
    ),
    bold: const TextStyle(fontWeight: FontWeight.bold),
    subscript: const TextStyle(
      fontFeatures: [
        FontFeature.liningFigures(),
        FontFeature.subscripts(),
      ],
    ),
    superscript: const TextStyle(
      fontFeatures: [
        FontFeature.liningFigures(),
        FontFeature.superscripts(),
      ],
    ),
    italic: const TextStyle(fontStyle: FontStyle.italic),
    small: TextStyle(fontSize: 12 * fontScale),
    underline: const TextStyle(decoration: TextDecoration.underline),
    strikeThrough: const TextStyle(decoration: TextDecoration.lineThrough),
    inlineCode: InlineCodeStyle(
      backgroundColor: Colors.grey.shade100,
      radius: const Radius.circular(3),
      style: inlineCodeStyle,
      header1: inlineCodeStyle.copyWith(
        fontSize: 32 * fontScale,
        fontWeight: FontWeight.w500,
      ),
      header2: inlineCodeStyle.copyWith(
        fontSize: 22 * fontScale,
        fontWeight: FontWeight.w500,
      ),
      header3: inlineCodeStyle.copyWith(
        fontSize: 18 * fontScale,
        fontWeight: FontWeight.w500,
      ),
    ),
    link: TextStyle(
      color: themeData.colorScheme.secondary,
      decoration: TextDecoration.underline,
    ),
    placeHolder: DefaultTextBlockStyle(
      defaultTextStyle.style.copyWith(
        fontSize: 20 * fontScale,
        height: 1.5,
        color: Colors.grey.withOpacity(0.6),
      ),
      const VerticalSpacing(0, 0),
      const VerticalSpacing(0, 0),
      null,
    ),
    lists: DefaultListBlockStyle(
      baseStyle,
      baseSpacing,
      const VerticalSpacing(0, 6),
      null,
      null,
    ),
    quote: DefaultTextBlockStyle(
      TextStyle(color: baseStyle.color!.withOpacity(0.6)),
      baseSpacing,
      const VerticalSpacing(6, 2),
      BoxDecoration(
        border: Border(
          left: BorderSide(width: 4, color: Colors.grey.shade300),
        ),
      ),
    ),
    code: DefaultTextBlockStyle(
      TextStyle(
        color: Colors.blue.shade900.withOpacity(0.9),
        fontFamily: fontFamily,
        fontSize: 13 * fontScale,
        height: 1.15,
      ),
      baseSpacing,
      const VerticalSpacing(0, 0),
      BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
    indent: DefaultTextBlockStyle(
      baseStyle,
      baseSpacing,
      const VerticalSpacing(0, 6),
      null,
    ),
    align: DefaultTextBlockStyle(
      baseStyle,
      const VerticalSpacing(0, 0),
      const VerticalSpacing(0, 0),
      null,
    ),
    leading: DefaultTextBlockStyle(
      baseStyle,
      const VerticalSpacing(0, 0),
      const VerticalSpacing(0, 0),
      null,
    ),
    sizeSmall: TextStyle(fontSize: 10 * fontScale),
    sizeLarge: TextStyle(fontSize: 18 * fontScale),
    sizeHuge: TextStyle(fontSize: 22 * fontScale),
  );
}

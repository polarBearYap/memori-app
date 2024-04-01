import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/translations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/utils/theme_mode.dart';

class CustomQuillToolbarFontSizeButton extends StatefulWidget {
  CustomQuillToolbarFontSizeButton({
    required this.controller,
    this.options = const QuillToolbarFontSizeButtonOptions(),
    super.key,
  })  : assert(
          options.rawItemsMap?.isNotEmpty ?? true,
          'Library assert error 1',
        ),
        assert(
          options.initialValue == null ||
              (options.initialValue?.isNotEmpty ?? true),
          'Library assert error 2',
        );

  final QuillToolbarFontSizeButtonOptions options;

  final QuillController controller;

  @override
  State<StatefulWidget> createState() => _QuillToolbarFontSizeButtonState();
}

class _QuillToolbarFontSizeButtonState
    extends State<CustomQuillToolbarFontSizeButton> {
  String _currentValue = '';

  QuillToolbarFontSizeButtonOptions get options => widget.options;

  Map<String, String> get rawItemsMap {
    final fontSizes = options.rawItemsMap ??
        context.quillSimpleToolbarConfigurations?.fontSizesValues ??
        {
          context.loc.small: 'small',
          context.loc.large: 'large',
          context.loc.huge: 'huge',
          context.loc.clear: '0',
        };
    return fontSizes;
  }

  String? getLabel(final String? currentValue) => switch (currentValue) {
        'small' => context.loc.small,
        'large' => context.loc.large,
        'huge' => context.loc.huge,
        String() => currentValue,
        null => null,
      };

  String get _defaultDisplayText =>
      options.initialValue ??
      widget.options.defaultDisplayText ??
      context.loc.fontSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentValue = _defaultDisplayText;
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? _getKeyName(final dynamic value) {
    for (final entry in rawItemsMap.entries) {
      if (getFontSize(entry.value) == getFontSize(value)) {
        return entry.key;
      }
    }
    return null;
  }

  QuillController get controller => widget.controller;

  double get iconSize {
    final baseFontSize = context.quillToolbarBaseButtonOptions?.iconSize;
    final iconSize = options.iconSize;
    return iconSize ?? baseFontSize ?? kDefaultIconSize;
  }

  double get iconButtonFactor {
    final baseIconFactor =
        context.quillToolbarBaseButtonOptions?.iconButtonFactor;
    final iconButtonFactor = options.iconButtonFactor;
    return iconButtonFactor ?? baseIconFactor ?? kDefaultIconButtonFactor;
  }

  VoidCallback? get afterButtonPressed =>
      options.afterButtonPressed ??
      context.quillToolbarBaseButtonOptions?.afterButtonPressed;

  QuillIconTheme? get iconTheme =>
      options.iconTheme ?? context.quillToolbarBaseButtonOptions?.iconTheme;

  String get tooltip =>
      options.tooltip ??
      context.quillToolbarBaseButtonOptions?.tooltip ??
      context.loc.fontSize;

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final textTheme = Theme.of(context).textTheme;
          final labelFontSize = isPortrait
              ? textTheme.labelMedium!.fontSize!.scaledSp
              : textTheme.labelMedium!.fontSize!.scaledSp * 0.6;
          final iconSize = isPortrait ? 20.scaledSp : 10.scaledSp;
          final isDarkMode = checkIsDarkMode(context: context);

          return InkWell(
            onTap: () {
              ScrollController scrollController = ScrollController();

              showDialog(
                context: context,
                builder: (final BuildContext context) => AlertDialog(
                  title: Text(
                    localized(context).card_editor_popup_choose_opton,
                    style: getDialogTitle(
                      isPortrait: isPortrait,
                      textTheme: textTheme,
                    ),
                  ),
                  content: SizedBox(
                    height: 300.h,
                    child: Scrollbar(
                      controller: scrollController,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...rawItemsMap.entries.map((final fontSize) {
                              onChanged(final value) {
                                final keyName = _getKeyName(value);
                                setState(() {
                                  if (keyName != context.loc.clear) {
                                    _currentValue =
                                        keyName ?? _defaultDisplayText;
                                  } else {
                                    _currentValue = _defaultDisplayText;
                                  }
                                  if (keyName != null) {
                                    controller.formatSelection(
                                      Attribute.fromKeyValue(
                                        Attribute.size.key,
                                        value == '0'
                                            ? null
                                            : getFontSize(value),
                                      ),
                                    );
                                    options.onSelected?.call(value!);
                                  }
                                });

                                if (value == '0') {
                                  controller.selectFontSize(null);
                                } else {
                                  controller.selectFontSize(fontSize);
                                }
                                Navigator.of(context).pop();
                              }

                              return Material(
                                color: isDarkMode
                                    ? const Color(0xFF262D33)
                                    : const Color(0xFFE1E8F5),
                                child: InkWell(
                                  splashColor: isDarkMode
                                      ? Colors.white10
                                      : Colors.black12,
                                  highlightColor: isDarkMode
                                      ? Colors.white10
                                      : Colors.black12,
                                  onTap: () {
                                    onChanged(fontSize.value);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 16.0,
                                    ), // Adjust padding as needed
                                    child: Row(
                                      children: <Widget>[
                                        Transform.scale(
                                          scale: getRadioScale(context),
                                          child: Radio<String>(
                                            value: fontSize.value,
                                            groupValue:
                                                rawItemsMap[_currentValue],
                                            onChanged: (final String? value) {
                                              onChanged(value);
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Expanded(
                                          child: Text(
                                            fontSize.key.toString(),
                                            style: getDialogContent(
                                              isPortrait: isPortrait,
                                              textTheme: textTheme,
                                            ).copyWith(
                                              color: fontSize.value == '0'
                                                  ? options.defaultItemColor
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ).then((final _) {
                scrollController.dispose();
              });
              afterButtonPressed?.call();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 5.h,
              ),
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5.0.scaledSp),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 15.w,
                    height: double.infinity,
                  ),
                  Expanded(
                    child: Text(
                      _currentValue,
                      style: TextStyle(
                        fontSize: labelFontSize,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    size: iconSize,
                  ),
                ],
              ),
            ),
          );
        },
      );
}

dynamic getFontSize(final dynamic sizeValue) {
  if (sizeValue is String &&
      ['small', 'normal', 'large', 'huge'].contains(sizeValue)) {
    return sizeValue;
  }

  if (sizeValue is double) {
    return sizeValue;
  }

  if (sizeValue is int) {
    return sizeValue.toDouble();
  }

  assert(sizeValue is String, 'Library assert error 3');
  final fontSize = double.tryParse(sizeValue);
  if (fontSize == null) {
    throw ArgumentError('Invalid size $sizeValue');
  }
  return fontSize;
}

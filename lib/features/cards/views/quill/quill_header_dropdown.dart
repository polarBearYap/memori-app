import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/translations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/utils/theme_mode.dart';

class CustomQuillToolbarSelectHeaderStyleDropdownButton extends StatefulWidget {
  const CustomQuillToolbarSelectHeaderStyleDropdownButton({
    required this.controller,
    this.options = const QuillToolbarSelectHeaderStyleDropdownButtonOptions(),
    super.key,
  });

  final QuillController controller;
  final QuillToolbarSelectHeaderStyleDropdownButtonOptions options;

  @override
  State<CustomQuillToolbarSelectHeaderStyleDropdownButton> createState() =>
      _CustomQuillToolbarSelectHeaderStyleDropdownButtonState();
}

class _CustomQuillToolbarSelectHeaderStyleDropdownButtonState
    extends State<CustomQuillToolbarSelectHeaderStyleDropdownButton> {
  Attribute<dynamic> _selectedItem = Attribute.header;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_didChangeEditingValue);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeEditingValue);
    super.dispose();
  }

  @override
  void didUpdateWidget(
    covariant final CustomQuillToolbarSelectHeaderStyleDropdownButton oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) {
      return;
    }
    widget.controller
      ..removeListener(_didChangeEditingValue)
      ..addListener(_didChangeEditingValue);
  }

  void _didChangeEditingValue() {
    final newSelectedItem = _getHeaderValue();
    if (newSelectedItem == _selectedItem) {
      return;
    }
    setState(() {
      _selectedItem = newSelectedItem;
    });
  }

  Attribute<dynamic> _getHeaderValue() {
    final attr = widget.controller.toolbarButtonToggler[Attribute.header.key];
    if (attr != null) {
      // checkbox tapping causes controller.selection to go to offset 0
      widget.controller.toolbarButtonToggler.remove(Attribute.header.key);
      return attr;
    }
    return widget.controller
            .getSelectionStyle()
            .attributes[Attribute.header.key] ??
        Attribute.header;
  }

  String _label(final Attribute<dynamic> value) {
    final label = switch (value) {
      Attribute.h1 => context.loc.heading1,
      Attribute.h2 => context.loc.heading2,
      Attribute.h3 => context.loc.heading3,
      Attribute.h4 => context.loc.heading4,
      Attribute.h5 => context.loc.heading5,
      Attribute.h6 => context.loc.heading6,
      Attribute.header =>
        widget.options.defaultDisplayText ?? context.loc.normal,
      Attribute<dynamic>() => throw ArgumentError(),
    };
    return label;
  }

  double get iconSize {
    final baseFontSize = context.quillToolbarBaseButtonOptions?.iconSize;
    final iconSize = widget.options.iconSize;
    return iconSize ?? baseFontSize ?? kDefaultIconSize;
  }

  double get iconButtonFactor {
    final baseIconFactor =
        context.quillToolbarBaseButtonOptions?.iconButtonFactor;
    final iconButtonFactor = widget.options.iconButtonFactor;
    return iconButtonFactor ?? baseIconFactor ?? kDefaultIconButtonFactor;
  }

  QuillIconTheme? get iconTheme =>
      widget.options.iconTheme ??
      context.quillToolbarBaseButtonOptions?.iconTheme;

  List<Attribute<int?>> get headerAttributes =>
      widget.options.attributes ??
      [
        Attribute.h1,
        Attribute.h2,
        Attribute.h3,
        Attribute.header,
      ];

  String get tooltip =>
      widget.options.tooltip ??
      context.quillToolbarBaseButtonOptions?.tooltip ??
      context.loc.headerStyle;

  QuillToolbarBaseButtonOptions? get baseButtonExtraOptions =>
      context.quillToolbarBaseButtonOptions;

  VoidCallback? get afterButtonPressed =>
      widget.options.afterButtonPressed ??
      baseButtonExtraOptions?.afterButtonPressed;

  void _onPressed(final Attribute<int?> e) {
    setState(() => _selectedItem = e);
    widget.controller.formatSelection(_selectedItem);
  }

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
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: headerAttributes
                        .map(
                          (final option) => Material(
                            color: isDarkMode
                                ? const Color(0xFF262D33)
                                : const Color(0xFFE1E8F5),
                            child: InkWell(
                              splashColor:
                                  isDarkMode ? Colors.white10 : Colors.black12,
                              highlightColor:
                                  isDarkMode ? Colors.white10 : Colors.black12,
                              onTap: () {
                                _onPressed(option);
                                Navigator.of(context).pop();
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
                                        value: option.value.toString(),
                                        groupValue:
                                            _selectedItem.value.toString(),
                                        onChanged: (final String? value) {
                                          _onPressed(option);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Expanded(
                                      child: Text(
                                        _label(option),
                                        style: getDialogContent(
                                          isPortrait: isPortrait,
                                          textTheme: textTheme,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
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
                      _label(_selectedItem),
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

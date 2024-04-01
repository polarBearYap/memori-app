import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memori_app/features/common/bloc/font_size_bloc.dart';
import 'package:memori_app/features/common/bloc/locale_cubit.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';

class ChangeLanguageFloatingButton extends StatelessWidget {
  const ChangeLanguageFloatingButton({super.key});

  @override
  Widget build(final BuildContext context) =>
      BlocBuilder<FontSizeCubit, FontSizeState>(
        builder: (final context, final state) => LayoutBuilder(
          builder: (final context, final constraints) {
            final isPortrait =
                MediaQuery.of(context).orientation == Orientation.portrait;
            const fabShape = CircleBorder();
            const backgroundColor = Colors.white;

            final childWidget = GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                builder: (final BuildContext context) =>
                    const ChangeLanguageScreen(),
              ),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(
                    0.75,
                  ), // Adjust the opacity here (0.0 - 1.0)
                  BlendMode.dstIn,
                ),
                child: BlocBuilder<LocaleCubit, Locale>(
                  builder: (final context, final state) => Image.asset(
                    'assets/country_icons/${state.languageCode == 'zh' ? 'chinese' : 'english'}_lang.png',
                  ),
                ),
              ),
            );

            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;

            return SizedBox(
              width: 35.w,
              child: () {
                if (screenWidth <= 400 ||
                    (!isPortrait && screenHeight <= 400)) {
                  return FloatingActionButton.small(
                    onPressed: () {},
                    backgroundColor: backgroundColor,
                    shape: fabShape,
                    child: childWidget,
                  );
                } /*else if (screenWidth >= 800 &&
                    (isPortrait || screenHeight >= 800))*/
                else if (screenWidth >= 800 &&
                    (isPortrait || isBigScreen(context))) {
                  return FloatingActionButton.large(
                    onPressed: () {},
                    backgroundColor: backgroundColor,
                    shape: fabShape,
                    child: childWidget,
                  );
                } else {
                  return FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: backgroundColor,
                    shape: fabShape,
                    child: childWidget,
                  );
                }
              }(),
            );
          },
        ),
      );
}

class LanguageDropdownOption {
  Locale selectedOption;

  LanguageDropdownOption({
    required this.selectedOption,
  });
}

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({
    final bool hideDescription = false,
    super.key,
  }) : _hideDescription = hideDescription;

  final bool _hideDescription;

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  late final LanguageDropdownOption _option;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _option = LanguageDropdownOption(
      selectedOption: context.read<LocaleCubit>().state,
    );
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            // height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  _LanguageTitle(),
                  if (!widget._hideDescription)
                    SizedBox(
                      height: 10.h,
                    ),
                  if (!widget._hideDescription)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                      ),
                      child: _LanguageDescription(),
                    ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                    ),
                    child: _LanguageDropdownOption(
                      languageName: localized(context).language_value_english,
                      langaugeValue: 'en',
                      selectedLangaugeValue:
                          _option.selectedOption.languageCode,
                      imagePath: 'assets/country_icons/english_lang.png',
                      onTap: () {
                        setState(() {
                          _option.selectedOption = const Locale('en');
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                    ),
                    child: _LanguageDropdownOption(
                      languageName: localized(context).language_value_chinese,
                      langaugeValue: 'zh',
                      selectedLangaugeValue:
                          _option.selectedOption.languageCode,
                      imagePath: 'assets/country_icons/chinese_lang.png',
                      onTap: () {
                        setState(() {
                          _option.selectedOption = const Locale('zh');
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                    ),
                    child: _LanguageContinueButton(
                      onTap: () {
                        context.read<LocaleCubit>().setLocale(
                              _option.selectedOption,
                            );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _LanguageTitle extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final orientation = MediaQuery.of(context).orientation;
          final isPortrait = orientation == Orientation.portrait;
          final textTheme = Theme.of(context).textTheme;
          double titleFontSize = isPortrait
              ? textTheme.titleMedium!.fontSize!.scaledSp * 1.1
              : textTheme.titleSmall!.fontSize!.scaledSp * 0.9;
          if (isBigScreen(context)) {
            titleFontSize *= 0.8;
          }
          return Text(
            localized(context).language_title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: titleFontSize,
            ),
            overflow: TextOverflow.visible,
          );
        },
      );
}

class _LanguageDescription extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final orientation = MediaQuery.of(context).orientation;
          final isPortrait = orientation == Orientation.portrait;
          final textTheme = Theme.of(context).textTheme;
          double descFontSize = isPortrait
              ? textTheme.bodySmall!.fontSize!.scaledSp * 0.9
              : textTheme.bodySmall!.fontSize!.scaledSp * 0.65;
          if (isBigScreen(context)) {
            descFontSize *= 0.8;
          }
          return Text(
            localized(context).language_desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: descFontSize,
            ),
          );
        },
      );
}

class _LanguageContinueButton extends StatelessWidget {
  const _LanguageContinueButton({
    required final VoidCallback onTap,
  }) : _onTap = onTap;

  final VoidCallback _onTap;

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final textTheme = Theme.of(context).textTheme;
          final orientation = MediaQuery.of(context).orientation;
          final isPortrait = orientation == Orientation.portrait;
          double fontSize = isPortrait
              ? textTheme.labelMedium!.fontSize!.scaledSp * 0.95
              : textTheme.labelSmall!.fontSize!.scaledSp * 0.7;
          if (isBigScreen(context)) {
            fontSize *= 0.8;
          }
          return FilledButton(
            onPressed: _onTap,
            style: getFilledButtonStyle(
              isPortrait: isPortrait,
            ),
            child: Text(
              localized(context).language_continue,
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
          );
        },
      );
}

class _LanguageDropdownOption extends StatelessWidget {
  const _LanguageDropdownOption({
    required final String imagePath,
    required final String languageName,
    required final String langaugeValue,
    required final String selectedLangaugeValue,
    required final VoidCallback onTap,
  })  : _imagePath = imagePath,
        _languageName = languageName,
        _langaugeValue = langaugeValue,
        _selectedLangaugeValue = selectedLangaugeValue,
        _onTap = onTap;

  final String _imagePath;
  final String _languageName;
  final String _langaugeValue;
  final String _selectedLangaugeValue;
  final VoidCallback _onTap;

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final textTheme = Theme.of(context).textTheme;
          final orientation = MediaQuery.of(context).orientation;
          final isPortrait = orientation == Orientation.portrait;
          double labelFontSize = isPortrait
              ? textTheme.labelLarge!.fontSize!.scaledSp
              : textTheme.labelSmall!.fontSize!.scaledSp * 0.8;
          final isBigScreenFlag = isBigScreen(context);
          if (isBigScreenFlag) {
            labelFontSize *= 0.8;
          }
          return Card(
            child: InkWell(
              onTap: _onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.h,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: isBigScreenFlag ? 5.w : 20.w,
                    ),
                    SizedBox(
                      height: 30.h,
                      child: Image.asset(
                        _imagePath,
                      ),
                    ),
                    SizedBox(
                      width: isBigScreenFlag ? 10.w : 20.w,
                    ),
                    Expanded(
                      child: Text(
                        _languageName,
                        style: TextStyle(
                          fontSize: labelFontSize,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Transform.scale(
                      scale: getRadioScale(context),
                      child: Radio(
                        value: _langaugeValue,
                        groupValue: _selectedLangaugeValue,
                        onChanged: (final value) {},
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/utils/theme_mode.dart';
import 'package:memori_app/features/common/views/independent_scroll_view.dart';
import 'package:memori_app/features/decks/bloc/deck_setting/deck_setting_bloc.dart';
import 'package:memori_app/features/decks/views/back_navigator.dart';

class DeckSettings extends StatefulWidget {
  const DeckSettings({
    required final String deckId,
    super.key,
  }) : _deckId = deckId;

  final String _deckId;

  @override
  State<DeckSettings> createState() => _DeckSettingsState();
}

class _DeckSettingsState extends State<DeckSettings> {
  late String _deckSettingsId;
  late String _deckName;
  late final CardTypeOption _option;
  late final TextEditingController _newCardController;
  late final TextEditingController _maxReviewController;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _deckSettingsId = '';
    _deckName = '';
    _option = CardTypeOption();
    _newCardController = TextEditingController(text: '0');
    _maxReviewController = TextEditingController(text: '0');
    initForm();
  }

  void initForm() {
    _isLoading = true;
    context.read<DeckSettingBloc>().add(
          DeckSettingsInit(
            deckId: widget._deckId,
          ),
        );
  }

  void submitForm() {
    context.read<DeckSettingBloc>().add(
          DeckSettingUpdated(
            deckSettingId: _deckSettingsId,
            newCardPerDay: int.parse(_newCardController.text),
            maxReviewPerDay: int.parse(_maxReviewController.text),
            skipNewCard: !_option.newCard,
            skipLearningCard: !_option.learningCard,
            skipReviewCard: !_option.reviewCard,
          ),
        );
  }

  @override
  void didUpdateWidget(
    final DeckSettings oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (widget._deckId != oldWidget._deckId) {
      setState(() {
        initForm();
      });
    }
  }

  @override
  void dispose() {
    _newCardController.dispose();
    _maxReviewController.dispose();
    super.dispose();
  }

  Widget buildSettings() => LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final theme = Theme.of(context);
          final textTheme = theme.textTheme;
          final titleFontSize = isPortrait
              ? textTheme.titleMedium!.fontSize!.scaledSp * 1.2
              : textTheme.titleSmall!.fontSize!.scaledSp;
          final settingFontText = isPortrait
              ? textTheme.bodyMedium!.fontSize!.scaledSp
              : textTheme.bodySmall!.fontSize!.scaledSp;
          final settingFontStyle = TextStyle(
            fontSize: settingFontText,
          );
          final dailyLimitWidthLimit = isFontSizeBig() ? 400.w : 300.w;
          return ListView.separated(
            itemCount: 4,
            separatorBuilder: (final BuildContext context, final int index) =>
                SizedBox(
              height: 20.h,
            ),
            itemBuilder: (final BuildContext context, final int index) {
              if (index == 0) {
                return Card(
                  child: Container(
                    width: 300.w,
                    padding: EdgeInsets.fromLTRB(
                      10.w,
                      15.h,
                      10.w,
                      10.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localized(context).deck_daily_limit,
                          style: TextStyle(
                            fontSize: titleFontSize,
                          ),
                        ),
                        const Divider(
                          indent: 5,
                          endIndent: 5,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        IndependentScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: dailyLimitWidthLimit,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      localized(context).deck_new_card_per_day,
                                      style: settingFontStyle,
                                    ),
                                    const Spacer(),
                                    CustomNumberButton(
                                      min: 1,
                                      max: 200,
                                      controller: _newCardController,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              SizedBox(
                                width: dailyLimitWidthLimit,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      localized(context)
                                          .deck_max_review_per_day,
                                      style: settingFontStyle,
                                    ),
                                    const Spacer(),
                                    CustomNumberButton(
                                      min: 1,
                                      max: 200,
                                      controller: _maxReviewController,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (index == 1) {
                return Card(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      10.w,
                      15.h,
                      10.w,
                      10.h,
                    ),
                    child: _DeckSettingsCardTypeSection(
                      option: _option,
                    ),
                  ),
                );
              }
              if (index == 2) {
                return FilledButton(
                  onPressed: () => {
                    submitForm(),
                  },
                  style: getFilledButtonStyle(isPortrait: isPortrait),
                  child: Text(
                    localized(context).deck_card_type_apply,
                    style: getFilledButtonTextStyle(
                      isPortrait: isPortrait,
                      textTheme: textTheme,
                    ),
                  ),
                );
              }
              return SizedBox(
                height: 20.h,
              );
            },
          );
        },
      );

  @override
  Widget build(final BuildContext context) =>
      BlocListener<DeckSettingBloc, DeckSettingState>(
        listener: (final context, final state) {
          if (state.deckStatus == FormzSubmissionStatus.inProgress) {
            setState(() {
              _isLoading = true;
            });
          } else if (state.deckStatus == FormzSubmissionStatus.initial) {
            setState(() {
              _deckName = state.deckName;
              _deckSettingsId = state.deckSettingId;
              _option
                ..newCard = !state.skipNewCard
                ..learningCard = !state.skipLearningCard
                ..reviewCard = !state.skipReviewCard;
              _newCardController.text = state.newCardPerDay.toString();
              _maxReviewController.text = state.maxReviewPerDay.toString();
              _isLoading = false;
            });
          } else if (state.deckStatus == FormzSubmissionStatus.success ||
              state.deckStatus == FormzSubmissionStatus.failure) {
            showScaledSnackBar(
              context,
              state.deckStatus == FormzSubmissionStatus.success
                  ? localized(context).deck_setting_update_successful
                  : localized(context).deck_setting_update_failed,
            );
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: LayoutBuilder(
          builder: (final context, final constraints) {
            final isPortrait =
                MediaQuery.of(context).orientation == Orientation.portrait;
            final textTheme = Theme.of(context).textTheme;
            final titleFontSize = isPortrait
                ? textTheme.titleMedium!.fontSize!.scaledSp
                : textTheme.titleSmall!.fontSize!.scaledSp;
            return Scaffold(
              appBar: AppBar(
                leading: const BackNavigator(),
                leadingWidth: getAppBarLeadingWidth(isPortrait: isPortrait),
                title: Text(
                  localized(context).deck_settings_title(_deckName),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleFontSize,
                  ),
                ),
                elevation: 10.0,
                toolbarHeight: getAppBarHeight(isPortrait: isPortrait),
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                  vertical: 20.h,
                ),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : buildSettings(),
              ),
            );
          },
        ),
      );
}

class NumberRangeTextInputFormatter extends TextInputFormatter {
  final int minValue;
  final int maxValue;

  NumberRangeTextInputFormatter({
    required this.minValue,
    required this.maxValue,
  });

  @override
  TextEditingValue formatEditUpdate(
    final TextEditingValue oldValue,
    final TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final int? value = int.tryParse(newValue.text);
    if (value == null) {
      return oldValue;
    }

    if (value < minValue) {
      return TextEditingValue(text: minValue.toString());
    } else if (value > maxValue) {
      return TextEditingValue(text: maxValue.toString());
    }
    return newValue;
  }
}

class CustomNumberButton extends StatefulWidget {
  const CustomNumberButton({
    required final TextEditingController controller,
    required final int min,
    required final int max,
    super.key,
  })  : _controller = controller,
        _min = min,
        _max = max;

  final TextEditingController _controller;
  final int _min;
  final int _max;

  @override
  State<CustomNumberButton> createState() => _CustomNumberButtonState();
}

class _CustomNumberButtonState extends State<CustomNumberButton> {
  @override
  void didUpdateWidget(
    final CustomNumberButton oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (widget._controller != oldWidget._controller ||
        widget._min != oldWidget._min ||
        widget._max != oldWidget._max) {
      setState(() {});
    }
  }

  void _incrementCounter() {
    setState(() {
      int? cur = int.tryParse(widget._controller.text);
      if (cur == null) {
        cur = widget._min;
      } else if (cur >= widget._max) {
        cur = widget._max;
      } else {
        cur++;
      }
      widget._controller.text = cur.toString();
    });
  }

  void _decrementCounter() {
    setState(() {
      int? cur = int.tryParse(widget._controller.text);
      if (cur == null) {
        cur = widget._min;
      } else if (cur <= widget._min) {
        cur = widget._min;
      } else {
        cur--;
      }
      widget._controller.text = cur.toString();
    });
  }

  @override
  Widget build(final BuildContext context) {
    final borderRadiusSize = 20.scaledSp;
    final borderRadius = Radius.circular(borderRadiusSize);

    const noBorder = OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide.none,
    );

    return LayoutBuilder(
      builder: (final context, final constraints) {
        final textTheme = Theme.of(context).textTheme;
        final orientation = MediaQuery.of(context).orientation;
        final isPortrait = orientation == Orientation.portrait;
        final iconSize = isPortrait ? 15.scaledSp : 10.scaledSp;
        final screenHeight = MediaQuery.of(context).size.height;
        final heightScaleFactor = screenHeight < 1000 ? 0.60 : 0.70;
        /*
        final factor = FontSizeScale().factorDesc;
        final height = factor == FontSizeScaleFactor.biggest
            ? 65.h
            : factor == FontSizeScaleFactor.bigger
                ? 50.h
                : isPortrait
                    ? 30.h
                    : 40.h;
        */
        double height = getTextFieldHeight(
          isPortrait: isPortrait,
          hasErrorText: false,
        );
        height = isPortrait ? height : height;
        final buttonStyle = ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: borderRadius,
                bottomLeft: borderRadius,
              ),
            ),
          ),
          padding: MaterialStateProperty.all(
            EdgeInsets.zero,
          ),
        );
        return Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(borderRadiusSize),
            color: Theme.of(context).inputDecorationTheme.fillColor,
          ),
          padding: EdgeInsets.zero,
          width: isPortrait ? 120.w : 90.w,
          height: height * heightScaleFactor,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: height,
                  child: FilledButton(
                    onPressed: _decrementCounter,
                    style: buttonStyle,
                    child: Icon(
                      Icons.remove,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: TextField(
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: getTextFieldDecoration(
                    isPortrait: isPortrait,
                    textTheme: textTheme,
                  ).copyWith(
                    border: noBorder,
                    focusedBorder: noBorder,
                    enabledBorder: noBorder,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 5.h,
                    ),
                  ),
                  style: getTextFieldStyle(
                    isPortrait: isPortrait,
                    textTheme: textTheme,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    NumberRangeTextInputFormatter(
                      minValue: widget._min,
                      maxValue: widget._max,
                    ),
                    // FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  controller: widget._controller,
                ),
              ),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: height,
                  child: FilledButton(
                    onPressed: _incrementCounter,
                    style: buttonStyle.copyWith(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: borderRadius,
                            bottomRight: borderRadius,
                          ),
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CardTypeOption {
  bool _allCard = true;
  bool _newCard = true;
  bool _learningCard = true;
  bool _reviewCard = true;

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is CardTypeOption &&
          runtimeType == other.runtimeType &&
          allCard == other.allCard &&
          newCard == other.newCard &&
          learningCard == other.learningCard &&
          reviewCard == other.reviewCard;

  @override
  int get hashCode =>
      allCard.hashCode ^
      newCard.hashCode ^
      learningCard.hashCode ^
      reviewCard.hashCode;

  set allCard(final bool value) {
    _allCard = value;
    if (_allCard) {
      _newCard = true;
      _learningCard = true;
      _reviewCard = true;
    } else {
      _newCard = false;
      _learningCard = false;
      _reviewCard = false;
    }
  }

  bool get allCard => _allCard;

  bool isAllCard() => _newCard && _learningCard && _reviewCard;

  set newCard(final bool value) {
    _newCard = value;
    if (!value) {
      _allCard = false;
    } else if (isAllCard()) {
      _allCard = true;
    }
  }

  bool get newCard => _newCard;

  set learningCard(final bool value) {
    _learningCard = value;
    if (!value) {
      _allCard = false;
    } else if (isAllCard()) {
      _allCard = true;
    }
  }

  bool get learningCard => _learningCard;

  set reviewCard(final bool value) {
    _reviewCard = value;
    if (!value) {
      _allCard = false;
    } else if (isAllCard()) {
      _allCard = true;
    }
  }

  bool get reviewCard => _reviewCard;

  CardTypeOption();

  /*@override
  List<Object?> get props => [
        _allCard,
        _newCard,
        _learningCard,
        _reviewCard,
      ];*/
}

class _DeckSettingsCardTypeSection extends StatefulWidget {
  const _DeckSettingsCardTypeSection({
    required final CardTypeOption option,
  }) : _option = option;

  final CardTypeOption _option;

  @override
  State<_DeckSettingsCardTypeSection> createState() =>
      _DeckSettingsCardTypeSectionState();
}

class _DeckSettingsCardTypeSectionState
    extends State<_DeckSettingsCardTypeSection> {
  @override
  void didUpdateWidget(
    final _DeckSettingsCardTypeSection oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (widget._option != oldWidget._option) {
      setState(() {});
    }
  }

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final theme = Theme.of(context);
          final textTheme = theme.textTheme;
          final titleFontSize = isPortrait
              ? textTheme.titleMedium!.fontSize!.scaledSp * 1.2
              : textTheme.titleSmall!.fontSize!.scaledSp;
          final settingFontText = isPortrait
              ? textTheme.bodyMedium!.fontSize!.scaledSp
              : textTheme.bodySmall!.fontSize!.scaledSp;
          final settingFontStyle = TextStyle(
            fontSize: settingFontText,
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localized(context).deck_card_type,
                style: TextStyle(
                  fontSize: titleFontSize,
                ),
              ),
              const Divider(
                indent: 5,
                endIndent: 5,
              ),
              SizedBox(
                height: 10.h,
              ),
              _CustomSwitchListTile(
                title: localized(context).deck_card_type_all,
                value: widget._option.allCard,
                onTapRadio: (final bool value) {
                  setState(() {
                    widget._option.allCard = value;
                  });
                },
                onTapInkWell: () {
                  setState(() {
                    widget._option.allCard = !widget._option.allCard;
                  });
                },
                textStyle: settingFontStyle,
              ),
              SizedBox(
                height: 5.h,
              ),
              _CustomSwitchListTile(
                title: localized(context).deck_card_type_new,
                value: widget._option.newCard,
                onTapRadio: (final bool value) {
                  setState(() {
                    widget._option.newCard = value;
                  });
                },
                onTapInkWell: () {
                  setState(() {
                    widget._option.newCard = !widget._option.newCard;
                  });
                },
                textStyle: settingFontStyle,
              ),
              SizedBox(
                height: 5.h,
              ),
              _CustomSwitchListTile(
                title: localized(context).deck_card_type_leanring,
                value: widget._option.learningCard,
                onTapRadio: (final bool value) {
                  setState(() {
                    widget._option.learningCard = value;
                  });
                },
                onTapInkWell: () {
                  setState(() {
                    widget._option.learningCard = !widget._option.learningCard;
                  });
                },
                textStyle: settingFontStyle,
              ),
              SizedBox(
                height: 5.h,
              ),
              _CustomSwitchListTile(
                title: localized(context).deck_card_type_review,
                value: widget._option.reviewCard,
                onTapRadio: (final bool value) {
                  setState(() {
                    widget._option.reviewCard = value;
                  });
                },
                onTapInkWell: () {
                  setState(() {
                    widget._option.reviewCard = !widget._option.reviewCard;
                  });
                },
                textStyle: settingFontStyle,
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          );
        },
      );
}

class _CustomSwitchListTile extends StatelessWidget {
  const _CustomSwitchListTile({
    required final bool value,
    required final String title,
    required final TextStyle textStyle,
    required final VoidCallback onTapInkWell,
    // ignore: avoid_positional_boolean_parameters
    required final void Function(bool) onTapRadio,
  })  : _value = value,
        _title = title,
        _textStyle = textStyle,
        _onTapInkWell = onTapInkWell,
        _onTapRadio = onTapRadio;

  final bool _value;
  final String _title;
  final TextStyle _textStyle;
  final VoidCallback _onTapInkWell;
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool) _onTapRadio;

  @override
  Widget build(final BuildContext context) {
    final isDarkMode = checkIsDarkMode(context: context);
    return Material(
      color: isDarkMode ? const Color(0xFF1E2227) : const Color(0xFFEDF2F9),
      child: InkWell(
        splashColor: isDarkMode ? Colors.white10 : Colors.black12,
        highlightColor: isDarkMode ? Colors.white10 : Colors.black12,
        onTap: _onTapInkWell,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  _title,
                  style: _textStyle,
                ),
              ),
              Transform.scale(
                scale: getSwitchScale(context),
                child: Switch(
                  value: _value,
                  onChanged: _onTapRadio,
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
  }
}

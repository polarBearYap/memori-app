import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/views/showcase_widget.dart';
import 'package:memori_app/features/decks/bloc/deck/add_deck_bloc.dart';
import 'package:memori_app/features/decks/models/deck.dart';
import 'package:showcaseview/showcaseview.dart';

class AddDeckDialog extends StatefulWidget {
  const AddDeckDialog({
    final bool isShowcasing = false,
    super.key,
  }) : _isShowcasing = isShowcasing;

  final bool _isShowcasing;

  @override
  State<StatefulWidget> createState() => _AddDeckDialogState();
}

class _AddDeckDialogState extends State<AddDeckDialog> {
  late final TextEditingController _nameController;
  late bool _hasIconShowcaseShown;
  Timer? _debounceTimer;
  late BuildContext _showcaseContext;
  final GlobalKey _textFieldGlobalKey = GlobalKey();
  final GlobalKey _submitButtonGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _hasIconShowcaseShown = false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(
    final AddDeckDialog oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (widget._isShowcasing != oldWidget._isShowcasing) {
      setState(() {});
    }
  }

  void showcaseTextField() {
    if (widget._isShowcasing) {
      WidgetsBinding.instance.addPostFrameCallback((final _) {
        Future.delayed(const Duration(milliseconds: 500), () {
          startShowcase(
            _showcaseContext,
            [
              _textFieldGlobalKey,
            ],
          );
        });
      });
    }
  }

  void showcaseSubmit() {
    if (widget._isShowcasing) {
      if (_debounceTimer?.isActive ?? false) {
        _debounceTimer!.cancel();
      }
      _debounceTimer = Timer(const Duration(seconds: 1), () {
        startShowcase(
          _showcaseContext,
          [
            _submitButtonGlobalKey,
          ],
        );
      });
    }
    _hasIconShowcaseShown = true;
  }

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final colorScheme = Theme.of(context).colorScheme;
          final textTheme = Theme.of(context).textTheme;

          return Dialog(
            child: Container(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
              child: SingleChildScrollView(
                child: ShowCaseWidget(
                  builder: Builder(
                    builder: (final context) {
                      _showcaseContext = context;
                      showcaseTextField();
                      return ListBody(
                        children: <Widget>[
                          Text(
                            localized(context).deck_add_title,
                            style: getDialogTitle(
                              isPortrait: isPortrait,
                              textTheme: textTheme,
                            ).copyWith(
                              color: colorScheme.onBackground,
                            ),
                          ),
                          SizedBox(
                            height: isPortrait ? 25.h : 10.scaledSp,
                          ),
                          CustomShowcaseWidget(
                            title: localized(context)
                                .showcase_add_deck_textfield_title,
                            desc: localized(context)
                                .showcase_add_deck_textfield_desc,
                            showcaseKey: _textFieldGlobalKey,
                            targetShapeBorder: const RoundedRectangleBorder(),
                            onTargetClick: () {},
                            child: _FormTextField(
                              controller: _nameController,
                              fieldName: localized(context).deck_name,
                              icon: Icons.folder_open,
                              autoFocus: true,
                            ),
                          ),
                          SizedBox(
                            height: isPortrait ? 10.h : 15.h,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    localized(context).deck_add_edit_cancel,
                                    style: getDialogLabel(
                                      isPortrait: isPortrait,
                                      textTheme: textTheme,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                BlocListener<AddDeckBloc, AddDeckState>(
                                  listenWhen: (final previous, final current) =>
                                      current.deckAddedStatus !=
                                      FormzSubmissionStatus.inProgress,
                                  listener: (final context, final state) {
                                    if (state.deckAddedStatus ==
                                        FormzSubmissionStatus.initial) {
                                      if (state.deckAdded.isValid &&
                                          !_hasIconShowcaseShown) {
                                        showcaseSubmit();
                                      } else if (_hasIconShowcaseShown) {
                                        dismissShowcase(_showcaseContext);
                                        _hasIconShowcaseShown = false;
                                      }
                                      return;
                                    }
                                    Navigator.of(context).pop();
                                    showScaledSnackBar(
                                      context,
                                      state.deckAddedStatus ==
                                              FormzSubmissionStatus.success
                                          ? localized(context)
                                              .deck_add_successful
                                          : localized(context).deck_add_failed,
                                    );
                                  },
                                  child: BlocBuilder<AddDeckBloc, AddDeckState>(
                                    buildWhen:
                                        (final previous, final current) =>
                                            previous.deckAdded !=
                                                current.deckAdded ||
                                            previous.deckAddedStatus !=
                                                current.deckAddedStatus,
                                    builder: (final context, final state) {
                                      onSubmit() {
                                        context.read<AddDeckBloc>().add(
                                              DeckAddedSubmitted(
                                                deckName: _nameController.text,
                                                isShowcasing:
                                                    widget._isShowcasing,
                                              ),
                                            );
                                      }

                                      return CustomShowcaseWidget(
                                        title: localized(context)
                                            .showcase_add_deck_submit_title,
                                        desc: localized(context)
                                            .showcase_add_deck_submit_desc,
                                        showcaseKey: _submitButtonGlobalKey,
                                        targetShapeBorder: const CircleBorder(),
                                        disableDefaultTargetGestures: false,
                                        speechBubbleRight: isPortrait
                                            ? (isFontSizeSmall() ? 0 : 5.w)
                                            : 0,
                                        containerFlexLeft: isFontSizeBig()
                                            ? (isPortrait ? 4 : 6)
                                            : isFontSizeNormal()
                                                ? (isPortrait ? 7 : 9)
                                                : (isPortrait ? 9 : 11),
                                        onTargetClick: () {
                                          onSubmit();
                                        },
                                        child: FilledButton(
                                          onPressed:
                                              state.deckAdded.isNotValid ||
                                                      state.deckAddedStatus ==
                                                          FormzSubmissionStatus
                                                              .inProgress
                                                  ? null
                                                  : onSubmit,
                                          child: state.deckAddedStatus ==
                                                  FormzSubmissionStatus
                                                      .inProgress
                                              ? const CircularProgressIndicator()
                                              : Text(
                                                  localized(context)
                                                      .deck_add_edit_ok,
                                                  style: getDialogLabel(
                                                    isPortrait: isPortrait,
                                                    textTheme: textTheme,
                                                  ),
                                                ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5.scaledSp,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      );
}

class _FormTextField extends StatelessWidget {
  const _FormTextField({
    required final String fieldName,
    required final TextEditingController controller,
    final IconData icon = Icons.verified_user_outlined,
    final bool autoFocus = false,
  })  : _fieldName = fieldName,
        _controller = controller,
        _icon = icon,
        _autoFocus = autoFocus;

  final TextEditingController _controller;
  final String _fieldName;
  final IconData _icon;
  final bool _autoFocus;
  @override
  Widget build(final BuildContext context) =>
      BlocBuilder<AddDeckBloc, AddDeckState>(
        buildWhen: (final previous, final current) =>
            previous.deckAdded.value != current.deckAdded.value,
        builder: (final context, final state) => LayoutBuilder(
          builder: (final context, final constraints) {
            final isPortrait =
                MediaQuery.of(context).orientation == Orientation.portrait;
            final textTheme = Theme.of(context).textTheme;

            return SizedBox(
              height: getTextFieldHeight(
                isPortrait: isPortrait,
                hasErrorText: true,
              ),
              child: TextField(
                controller: _controller,
                decoration: getTextFieldDecoration(
                  isPortrait: isPortrait,
                  textTheme: textTheme,
                  prefixIconData: _icon,
                ).copyWith(
                  labelText: _fieldName,
                  errorText: state.deckAdded.error == DeckValidationError.empty
                      ? localized(context).deck_name_is_empty
                      : state.deckAdded.isNotValid
                          ? localized(context).deck_name_is_invalid
                          : null,
                ),
                style: getTextFieldStyle(
                  isPortrait: isPortrait,
                  textTheme: textTheme,
                ),
                onChanged: (final value) => context.read<AddDeckBloc>().add(
                      DeckNameChanged(value),
                    ),
                autofocus: _autoFocus,
              ),
            );
          },
        ),
      );
}

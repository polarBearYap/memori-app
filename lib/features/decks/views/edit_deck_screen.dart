import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/decks/bloc/deck/edit_deck_bloc.dart';
import 'package:memori_app/features/decks/models/deck.dart';

class EditDeckDialog extends StatefulWidget {
  const EditDeckDialog({
    required final String deckId,
    super.key,
  }) : _deckId = deckId;

  final String _deckId;

  @override
  State<StatefulWidget> createState() => _EditDeckDialogState();
}

class _EditDeckDialogState extends State<EditDeckDialog> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final textTheme = Theme.of(context).textTheme;
          // final titleFontSize = isPortrait
          //     ? textTheme.titleMedium!.fontSize!.scaledSp
          //     : textTheme.titleSmall!.fontSize!.scaledSp;
          // final labelFontSize = isPortrait
          //     ? textTheme.labelSmall!.fontSize!.scaledSp
          //     : textTheme.labelSmall!.fontSize!.scaledSp * 0.55;
          return Dialog(
            child: Container(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
              child: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      localized(context).deck_edit_title,
                      style: getDialogTitle(
                        isPortrait: isPortrait,
                        textTheme: textTheme,
                      ),
                    ),
                    SizedBox(
                      height: isPortrait ? 25.h : 10.scaledSp,
                    ),
                    _FormTextField(
                      controller: _nameController,
                      fieldName: localized(context).deck_name,
                      icon: Icons.folder_open,
                      autoFocus: true,
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
                          BlocListener<EditDeckBloc, EditDeckState>(
                            listenWhen: (final previous, final current) =>
                                current.deckEditedStatus !=
                                    FormzSubmissionStatus.initial &&
                                current.deckEditedStatus !=
                                    FormzSubmissionStatus.inProgress,
                            listener: (final context, final state) {
                              Navigator.of(context).pop();
                              showScaledSnackBar(
                                context,
                                state.deckEditedStatus ==
                                        FormzSubmissionStatus.success
                                    ? localized(context).deck_update_successful
                                    : localized(context).deck_update_failed,
                              );
                            },
                            child: BlocBuilder<EditDeckBloc, EditDeckState>(
                              buildWhen: (final previous, final current) =>
                                  previous.deckEdited != current.deckEdited ||
                                  previous.deckEditedStatus !=
                                      current.deckEditedStatus,
                              builder: (final context, final state) =>
                                  FilledButton(
                                onPressed: state.deckEdited.isNotValid ||
                                        state.deckEditedStatus ==
                                            FormzSubmissionStatus.inProgress
                                    ? null
                                    : () {
                                        context.read<EditDeckBloc>().add(
                                              DeckEditedSubmitted(
                                                deckId: widget._deckId,
                                                deckName: _nameController.text,
                                              ),
                                            );
                                      },
                                child: state.deckEditedStatus ==
                                        FormzSubmissionStatus.inProgress
                                    ? const CircularProgressIndicator()
                                    : Text(
                                        localized(context).deck_add_edit_ok,
                                        style: getDialogLabel(
                                          isPortrait: isPortrait,
                                          textTheme: textTheme,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.scaledSp,
                    ),
                  ],
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
      BlocBuilder<EditDeckBloc, EditDeckState>(
        buildWhen: (final previous, final current) =>
            previous.deckEdited.value != current.deckEdited.value,
        builder: (final context, final state) => LayoutBuilder(
          builder: (final context, final constraints) {
            final textTheme = Theme.of(context).textTheme;
            final orientation = MediaQuery.of(context).orientation;
            final isPortrait = orientation == Orientation.portrait;
            if (state.overrideDeckName) {
              _controller.text = state.deckEdited.value;
            }
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
                  errorText: state.deckEdited.error == DeckValidationError.empty
                      ? localized(context).deck_name_is_empty
                      : state.deckEdited.isNotValid
                          ? localized(context).deck_name_is_invalid
                          : null,
                ),
                style: getTextFieldStyle(
                  isPortrait: isPortrait,
                  textTheme: textTheme,
                ),
                onChanged: (final value) => context.read<EditDeckBloc>().add(
                      DeckNameChanged(value),
                    ),
                autofocus: _autoFocus,
              ),
            );
          },
        ),
      );
}

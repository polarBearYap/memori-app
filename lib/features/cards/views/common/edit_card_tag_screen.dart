import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:memori_app/features/cards/bloc/card_tag/edit_card_tag_bloc.dart';
import 'package:memori_app/features/cards/models/card_tag.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';

class EditCardTagDialog extends StatefulWidget {
  const EditCardTagDialog({
    required final String cardTagId,
    super.key,
  }) : _cardTagId = cardTagId;

  final String _cardTagId;

  @override
  State<StatefulWidget> createState() => _EditCardTagDialogState();
}

class _EditCardTagDialogState extends State<EditCardTagDialog> {
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
  Widget build(final BuildContext context) => Dialog(
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
          child: SingleChildScrollView(
            child: LayoutBuilder(
              builder: (final context, final constraints) {
                final textTheme = Theme.of(context).textTheme;
                final orientation = MediaQuery.of(context).orientation;
                final isPortrait = orientation == Orientation.portrait;
                return ListBody(
                  children: <Widget>[
                    Text(
                      localized(context).card_tag_edit_title,
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
                      fieldName: localized(context).card_tag_name,
                      icon: Icons.sell,
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
                              localized(context).card_tag_save_cancel,
                              style: getDialogLabel(
                                isPortrait: isPortrait,
                                textTheme: textTheme,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          BlocListener<EditCardTagBloc, EditCardTagState>(
                            listenWhen: (final previous, final current) =>
                                current.cardTagEditedStatus !=
                                    FormzSubmissionStatus.initial &&
                                current.cardTagEditedStatus !=
                                    FormzSubmissionStatus.inProgress,
                            listener: (final context, final state) {
                              Navigator.of(context).pop();
                              showScaledSnackBar(
                                context,
                                state.cardTagEditedStatus ==
                                        FormzSubmissionStatus.success
                                    ? localized(context)
                                        .card_tag_update_successful
                                    : localized(context).card_tag_update_failed,
                              );
                            },
                            child:
                                BlocBuilder<EditCardTagBloc, EditCardTagState>(
                              buildWhen: (final previous, final current) =>
                                  previous.cardTagEdited !=
                                      current.cardTagEdited ||
                                  previous.cardTagEditedStatus !=
                                      current.cardTagEditedStatus,
                              builder: (final context, final state) =>
                                  FilledButton(
                                onPressed: state.cardTagEdited.isNotValid ||
                                        state.cardTagEditedStatus ==
                                            FormzSubmissionStatus.inProgress
                                    ? null
                                    : () {
                                        context.read<EditCardTagBloc>().add(
                                              CardTagEditedSubmitted(
                                                cardTagId: widget._cardTagId,
                                                cardTagName:
                                                    _nameController.text,
                                              ),
                                            );
                                      },
                                child: state.cardTagEditedStatus ==
                                        FormzSubmissionStatus.inProgress
                                    ? const CircularProgressIndicator()
                                    : Text(
                                        localized(context).card_tag_save_ok,
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
                      height: 10.h,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
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
      BlocBuilder<EditCardTagBloc, EditCardTagState>(
        buildWhen: (final previous, final current) =>
            previous.cardTagEdited.value != current.cardTagEdited.value,
        builder: (final context, final state) => LayoutBuilder(
          builder: (final context, final constraints) {
            final textTheme = Theme.of(context).textTheme;
            final orientation = MediaQuery.of(context).orientation;
            final isPortrait = orientation == Orientation.portrait;
            if (state.overrideCardTagName) {
              _controller.text = state.cardTagEdited.value;
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
                  errorText:
                      state.cardTagEdited.error == CardTagValidationError.empty
                          ? localized(context).card_tag_name_is_empty
                          : state.cardTagEdited.isNotValid
                              ? localized(context).card_tag_name_is_invalid
                              : null,
                ),
                style: getTextFieldStyle(
                  isPortrait: isPortrait,
                  textTheme: textTheme,
                ),
                onChanged: (final value) => context.read<EditCardTagBloc>().add(
                      CardTagNameChanged(value),
                    ),
                autofocus: _autoFocus,
              ),
            );
          },
        ),
      );
}

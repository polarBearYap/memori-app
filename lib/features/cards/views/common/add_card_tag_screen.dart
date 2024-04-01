import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:memori_app/features/cards/bloc/card_tag/add_card_tag_bloc.dart';
import 'package:memori_app/features/cards/models/card_tag.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';

class AddCardTagDialog extends StatefulWidget {
  const AddCardTagDialog({
    final String text = '',
    super.key,
  }) : _text = text;

  final String _text;

  @override
  State<StatefulWidget> createState() => _AddCardTagDialogState();
}

class _AddCardTagDialogState extends State<AddCardTagDialog> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nameController.text = widget._text;
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
                      localized(context).card_tag_add_title,
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
                          BlocListener<AddCardTagBloc, AddCardTagState>(
                            listenWhen: (final previous, final current) =>
                                current.cardTagAddedStatus !=
                                    FormzSubmissionStatus.initial &&
                                current.cardTagAddedStatus !=
                                    FormzSubmissionStatus.inProgress,
                            listener: (final context, final state) {
                              Navigator.of(context).pop();
                              showScaledSnackBar(
                                context,
                                state.cardTagAddedStatus ==
                                        FormzSubmissionStatus.success
                                    ? localized(context).card_tag_add_successful
                                    : localized(context).card_tag_add_failed,
                              );
                            },
                            child: BlocBuilder<AddCardTagBloc, AddCardTagState>(
                              buildWhen: (final previous, final current) =>
                                  previous.cardTagAdded !=
                                      current.cardTagAdded ||
                                  previous.cardTagAddedStatus !=
                                      current.cardTagAddedStatus,
                              builder: (final context, final state) =>
                                  FilledButton(
                                onPressed: state.cardTagAdded.isNotValid ||
                                        state.cardTagAddedStatus ==
                                            FormzSubmissionStatus.inProgress
                                    ? null
                                    : () {
                                        context.read<AddCardTagBloc>().add(
                                              CardTagAddedSubmitted(
                                                _nameController.text,
                                              ),
                                            );
                                      },
                                child: state.cardTagAddedStatus ==
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
      BlocBuilder<AddCardTagBloc, AddCardTagState>(
        buildWhen: (final previous, final current) =>
            previous.cardTagAdded.value != current.cardTagAdded.value,
        builder: (final context, final state) => LayoutBuilder(
          builder: (final context, final constraints) {
            final textTheme = Theme.of(context).textTheme;
            final orientation = MediaQuery.of(context).orientation;
            final isPortrait = orientation == Orientation.portrait;
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
                      state.cardTagAdded.error == CardTagValidationError.empty
                          ? localized(context).card_tag_name_is_empty
                          : state.cardTagAdded.isNotValid
                              ? localized(context).card_tag_name_is_invalid
                              : null,
                ),
                style: getTextFieldStyle(
                  isPortrait: isPortrait,
                  textTheme: textTheme,
                ),
                onChanged: (final value) => context.read<AddCardTagBloc>().add(
                      CardTagNameChanged(value),
                    ),
                autofocus: _autoFocus,
              ),
            );
          },
        ),
      );
}

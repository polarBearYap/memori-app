import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:memori_app/features/authentication/bloc/delete_account_bloc.dart';
import 'package:memori_app/features/authentication/bloc/logout_bloc.dart';
import 'package:memori_app/features/authentication/models/models.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/views/alert_dialog.dart';
import 'package:memori_app/features/common/views/delete_alert.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final theme = Theme.of(context);
          final colorTheme = theme.colorScheme;
          final textTheme = theme.textTheme;
          final splashColor = theme.splashColor;
          final outlineButtonStyle = ButtonStyle(
            minimumSize: MaterialStateProperty.all(
              Size(
                double.infinity,
                30.h,
              ),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0.scaledSp),
              ),
            ),
            overlayColor: MaterialStateProperty.all(
              splashColor,
            ),
          );

          final orientation = MediaQuery.of(context).orientation;
          final isPortrait = orientation == Orientation.portrait;
          double titleFontSize = isPortrait
              ? textTheme.titleMedium!.fontSize!.scaledSp
              : textTheme.titleSmall!.fontSize!.scaledSp;
          double descFontSize = isPortrait
              ? textTheme.bodySmall!.fontSize!.scaledSp
              : textTheme.bodySmall!.fontSize!.scaledSp * 0.65;
          double iconSize = isPortrait ? 15.scaledSp : 10.scaledSp;

          if (isBigScreen(context)) {
            titleFontSize *= 0.8;
            descFontSize *= 0.8;
          }

          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 25.w,
                  vertical: 15.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localized(context).settings_delete_account_title,
                      style: TextStyle(
                        fontSize: titleFontSize,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      localized(context).settings_delete_account_desc,
                      style: TextStyle(
                        fontSize: descFontSize,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    BlocBuilder<DeleteAccountBloc, DeleteAccountState>(
                      buildWhen: (final previous, final current) =>
                          previous.isPasswordVisible !=
                              current.isPasswordVisible ||
                          previous.password != current.password,
                      builder: (final context, final state) => SizedBox(
                        height: getTextFieldHeight(
                          isPortrait: isPortrait,
                          hasErrorText: true,
                        ),
                        child: TextField(
                          key: const Key(
                            'deleteUserForm_passwordInput_textField',
                          ),
                          decoration: getTextFieldDecoration(
                            isPortrait: isPortrait,
                            textTheme: textTheme,
                            prefixIconData: Icons.lock,
                            iconSize: iconSize,
                          ).copyWith(
                            errorText: state.password.isValid
                                ? null
                                : state.password.error == null
                                    ? null
                                    : state.password.error ==
                                            PasswordValidationError.empty
                                        ? localized(context)
                                            .user_password_error_is_empty
                                        : localized(context)
                                            .user_password_error_general,
                            hintText:
                                localized(context).user_password_hint_text,
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  context.read<DeleteAccountBloc>().add(
                                        DeleteAccountPasswordVisibilityChanged(
                                          isPasswordVisible:
                                              !state.isPasswordVisible,
                                        ),
                                      ),
                              icon: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.w,
                                ),
                                child: Icon(
                                  state.isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  size: iconSize,
                                ),
                              ),
                            ),
                          ),
                          style: getTextFieldStyle(
                            isPortrait: isPortrait,
                            textTheme: textTheme,
                          ),
                          obscureText: !state.isPasswordVisible,
                          onChanged: (final password) => context
                              .read<DeleteAccountBloc>()
                              .add(DeleteAccountPasswordChanged(password)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    BlocListener<DeleteAccountBloc, DeleteAccountState>(
                      listener: (final context, final state) {
                        if (state.status == FormzSubmissionStatus.success) {
                          showDialog(
                            context: context,
                            builder: (final context) => CustomAlertDialog(
                              title: Text(
                                localized(context)
                                    .settings_delete_account_success_title,
                                style: getDialogTitle(
                                  isPortrait: isPortrait,
                                  textTheme: textTheme,
                                ),
                              ),
                              content: Text(
                                localized(context)
                                    .settings_delete_account_success,
                                style: getDialogContent(
                                  isPortrait: isPortrait,
                                  textTheme: textTheme,
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    context
                                        .read<LogoutBloc>()
                                        .add(const LogoutSubmitted());
                                  },
                                  child: Text(
                                    localized(context)
                                        .settings_delete_account_success_ok,
                                    style: getDialogLabel(
                                      isPortrait: isPortrait,
                                      textTheme: textTheme,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (state.status ==
                            FormzSubmissionStatus.failure) {
                          showDialog(
                            context: context,
                            builder: (final context) => CustomAlertDialog(
                              title: Text(
                                localized(context)
                                    .settings_delete_account_failed_title,
                                style: getDialogTitle(
                                  isPortrait: isPortrait,
                                  textTheme: textTheme,
                                ),
                              ),
                              content: Text(
                                state.failedMessage.isEmpty
                                    ? localized(context)
                                        .user_password_error_general
                                    : state.failedMessage,
                                style: getDialogContent(
                                  isPortrait: isPortrait,
                                  textTheme: textTheme,
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    localized(context)
                                        .settings_delete_account_failed_ok,
                                    style: getDialogLabel(
                                      isPortrait: isPortrait,
                                      textTheme: textTheme,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: BlocBuilder<DeleteAccountBloc, DeleteAccountState>(
                        builder: (final context, final state) => FilledButton(
                          style: outlineButtonStyle.copyWith(
                            foregroundColor: MaterialStateProperty.all(
                              colorTheme.onError,
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              colorTheme.error,
                            ),
                            side: MaterialStateProperty.all(
                              BorderSide(
                                color: colorTheme.error,
                                width: 2.0,
                              ),
                            ),
                          ),
                          onPressed: state.status ==
                                  FormzSubmissionStatus.inProgress
                              ? null
                              : () => {
                                    showDialog(
                                      context: context,
                                      builder: (final BuildContext context) =>
                                          DeleteConfirmationDialog(
                                        title: localized(context)
                                            .settings_delete_account_confirmation_title,
                                        content: localized(context)
                                            .settings_delete_account_confirmation_desc,
                                        confirmText: localized(context)
                                            .settings_delete_account_confirmation_yes,
                                        dismissText: localized(context)
                                            .settings_delete_account_confirmation_no,
                                        onConfirm: () {
                                          context.read<DeleteAccountBloc>().add(
                                                DeleteAccountSubmitted(
                                                  localized(context),
                                                ),
                                              );
                                        },
                                      ),
                                    ),
                                  },
                          child:
                              state.status == FormzSubmissionStatus.inProgress
                                  ? const CircularProgressIndicator()
                                  : Text(
                                      localized(context)
                                          .settings_delete_account_button_text,
                                      style: getFilledButtonTextStyle(
                                        isPortrait: isPortrait,
                                        textTheme: textTheme,
                                      ),
                                    ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: isPortrait ? 10.scaledSp : 3.scaledSp,
                    ),
                    OutlinedButton(
                      style: outlineButtonStyle,
                      onPressed: () => {
                        Navigator.of(context).pop(),
                      },
                      child: Text(
                        localized(context).settings_delete_account_cancel,
                        style: getFilledButtonTextStyle(
                          isPortrait: isPortrait,
                          textTheme: textTheme,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.scaledSp,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}

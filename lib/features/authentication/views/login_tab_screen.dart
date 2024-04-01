import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:memori_app/features/authentication/bloc/login_bloc.dart';
import 'package:memori_app/features/authentication/models/models.dart';
import 'package:memori_app/features/common/bloc/keyboard_bloc.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';

class LoginTabScreen extends StatelessWidget {
  const LoginTabScreen({super.key});

  @override
  Widget build(final BuildContext context) => Column(
        children: [
          SizedBox(
            height: 40.h,
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.fromLTRB(36.w, 0, 36.w, 0),
              child: SingleChildScrollView(
                primary: false,
                child: Column(
                  children: [
                    const _EmailField(),
                    _FormDivider(),
                    const _PasswordField(),
                    /*SizedBox(
                        height: 15.h,
                      ),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: _ForgetPasswordLink(),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),*/
                    _FormDivider(),
                    const _LoginButton(),
                  ],
                ),
              ),
            ),
          ),
          BlocProvider(
            create: (final context) => KeyboardVisibilityBloc(),
            child: BlocBuilder<KeyboardVisibilityBloc, KeyboardVisibilityState>(
              builder: (final context, final state) => state is KeyboardHidden
                  ? const Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: _SignUpLink(),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      );
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(final BuildContext context) =>
      BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (final previous, final current) =>
            previous.email != current.email,
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
                key: const Key('loginForm_emailInput_textField'),
                decoration: getTextFieldDecoration(
                  isPortrait: isPortrait,
                  textTheme: textTheme,
                  prefixIconData: Icons.mail,
                  iconSize: isPortrait ? 12.scaledSp : 8.scaledSp,
                ).copyWith(
                  errorText: state.email.isValid
                      ? null
                      : state.email.error == null ||
                              state.email.error == EmailValidationError.empty
                          ? null
                          : localized(context).user_email_error_general,
                  hintText: localized(context).user_email_hint_text,
                ),
                style: getTextFieldStyle(
                  isPortrait: isPortrait,
                  textTheme: textTheme,
                ),
                onChanged: (final username) =>
                    context.read<LoginBloc>().add(LoginEmailChanged(username)),
              ),
            );
          },
        ),
      );
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(final BuildContext context) =>
      BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (final previous, final current) =>
            previous.isPasswordVisible != current.isPasswordVisible ||
            previous.password != current.password,
        builder: (final context, final state) => LayoutBuilder(
          builder: (final context, final constraints) {
            final textTheme = Theme.of(context).textTheme;
            final orientation = MediaQuery.of(context).orientation;
            final isPortrait = orientation == Orientation.portrait;
            final iconSize = isPortrait ? 12.scaledSp : 8.scaledSp;
            return SizedBox(
              height: getTextFieldHeight(
                isPortrait: isPortrait,
                hasErrorText: true,
              ),
              child: TextField(
                key: const Key('loginForm_passwordInput_textField'),
                decoration: getTextFieldDecoration(
                  isPortrait: isPortrait,
                  textTheme: textTheme,
                  prefixIconData: Icons.lock,
                  iconSize: iconSize,
                ).copyWith(
                  errorText: state.password.isValid
                      ? null
                      : state.password.error == null ||
                              state.password.error ==
                                  PasswordValidationError.empty
                          ? null
                          : localized(context).user_password_error_general,
                  hintText: localized(context).user_password_hint_text,
                  suffixIcon: IconButton(
                    onPressed: () => context.read<LoginBloc>().add(
                          LoginPasswordVisibilityChanged(
                            isPasswordVisible: !state.isPasswordVisible,
                          ),
                        ),
                    icon: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
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
                onChanged: (final username) => context
                    .read<LoginBloc>()
                    .add(LoginPasswordChanged(username)),
              ),
            );
          },
        ),
      );
}

class ForgetPasswordLink extends StatelessWidget {
  const ForgetPasswordLink({super.key});

  @override
  Widget build(final BuildContext context) => Text.rich(
        TextSpan(
          text: localized(context).user_forgot_password_title,
          style: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline, // Underline the hyperlink
          ),
        ),
      );
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(final BuildContext context) =>
      BlocListener<LoginBloc, LoginState>(
        listenWhen: (final previous, final current) =>
            current.status != FormzSubmissionStatus.initial &&
            current.status != FormzSubmissionStatus.inProgress,
        listener: (final context, final state) {
          if (state.status == FormzSubmissionStatus.success) {
            context.go('/home');
          } else if (state.status == FormzSubmissionStatus.failure) {
            showScaledSnackBar(
              context,
              state.failedMessage.isEmpty
                  ? localized(context).user_login_error_general
                  : state.failedMessage,
            );
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (final context, final state) => state.status.isInProgress
              ? const CircularProgressIndicator()
              : LayoutBuilder(
                  builder: (final context, final constraints) {
                    final orientation = MediaQuery.of(context).orientation;
                    final isPortrait = orientation == Orientation.portrait;
                    final textTheme = Theme.of(context).textTheme;
                    final fontSize = isPortrait
                        ? textTheme.labelSmall!.fontSize!.scaledSp
                        : textTheme.labelSmall!.fontSize!.scaledSp * 0.55;
                    return FilledButton(
                      key: const Key('loginForm_continue_raisedButton'),
                      onPressed: state.isValid
                          ? () {
                              context
                                  .read<LoginBloc>()
                                  .add(LoginSubmitted(localized(context)));
                            }
                          : null,
                      style: FilledButton.styleFrom(
                        minimumSize: isPortrait
                            ? Size(double.infinity, 40.h)
                            : Size(double.infinity, 50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10.0.scaledSp,
                          ), // Adjust the border radius as needed
                        ),
                      ),
                      child: Text(
                        localized(context).user_login_button_text,
                        style: TextStyle(
                          fontSize: fontSize,
                        ),
                      ),
                    );
                  },
                ),
        ),
      );
}

class _SignUpLink extends StatelessWidget {
  const _SignUpLink();

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final orientation = MediaQuery.of(context).orientation;
          final isPortrait = orientation == Orientation.portrait;
          final textTheme = Theme.of(context).textTheme;
          final fontSize = isPortrait
              ? textTheme.labelSmall!.fontSize!.scaledSp * 0.9
              : textTheme.labelSmall!.fontSize!.scaledSp * 0.5;
          return Text.rich(
            TextSpan(
              text: localized(context).user_signup_hyperlink_text_front,
              style: TextStyle(
                fontSize: fontSize,
              ),
              children: [
                TextSpan(
                  text: localized(context).user_signup_hyperlink_text_back,
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontSize: fontSize,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.go('/userpage/signup');
                    },
                ),
              ],
            ),
          );
        },
      );
}

class _FormDivider extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          return SizedBox(
            height: isPortrait ? 10.h : 30.h,
          );
        },
      );
}

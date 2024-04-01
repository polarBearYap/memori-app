import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:memori_app/features/authentication/bloc/signup_bloc.dart';
import 'package:memori_app/features/authentication/models/models.dart';
import 'package:memori_app/features/authentication/utilities/password_strength_checker.dart';
import 'package:memori_app/features/common/bloc/keyboard_bloc.dart';
import 'package:memori_app/features/common/utils/font_size.dart';
import 'package:memori_app/features/common/utils/localization.dart';
import 'package:memori_app/features/common/utils/media_query.dart';
import 'package:memori_app/features/common/views/alert_dialog.dart';
import 'package:memori_app/firebase/auth/auth.dart';

class SignUpTabScreen extends StatelessWidget {
  const SignUpTabScreen({super.key});

  @override
  Widget build(final BuildContext context) => Column(
        children: [
          SizedBox(
            height: 40.h,
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20.w, 0),
              child: Scrollbar(
                thickness: 5,
                child: SingleChildScrollView(
                  child: BlocProvider(
                    create: (final context) => SignUpBloc(
                      authenticationRepository:
                          context.read<AuthenticationRepository>(),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(36.w, 0, 20.w, 0),
                          child: const _UsernameField(),
                        ),
                        _FormDivider(),
                        Padding(
                          padding: EdgeInsets.fromLTRB(36.w, 0, 20.w, 0),
                          child: const _EmailField(),
                        ),
                        _FormDivider(),
                        Padding(
                          padding: EdgeInsets.fromLTRB(36.w, 0, 20.w, 0),
                          child: const _PasswordField(),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        LayoutBuilder(
                          builder: (final context, final constraints) {
                            final orientation =
                                MediaQuery.of(context).orientation;
                            final isPortrait =
                                orientation == Orientation.portrait;
                            return Padding(
                              padding: isPortrait
                                  ? EdgeInsets.fromLTRB(36.w, 0, 20.w, 0)
                                  : EdgeInsets.fromLTRB(36.w, 10.h, 20.w, 10.h),
                              child: const _PasswordStrengthField(),
                            );
                          },
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(36.w, 0, 20.w, 0),
                          child: const _PasswordHint(),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(36.w, 0, 20.w, 0),
                          child: const _PasswordConfirmField(),
                        ),
                        _FormDivider(),
                        Padding(
                          padding: EdgeInsets.fromLTRB(36.w, 0, 20.w, 0),
                          child: const _SignUpButton(),
                        ),
                      ],
                    ),
                  ),
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
                        child: _LoginLink(),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      );
}

class _UsernameField extends StatelessWidget {
  const _UsernameField();

  @override
  Widget build(final BuildContext context) =>
      BlocBuilder<SignUpBloc, SignUpState>(
        buildWhen: (final previous, final current) =>
            previous.username != current.username,
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
                key: const Key('signupForm_usernameInput_textField'),
                decoration: getTextFieldDecoration(
                  isPortrait: isPortrait,
                  textTheme: textTheme,
                  prefixIconData: Icons.person,
                  iconSize: isPortrait ? 12.scaledSp : 8.scaledSp,
                ).copyWith(
                  errorText: state.username.isValid
                      ? null
                      : state.username.error == null ||
                              state.username.error ==
                                  UsernameValidationError.empty
                          ? null
                          : localized(context).user_username_error_general,
                  hintText: localized(context).user_username_hint_text,
                ),
                style: getTextFieldStyle(
                  isPortrait: isPortrait,
                  textTheme: textTheme,
                ),
                onChanged: (final username) => context
                    .read<SignUpBloc>()
                    .add(SignUpUsernameChanged(username)),
              ),
            );
          },
        ),
      );
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(final BuildContext context) =>
      BlocBuilder<SignUpBloc, SignUpState>(
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
                key: const Key('signupForm_emailInput_textField'),
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
                onChanged: (final email) =>
                    context.read<SignUpBloc>().add(SignUpEmailChanged(email)),
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
      BlocBuilder<SignUpBloc, SignUpState>(
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
                hasErrorText: false,
              ),
              child: TextField(
                key: const Key('signupForm_passwordInput_textField'),
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
                                  NewPasswordValidationError.empty ||
                              state.password.error ==
                                  NewPasswordValidationError.weak
                          ? null
                          : localized(context).user_password_error_general,
                  hintText: localized(context).user_password_hint_text,
                  suffixIcon: IconButton(
                    onPressed: () => context.read<SignUpBloc>().add(
                          SignUpPasswordVisibilityChanged(
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
                    .read<SignUpBloc>()
                    .add(SignUpPasswordChanged(username)),
              ),
            );
          },
        ),
      );
}

class _PasswordConfirmField extends StatelessWidget {
  const _PasswordConfirmField();

  @override
  Widget build(final BuildContext context) =>
      BlocBuilder<SignUpBloc, SignUpState>(
        buildWhen: (final previous, final current) =>
            previous.isPasswordConfirmVisible !=
                current.isPasswordConfirmVisible ||
            previous.passwordConfirm != current.passwordConfirm ||
            previous.passwordConfirm.originalPassword !=
                current.passwordConfirm.originalPassword,
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
                key: const Key('signupForm_passwordConfirmInput_textField'),
                decoration: getTextFieldDecoration(
                  isPortrait: isPortrait,
                  textTheme: textTheme,
                  prefixIconData: Icons.lock,
                  iconSize: iconSize,
                ).copyWith(
                  errorText: state.passwordConfirm.isValid ||
                          state.passwordConfirm.originalPassword.isEmpty
                      ? null
                      : localized(context).user_password_error_not_match,
                  hintText: localized(context).user_confirm_password_hint_text,
                  suffixIcon: IconButton(
                    onPressed: () => context.read<SignUpBloc>().add(
                          SignUpPasswordConfirmVisibilityChanged(
                            isPasswordVisible: !state.isPasswordConfirmVisible,
                          ),
                        ),
                    icon: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                      ),
                      child: Icon(
                        state.isPasswordConfirmVisible
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
                obscureText: !state.isPasswordConfirmVisible,
                onChanged: (final username) => context
                    .read<SignUpBloc>()
                    .add(SignUpPasswordConfirmChanged(username)),
              ),
            );
          },
        ),
      );
}

class _PasswordStrengthField extends StatelessWidget {
  const _PasswordStrengthField();

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final width = constraints.maxWidth / (isFontSizeBig() ? 4.4 : 4.3);
          final height = isPortrait ? 5.h : 10.h;
          return Row(
            children: [
              _PasswordStrengthFieldBar(
                animationMsDuration: 200,
                passwordStrength: PasswordStrength.weak,
                initWidth: width,
                initHeight: height,
              ),
              const Spacer(),
              _PasswordStrengthFieldBar(
                animationMsDuration: 200,
                passwordStrength: PasswordStrength.moderate,
                initWidth: width,
                initHeight: height,
              ),
              const Spacer(),
              _PasswordStrengthFieldBar(
                animationMsDuration: 200,
                passwordStrength: PasswordStrength.strong,
                initWidth: width,
                initHeight: height,
              ),
              const Spacer(),
              _PasswordStrengthFieldBar(
                animationMsDuration: 200,
                passwordStrength: PasswordStrength.verystrong,
                initWidth: width,
                initHeight: height,
              ),
            ],
          );
        },
      );
}

class _PasswordStrengthFieldBar extends StatefulWidget {
  const _PasswordStrengthFieldBar({
    required final int animationMsDuration,
    required final PasswordStrength passwordStrength,
    required final double initWidth,
    required final double initHeight,
  })  : _animationMsDuration = animationMsDuration,
        _passwordStrength = passwordStrength,
        _initWidth = initWidth,
        _initHeight = initHeight;

  final int _animationMsDuration;
  final PasswordStrength _passwordStrength;
  final double _initWidth;
  final double _initHeight;

  @override
  State<StatefulWidget> createState() => _PasswordStrengthFieldBarState();
}

extension PasswordStrengthColorExtension on PasswordStrength {
  Color get color {
    switch (this) {
      case PasswordStrength.unspecified:
        return const Color.fromARGB(255, 225, 227, 234);
      case PasswordStrength.weak:
        return const Color.fromARGB(255, 193, 60, 53);
      case PasswordStrength.moderate:
        return const Color.fromARGB(255, 236, 170, 65);
      case PasswordStrength.strong:
      case PasswordStrength.verystrong:
        return const Color.fromARGB(255, 57, 129, 91);
    }
  }
}

class _PasswordStrengthFieldBarState extends State<_PasswordStrengthFieldBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  late final SignUpBloc _signUpBloc;
  late final StreamSubscription<SignUpState> _signUpStateSubscription;

  double _width = 65.w;
  double _height = 5.h;

  static const Color defaultColor = Color.fromARGB(255, 225, 227, 234);
  Color _strengthColor = defaultColor;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: widget._animationMsDuration),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _signUpBloc = BlocProvider.of<SignUpBloc>(context);

    _signUpStateSubscription = _signUpBloc.stream.listen((final signUpState) {
      if (signUpState.previousPasswordStrength.value ==
          signUpState.passwordStrength.value) {
        return;
      }
      var diff = signUpState.passwordStrength.value -
          signUpState.previousPasswordStrength.value;
      if (diff > 0 &&
          widget._passwordStrength.value <=
              signUpState.passwordStrength.value) {
        if (_strengthColor != signUpState.passwordStrength.color) {
          setState(() {
            _strengthColor = signUpState.passwordStrength.color;
          });
        }
        if (!_animationController.isCompleted) {
          _animationController.forward();
        }
      } else if (diff < 0) {
        if (widget._passwordStrength.value >
            signUpState.passwordStrength.value) {
          if (!_animationController.isDismissed) {
            _animationController.reverse();
          }
        }
        setState(() {
          _strengthColor = signUpState.passwordStrength.color;
        });
      }
    });
  }

  @override
  void didUpdateWidget(
    final _PasswordStrengthFieldBar oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (widget._initWidth != oldWidget._initWidth ||
        widget._initHeight != oldWidget._initHeight) {
      setState(() {
        _width = widget._initWidth;
        _height = widget._initHeight;
        // _width = isPortrait ? 65.w : 68.w;
        // _width = isPortrait ? 65.w : 55.w;
        // _height = isPortrait ? 5.h : 10.h;
      });
    }
  }

  @override
  void dispose() {
    _signUpStateSubscription.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => AnimatedBuilder(
        animation: _animationController,
        builder: (final BuildContext context, final Widget? child) {
          final double width = _animation.value * _width;
          return Container(
            width: _width,
            height: _height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0.scaledSp),
              color: const Color.fromARGB(255, 225, 227, 234),
            ),
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: widget._animationMsDuration),
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0.scaledSp),
                    color: _strengthColor,
                  ),
                ),
              ],
            ),
          );
        },
      );
}

extension PasswordStrengthTextExtension on PasswordStrength {
  String text(final BuildContext context) {
    switch (this) {
      case PasswordStrength.unspecified:
        return localized(context).user_password_strength_text;
      case PasswordStrength.weak:
        return localized(context).user_password_strength_very_weak;
      case PasswordStrength.moderate:
        return localized(context).user_password_strength_weak;
      case PasswordStrength.strong:
        return localized(context).user_password_strength_strong;
      case PasswordStrength.verystrong:
        return localized(context).user_password_strength_very_strong;
    }
  }
}

class _PasswordHint extends StatelessWidget {
  const _PasswordHint();

  @override
  Widget build(final BuildContext context) =>
      BlocBuilder<SignUpBloc, SignUpState>(
        buildWhen: (final previous, final current) =>
            previous.passwordStrength != current.passwordStrength ||
            previous.passwordValidation != current.passwordValidation,
        builder: (final context, final state) => LayoutBuilder(
          builder: (final context, final constraints) {
            final orientation = MediaQuery.of(context).orientation;
            final isPortrait = orientation == Orientation.portrait;
            final textTheme = Theme.of(context).textTheme;
            final labelFontSize = isPortrait
                ? textTheme.bodySmall!.fontSize!.scaledSp * 0.9
                : textTheme.bodySmall!.fontSize!.scaledSp * 0.5;
            final iconSize = isPortrait ? 13.scaledSp : 8.scaledSp;

            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  state.passwordStrength.text(context),
                  style: TextStyle(
                    fontSize:
                        isPortrait ? labelFontSize * 0.9 : labelFontSize * 0.95,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                    isPortrait ? 4.w : 2.w,
                  ), // Adjust padding to change the touch area
                  child: GestureDetector(
                    onTap: () {
                      List<bool> validations = [
                        state.passwordValidation.hasLowercase,
                        state.passwordValidation.hasUppercase,
                        state.passwordValidation.hasDigits,
                        state.passwordValidation.hasSpecialCharacters,
                        state.passwordStrength.value >=
                            PasswordStrength.strong.value,
                      ];
                      List<String> descriptions = [
                        localized(context).user_password_criteria_lowercase,
                        localized(context).user_password_criteria_uppercase,
                        localized(context).user_password_criteria_digit,
                        localized(context).user_password_criteria_special,
                        localized(context).user_password_criteria_complex,
                      ];

                      List<List<dynamic>> zipList =
                          validations.asMap().entries.map((final entry) {
                        int index = entry.key;
                        String name = descriptions[index];
                        return [entry.value, name];
                      }).toList();
                      List<Widget> children = [];

                      for (var pair in zipList) {
                        bool validationResult = pair[0];
                        children.add(
                          Row(
                            children: [
                              Icon(
                                validationResult ? Icons.check : Icons.close,
                                color: validationResult
                                    ? PasswordStrength.strong.color
                                    : PasswordStrength.weak.color,
                                size: isPortrait ? 12.scaledSp : 8.scaledSp,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  pair[1],
                                  style: getDialogContent(
                                    isPortrait: isPortrait,
                                    textTheme: textTheme,
                                  ).copyWith(
                                    color: validationResult
                                        ? PasswordStrength.strong.color
                                        : PasswordStrength.weak.color,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      showDialog(
                        context: context,
                        builder: (final BuildContext context) =>
                            CustomAlertDialog(
                          title: Text(
                            localized(context).user_password_criteria_title,
                            style: getDialogTitle(
                              isPortrait: isPortrait,
                              textTheme: textTheme,
                            ),
                          ),
                          content: SingleChildScrollView(
                            primary: false,
                            child: ListBody(
                              children: children,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                localized(context).user_password_criteria_close,
                                style: getDialogLabel(
                                  isPortrait: isPortrait,
                                  textTheme: textTheme,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Icon(
                      Icons.info,
                      size: iconSize,
                    ), // Keep your icon size
                  ),
                ),
              ],
            );
          },
        ),
      );
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton();

  @override
  Widget build(final BuildContext context) =>
      BlocListener<SignUpBloc, SignUpState>(
        listenWhen: (final previous, final current) =>
            current.status != FormzSubmissionStatus.initial &&
            current.status != FormzSubmissionStatus.inProgress,
        listener: (final context, final state) {
          showScaledSnackBar(
            context,
            state.status == FormzSubmissionStatus.success
                ? localized(context).user_signup_successful
                : state.failedMessage.isEmpty
                    ? localized(context).user_signup_error_general
                    : state.failedMessage,
          );
          if (state.status == FormzSubmissionStatus.success) {
            context.go('/home');
          }
        },
        child: BlocBuilder<SignUpBloc, SignUpState>(
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
                      key: const Key('signupForm_continue_raisedButton'),
                      onPressed: state.isValid
                          ? () {
                              context
                                  .read<SignUpBloc>()
                                  .add(SignUpSubmitted(localized(context)));
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
                        localized(context).user_sign_up_button_text,
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

class _LoginLink extends StatelessWidget {
  const _LoginLink();

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
              text: localized(context).user_login_hyperlink_text_front,
              style: TextStyle(
                fontSize: fontSize,
              ),
              children: [
                TextSpan(
                  text: localized(context).user_login_hyperlink_text_back,
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontSize: fontSize,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.go('/userpage/login');
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

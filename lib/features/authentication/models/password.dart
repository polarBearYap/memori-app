import 'package:formz/formz.dart';
import 'package:memori_app/features/authentication/utilities/utilities.dart';

enum PasswordValidationError { empty }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(final String value) {
    if (value.isEmpty) return PasswordValidationError.empty;
    return null;
  }
}

enum NewPasswordValidationError { empty, weak }

class NewPassword extends FormzInput<String, NewPasswordValidationError> {
  final PasswordStrength passwordStrength;

  const NewPassword.pure({this.passwordStrength = PasswordStrength.weak})
      : super.pure('');
  const NewPassword.dirty({required this.passwordStrength, final String value = ''})
      : super.dirty(value);

  @override
  NewPasswordValidationError? validator(final String value) {
    if (value.isEmpty) {
      return NewPasswordValidationError.empty;
    }
    if (passwordStrength.value < PasswordStrength.strong.value) {
      return NewPasswordValidationError.weak;
    }
    return null;
  }
}

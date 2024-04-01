import 'package:formz/formz.dart';

enum PasswordConfirmValidationError { empty, notMatch }

class PasswordConfirm
    extends FormzInput<String, PasswordConfirmValidationError> {
  final String originalPassword;

  const PasswordConfirm.pure({this.originalPassword = ''}) : super.pure('');
  const PasswordConfirm.dirty(
      {required this.originalPassword, final String value = '',})
      : super.dirty(value);

  @override
  PasswordConfirmValidationError? validator(final String value) {
    if (value.isEmpty) {
      return PasswordConfirmValidationError.empty;
    } else if (value != originalPassword) {
      return PasswordConfirmValidationError.notMatch;
    }
    return null;
  }
}

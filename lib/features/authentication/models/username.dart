import 'package:formz/formz.dart';

enum UsernameValidationError { empty }

class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure() : super.pure('');
  const Username.dirty([super.value = '']) : super.dirty();

  @override
  UsernameValidationError? validator(final String value) {
    if (value.isEmpty) {
      return UsernameValidationError.empty;
    }
    return null;
  }
}

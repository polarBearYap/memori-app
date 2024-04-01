import 'package:email_validator/email_validator.dart';
import 'package:formz/formz.dart';

enum EmailValidationError { empty, invalid }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([super.value = '']) : super.dirty();

  @override
  EmailValidationError? validator(final String value) {
    if (value.isEmpty) {
      return EmailValidationError.empty;
    } else if (!EmailValidator.validate(value)) {
      return EmailValidationError.invalid;
    }
    return null;
  }
}

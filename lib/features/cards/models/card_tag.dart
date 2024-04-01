import 'package:formz/formz.dart';

enum CardTagValidationError { empty }

class CardTagInput extends FormzInput<String, CardTagValidationError> {
  const CardTagInput.pure() : super.pure('');
  const CardTagInput.dirty([super.value = '']) : super.dirty();

  @override
  CardTagValidationError? validator(final String value) {
    if (value.isEmpty) {
      return CardTagValidationError.empty;
    }
    return null;
  }
}

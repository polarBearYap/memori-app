import 'package:formz/formz.dart';

enum DeckValidationError { empty }

class DeckInput extends FormzInput<String, DeckValidationError> {
  const DeckInput.pure() : super.pure('');
  const DeckInput.dirty([super.value = '']) : super.dirty();

  @override
  DeckValidationError? validator(final String value) {
    if (value.isEmpty) {
      return DeckValidationError.empty;
    }
    return null;
  }
}

import 'package:equatable/equatable.dart';
import 'package:password_strength/password_strength.dart';

enum PasswordStrength {
  unspecified,
  weak,
  moderate,
  strong,
  verystrong,
}

extension PasswordStrengthExtension on PasswordStrength {
  int get value {
    switch (this) {
      case PasswordStrength.unspecified:
        return 0;
      case PasswordStrength.weak:
        return 1;
      case PasswordStrength.moderate:
        return 2;
      case PasswordStrength.strong:
        return 3;
      case PasswordStrength.verystrong:
        return 4;
    }
  }
}

final class PasswordValidation extends Equatable {
  final bool hasDigits;
  final bool hasLowercase;
  final bool hasSpecialCharacters;
  final bool hasUppercase;

  const PasswordValidation()
      : hasDigits = false,
        hasLowercase = false,
        hasSpecialCharacters = false,
        hasUppercase = false;

  const PasswordValidation.withValue({
    required this.hasDigits,
    required this.hasLowercase,
    required this.hasSpecialCharacters,
    required this.hasUppercase,
  });

  @override
  List<Object> get props => [
        hasDigits,
        hasLowercase,
        hasSpecialCharacters,
        hasUppercase,
      ];
}

/*
  Weak: Less than 8 characters
  Moderate: 8-11 characters
  Strong: 12-15 characters
  Very Strong: 16 or more characters
   */
PasswordStrength getStrengthByLength(final String password) {
  if (password.length < 8) {
    return PasswordStrength.weak;
  } else if (password.length < 12) {
    return PasswordStrength.moderate;
  } else if (password.length < 16) {
    return PasswordStrength.strong;
  }
  return PasswordStrength.verystrong;
}

PasswordValidation validatePassword(final String password) {
  bool hasUppercase = RegExp('[A-Z]').hasMatch(password);
  bool hasLowercase = RegExp('[a-z]').hasMatch(password);
  bool hasDigits = RegExp(r'\d').hasMatch(password);
  bool hasSpecialCharacters = RegExp(r'[\W_]').hasMatch(password);

  return PasswordValidation.withValue(
    hasDigits: hasDigits,
    hasLowercase: hasLowercase,
    hasUppercase: hasUppercase,
    hasSpecialCharacters: hasSpecialCharacters,
  );
}

PasswordStrength evaluatePasswordStrength(final String password) {
  if (password.isEmpty) {
    return PasswordStrength.unspecified;
  }

  int passwordCriteria = 0;
  bool hasUppercase = RegExp('[A-Z]').hasMatch(password);
  bool hasLowercase = RegExp('[a-z]').hasMatch(password);
  bool hasDigits = RegExp(r'\d').hasMatch(password);
  bool hasSpecialCharacters = RegExp(r'[\W_]').hasMatch(password);
  int countSpecialCharacters = RegExp(r'[\W_]').allMatches(password).length;
  PasswordStrength strengthByLen = getStrengthByLength(password);
  double libraryStrength = estimatePasswordStrength(password);
  if (hasUppercase) {
    passwordCriteria++;
  }
  if (hasLowercase) {
    passwordCriteria++;
  }
  if (hasDigits) {
    passwordCriteria++;
  }
  if (hasSpecialCharacters) {
    passwordCriteria++;
  }

  // Weak: Include only either uppercase, lowercase, digits, or special chars
  if (passwordCriteria < 2 || strengthByLen == PasswordStrength.weak) {
    return PasswordStrength.weak;
  }
  // Strong: Include all uppercase, lowercase, digits, or special chars
  if (passwordCriteria == 4) {
    // Use library to check common or moderate password
    if (libraryStrength < 0.3) {
      return PasswordStrength.weak;
    }
    if (libraryStrength < 0.7) {
      return PasswordStrength.moderate;
    }
    // Very Strong: Include more than one special characters
    if (countSpecialCharacters > 1 &&
        (strengthByLen.value >= PasswordStrength.strong.value)) {
      return PasswordStrength.verystrong;
    }
    if (strengthByLen == PasswordStrength.moderate) {
      return PasswordStrength.strong;
    }
    if (strengthByLen == PasswordStrength.weak) {
      return PasswordStrength.moderate;
    }
    return PasswordStrength.strong;
  }
  // Moderate: Includes three out of 4 password criterias
  if (passwordCriteria == 3) {
    return PasswordStrength.moderate;
  }
  return PasswordStrength.weak;
}

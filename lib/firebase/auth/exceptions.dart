import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpWithEmailAndPasswordFailure implements Exception {
  SignUpWithEmailAndPasswordFailure([
    this.message = '',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  /// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/createUserWithEmailAndPassword.html
  factory SignUpWithEmailAndPasswordFailure.fromCode(
    final String code,
    final AppLocalizations localized,
  ) {
    switch (code) {
      case 'invalid-email':
        return SignUpWithEmailAndPasswordFailure(
          localized.firebase_invalid_email,
        );
      case 'user-disabled':
        return SignUpWithEmailAndPasswordFailure(
          localized.firebase_user_disabled,
        );
      case 'email-already-in-use':
        return SignUpWithEmailAndPasswordFailure(
          localized.firebase_email_already_in_use,
        );
      case 'operation-not-allowed':
        return SignUpWithEmailAndPasswordFailure(
          localized.firebase_operation_not_allowed,
        );
      case 'weak-password':
        return SignUpWithEmailAndPasswordFailure(
          localized.firebase_weak_password,
        );
      default:
        return SignUpWithEmailAndPasswordFailure(
          localized.firebase_unknown_error,
        );
    }
  }

  /// The associated error message.
  final String message;
}

class LogInWithEmailAndPasswordFailure implements Exception {
  /// {@macro log_in_with_email_and_password_failure}
  LogInWithEmailAndPasswordFailure([
    this.message = '',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithEmailAndPasswordFailure.fromCode(
    final String code,
    final AppLocalizations localized,
  ) {
    switch (code) {
      case 'invalid-email':
        return LogInWithEmailAndPasswordFailure(
          // 'Email is not valid or badly formatted.',
          localized.firebase_wrong_password,
        );
      case 'user-disabled':
        return LogInWithEmailAndPasswordFailure(
          localized.firebase_user_disabled,
        );
      case 'user-not-found':
        return LogInWithEmailAndPasswordFailure(
          localized.firebase_email_not_found,
        );
      case 'wrong-password':
      case 'invalid-credential':
        return LogInWithEmailAndPasswordFailure(
          // 'Incorrect password, please try again.',
          localized.firebase_wrong_password,
        );
      default:
        return LogInWithEmailAndPasswordFailure(
          localized.firebase_unknown_error,
        );
    }
  }

  /// The associated error message.
  final String message;
}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

class ReauthenticateWithPasswordFailure implements Exception {
  ReauthenticateWithPasswordFailure([
    this.message = '',
  ]);

  factory ReauthenticateWithPasswordFailure.fromCode(
    final String code,
    final AppLocalizations localized,
  ) {
    switch (code) {
      case 'invalid-email':
        return ReauthenticateWithPasswordFailure(
          localized.firebase_wrong_password,
        );
      case 'wrong-password':
        return ReauthenticateWithPasswordFailure(
          localized.firebase_wrong_password,
        );
      default:
        return ReauthenticateWithPasswordFailure(
          localized.firebase_unknown_error,
        );
    }
  }

  /// The associated error message.
  final String message;
}

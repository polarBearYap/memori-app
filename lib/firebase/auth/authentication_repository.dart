import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:memori_app/api/api.dart';
import 'package:memori_app/db/repositories/app_users_repository.dart';
import 'package:memori_app/db/repositories/time_zones_repository.dart';
import 'package:memori_app/db/tables/app_users.drift.dart';
import 'package:memori_app/features/authentication/bloc/signup_cubit.dart';
import 'package:memori_app/firebase/auth/exceptions.dart';
import 'package:memori_app/firebase/auth/user.dart';
import 'package:uuid/uuid.dart';

class AuthenticationRepository {
  AuthenticationRepository({
    required final AppUsersRepository appUsersRepository,
    required final TimeZonesRepository timeZonesRepository,
    required final SyncApi syncApi,
    final FirebaseAuth? firebaseAuth,
    required final SignUpCubit signUpCubit,
  })  : _appUsersRepository = appUsersRepository,
        _timeZonesRepository = timeZonesRepository,
        _syncApi = syncApi,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _signUpCubit = signUpCubit;

  final AppUsersRepository _appUsersRepository;
  final TimeZonesRepository _timeZonesRepository;
  final FirebaseAuth _firebaseAuth;
  final SyncApi _syncApi;
  final SignUpCubit _signUpCubit;

  Stream<MemoriUser> get user =>
      _firebaseAuth.authStateChanges().map((final firebaseUser) {
        final user =
            firebaseUser == null ? MemoriUser.empty : firebaseUser.toUser;
        return user;
      });

  /// Returns the current cached user.
  /// Defaults to [MemoriUser.empty] if there is no cached user.
  // MemoriUser get currentUser {
  // return _cache.read<MemoriUser>(key: userCacheKey) ?? MemoriUser.empty;
  // }

  Future<void> signUp({
    required final String username,
    required final String email,
    required final String password,
    required final AppLocalizations localized,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user!;
      // Set username in the firebase
      await user.updateDisplayName(username);
      await createUserInDatabase(user, username);
      await logInWithEmailAndPassword(
        email: email,
        password: password,
        localized: localized,
      );
      _signUpCubit.setFirstSignedUp(firstSignedUp: true);
    } on FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(
        e.code,
        localized,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw SignUpWithEmailAndPasswordFailure();
    }
  }

  Future<void> logInWithEmailAndPassword({
    required final String email,
    required final String password,
    required final AppLocalizations localized,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user!;
      final username = user.displayName ?? '';
      // Ensure that user record is created in database to allow sync
      AppUser? appUser = await _appUsersRepository.getEntity(user.uid);
      if (appUser == null) {
        await createUserInDatabase(user, username);
      }
      // Send API request to Spring backend for user creation
      await _syncApi.createUser(
        UserCreationRequest(
          email: user.email!,
          username: username,
          isEmailVerified: false,
        ),
      );
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(
        e.code,
        localized,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> createUserInDatabase(
    final User user,
    final String username,
  ) async {
    // Generate a random UUID for device
    final deviceId = const Uuid().v4();
    // Get default timezone
    const timeZoneCode = 'Asia/Kuala_Lumpur';
    final timeZone = await _timeZonesRepository.getEntity(timeZoneCode);
    // Create a user record in the local database
    final userCompanion = AppUsersCompanion(
      id: Value(user.uid),
      username: Value(username.isEmpty ? user.displayName! : username),
      email: Value(user.email!),
      isEmailVerified: const Value(false),
      dailyResetTime: const Value(2),
      deviceId: Value(deviceId),
      timezoneId: Value(timeZone!.id),
      lastSyncedAt: Value(DateTime.utc(2024, 1, 1)),
    );
    await _appUsersRepository.addEntity(userCompanion);
  }

  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw LogOutFailure();
    }
  }

  Future<void> deleteUser({
    required final String password,
    required final AppLocalizations localized,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('User is not logged in');
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email ?? '',
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      await user.delete();
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Error reauthenticating user: $e');
      }
      throw ReauthenticateWithPasswordFailure.fromCode(
        e.code,
        localized,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw ReauthenticateWithPasswordFailure();
    }
  }
}

extension on User {
  MemoriUser get toUser => MemoriUser(
        id: uid,
        email: email,
        name: displayName,
        photo: photoURL,
      );
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrimeXAuthService {
  PrimeXAuthService._();

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final LocalAuthentication _localAuth = LocalAuthentication();

  static const String _biometricEnabledKey = 'primex_biometric_login_enabled';

  static User? get currentUser => _firebaseAuth.currentUser;

  static Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  static Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    if (normalizedEmail.isEmpty || password.isEmpty) {
      throw FirebaseAuthException(
        code: 'missing-fields',
        message: 'Enter your email and password.',
      );
    }

    return _firebaseAuth.signInWithEmailAndPassword(
      email: normalizedEmail,
      password: password,
    );
  }

  static Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    if (normalizedEmail.isEmpty || password.length < 6) {
      throw FirebaseAuthException(
        code: 'invalid-registration',
        message:
            'Enter a valid email and a password with at least 6 characters.',
      );
    }

    final result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: normalizedEmail,
      password: password,
    );

    await result.user?.sendEmailVerification();
    return result;
  }

  static Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      final provider = GoogleAuthProvider()
        ..setCustomParameters({
          'prompt': 'select_account',
        });

      return _firebaseAuth.signInWithPopup(provider);
    }

    final signIn = GoogleSignIn.instance;

    await signIn.initialize();

    if (!signIn.supportsAuthenticate()) {
      throw FirebaseAuthException(
        code: 'google-not-supported',
        message:
            'Google sign-in is not available on this device configuration.',
      );
    }

    final GoogleSignInAccount googleUser = await signIn.authenticate();

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final idToken = googleAuth.idToken;

    if (idToken == null || idToken.isEmpty) {
      throw FirebaseAuthException(
        code: 'google-token-missing',
        message: 'Google did not return a valid authentication token.',
      );
    }

    final credential = GoogleAuthProvider.credential(
      idToken: idToken,
    );

    return _firebaseAuth.signInWithCredential(credential);
  }

  static Future<bool> deviceSupportsBiometrics() async {
    if (kIsWeb) return false;

    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final supported = await _localAuth.isDeviceSupported();

      return canCheck || supported;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> hasEnrolledBiometrics() async {
    if (kIsWeb) return false;

    try {
      final biometrics = await _localAuth.getAvailableBiometrics();

      return biometrics.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> biometricLoginEnabled() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getBool(_biometricEnabledKey) ?? false;
  }

  static Future<void> setBiometricLoginEnabled(
    bool enabled,
  ) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool(
      _biometricEnabledKey,
      enabled,
    );
  }

  static Future<bool> verifyDeviceOwner({
    String reason = 'Authenticate to secure PrimeX Marketplace on this device.',
  }) async {
    if (kIsWeb) return false;

    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
        sensitiveTransaction: true,
      );
    } on LocalAuthException {
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> authenticateWithBiometrics() async {
    if (kIsWeb) return false;

    final enabled = await biometricLoginEnabled();

    if (!enabled) {
      return false;
    }

    if (_firebaseAuth.currentUser == null) {
      return false;
    }

    final supported = await deviceSupportsBiometrics();

    if (!supported) {
      return false;
    }

    return verifyDeviceOwner(
      reason:
          'Use Face ID, fingerprint, PIN, or device security to open PrimeX Marketplace.',
    );
  }

  static Future<void> sendPasswordReset(
    String email,
  ) async {
    final normalizedEmail = email.trim().toLowerCase();

    if (normalizedEmail.isEmpty) {
      throw FirebaseAuthException(
        code: 'missing-email',
        message: 'Enter your email address first.',
      );
    }

    await _firebaseAuth.sendPasswordResetEmail(
      email: normalizedEmail,
    );
  }

  static Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}

    await _firebaseAuth.signOut();
  }

  static String readableError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'The email address is not valid.';

        case 'user-not-found':
          return 'No PrimeX account was found for this email.';

        case 'wrong-password':
        case 'invalid-credential':
          return 'The email or password is incorrect.';

        case 'email-already-in-use':
          return 'An account already exists with this email.';

        case 'weak-password':
          return 'Use a stronger password with at least 6 characters.';

        case 'popup-closed-by-user':
          return 'Google sign-in was canceled.';

        case 'popup-blocked':
          return 'Your browser blocked the Google sign-in window.';

        case 'network-request-failed':
          return 'Check your internet connection and try again.';

        case 'google-not-supported':
          return error.message ??
              'Google sign-in is not supported on this device.';

        default:
          return error.message ?? 'Authentication failed.';
      }
    }

    if (error is LocalAuthException) {
      return 'Device authentication could not be completed.';
    }

    return error.toString().replaceFirst('Exception: ', '');
  }
}

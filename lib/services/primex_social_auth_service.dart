import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class PrimeXSocialAuthService {
  static Future<UserCredential> signInWithGoogle() async {
    final provider = GoogleAuthProvider();
    provider.addScope('email');
    provider.addScope('profile');
    return FirebaseAuth.instance.signInWithPopup(provider);
  }

  static Future<UserCredential> signInWithApple() async {
    final apple = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final credential = OAuthProvider('apple.com').credential(
      idToken: apple.identityToken,
      accessToken: apple.authorizationCode,
    );

    return FirebaseAuth.instance.signInWithCredential(credential);
  }
}

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialLoginHelper {
  static String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<UserCredential?> loginWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
      accessToken: appleCredential.authorizationCode, //<-- ADDED THIS LINE
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  static Future<UserCredential?> loginWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      GoogleSignInAuthentication? googleSignInAuthentication =
          await googleUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );
      if (googleUser == null) {
        // User canceled the sign-in process.
        return null;
      }
      debugPrint('User ID: ${googleUser.id}');
      debugPrint('Display Name: ${googleUser.displayName}');
      debugPrint('Email: ${googleUser.email}');
      debugPrint('ID Token: ${credential.token}');
      debugPrint('Access Token: ${credential.accessToken}');
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      debugPrint('Error during Google Sign-In: $e');
    }
    return null;
  }

  static Future<UserCredential?> loginWithFacebook() async {
//{
//     "email": "dsmr.apps@gmail.com",
//     "id": 3003332493073668,
//     "name": "Darwin",
//     "picture": {
//         "data": {
//             "height": 50,
//             "is_silhouette": 0,
//             "url": "https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=3003332493073668",
//             "width": 50
//         }
//     }
// }

    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        // You can now use the `accessToken` to sign in or register the user.
        // For example, send the user's access token to your server for validation.

        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(accessToken.tokenString);
        return await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
      } else {
        // Handle other status cases (e.g., error, canceled).
        debugPrint('Error during Facebook Sign-In: ${result.status}');
        return null;
      }
    } catch (e) {
      debugPrint('Error during Facebook Sign-In: $e');
      return null;
    }
  }
}

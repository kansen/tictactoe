import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  bool _isGoogleSignIn;

  GoogleSignInProvider() {
    _isGoogleSignIn = false;
  }

  bool get isGoogleSignIn => _isGoogleSignIn;

  set isGoogleSignIn(bool isGoogleSignIn) {
    _isGoogleSignIn = isGoogleSignIn;
    notifyListeners();
  }

  Future login() async {
    isGoogleSignIn = true;

    final user = await googleSignIn.signIn();

    if (user == null) {
      isGoogleSignIn = false;
    } else {
      final googleAUth = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAUth.accessToken,
        idToken: googleAUth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      isGoogleSignIn = false;

    }

  }

  void logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
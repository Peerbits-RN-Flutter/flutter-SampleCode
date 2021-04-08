/*
import 'dart:async';
import '../Utils/Utils.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class GoogleSignInUtils extends GetxController {
  GoogleSignInAccount _currentUser;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      _currentUser = account;
    });
    _googleSignIn.signInSilently();
  }

  GoogleSignInAccount get currentUser => _currentUser;

  Future<GoogleSignInAccount> handleSignIn() async {
    try {
      return await _googleSignIn.signIn();
    } catch (error) {
      handleApiError(error);
    }
    return null;
  }

  Future<void> handleSignOut() => _googleSignIn.disconnect();
}
*/

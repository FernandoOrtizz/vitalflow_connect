import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/fitness/v1.dart';
import 'package:flutter/material.dart';

abstract class GoogleAuthService {
  login();
  Future<void> refreshAccessToken();
}

class GoogleAuth with ChangeNotifier implements GoogleAuthService {
  String? _accessToken;
  String? get accessToken => _accessToken;

  String? _refreshToken;
  String? get refreshToken => _refreshToken;

  UserCredential? _currentUser;
  UserCredential? get currentUser => _currentUser;

  @override
  Future<void> login() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: <String>[
        FitnessApi.fitnessActivityReadScope,
        FitnessApi.fitnessBloodPressureReadScope,
        FitnessApi.fitnessHeartRateReadScope,
        FitnessApi.fitnessSleepReadScope,
        FitnessApi.fitnessOxygenSaturationReadScope
      ],
    );

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount == null) {
      throw Exception('Google Sign In failed');
    }

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    _accessToken = googleSignInAuthentication.accessToken;
    _refreshToken = googleSignInAuthentication.idToken;

    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: _accessToken, idToken: googleSignInAuthentication.idToken);

    _currentUser = await FirebaseAuth.instance.signInWithCredential(credential);

    return Future.value();
  }

  Future<void> refreshAccessToken() async {}
}

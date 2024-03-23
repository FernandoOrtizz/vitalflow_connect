import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis/fitness/v1.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;

abstract class GoogleAuthService {
  Future<void> signIn();
  Future<void> refreshAccessToken();
}

class GoogleAuth implements GoogleAuthService {
  String? _accessToken;
  String? get accessToken => _accessToken;

  String? _refreshToken;
  String? get refreshToken => _refreshToken;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      FitnessApi.fitnessActivityReadScope,
      FitnessApi.fitnessBloodPressureReadScope,
      FitnessApi.fitnessHeartRateReadScope,
      FitnessApi.fitnessSleepReadScope,
      FitnessApi.fitnessOxygenSaturationReadScope
    ],
  );

  Future<void> signIn() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    if (googleSignInAccount == null) {
      throw Exception('Google Sign In failed');
    }

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    _accessToken = googleSignInAuthentication.accessToken;
    _refreshToken = googleSignInAuthentication.idToken;
  }

  Future<void> refreshAccessToken() async {}
}

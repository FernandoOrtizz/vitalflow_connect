import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';

class HealthRepository {
  var db = FirebaseFirestore.instance;

  int startTime = convertToNanoseconds(DateTime(2024, 3, 22, 0, 0));
  int endTime = convertToNanoseconds(DateTime.now());

  Future<bool> obtainCredentials() async {
    var googleSignin = await GoogleSignIn(scopes: [
      'https://www.googleapis.com/auth/fitness.heart_rate.read',
      'https://www.googleapis.com/auth/fitness.activity.read',
      'https://www.googleapis.com/auth/fitness.blood_pressure.read',
      'https://www.googleapis.com/auth/fitness.sleep.read',
      'https://www.googleapis.com/auth/fitness.oxygen_saturation.read',
    ]);

    await googleSignin.signIn();

    final auth.AuthClient? client = await googleSignin.authenticatedClient();

    assert(client != null, 'Authenticated client missing!');

    //Obtener signos vitales
    await getSteps(client);
    await getHeartRate(client);
    await getRestingHeartRate(client);
    await getCaloriesExpended(client);
    // getOxygenSaturation(client);
    // getSleep(client);

    return true;
  }

  Future<void> getSteps(auth.AuthClient? client) async {
    int startTime = convertToNanoseconds(DateTime(2024, 3, 22, 0, 0));
    int endTime = convertToNanoseconds(DateTime.now());

    // URL del endpoint
    String url =
        'https://www.googleapis.com/fitness/v1/users/me/dataSources/derived:com.google.step_count.delta:com.google.android.gms:estimated_steps/datasets/$startTime-$endTime';
    var token = client?.credentials.accessToken.data.toString();

    // Encabezados de la solicitud
    Map<String, String> headers = {'Authorization': "Bearer $token"};

    // Realiza la solicitud GET
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      print('Excepción durante la solicitud: $e');
    }
  }

  Future<void> getHeartRate(auth.AuthClient? client) async {
    int startTime = convertToNanoseconds(DateTime(2024, 3, 22, 0, 0));
    int endTime = convertToNanoseconds(DateTime.now());

    // URL del endpoint
    String url =
        "https://www.googleapis.com/fitness/v1/users/me/dataSources/derived:com.google.heart_rate.bpm:com.google.android.gms:merge_heart_rate_bpm/datasets/$startTime-$endTime";
    var token = client?.credentials.accessToken.data.toString();

    // Encabezados de la solicitud
    Map<String, String> headers = {'Authorization': "Bearer $token"};

    // Realiza la solicitud GET
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseToMap = jsonDecode(response.body);

        Map<String, dynamic> mapSerialized = extractLastPoint(responseToMap);

        postHeartRate(mapSerialized);
      } else {}
    } catch (e) {
      print('Excepción durante la solicitud: $e');
    }
  }

  Future<void> getRestingHeartRate(auth.AuthClient? client) async {
    int startTime = convertToNanoseconds(DateTime(2024, 3, 22, 0, 0));
    int endTime = convertToNanoseconds(DateTime.now());

    // URL del endpoint
    String url =
        'https://www.googleapis.com/fitness/v1/users/me/dataSources/derived:com.google.heart_rate.bpm:com.google.android.gms:resting_heart_rate<-merge_heart_rate_bpm/datasets/$startTime-$endTime';
    var token = client?.credentials.accessToken.data.toString();

    // Encabezados de la solicitud
    Map<String, String> headers = {'Authorization': "Bearer $token"};

    // Realiza la solicitud GET
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      print('Excepción durante la solicitud: $e');
    }
  }

  Future<void> getCaloriesExpended(auth.AuthClient? client) async {
    int startTime = convertToNanoseconds(DateTime(2024, 3, 22, 0, 0));
    int endTime = convertToNanoseconds(DateTime.now());
    // URL del endpoint
    String url =
        'https://www.googleapis.com/fitness/v1/users/me/dataSources/derived:com.google.calories.expended:com.google.android.gms:merge_calories_expended/datasets/$startTime-$endTime';
    var token = client?.credentials.accessToken.data.toString();

    // Encabezados de la solicitud
    Map<String, String> headers = {'Authorization': "Bearer $token"};

    // Realiza la solicitud GET
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      print('Excepción durante la solicitud: $e');
    }
  }

  Future<void> getOxygenSaturation(auth.AuthClient? client) async {
    int startTime = convertToNanoseconds(DateTime(2024, 3, 22, 0, 0));
    int endTime = convertToNanoseconds(DateTime.now());
    // URL del endpoint
    String url = 'PENDIENTE';
    var token = client?.credentials.accessToken.data.toString();

    // Encabezados de la solicitud
    Map<String, String> headers = {'Authorization': "Bearer $token"};

    // Realiza la solicitud GET
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      print('Excepción durante la solicitud: $e');
    }
  }

  Future<void> getSleep(auth.AuthClient? client) async {
    int startTime = convertToNanoseconds(DateTime(2024, 3, 22, 0, 0));
    int endTime = convertToNanoseconds(DateTime.now());
    // URL del endpoint
    String url = 'PENDIENTE';
    var token = client?.credentials.accessToken.data.toString();

    // Encabezados de la solicitud
    Map<String, String> headers = {'Authorization': "Bearer $token"};

    // Realiza la solicitud GET
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        print(response.body);
      } else {}
    } catch (e) {
      print('Excepción durante la solicitud: $e');
    }
  }

  Future<void> postHeartRate(Map<String, dynamic> heartRateData) async {
    await db.collection("bpm").add(heartRateData);
  }

  Future<void> addUser() async {
    await db.collection("users").add({
      "authType": 'mail',
      'hash': '',
      'id_monitored_individuals': [],
      'mail': 'hernanReyesMed@gmail.com',
      'nickName': 'Storm'
    });
  }
}

Map<String, dynamic> extractLastPoint(Map<String, dynamic> responseSerialized) {
  List<dynamic> point = responseSerialized['point'];
  Map<String, dynamic> lastPoint = point.last;

  var date = decodeMiliseconds(int.parse(lastPoint['modifiedTimeMillis']));

  Map<String, dynamic> extractedData = {
    'value': lastPoint['value'][0]['fpVal'],
    'modifiedTimeMillis': lastPoint['modifiedTimeMillis'],
    'date': date,
    'user_id': ''
  };

  return extractedData;
}

int convertToNanoseconds(DateTime fecha) {
  int result = fecha.microsecondsSinceEpoch * 1000;
  return result;
}

DateTime decodeMiliseconds(int miliseconds) {
  return DateTime.fromMillisecondsSinceEpoch(miliseconds);
}

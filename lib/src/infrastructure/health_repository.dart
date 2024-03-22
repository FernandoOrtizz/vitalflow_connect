import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;
import 'package:http/http.dart' as http;

class HealthRepository {
  Future<bool> obtainCredentials() async {
    var googleSignin = await GoogleSignIn(scopes: [
      'https://www.googleapis.com/auth/fitness.heart_rate.read',
      'https://www.googleapis.com/auth/fitness.activity.read',
      'https://www.googleapis.com/auth/fitness.blood_glucose.read',
      'https://www.googleapis.com/auth/fitness.blood_pressure.read',
      'https://www.googleapis.com/auth/fitness.sleep.read',
      'https://www.googleapis.com/auth/fitness.oxygen_saturation.read'
    ]);

    await googleSignin.signIn();

    final auth.AuthClient? client = await googleSignin.authenticatedClient();

    assert(client != null, 'Authenticated client missing!');

    //Obtener signos vitales
    getSteps(client);

    return true;
  }

  void getSteps(auth.AuthClient? client) async {
    // URL del endpoint
    String url =
        'https://www.googleapis.com/fitness/v1/users/me/dataSources/derived:com.google.step_count.delta:com.google.android.gms:estimated_steps/datasets/1711087200000000000-1711125228448289164';
    var token = client?.credentials.accessToken.data.toString();

    // Encabezados de la solicitud
    Map<String, String> headers = {'Authorization': "Bearer $token"};

    // Realiza la solicitud GET
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        print('Respuesta exitosa:');
        print(response.body);
      } else {
        print('Error: ${response.statusCode}');
        print('Mensaje de error: ${response.body}');
      }
    } catch (e) {
      print('Excepción durante la solicitud: $e');
    }
  }

  // final health = HealthFactory();

  // Future<bool> getHeartRate() async {

  //   bool requested =
  //       await health.requestAuthorization([HealthDataType.HEART_RATE]);

  //   if (requested) {
  //     List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
  //         DateTime.now().subtract(Duration(days: 7)),
  //         DateTime.now(),
  //         [HealthDataType.HEART_RATE]);

  //     return false;
  //   }
  // }
}

/*
// create a HealthFactory for use in the app, choose if HealthConnect should be used or not
    final health = HealthFactory(useHealthConnectIfAvailable: true);

    // define the types to get
    var types = [
      // HealthDataType.STEPS,
      // HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.HEART_RATE,
    ];

    // requesting access to the data types before reading them
    bool requested = await health.requestAuthorization(types);

    var now = DateTime.now();

    // fetch health data from the last 24 hours
    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        now.subtract(Duration(days: 1)), now, types);

    // request permissions to write steps and blood glucose
    types = [HealthDataType.STEPS, HealthDataType.BLOOD_GLUCOSE];
    var permissions = [
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE
    ];
    await health.requestAuthorization(types, permissions: permissions);

    // write steps and blood glucose
    bool success =
        await health.writeHealthData(10, HealthDataType.STEPS, now, now);
    success = await health.writeHealthData(
        3.1, HealthDataType.BLOOD_GLUCOSE, now, now);

    // get the number of steps for today
    var midnight = DateTime(now.year, now.month, now.day);
    int? steps = await health.getTotalStepsInInterval(midnight, now);
    print('========================');
    print(healthData);

 */
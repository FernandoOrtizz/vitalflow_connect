import 'package:googleapis/fitness/v1.dart';
import 'package:googleapis_auth/auth_browser.dart';
import 'package:health/health.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vitalflow_connect/src/models/blood_glucose.dart';
import 'package:vitalflow_connect/src/models/heart_rate.dart';
import 'package:vitalflow_connect/src/models/steps.dart';
import 'package:googleapis_auth/auth_io.dart';

class HealthRepository {
  final health = HealthFactory(useHealthConnectIfAvailable: true);
  var now = DateTime.now();

  DateTime startDate = DateTime(2024, 3, 22, 0, 0, 0);

  Future<bool> requesHealthPermissions() async {
    var types = [
      HealthDataType.STEPS,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.HEART_RATE,
    ];

    bool permissionsRequested = await health.requestAuthorization(types);

    return permissionsRequested;
  }

  Future<bool> getBloodGlucose() async {
    // final fitnessApi = FitnessApi(await obtainCredentials());

    // // Realizar la llamada a la API de Google Fit para obtener los datos
    // final response = await fitnessApi.users.dataSources.datasets.get(
    //   'me', // Identificador del usuario
    //   'derived:com.google.step_count.delta:com.google.android.gms:estimated_steps/datasets/1711087200000000000-1711125228448289164', // ID de la fuente de datos de Google Fit
    //   '1711087200000000000-1711125228448289164', // ID del conjunto de datos de Google Fit
    // );

    // final data = response.toJson();
    // print('+++++++++++++++++++++++++++');
    // print(data);

    return true;

    // List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
    //     DateTime.now().subtract(const Duration(days: 7)),
    //     now,
    //     [HealthDataType.BLOOD_GLUCOSE]);

    // return healthData.map((e) {
    //   print(e.value.toJson()['numericValue'] + "-----");
    //   return BloodGlucose(e.dateFrom, e.dateTo, e.unit.toString(),
    //       double.parse(e.value.toJson()['numericValue']));
    // }).toList();
  }

  Future<Client> obtainCredentials() async {
    final client = Client();

    try {
      await obtainAccessCredentialsViaUserConsent(
        ClientId('110224010699229439082'),
        ['https://www.googleapis.com/auth/fitness.heart_rate.read'],
        client,
        _prompt,
      );

      return client;
    } finally {
      client.close();
    }
  }

  void _prompt(String url) {
    print('Please go to the following URL and grant access:');
    print('  => $url');
    print('');
  }

  Future<List> getSteps() async {
    //solicitando permisos para reconocimiento de actividad
    var status = await Permission.activityRecognition.request();
    if (!status.isGranted) {
      print('El usuario denegó el permiso ACTIVITY_RECOGNITION.');
      return [];
    }

    // request permissions to write steps and blood glucose
    // var types = [HealthDataType.STEPS];
    // var permissions = [HealthDataAccess.READ_WRITE];
    // await health.requestAuthorization(types, permissions: permissions);
    // bool success =
    //     await health.writeHealthData(77, HealthDataType.STEPS, now, now);

    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        startDate, DateTime.now(), [HealthDataType.STEPS]);

    var midnight = DateTime(now.year, now.month, now.day);
    int? steps = await health.getTotalStepsInInterval(midnight, now);

    print('===========================');
    print(steps);

    return healthData.map((e) {
      print(e);
      print('=-=-=-=-=-=-');
      return Steps(e.dateFrom, e.dateTo, e.unit.toString(),
          double.parse(e.value.toJson()['numericValue']));
    }).toList();
  }

  Future<List<HeartRate>> getHeartRate() async {
    print('Start heartrate func');

    // bool success = await health.writeHealthData(
    //     99.00, HealthDataType.HEART_RATE, now, now);

    // bool requested =
    //     await health.requestAuthorization([HealthDataType.HEART_RATE]);

    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        startDate, DateTime.now(), [HealthDataType.HEART_RATE]);
    print('LISTA BPM');

    print(healthData);

    return healthData.map((e) {
      print('VALOR BPM');
      print(e);
      print(e.value.toJson()['numericValue'] + "----- HeartRATE");
      return HeartRate(e.dateFrom, e.dateTo, e.unit.toString(),
          double.parse(e.value.toJson()['numericValue']));
    }).toList();
  }

  // void requestActivityRecognitionPermission(BuildContext context) async {
  //   var status = await Permission.activityRecognition.status;
  //   if (status.isGranted) {
  //     print('El permiso ACTIVITY_RECOGNITION ya está concedido.');
  //     return;
  //   }

  //   // Si el permiso no está concedido, solicitarlo al usuario
  //   status = await Permission.activityRecognition.request();
  //   if (status.isGranted) {
  //     print('El usuario concedió el permiso ACTIVITY_RECOGNITION.');
  //   } else {
  //     // ignore: use_build_context_synchronously
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) => AlertDialog(
  //         title: Text('Permiso necesario'),
  //         content: Text(
  //             'Para acceder a esta función, necesitamos el permiso de reconocimiento de actividad.'),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text('Cancelar'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               // Abrir la configuración de la aplicación para que el usuario pueda conceder el permiso manualmente
  //               openAppSettings();
  //             },
  //             child: Text('Configuración'),
  //           ),
  //         ],
  //       ),
  //     );
  //     print('El usuario denegó el permiso ACTIVITY_RECOGNITION.');
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
import 'package:flutter/material.dart';
import 'package:vitalflow_connect/src/infrastructure/health_repository.dart';

class HomeController {
  final bloodGlucose = ValueNotifier<String>('');
  final steps = ValueNotifier<String>('');
  final heartRate = ValueNotifier<String>('');
  final repository = HealthRepository();

  Future<void> getData() async {
    // final heartRateData = await repository.getHeartRate();

    final bloodGlucoseData = await repository.obtainCredentials();
    // final stepsData = await repository.getSteps();
    // repository.requestActivityRecognitionPermission();
    // final stepsData = await repository.getSteps();

    // final lastBloodGlucose =
    //     bloodGlucoseData.isNotEmpty ? bloodGlucoseData.last : null;
    // print('=================================');
    // print(lastBloodGlucose);
    // bloodGlucose.value = '';

    // create a HealthFactory for use in the app, choose if HealthConnect should be used or not
    // HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

    // // define the types to get
    // var types = [
    //   HealthDataType.HEART_RATE,
    //   // HealthDataType.SLEEP_SESSION,
    //   // HealthDataType.BLOOD_OXYGEN,
    //   // HealthDataType.STEPS,
    //   // HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    //   HealthDataType.BLOOD_GLUCOSE,
    // ];

    // // requesting access to the data types before reading them
    // bool requested = await health.requestAuthorization(types);

    // var now = DateTime.now();

    // // fetch health data from the last 24 hours
    // List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
    //     now.subtract(Duration(days: 1)), now, types);

    // // request permissions to write steps and blood glucose
    // types = [HealthDataType.STEPS, HealthDataType.BLOOD_GLUCOSE];
    // var permissions = [
    //   HealthDataAccess.READ_WRITE,
    //   HealthDataAccess.READ_WRITE
    // ];
    // await health.requestAuthorization(types, permissions: permissions);

    // // write steps and blood glucose
    // bool success = await health.writeHealthData(
    //     3.5, HealthDataType.BLOOD_GLUCOSE, now, now);

    // // get the number of steps for today
    // var midnight = DateTime(now.year, now.month, now.day);
    // int? steps = await health.getTotalStepsInInterval(midnight, now);

    // print('----------------------------------================================');
    // print(healthData);
  }
}

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:vitalflow_connect/src/application/runner/ports.dart';
import 'package:vitalflow_connect/src/application/runner/usecase.dart';
import 'package:vitalflow_connect/src/application/sync/usecase.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/monitoring_permission.dart';
import 'package:vitalflow_connect/src/infrastructure/fitness_api/activity.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/activity.dart'
    as activityDestination;
import 'package:vitalflow_connect/src/infrastructure/firestore/heart_rate.dart'
    as heartRateDestination;
import 'package:vitalflow_connect/src/infrastructure/firestore/resting_heart_rate.dart'
    as restingHeartRateDestination;
import 'package:vitalflow_connect/src/infrastructure/firestore/calories_expended.dart'
    as caloriesExpendedDestination;
import 'package:vitalflow_connect/src/infrastructure/fitness_api/calories_expanded.dart';
import 'package:vitalflow_connect/src/infrastructure/fitness_api/heart_rate.dart';
import 'package:vitalflow_connect/src/infrastructure/fitness_api/request.dart';
import 'package:vitalflow_connect/src/infrastructure/fitness_api/resting_heart_rate.dart';
import 'package:vitalflow_connect/src/infrastructure/google_signin/signin.dart';

class HomeController {
  GoogleAuth googleAuthService;
  String email;

  HomeController({required this.googleAuthService, required this.email});

  Future<void> getData() async {
    Timer.periodic(const Duration(seconds: 60), (timer) {
      var request = Request(authService: googleAuthService);

      List<Sync> syncList = [];

      var activitySource = Activity(request: request);
      var activityDest = activityDestination.Activity();
      var activitySync = SyncUseCase(activitySource, activityDest, email);

      var heartRateSource = HeartRate(request: request);
      var heartRateDest = heartRateDestination.HeartRate();
      var heartRateSync = SyncUseCase(heartRateSource, heartRateDest, email);

      var restingHeartRateSource = RestingHeartRate(request: request);
      var restingHeartRateDest = restingHeartRateDestination.RestingHeartRate();
      var restingHeartRateSync =
          SyncUseCase(restingHeartRateSource, restingHeartRateDest, email);

      var caloriesExpendedRateSource = CaloriesExpended(request: request);
      var caloriesExpendedRateDest =
          caloriesExpendedDestination.CaloriesExpended();
      var caloriesExpendedSync = SyncUseCase(
          caloriesExpendedRateSource, caloriesExpendedRateDest, email);

      syncList.add(activitySync);
      syncList.add(heartRateSync);
      syncList.add(restingHeartRateSync);
      syncList.add(caloriesExpendedSync);

      var runner = Runner(syncList);

      // var getSteps = activityDest.get();

      print('STEPS: +++++');
      // print(getSteps);
      // TODO: HACER QUE CORRA EN SEGUNDO PLANO
      runner.execute();
    });
    return Future.value();
  }
}

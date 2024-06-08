import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:vitalflow_connect/src/application/report/ports.dart';
import 'package:vitalflow_connect/src/application/report/usecase.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/activity.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/calories_expended.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/heart_rate.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/resting_heart_rate.dart';
import 'package:vitalflow_connect/src/ui/pages/history/history_page.dart';

class InfoByDayProvider with ChangeNotifier {
  List<VitalFlowRepository> repositories = <VitalFlowRepository>[
    Activity(),
    CaloriesExpended(),
    HeartRate(),
    RestingHeartRate(),
  ];

  // reporte(repositories);
  // Map<String, Map<String, double>> dailyData = getDailyInfo();
}

void reporte(List<VitalFlowRepository> repositories) async {
  Report report = Report(repositories);
  DateTime startDate = DateTime.now().add(Duration(days: -7));
  DateTime endDate = DateTime.now();

  await report.getDailyAverageData(
      FirebaseAuth.instance.currentUser?.email ?? '', startDate, endDate);
}

import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vitalflow_connect/src/application/report/ports.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/activity.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/calories_expended.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/heart_rate.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/resting_heart_rate.dart';
import 'package:vitalflow_connect/src/ui/pages/history/history_stats_page.dart';
import 'package:vitalflow_connect/src/ui/pages/home/home_page.dart';
import 'package:vitalflow_connect/src/ui/widgets/custom_appbar.dart';
import 'package:vitalflow_connect/src/ui/widgets/history_card_widget.dart';

import '../../../application/report/usecase.dart';
import '../../widgets/bottom_menu.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _selectedScale = 'Días';
  Report report = Report([]);

  String email = FirebaseAuth.instance.currentUser?.email ?? '';
  DateTime start = DateTime.now().add(Duration(days: -300));
  DateTime end = DateTime.now();

  List<Widget> widgetList = [];

  @override
  void initState() {
    super.initState();
    // initialCards();
    initData();
  }

  void initialCards() async {
    var dailyInfo = await getDailyInfo();

    dailyInfo.forEach((key, value) {
      widgetList.add(GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HistoryStatsPage(),
              ));
        },
        child: const HistoryCardWidget(
          title: 'Jueves',
          bpmValue: '116',
          sleepValue: '7.7',
          oxValue: '95',
          stepsValue: '1094',
          restBpmValue: '46',
          calories: '120/80',
        ),
      ));
    });
  }

  void initData() async {
    List<VitalFlowRepository> repositories = <VitalFlowRepository>[
      // Activity(),
      // CaloriesExpended(),
      HeartRate(),
      // RestingHeartRate()
    ];

    report = Report(repositories);

    print('daily average data');
    // print(await report.getDailyAverageData(email, start, end));
    print(await report.getMonthlyAverageData(email));

    // print('weekly average data');
    // print(report.getWeeklyAverageData(email, start, end));

    // print('monthly average data');
    // print(report.getMonthlyAverageData(email));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context: context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
                      value: _selectedScale,
                      onChanged: (newValue) async {
                        List<Widget> widgetListTemp = [];
                        Map<String, Map<String, double>> filterInfo = {};

                        switch (newValue) {
                          case 'Días':
                            filterInfo = await getDailyInfo();
                            filterInfo.forEach((key, value) {
                              widgetListTemp.add(GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const HistoryStatsPage(),
                                      ));
                                },
                                child: HistoryCardWidget(
                                  title: key,
                                  bpmValue: value['heart_rate'] != null
                                      ? value['heart_rate']!.toStringAsFixed(2)
                                      : '0',
                                  sleepValue: '7.7',
                                  oxValue: '95',
                                  stepsValue: value['activity'] != null
                                      ? value['activity']!.toStringAsFixed(2)
                                      : '0',
                                  restBpmValue: value['resting_bpm'] != null
                                      ? value['resting_bpm']!.toStringAsFixed(2)
                                      : '0',
                                  calories: value['calories_expended'] != null
                                      ? value['calories_expended']!
                                          .toStringAsFixed(2)
                                      : '0',
                                ),
                              ));
                            });
                          case 'Semanas':
                            filterInfo = await getWeeklyInfo();
                            filterInfo.forEach((key, value) {
                              widgetListTemp.add(GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const HistoryStatsPage(),
                                      ));
                                },
                                child: HistoryCardWidget(
                                  title: key,
                                  bpmValue: value['heart_rate'] != null
                                      ? value['heart_rate']!.toStringAsFixed(2)
                                      : '0',
                                  sleepValue: '7.7',
                                  oxValue: '95',
                                  stepsValue: value['activity'] != null
                                      ? value['activity']!.toStringAsFixed(2)
                                      : '0',
                                  restBpmValue: value['resting_bpm'] != null
                                      ? value['resting_bpm']!.toStringAsFixed(2)
                                      : '0',
                                  calories: value['calories_expended'] != null
                                      ? value['calories_expended']!
                                          .toStringAsFixed(2)
                                      : '0',
                                ),
                              ));
                            });
                          // getWeeklyInfo();
                        }
                        // getDailyInfo();

                        setState(() {
                          widgetList = [];

                          widgetList = widgetListTemp;
                          _selectedScale = newValue!;
                        });
                      },
                      items: <String>['Días', 'Semanas', 'Meses']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...widgetList
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomMenu(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          }
        },
      ),
    );
  }

  Future<Map<String, Map<String, double>>> getDailyInfo() async {
    Map<String, Map<String, double>> weekDayInfo = {};
    Map<String, Map<String, double>> dailyData =
        await report.getDailyAverageData(email, start, end);

    for (var i = 0; i < 7; i++) {
      var date = DateTime.now().add(Duration(days: -i));
      var dayName = translateDay[DateFormat('EEEE').format(date)]!;
      weekDayInfo[dayName] = {};

      dailyData.forEach((key, value) {
        weekDayInfo[dayName]?.addAll({key: value[dayName] ?? 0});
      });
    }

    return weekDayInfo;
  }

  Future<Map<String, Map<String, double>>> getWeeklyInfo() async {
    //
    Map<String, Map<String, double>> weekDataResult = {};
    Map<String, Map<String, double>> weeklyData =
        await report.getWeeklyAverageData(email, start, end);

    weeklyData.forEach((vitalFlow, value) {
      value.forEach((dateRange, vitalValue) {
        weekDataResult[dateRange] = {};
      });
      value.forEach((dateRange, vitalValue) {
        weekDataResult[dateRange]?.addAll({vitalFlow: vitalValue});
      });
    });

    print('Week');
    print(weekDataResult);
    return weekDataResult;
  }

  // Future<Map<String, Map<String, double>>> getMonthlyInfo() async {

  // }
}

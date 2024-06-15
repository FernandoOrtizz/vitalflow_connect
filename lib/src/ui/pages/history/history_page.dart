import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vitalflow_connect/src/application/report/ports.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/activity.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/calories_expended.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/heart_rate.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/resting_heart_rate.dart';
import 'package:vitalflow_connect/src/provider/user.dart';
import 'package:vitalflow_connect/src/ui/pages/history/history_stats_page.dart';
import 'package:vitalflow_connect/src/ui/pages/history/history_stats_page_monthly.dart';
import 'package:vitalflow_connect/src/ui/pages/history/history_stats_page_weekly.dart';
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
  Activity act = Activity();

  String _selectedScale = 'Días';
  Report report = Report([]);

  String email = FirebaseAuth.instance.currentUser?.email ?? '';
  DateTime start = DateTime(2024, 5, 31);
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
                builder: (context) => HistoryStatsPage(
                  title: key,
                  data: {},
                ),
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
      Activity(),
      CaloriesExpended(),
      HeartRate(),
      RestingHeartRate(),
    ];

    report = Report(repositories);
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

                            int index = 0;
                            filterInfo.forEach((key, value) {
                              DateTime date =
                                  DateTime.now().add(Duration(days: -index));
                              var startDate = DateTime(
                                  date.year, date.month, date.day, 0, 1, 0);
                              var endDate = DateTime(
                                  date.year, date.month, date.day, 23, 59, 59);

                              widgetListTemp.add(GestureDetector(
                                onTap: () async {
                                  Map<String, List<double>> data =
                                      await report.getDailyDataGroupedByHour(
                                          Provider.of<CurrentUser>(context,
                                                  listen: false)
                                              .email,
                                          startDate,
                                          endDate);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HistoryStatsPage(
                                          title: key,
                                          data: data,
                                        ),
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
                              index += 1;
                            });
                          case 'Semanas':
                            filterInfo = await getWeeklyInfo();
                            int index = 0;

                            filterInfo.forEach((key, value) {
                              DateTime date = DateTime.now()
                                  .add(Duration(days: -index * 8));
                              var endDate = DateTime(
                                  date.year, date.month, date.day, 23, 59, 59);
                              var startDate = DateTime(endDate.year,
                                      endDate.month, endDate.day, 0, 1, 0)
                                  .add(const Duration(days: -7));

                              widgetListTemp.add(GestureDetector(
                                onTap: () async {
                                  Map<String, Map<String, double>> data =
                                      await report.getWeeklyDataGroupedByDay(
                                          Provider.of<CurrentUser>(context,
                                                  listen: false)
                                              .email,
                                          startDate,
                                          endDate);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            HistoryStatsPageWeekly(
                                          title: key,
                                          data: data,
                                        ),
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
                              index += 1;
                            });
                          case 'Meses':
                            filterInfo = await getMonthlyInfo();
                            int index = 0;

                            filterInfo.forEach((key, value) {
                              DateTime date = DateTime.now()
                                  .add(Duration(days: -index * 30));
                              DateTime endDayOfMonth =
                                  DateTime(date.year, date.month + 1, 0);

                              var endDate = DateTime(
                                  endDayOfMonth.year,
                                  endDayOfMonth.month,
                                  endDayOfMonth.day,
                                  23,
                                  59,
                                  59);
                              var startDate = DateTime(
                                  endDate.year, endDate.month, 1, 0, 1, 0);

                              if (endDate.isAfter(DateTime.now())) {
                                endDate = DateTime.now();
                              }

                              widgetListTemp.add(GestureDetector(
                                onTap: () async {
                                  Map<String, Map<String, double>> data =
                                      await report.getMonthlyDataGroupedByWeek(
                                          Provider.of<CurrentUser>(context,
                                                  listen: false)
                                              .email,
                                          startDate,
                                          endDate);

                                  print('key: $key');
                                  print('start: $startDate, end: $endDate');
                                  print(data);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            HistoryStatsPageMonthly(
                                          title: key,
                                          data: data,
                                        ),
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
                              index += 1;
                            });
                        }

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
    Map<String, Map<String, double>> weekDataResult = {};
    Map<String, Map<String, double>> weeklyData =
        await report.getWeeklyAverageData(email, start, end);

    weeklyData.forEach((vitalFlow, value) {
      value.forEach((dateRange, vitalValue) {
        var current = weekDataResult[dateRange];
        if (current == null) {
          weekDataResult[dateRange] = {};
        }
        weekDataResult[dateRange]?.addAll({vitalFlow: vitalValue});
      });
    });

    return weekDataResult;
  }

  Future<Map<String, Map<String, double>>> getMonthlyInfo() async {
    Map<String, Map<String, double>> monthDataResult = {};

    DateTime now = DateTime.now();
    Map<String, Map<String, double>> monthlyData =
        await report.getMonthlyAverageData(
            email, DateTime(now.year - 1, now.month, now.day), now);

    monthlyData.forEach((vitalFlow, value) {
      value.forEach((dateRange, vitalValue) {
        var current = monthDataResult[dateRange];
        if (current == null) {
          monthDataResult[dateRange] = {};
        }

        monthDataResult[dateRange]?.addAll({vitalFlow: vitalValue});
      });
    });

    return monthDataResult;
  }
}

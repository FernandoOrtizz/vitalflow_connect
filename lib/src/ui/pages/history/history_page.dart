import 'package:flutter/foundation.dart';
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

  DateTime start = DateTime(2024, 5, 31);
  DateTime end = DateTime.now();
  List<Widget> widgetList = [];

  Future<Map<String, Map<String, double>>>? _myData;
  String _email = '';

  @override
  void initState() {
    List<VitalFlowRepository> repositories = <VitalFlowRepository>[
      Activity(),
      CaloriesExpended(),
      HeartRate(),
      RestingHeartRate(),
    ];

    report = Report(repositories);

    _email = context.read<CurrentUser>().email;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _email = context.watch<CurrentUser>().email;
    _myData = getDailyInfo(_email);

    switch (_selectedScale) {
      case 'Días':
        _myData = getDailyInfo(_email);
        break;
      case 'Semanas':
        _myData = getWeeklyInfo(_email);
        break;
      case 'Meses':
        _myData = getMonthlyInfo(_email);
        break;
    }

    return FutureBuilder(future: _myData, builder: _buildFuture);
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.hasData) {
      widgetList = [];

      switch (_selectedScale) {
        case 'Días':
          int index = 0;
          snapshot.data.forEach((key, value) {
            DateTime date = DateTime.now().add(Duration(days: -index));
            var startDate = DateTime(date.year, date.month, date.day, 0, 1, 0);
            var endDate = DateTime(date.year, date.month, date.day, 23, 59, 59);

            widgetList.add(GestureDetector(
              onTap: () async {
                Map<String, List<double>> data = await report
                    .getDailyDataGroupedByHour(_email, startDate, endDate);

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
                sleepValue: '0',
                oxValue: '0',
                stepsValue: value['activity'] != null
                    ? value['activity']!.toStringAsFixed(2)
                    : '0',
                restBpmValue: value['resting_bpm'] != null
                    ? value['resting_bpm']!.toStringAsFixed(2)
                    : '0',
                calories: value['calories_expended'] != null
                    ? value['calories_expended']!.toStringAsFixed(2)
                    : '0',
              ),
            ));
            index += 1;
          });
        case 'Semanas':
          int index = 0;

          snapshot.data.forEach((key, value) {
            DateTime date = getSundayOfCurrentWeek();
            var endDate = DateTime(date.year, date.month, date.day, 23, 59, 59);
            var startDate =
                DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 1)
                    .add(const Duration(days: -6));

            widgetList.add(GestureDetector(
              onTap: () async {
                Map<String, Map<String, double>> data = await report
                    .getWeeklyDataGroupedByDay(_email, startDate, endDate);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryStatsPageWeekly(
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
                sleepValue: '0',
                oxValue: '0',
                stepsValue: value['activity'] != null
                    ? value['activity']!.toStringAsFixed(2)
                    : '0',
                restBpmValue: value['resting_bpm'] != null
                    ? value['resting_bpm']!.toStringAsFixed(2)
                    : '0',
                calories: value['calories_expended'] != null
                    ? value['calories_expended']!.toStringAsFixed(2)
                    : '0',
              ),
            ));
            index += 1;
          });
        case 'Meses':
          int index = 0;

          snapshot.data.forEach((key, value) {
            DateTime date = DateTime.now().add(Duration(days: -index * 30));
            DateTime endDayOfMonth = DateTime(date.year, date.month + 1, 0);

            var endDate = DateTime(endDayOfMonth.year, endDayOfMonth.month,
                endDayOfMonth.day, 23, 59, 59);
            var startDate = DateTime(endDate.year, endDate.month, 1, 0, 1, 0);

            if (endDate.isAfter(DateTime.now())) {
              endDate = DateTime.now();
            }

            widgetList.add(GestureDetector(
              onTap: () async {
                Map<String, Map<String, double>> data = await report
                    .getMonthlyDataGroupedByWeek(_email, startDate, endDate);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryStatsPageMonthly(
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
                sleepValue: '0',
                oxValue: '0',
                stepsValue: value['activity'] != null
                    ? value['activity']!.toStringAsFixed(2)
                    : '0',
                restBpmValue: value['resting_bpm'] != null
                    ? value['resting_bpm']!.toStringAsFixed(2)
                    : '0',
                calories: value['calories_expended'] != null
                    ? value['calories_expended']!.toStringAsFixed(2)
                    : '0',
              ),
            ));
            index += 1;
          });
      }

      if (widgetList.isEmpty) {
        widgetList.add(
          const Center(
            child: Text('No hay datos disponibles'),
          ),
        );
      }
    }

    return Scaffold(
      appBar: CustomAppBar(
          usersToMonitor: context.watch<CurrentUser>().allowedUsersToMonitor,
          context: context),
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
                        setState(() {
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

  Future<Map<String, Map<String, double>>> getDailyInfo(String email) async {
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

  Future<Map<String, Map<String, double>>> getWeeklyInfo(String email) async {
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

  Future<Map<String, Map<String, double>>> getMonthlyInfo(String email) async {
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

DateTime getSundayOfCurrentWeek() {
  DateTime now = DateTime.now();
  int currentDayOfWeek = now.weekday;
  int differenceToSunday = DateTime.sunday - currentDayOfWeek;
  DateTime nextSunday = now.add(Duration(days: differenceToSunday));
  return DateTime.utc(nextSunday.year, nextSunday.month, nextSunday.day);
}

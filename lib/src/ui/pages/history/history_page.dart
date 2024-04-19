import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vitalflow_connect/src/application/report/ports.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/activity.dart';
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

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() {
    List<VitalFlowRepository> repositories = <VitalFlowRepository>[
      Activity(),
    ];

    Report report = Report(repositories);

    String email = FirebaseAuth.instance.currentUser?.email ?? '';
    DateTime start = DateTime.now().add(Duration(days: -7));
    DateTime end = DateTime.now();

    print('daily average data');
    print(report.getDailyAverageData(email, start, end));

    print('weekly average data');
    print(report.getWeeklyAverageData(email, start, end));

    print('monthly average data');
    print(report.getMonthlyAverageData(email));
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
                      onChanged: (newValue) {
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
              GestureDetector(
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
                  stressValue: '46',
                  pressureValue: '120/80',
                ),
              ),
              HistoryCardWidget(
                title: 'Miércoles',
                bpmValue: '116',
                sleepValue: '7.7',
                oxValue: '95',
                stepsValue: '1094',
                stressValue: '46',
                pressureValue: '120/80',
              ),
              HistoryCardWidget(
                title: 'Martes',
                bpmValue: '116',
                sleepValue: '7.7',
                oxValue: '95',
                stepsValue: '1094',
                stressValue: '46',
                pressureValue: '120/80',
              ),
              HistoryCardWidget(
                title: 'Lunes',
                bpmValue: '116',
                sleepValue: '7.7',
                oxValue: '95',
                stepsValue: '1094',
                stressValue: '46',
                pressureValue: '120/80',
              ),
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
}

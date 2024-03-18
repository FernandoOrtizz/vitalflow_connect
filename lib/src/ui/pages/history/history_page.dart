import 'package:flutter/material.dart';
import 'package:vitalflow_connect/src/ui/pages/history/history_stats_page.dart';
import 'package:vitalflow_connect/src/ui/pages/home/home_page.dart';
import 'package:vitalflow_connect/src/ui/widgets/custom_appbar.dart';
import 'package:vitalflow_connect/src/ui/widgets/history_card_widget.dart';

import '../../widgets/bottom_menu.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _selectedScale = 'Días';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
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

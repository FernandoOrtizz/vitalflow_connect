import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HistoryPieChart extends StatefulWidget {
  final Map<String, double> data;
  final String title;
  final Icon icon;
  final Color color;

  const HistoryPieChart(
      {super.key,
      required this.data,
      required this.title,
      required this.icon,
      required this.color});

  @override
  State<StatefulWidget> createState() => HistoryPieChartState(
      weekData: data, title: title, icon: icon, color: color);
}

class HistoryPieChartState extends State<HistoryPieChart> {
  Map<String, double> weekData = {};
  String? title;
  Icon? icon;
  Color? color;

  HistoryPieChartState(
      {required this.weekData,
      required this.title,
      required this.color,
      required this.icon});
  Map<int, MaterialColor> colorByIndex = {
    0: Colors.blue,
    1: Colors.orange,
    2: Colors.purple,
    3: Colors.green,
  };

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    List<Widget> legendWidgets = [];
    int index = 0;
    weekData.forEach((key, value) {
      legendWidgets.addAll([
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                color: colorByIndex[index],
              ),
              const SizedBox(width: 5),
              Text(
                key,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ]);
      index++;
    });

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon!,
                  const SizedBox(width: 10),
                  Text(
                    title ?? '',
                    style: TextStyle(
                      color: color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AspectRatio(
                aspectRatio: 1.2,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingSections(colorByIndex, weekData),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: legendWidgets,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(
      Map<int, MaterialColor> colorByIndex, Map<String, double> weekDataMap) {
    return List.generate(weekDataMap.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: colorByIndex[i] ?? Colors.blue,
        value: weekDataMap.values.toList()[i].toDouble(),
        title: weekDataMap.values.toList()[i].toStringAsFixed(2),
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          shadows: shadows,
        ),
      );
    });
  }
}

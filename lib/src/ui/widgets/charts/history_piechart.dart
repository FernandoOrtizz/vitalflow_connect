import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HistoryPieChart extends StatefulWidget {
  final Map<String, double> data;

  const HistoryPieChart({super.key, required this.data});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => HistoryPieChartState(weekData: data);
}

class HistoryPieChartState extends State {
  Map<String, double> weekData = {};
  HistoryPieChartState({required this.weekData});
  Map<int, MaterialColor> colorByIndex = {
    0: Colors.blue,
    1: Colors.orange,
    2: Colors.purple,
    3: Colors.green,
  };

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    List<dynamic> widgets = [];

    int index = 0;
    weekData.forEach((key, value) {
      widgets.addAll([
        Text(key,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              backgroundColor:
                  colorByIndex[index], // Establecer el color de fondo
            )),
        const SizedBox(
          height: 1,
        )
      ]);

      index++;
    });

    return AspectRatio(
      aspectRatio: 1.3,
      child: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
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
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingSections(colorByIndex, weekData),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: [
                    ...widgets,
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(
      Map<int, MaterialColor> colorByIndex, Map<String, double> weekDataMap) {
    return List.generate(weekDataMap.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: colorByIndex[i] ?? Colors.blue,
        value: weekDataMap.values.toList()[i].toDouble(),
        title: weekDataMap.keys.toList()[i],
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

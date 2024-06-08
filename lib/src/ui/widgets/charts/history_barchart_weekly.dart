import 'dart:math';

// import 'package:fl_chart_app/presentation/resources/app_resources.dart';
// import 'package:fl_chart_app/util/extensions/color_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class HistoryBarchartWeekly extends StatefulWidget {
  final String title;
  final Icon icon;
  final Color color;
  Map<String, double> dataPerHour;

  HistoryBarchartWeekly(
      {super.key,
      required this.title,
      required this.icon,
      required this.color,
      required this.dataPerHour});

  final Color barBackgroundColor = Colors.black;
  final Color barColor = Colors.black;

  @override
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      BarChartSample1State(data: dataPerHour);
}

class BarChartSample1State extends State<HistoryBarchartWeekly> {
  Map<String, double> data = {};

  BarChartSample1State({required this.data});

  // ignore: empty_constructor_bodies
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 90,
                  ),
                  widget.icon,
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: widget.color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: BarChart(
                  randomData(data),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: widget.color,
          borderRadius: BorderRadius.circular(8),
          borderDashArray: null,
          width: 15,
          borderSide: BorderSide(color: widget.color, width: 2.0),
        ),
      ],
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    // Devolver el widget de título del eje Y
    return SideTitleWidget(
      axisSide: meta.axisSide,
      // Espacio entre los títulos y el eje
      space: 1,
      // Widget de texto con el valor calculado
      child: Text(dayName((value - 1).toInt()).substring(0, 3)),
    );
  }

  BarChartData randomData(Map<String, double> mapa) {
    // double maxY = data.values.toList().reduce(max);

    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 30,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 50,
            showTitles: true,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(
        7,
        (i) => makeGroupData(
          i + 1,
          mapa[dayName(i.toInt())]?.toDouble() ?? 0,
        ),
      ),
      gridData: const FlGridData(show: false),
    );
  }

  String dayName(int i) {
    return translateDay[DateFormat('EEEE')
            .format(DateTime.now().add(Duration(days: -i)))] ??
        '';
  }
}

var translateDay = {
  'Monday': 'Lunes',
  'Tuesday': 'Martes',
  'Wednesday': 'Miércoles',
  'Thursday': 'Jueves',
  'Friday': 'Viernes',
  'Saturday': 'Sábado',
  'Sunday': 'Domingo'
};

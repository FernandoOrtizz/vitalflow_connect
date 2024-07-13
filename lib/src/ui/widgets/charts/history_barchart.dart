import 'dart:math';

// import 'package:fl_chart_app/presentation/resources/app_resources.dart';
// import 'package:fl_chart_app/util/extensions/color_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryBarchart extends StatefulWidget {
  final String title;
  final Icon icon;
  final Color color;
  List<double> dataPerHour;

  HistoryBarchart(
      {super.key,
      required this.title,
      required this.icon,
      required this.color,
      required this.dataPerHour});

  final Color barBackgroundColor = Colors.black;
  final Color barColor = Colors.black;

  @override
  State<StatefulWidget> createState() =>
      BarChartSample1State(data: dataPerHour);
}

class BarChartSample1State extends State<HistoryBarchart> {
  List<double> data = [];

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
                    height: 70,
                  ),
                  widget.icon,
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: widget.color,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              Expanded(
                child: BarChart(
                  randomData(this.data),
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
          width: 10,
          borderSide: BorderSide(color: widget.color, width: 2.0),
        ),
      ],
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const startHour = 0;
    const interval = 2;

    // Calcular el valor correspondiente según la posición de la barra
    final currentHour = (startHour + value.toInt() * interval) % 24;

    // Establecer el estilo del texto
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    // Crear el widget de texto con el valor calculado
    final text = Text(
      '$currentHour',
      style: style,
    );

    // Devolver el widget de título del eje Y
    return SideTitleWidget(
      axisSide: meta.axisSide,
      // Espacio entre los títulos y el eje
      space: 1,
      // Widget de texto con el valor calculado
      child: text,
    );
  }

  BarChartData randomData(List<double> list) {
    list = [0.0, ...list];
    double maxY = list.reduce(max);

    return BarChartData(
      maxY: maxY,
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
            reservedSize: 40,
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
        12,
        (i) => makeGroupData(
          i,
          list[i * 2].toDouble(),
        ),
      ),
      gridData: const FlGridData(show: false),
    );
  }

  // horas  [0,0,0,0,0,0,0,0,0,0,2324,0,0,0,0,0,0,0,0,0,0,0,0,0]
  // indice [0,1,2,3,4,5,6]

  // BarChartData randomData() {
  //   Map<String, double> mapa = {
  //     'Viernes': 32,
  //     'Jueves': 32,
  //     'Miércoles': 32,
  //     'Martes': 32,
  //     'Lunes': 32,
  //     'Domingo': 32,
  //     'Sábado': 32,
  //   };

  //   return BarChartData(
  //     maxY: 200.0,
  //     barTouchData: BarTouchData(
  //       enabled: false,
  //     ),
  //     titlesData: FlTitlesData(
  //       show: true,
  //       bottomTitles: AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: true,
  //           getTitlesWidget: getTitles2,
  //           reservedSize: 30,
  //         ),
  //       ),
  //       leftTitles: const AxisTitles(
  //         sideTitles: SideTitles(
  //           reservedSize: 33,
  //           showTitles: true,
  //         ),
  //       ),
  //       topTitles: const AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: false,
  //         ),
  //       ),
  //       rightTitles: const AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: false,
  //         ),
  //       ),
  //     ),
  //     borderData: FlBorderData(
  //       show: false,
  //     ),
  //     barGroups: List.generate(
  //       7,
  //       (i) => makeGroupData(
  //         i + 1,
  //         mapa[dayName(i.toInt())]?.toDouble() ?? 0,
  //       ),
  //     ),
  //     gridData: const FlGridData(show: false),
  //   );
  // }

  // String dayName(int i) {
  //   String data = translateDay[DateFormat('EEEE')
  //           .format(DateTime.now().add(Duration(days: -i)))] ??
  //       '';

  //   print('$i DAYNAME + $data');
  //   return translateDay[DateFormat('EEEE')
  //           .format(DateTime.now().add(Duration(days: -i)))] ??
  //       '';
  // }
}

// BarChartData randomData() {
//   Map<String, double> mapa = {
//     'Viernes': 32,
//     'Jueves': 32,
//     'Miércoles': 32,
//     'Martes': 32,
//     'Lunes': 32,
//     'Domingo': 32,
//     'Sábado': 32,
//   };

//   return BarChartData(
//     maxY: 200.0,
//     barTouchData: BarTouchData(
//       enabled: false,
//     ),
//     titlesData: FlTitlesData(
//       show: true,
//       bottomTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           getTitlesWidget: getTitles2,
//           reservedSize: 30,
//         ),
//       ),
//       leftTitles: const AxisTitles(
//         sideTitles: SideTitles(
//           reservedSize: 33,
//           showTitles: true,
//         ),
//       ),
//       topTitles: const AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: false,
//         ),
//       ),
//       rightTitles: const AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: false,
//         ),
//       ),
//     ),
//     borderData: FlBorderData(
//       show: false,
//     ),
//     barGroups: List.generate(
//       7,
//       (i) => makeGroupData(
//         i + 1,
//         mapa[dayName(i.toInt())]?.toDouble() ?? 0,
//       ),
//     ),
//     gridData: const FlGridData(show: false),
//   );
// }

// String dayName(int i) {
//   String data = translateDay[DateFormat('EEEE')
//           .format(DateTime.now().add(Duration(days: -i)))] ??
//       '';

//   print('$i DAYNAME + $data');
//   return translateDay[DateFormat('EEEE')
//           .format(DateTime.now().add(Duration(days: -i)))] ??
//       '';
// }
// }

var translateDay = {
  'Monday': 'Lunes',
  'Tuesday': 'Martes',
  'Wednesday': 'Miércoles',
  'Thursday': 'Jueves',
  'Friday': 'Viernes',
  'Saturday': 'Sábado',
  'Sunday': 'Domingo'
};

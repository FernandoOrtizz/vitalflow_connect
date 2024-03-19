import 'dart:math';

// import 'package:fl_chart_app/presentation/resources/app_resources.dart';
// import 'package:fl_chart_app/util/extensions/color_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HistoryBarchart extends StatefulWidget {
  final String title;
  final Icon icon;
  final Color color;

  const HistoryBarchart(
      {super.key,
      required this.title,
      required this.icon,
      required this.color});

  final Color barBackgroundColor = Colors.black;
  final Color barColor = Colors.black;

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<HistoryBarchart> {
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
                      fontSize: 18,
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
                  randomData(),
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

  BarChartData randomData() {
    return BarChartData(
      maxY: 200.0,
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
            reservedSize: 33,
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
          Random().nextInt(200).toDouble(),
        ),
      ),
      gridData: const FlGridData(show: false),
    );
  }
}

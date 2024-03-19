import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HistoryPieChart extends StatelessWidget {
  final Color color;
  final String title;
  final Icon icon;

  const HistoryPieChart({
    Key? key,
    required this.color,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon,
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          color: color,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  // Agregar el PieChart dentro de un contenedor con un tamaño definido
                  SizedBox(
                    height: 250,
                    width: 200,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                              color: Colors.grey,
                              value: 66,
                              title: '16 horas despierto',
                              radius: 50,
                              titleStyle:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          PieChartSectionData(
                              color: color,
                              value: 33,
                              title: '8 horas de sueño',
                              radius: 50,
                              titleStyle:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

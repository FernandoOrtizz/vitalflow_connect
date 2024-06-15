import 'package:flutter/material.dart';
import 'package:vitalflow_connect/src/ui/widgets/charts/history_piechart.dart';
import 'package:vitalflow_connect/src/ui/widgets/custom_appbar.dart';

// ignore: must_be_immutable
class HistoryStatsPageMonthly extends StatelessWidget {
  String title = "N/A";
  Map<String, Map<String, double>> data;

  HistoryStatsPageMonthly({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context: context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          // controller: controller,
          child: Column(
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(
                height: 40,
              ),
              HistoryPieChart(
                data: data['heart_rate'] ?? {},
                title: "Ritmo cardíaco/semana",
                icon: Icon(
                  Icons.favorite,
                  color: Colors.pink.shade100,
                ),
                color: Colors.pink.shade100,
              ),
              const SizedBox(
                height: 10,
              ),
              HistoryPieChart(
                data: data['resting_bpm'] ?? {},
                title: "Ritmo cardíaco en reposo/semana",
                icon: Icon(
                  Icons.favorite_border_rounded,
                  color: Colors.pink.shade100,
                ),
                color: Colors.pink.shade100,
              ),
              const SizedBox(
                height: 10,
              ),
              HistoryPieChart(
                data: data['activity'] ?? {},
                title: "Cantidad de pasos/semana ",
                icon: Icon(
                  Icons.directions_walk_rounded,
                  color: Colors.green.shade300,
                ),
                color: Colors.green.shade300,
              ),
              const SizedBox(
                height: 10,
              ),
              HistoryPieChart(
                data: data['calories_expended'] ?? {},
                title: " Energía gastada/semana",
                icon: Icon(
                  Icons.battery_charging_full_rounded,
                  color: Colors.orange.shade300,
                ),
                color: Colors.orange.shade300,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

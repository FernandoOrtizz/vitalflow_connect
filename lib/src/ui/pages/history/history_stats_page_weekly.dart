import 'package:flutter/material.dart';
import 'package:vitalflow_connect/src/ui/widgets/charts/history_barchart_weekly.dart';
import 'package:vitalflow_connect/src/ui/widgets/custom_appbar.dart';
import 'package:vitalflow_connect/src/ui/widgets/charts/history_barchart.dart';

// ignore: must_be_immutable
class HistoryStatsPageWeekly extends StatelessWidget {
  String title = "N/A";
  Map<String, Map<String, double>> data;

  HistoryStatsPageWeekly({super.key, required this.title, required this.data});

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
              HistoryBarchartWeekly(
                title: "Ritmo cardíaco/día",
                icon: Icon(
                  Icons.favorite,
                  color: Colors.pink.shade100,
                ),
                color: Colors.pink.shade100,
                dataPerHour: data["heart_rate"]!,
              ),
              const SizedBox(
                height: 10,
              ),
              HistoryBarchartWeekly(
                title: "Ritmo cardíaco en reposo/día",
                icon: Icon(
                  Icons.favorite_border_rounded,
                  color: Colors.pink.shade100,
                ),
                color: Colors.pink.shade100,
                dataPerHour: data["resting_bpm"]!,
              ),
              const SizedBox(
                height: 10,
              ),
              HistoryBarchartWeekly(
                title: "Cantidad de pasos/día",
                icon: Icon(
                  Icons.directions_walk_rounded,
                  color: Colors.green.shade300,
                ),
                color: Colors.green.shade300,
                dataPerHour: data["activity"]!,
              ),
              const SizedBox(
                height: 10,
              ),
              HistoryBarchartWeekly(
                title: "Energía gastada/día",
                icon: Icon(
                  Icons.battery_charging_full_rounded,
                  color: Colors.orange.shade300,
                ),
                color: Colors.orange.shade300,
                dataPerHour: data["calories_expended"]!,
              ),
              const SizedBox(
                height: 10,
              ),
              // const HistoryPieChart(),
              // const SizedBox(
              //   height: 10,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

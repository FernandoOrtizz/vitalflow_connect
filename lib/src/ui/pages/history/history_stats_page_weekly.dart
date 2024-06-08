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
                title: "Ritmo cardíaco por hora",
                icon: Icon(
                  Icons.monitor_heart_outlined,
                  color: Colors.green.shade700,
                ),
                color: Colors.green.shade700,
                dataPerHour: data["heart_rate"]!,
              ),
              const SizedBox(
                height: 10,
              ),
              HistoryBarchartWeekly(
                title: "Descanso - Ritmo cardíaco por hora",
                icon: Icon(
                  Icons.monitor_heart_outlined,
                  color: Colors.green.shade700,
                ),
                color: Colors.green.shade700,
                dataPerHour: data["resting_bpm"]!,
              ),
              const SizedBox(
                height: 10,
              ),
              HistoryBarchartWeekly(
                title: "Cantidad de pasos por hora",
                icon: Icon(
                  Icons.monitor_heart_outlined,
                  color: Colors.green.shade700,
                ),
                color: Colors.green.shade700,
                dataPerHour: data["activity"]!,
              ),
              const SizedBox(
                height: 10,
              ),
              HistoryBarchartWeekly(
                title: "calorias quemadas por hora",
                icon: Icon(
                  Icons.monitor_heart_outlined,
                  color: Colors.green.shade700,
                ),
                color: Colors.green.shade700,
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

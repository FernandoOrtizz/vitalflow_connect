import 'package:flutter/material.dart';
import 'package:vitalflow_connect/src/ui/pages/history/history_page.dart';
import 'package:vitalflow_connect/src/ui/pages/home/home_page.dart';
import 'package:vitalflow_connect/src/ui/widgets/bottom_menu.dart';
import 'package:vitalflow_connect/src/ui/widgets/charts/history_piechart.dart';
import 'package:vitalflow_connect/src/ui/widgets/custom_appbar.dart';
import 'package:vitalflow_connect/src/ui/widgets/charts/history_barchart.dart';

class HistoryStatsPage extends StatelessWidget {
  final String title = "Lunes";
  const HistoryStatsPage({
    super.key,
    // required this.title
  });

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
              const Text(
                "Lunes",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(
                height: 40,
              ),
              HistoryBarchart(
                title: "Latidos Por minuto",
                icon: Icon(
                  Icons.monitor_heart_outlined,
                  color: Colors.green.shade700,
                ),
                color: Colors.green.shade700,
              ),
              const SizedBox(
                height: 10,
              ),
              const HistoryPieChart(
                  color: Colors.blueGrey,
                  title: "Horas de Sueño",
                  icon: Icon(
                    Icons.brightness_3_outlined,
                    color: Colors.blueGrey,
                  )),
              const SizedBox(
                height: 10,
              ),
              HistoryPieChart(
                  color: Colors.blue.shade300,
                  title: "Oxígeno en Sangre",
                  icon: Icon(
                    Icons.bloodtype_outlined,
                    color: Colors.blue.shade300,
                  )),
              const SizedBox(
                height: 10,
              ),
              HistoryBarchart(
                title: "Pasos",
                icon: Icon(
                  Icons.directions_walk,
                  color: Colors.green.shade300,
                ),
                color: Colors.green.shade300,
              ),
              const SizedBox(
                height: 10,
              ),
              HistoryBarchart(
                title: "Nivel de estrés",
                icon: Icon(
                  Icons.face_retouching_natural_sharp,
                  color: Colors.orange.shade300,
                ),
                color: Colors.orange.shade300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

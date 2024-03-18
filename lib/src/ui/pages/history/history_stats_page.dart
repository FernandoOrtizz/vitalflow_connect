import 'package:flutter/material.dart';
import 'package:vitalflow_connect/src/ui/pages/history/history_page.dart';
import 'package:vitalflow_connect/src/ui/pages/home/home_page.dart';
import 'package:vitalflow_connect/src/ui/widgets/bottom_menu.dart';
import 'package:vitalflow_connect/src/ui/widgets/custom_appbar.dart';
import 'package:vitalflow_connect/src/ui/widgets/history_barchart.dart';

class HistoryStatsPage extends StatelessWidget {
  const HistoryStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          // controller: controller,
          child: Column(
            children: [
              const Text("STATS"),
              HistoryBarchart(
                title: "Latidos Por minuto",
                icon: Icon(
                  Icons.monitor_heart_outlined,
                  color: Colors.green.shade700,
                ),
                color: Colors.green.shade700,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomMenu(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          } else if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HistoryPage()));
          }
        },
      ),
    );
  }
}

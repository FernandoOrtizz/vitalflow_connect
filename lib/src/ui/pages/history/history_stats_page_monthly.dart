import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalflow_connect/src/provider/user.dart';
import 'package:vitalflow_connect/src/ui/pages/account/account.dart';
import 'package:vitalflow_connect/src/ui/pages/home/home_page.dart';
import 'package:vitalflow_connect/src/ui/widgets/bottom_menu.dart';
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
      appBar: CustomAppBar(
        usersToMonitor: context.watch<CurrentUser>().allowedUsersToMonitor,
        context: context,
      ),
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
              if (data['heart_rate'] != null && data['heart_rate']!.isNotEmpty)
                HistoryPieChart(
                  data: data['heart_rate']!,
                  title: "Ritmo cardíaco",
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.pink.shade100,
                  ),
                  color: Colors.pink.shade100,
                ),
              const SizedBox(
                height: 10,
              ),
              if (data['resting_bpm'] != null &&
                  data['resting_bpm']!.isNotEmpty)
                HistoryPieChart(
                  data: data['resting_bpm']!,
                  title: "Ritmo cardíaco en reposo",
                  icon: Icon(
                    Icons.favorite_border_rounded,
                    color: Colors.pink.shade100,
                  ),
                  color: Colors.pink.shade100,
                ),
              const SizedBox(
                height: 10,
              ),
              if (data['activity'] != null && data['activity']!.isNotEmpty)
                HistoryPieChart(
                  data: data['activity']!,
                  title: "Cantidad de pasos",
                  icon: Icon(
                    Icons.directions_walk_rounded,
                    color: Colors.green.shade300,
                  ),
                  color: Colors.green.shade300,
                ),
              const SizedBox(
                height: 10,
              ),
              if (data['calories_expended'] != null &&
                  data['calories_expended']!.isNotEmpty)
                HistoryPieChart(
                  data: data['calories_expended']!,
                  title: "Energía gastada",
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
      bottomNavigationBar: BottomMenu(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          }
          if (index == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AccountPage()));
          }
        },
      ),
    );
  }
}

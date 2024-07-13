import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalflow_connect/src/provider/user.dart';
import 'package:vitalflow_connect/src/ui/pages/account/account.dart';
import 'package:vitalflow_connect/src/ui/pages/home/home_page.dart';
import 'package:vitalflow_connect/src/ui/widgets/bottom_menu.dart';
import 'package:vitalflow_connect/src/ui/widgets/custom_appbar.dart';
import 'package:vitalflow_connect/src/ui/widgets/charts/history_barchart.dart';

// ignore: must_be_immutable
class HistoryStatsPage extends StatelessWidget {
  String title = "N/A";
  Map<String, List<double>> data;

  HistoryStatsPage({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          usersToMonitor: context.watch<CurrentUser>().allowedUsersToMonitor,
          context: context),
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
              HistoryBarchart(
                title: "Ritmo cardíaco/hora",
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
              HistoryBarchart(
                title: "Ritmo cardíaco en reposo/hora",
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
              HistoryBarchart(
                title: "Cantidad de pasos/hora ",
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
              HistoryBarchart(
                title: " Energía gastada/hora",
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

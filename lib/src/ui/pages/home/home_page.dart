import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/heart_rate.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/resting_heart_rate.dart';
import 'package:vitalflow_connect/src/infrastructure/google_signin/signin.dart';
import 'package:vitalflow_connect/src/ui/pages/history/history_page.dart';
import 'package:vitalflow_connect/src/ui/pages/home/home_controller.dart';
import 'package:vitalflow_connect/src/ui/widgets/bottom_menu.dart';
import 'package:vitalflow_connect/src/ui/widgets/custom_appbar.dart';
import '../../widgets/home/card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var heartRateData = HeartRate();
  var restingHeartRateData = RestingHeartRate();
  @override
  Widget build(BuildContext context) {
    final controller =
        HomeController(googleAuthService: context.watch<GoogleAuth>());
    return Scaffold(
      appBar: CustomAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.getData(),
        child: const Icon(Icons.refresh),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.0, // Relación de aspecto de 2:1
          children: [
            CardWidget(
              title: 'Ritmo Cardiaco',
              iconData: Icons.favorite_border_rounded,
              value: heartRateData.getData(), //
              date: '2024-03-07',
              unit: 'LPM',
              iconColor: Colors.green.shade700,
            ),
            CardWidget(
              title: 'Ritmo cardiaco en reposo',
              iconData: Icons.favorite_border_rounded,
              value: '', //restingHeartRateData.getData(),
              date: '2024-03-07',
              unit: 'LPM',
              iconColor: Colors.pink.shade100,
            ),
            CardWidget(
              title: 'Pasos',
              iconData: Icons.directions_walk_rounded,
              value: '',
              date: '2024-03-07',
              unit: '',
              iconColor: Colors.green.shade300,
            ),
            CardWidget(
              title: 'Energía gastada',
              iconData: Icons.fireplace_rounded,
              value: '46',
              date: '2024-03-07',
              unit: 'Cals',
              iconColor: Colors.orange.shade300,
            ),
            CardWidget(
              title: 'Sueño',
              iconData: Icons.brightness_3_outlined,
              value: '7.7',
              date: '2024-03-07',
              unit: 'Horas',
              iconColor: Colors.blueGrey,
            ),
            CardWidget(
              title: 'Oxígeno en sangre',
              iconData: Icons.bloodtype_outlined,
              value: '95',
              date: '2024-03-07',
              unit: '%',
              iconColor: Colors.blue.shade300,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomMenu(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HistoryPage()));
          }
        },
      ),
    );
  }
}

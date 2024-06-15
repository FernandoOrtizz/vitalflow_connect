import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/activity.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/calories_expended.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/heart_rate.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/resting_heart_rate.dart';
import 'package:vitalflow_connect/src/infrastructure/google_signin/signin.dart';
import 'package:vitalflow_connect/src/provider/user.dart';
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
  @override
  Widget build(BuildContext context) {
    final controller = HomeController(
        googleAuthService: context.watch<GoogleAuth>(),
        email: context.watch<CurrentUser>().email);
    return Scaffold(
      appBar: CustomAppBar(context: context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          controller.getData(),
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomePage()))
        },
        child: const Icon(Icons.refresh),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.0, // Relación de aspecto de 2:1
          children: [
            buildHeartRateCard(),
            buildRestingHeartRateCard(),
            buildStepsCard(),
            buildCaloriesExpended(),
            CardWidget(
              title: 'Sueño',
              iconData: Icons.brightness_3_outlined,
              value: 'No hay datos',
              date: DateTime.now(),
              unit: '',
              iconColor: Colors.blueGrey,
            ),
            CardWidget(
              title: 'Oxígeno en sangre',
              iconData: Icons.bloodtype_outlined,
              value: 'No hay datos',
              date: DateTime.now(),
              unit: '',
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

  Widget buildCaloriesExpended() {
    return FutureBuilder<Map<String, dynamic>>(
      future: CaloriesExpended().getData(context.watch<CurrentUser>().email),
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            (snapshot.data != null && snapshot.data!.isEmpty)) {
          return CardWidget(
            title: 'Energía gastada',
            iconData: Icons.battery_charging_full_rounded,
            value: 'No hay datos',
            date: DateTime.now(),
            unit: '',
            iconColor: Colors.orange.shade300,
          );
        }

        if (snapshot.hasError) {
          return CardWidget(
            title: 'Energía gastada',
            iconData: Icons.battery_charging_full_rounded,
            value: 'error',
            date: DateTime.now(),
            unit: 'Cals',
            iconColor: Colors.orange.shade300,
          );
        }

        return CardWidget(
          title: 'Energía gastada',
          iconData: Icons.battery_charging_full_rounded,
          value: snapshot.data?["value"]?.toStringAsFixed(2) ?? '---',
          date: snapshot.data?["date"]?.toDate() ?? DateTime.now(),
          unit: 'Cals',
          iconColor: Colors.orange.shade300,
        );
      },
    );
  }

  Widget buildHeartRateCard() {
    return FutureBuilder<Map<String, dynamic>>(
      future: HeartRate().getData(context.watch<CurrentUser>().email),
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            (snapshot.data != null && snapshot.data!.isEmpty)) {
          return CardWidget(
            title: 'Ritmo cardiaco',
            iconData: Icons.favorite,
            value: 'No hay datos',
            date: DateTime.now(),
            unit: '',
            iconColor: Colors.pink.shade100,
          );
        }

        if (snapshot.hasError) {
          return CardWidget(
            title: 'Ritmo cardiaco',
            iconData: Icons.favorite,
            value: 'error',
            date: DateTime.now(),
            unit: 'LPM',
            iconColor: Colors.pink.shade100,
          );
        }

        return CardWidget(
          title: 'Ritmo cardiaco',
          iconData: Icons.favorite,
          value: snapshot.data?["value"].toString() ?? '---',
          date: snapshot.data?["date"]?.toDate() ?? DateTime.now(),
          unit: 'LPM',
          iconColor: Colors.pink.shade100,
        );
      },
    );
  }

  Widget buildRestingHeartRateCard() {
    return FutureBuilder<Map<String, dynamic>>(
      future: RestingHeartRate().getData(context.watch<CurrentUser>().email),
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            (snapshot.data != null && snapshot.data!.isEmpty)) {
          return CardWidget(
            title: 'Ritmo cardiaco en reposo',
            iconData: Icons.favorite_border_rounded,
            value: 'No hay datos',
            date: DateTime.now(),
            unit: '',
            iconColor: Colors.pink.shade100,
          );
        }

        if (snapshot.hasError) {
          return CardWidget(
            title: 'Ritmo cardiaco en reposo',
            iconData: Icons.favorite_border_rounded,
            value: 'error',
            date: DateTime.now(),
            unit: 'LPM',
            iconColor: Colors.pink.shade100,
          );
        }

        return CardWidget(
          title: 'Ritmo cardiaco en reposo',
          iconData: Icons.favorite_border_rounded,
          value: snapshot.data?["value"].toString() ?? '---',
          date: snapshot.data?["date"]?.toDate() ?? DateTime.now(),
          unit: 'LPM',
          iconColor: Colors.pink.shade100,
        );
      },
    );
  }

  Widget buildStepsCard() {
    return FutureBuilder<Map<String, dynamic>>(
      future: Activity().getData(context.watch<CurrentUser>().email),
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            (snapshot.data != null && snapshot.data!.isEmpty)) {
          return CardWidget(
            title: 'Pasos',
            iconData: Icons.directions_walk_rounded,
            value: 'No hay datos',
            date: DateTime.now(),
            unit: '',
            iconColor: Colors.green.shade300,
          );
        }

        if (snapshot.hasError) {
          return CardWidget(
            title: 'Pasos',
            iconData: Icons.directions_walk_rounded,
            value: 'error',
            date: DateTime.now(),
            unit: '',
            iconColor: Colors.green.shade300,
          );
        }

        return CardWidget(
          title: 'Pasos',
          iconData: Icons.directions_walk_rounded,
          value: snapshot.data?["value"].toString() ?? 'No hay datos',
          date: snapshot.data?["date"]?.toDate() ?? DateTime.now(),
          unit: '',
          iconColor: Colors.green.shade300,
        );
      },
    );
  }
}

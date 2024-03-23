import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vitalflow_connect/firebase_options.dart';
import 'package:vitalflow_connect/src/infrastructure/google_signin/signin.dart';

import 'package:vitalflow_connect/src/application/runner/ports.dart';
import 'package:vitalflow_connect/src/application/runner/usecase.dart';
import 'package:vitalflow_connect/src/application/sync/usecase.dart';
import 'package:vitalflow_connect/src/infrastructure/fitness_api/activity.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/activity.dart'
    as activityDestination;
import 'package:vitalflow_connect/src/infrastructure/firestore/heart_rate.dart'
    as heartRateDestination;
import 'package:vitalflow_connect/src/infrastructure/firestore/resting_heart_rate.dart'
    as restingHeartRateDestination;
import 'package:vitalflow_connect/src/infrastructure/firestore/calories_expended.dart'
    as caloriesExpendedDestination;
import 'package:vitalflow_connect/src/infrastructure/fitness_api/calories_expanded.dart';
import 'package:vitalflow_connect/src/infrastructure/fitness_api/heart_rate.dart';
import 'package:vitalflow_connect/src/infrastructure/fitness_api/request.dart';
import 'package:vitalflow_connect/src/infrastructure/fitness_api/resting_heart_rate.dart';
import 'package:vitalflow_connect/src/ui/pages/home/home_page.dart';
import 'package:vitalflow_connect/src/ui/pages/login/login_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
      create: (_) => GoogleAuth(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return MaterialApp(
        title: 'VitalFlow',
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: Colors.deepPurple.shade400),
          useMaterial3: true,
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data == null) {
                return LoginPage(
                  controller: controller,
                );
              }

              return const HomePage();
            }

            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}

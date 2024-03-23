import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vitalflow_connect/firebase_options.dart';
import 'package:vitalflow_connect/src/application/runner/ports.dart';
import 'package:vitalflow_connect/src/application/runner/usecase.dart';
import 'package:vitalflow_connect/src/application/sync/usecase.dart';
import 'package:vitalflow_connect/src/infrastructure/fitness_api/activity.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/activity.dart'
    as activityDestination;
import 'package:vitalflow_connect/src/infrastructure/fitness_api/request.dart';
import 'package:vitalflow_connect/src/infrastructure/google_signin/signin.dart';
import 'package:vitalflow_connect/src/ui/pages/login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var googleAuthService = GoogleAuth();
  var request = Request(authService: googleAuthService);

  List<Sync> syncList = [];

  var activitySource = Activity(request: request);
  var activityDest = activityDestination.Activity();
  var activitySync = SyncUseCase(activitySource, activityDest);

  syncList.add(activitySync);

  var runner = Runner(syncList);

  // TODO: HACER QUE CORRA EN SEGUNDO PLANO
  runner.execute();

  runApp(MyApp());
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
      home: LoginPage(controller: controller),
    );
  }
}

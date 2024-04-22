import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vitalflow_connect/firebase_options.dart';
import 'package:vitalflow_connect/src/application/report/ports.dart';
import 'package:vitalflow_connect/src/application/report/usecase.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/activity.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/monitoring_permission.dart';
import 'package:vitalflow_connect/src/infrastructure/google_signin/signin.dart';
import 'package:vitalflow_connect/src/provider/drop_down_provider.dart';
import 'package:vitalflow_connect/src/provider/user.dart';
import 'package:vitalflow_connect/src/ui/pages/home/home_page.dart';
import 'package:vitalflow_connect/src/ui/pages/login/login_page.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initializeDateFormatting('es', null);

  var monitoringPermissions = await MonitoringPermission()
      .getUserPermissions(FirebaseAuth.instance.currentUser?.email ?? '');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => GoogleAuth()),
      ChangeNotifierProvider(create: (_) => CurrentUser(monitoringPermissions)),
      ChangeNotifierProvider(create: (_) => DorpDownProvider())
    ],
    child: const MyApp(),
  ));
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

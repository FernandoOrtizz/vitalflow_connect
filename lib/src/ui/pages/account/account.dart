import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:vitalflow_connect/src/provider/drop_down_provider.dart';
import 'package:vitalflow_connect/src/provider/user.dart';
import 'package:vitalflow_connect/src/ui/pages/history/history_page.dart';
import 'package:vitalflow_connect/src/ui/pages/home/home_page.dart';
import 'package:vitalflow_connect/src/ui/pages/login/login_page.dart';
import 'package:vitalflow_connect/src/ui/widgets/bottom_menu.dart';
import 'package:vitalflow_connect/src/ui/widgets/custom_appbar.dart';

void main() => runApp(const AccountPage());

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _MyAppState();
}

class _MyAppState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return MaterialApp(
      title: 'Cerrar Sesión',
      home: Scaffold(
        appBar: CustomAppBar(
            usersToMonitor: context.watch<CurrentUser>().allowedUsersToMonitor,
            context: context),
        body: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            onPressed: () async {
              // context.read<DorpDownProvider>().dropDownEmail = '';
              // context.read<CurrentUser>().email = '';
              // context.read<CurrentUser>().allowedUsersToMonitor = [];

              await GoogleSignIn().signOut();
              await FirebaseAuth.instance.signOut();

              Phoenix.rebirth(context);

              // Navigator.of(context).popUntil((route) => false);

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => LoginPage(controller: controller),
              //       maintainState: false),
              // );
            },
            child: const Text('Cerrar Sesión'),
          ),
        ),
        bottomNavigationBar: BottomMenu(
          currentIndex: 2,
          onTap: (index) {
            if (index == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            }
            if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()));
            }
          },
        ),
      ),
    );
  }
}

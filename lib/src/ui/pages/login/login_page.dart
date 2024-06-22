import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/monitoring_permission.dart';
import 'package:vitalflow_connect/src/provider/user.dart';
import 'package:vitalflow_connect/src/ui/pages/home/home_page.dart';
import 'package:vitalflow_connect/src/infrastructure/google_signin/signin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.controller}) : super(key: key);

  final PageController controller;

  @override
  State<LoginPage> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  _LoginScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 18,
                ),
                const Center(
                  child: Row(
                    children: [
                      Text(
                        'VitalFlow Connect',
                        style: TextStyle(
                          color: Color(0xFF755DC1),
                          fontSize: 27,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const SizedBox(
                  height: 25,
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: SizedBox(
                      width: 329,
                      height: 56,
                      child: SignInButton(
                        Buttons.Google,
                        text: "Inicia sesión con Google",
                        onPressed: () async {
                          await context.read<GoogleAuth>().login();
                          context.read<CurrentUser>().email =
                              FirebaseAuth.instance.currentUser?.email ?? "";

                          context.read<CurrentUser>().allowedUsersToMonitor =
                              await MonitoringPermission().getUserPermissions(
                                  FirebaseAuth.instance.currentUser?.email ??
                                      '');
                          saveUser(
                              FirebaseAuth.instance.currentUser!.uid,
                              FirebaseAuth.instance.currentUser?.email ?? '',
                              FirebaseAuth.instance.currentUser?.displayName ??
                                  '');

                          if (!context.mounted) return;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        },
                      )),
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> validateUser(String uid) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection("users")
      .where("userUID", isEqualTo: uid)
      .get();

  if (querySnapshot.docs.isEmpty) {
    return false;
  }

  return true;
}

void saveUser(String uid, String email, String displayName) async {
  if (!await validateUser(uid)) {
    Map<String, String> data = {
      'userUID': uid,
      'email': email,
      'displayName': displayName
    };

    try {
      await FirebaseFirestore.instance.collection("users").add(data);
      return Future.value();
    } catch (e) {
      return Future.error(e);
    }
  }
}

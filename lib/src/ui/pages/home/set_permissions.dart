import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/monitoring_permission.dart';
import 'package:vitalflow_connect/src/provider/user.dart';
import 'package:vitalflow_connect/src/ui/pages/account/account.dart';
import 'package:vitalflow_connect/src/ui/pages/history/history_page.dart';
import 'package:vitalflow_connect/src/ui/pages/home/home_page.dart';
import 'package:vitalflow_connect/src/ui/widgets/bottom_menu.dart';
import 'package:vitalflow_connect/src/ui/widgets/custom_appbar.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../../../provider/drop_down_provider.dart';

class SetPermissions extends StatefulWidget {
  SetPermissions({Key? key}) : super(key: key);

  @override
  State<SetPermissions> createState() => _SetPermissionsState();
}

class _SetPermissionsState extends State<SetPermissions> {
  String qrValue = '';
  bool _isButtonEnabled = false;

  final TextEditingController _controller = TextEditingController();

  void scanQr() async {
    String? cameraScanResult = await scanner.scan();
    setState(() {
      _controller.text = cameraScanResult ?? '';
      _isButtonEnabled = _controller.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isButtonEnabled = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        usersToMonitor: context.read<CurrentUser>().allowedUsersToMonitor,
        context: context,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: scanQr,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10), // Más padding
                  shape: const CircleBorder(), // Botón redondo
                ),
                child: const SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 100, // Tamaño del icono
                      ),
                      Positioned(
                        bottom: 30,
                        child: Text(
                          'Escanear QR',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'O ingresa un código de usuario',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isButtonEnabled
                    ? () async {
                        final String code = _controller.text;
                        await MonitoringPermission().postUserPermissions(code);
                        _controller.clear();

                        context.read<DorpDownProvider>().dropDownEmail =
                            FirebaseAuth.instance.currentUser?.email ?? '';

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      }
                    : null,
                child: const Text('Conectar'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomMenu(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HistoryPage()));
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

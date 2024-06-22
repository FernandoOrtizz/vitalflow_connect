import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/monitoring_permission.dart';
import 'package:vitalflow_connect/src/provider/user.dart';
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

  final TextEditingController _controller = TextEditingController();

  void scanQr() async {
    String? cameraScanResult = await scanner.scan();
    setState(() {
      _controller.text = cameraScanResult ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          usersToMonitor: context.read<CurrentUser>().allowedUsersToMonitor,
          context: context),
      body: Padding(
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
              height: 50,
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'O ingresa un código de usuario',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
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
              },
              child: const Text('Conectar'),
            ),
          ],
        ),
      ),
    );
  }
}

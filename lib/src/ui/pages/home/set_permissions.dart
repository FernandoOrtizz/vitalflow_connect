import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/monitoring_permission.dart';
import 'package:vitalflow_connect/src/provider/user.dart';
import 'package:vitalflow_connect/src/ui/pages/history/history_page.dart';
import 'package:vitalflow_connect/src/ui/pages/home/home_page.dart';
import 'package:vitalflow_connect/src/ui/widgets/bottom_menu.dart';
import 'package:vitalflow_connect/src/ui/widgets/custom_appbar.dart';

class SetPermissions extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  // final VoidCallback onPressed;

  SetPermissions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Dar acceso a mis datos',
                hintText: 'Ingrese un correo electrónico',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final String email = _controller.text;
                MonitoringPermission().postUserPermissions(email);
                // Aquí puedes hacer lo que quieras con el valor del email
                print('Correo electrónico ingresado: $email');
                _controller.clear();
              },
              child: const Text('Conectar'),
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
          } else if ((index == 0)) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          }
        },
      ),
    );
  }
}

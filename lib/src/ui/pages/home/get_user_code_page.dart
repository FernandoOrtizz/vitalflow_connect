import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/monitoring_permission.dart';
import 'package:vitalflow_connect/src/provider/user.dart';
import 'package:vitalflow_connect/src/ui/pages/history/history_page.dart';
import 'package:vitalflow_connect/src/ui/pages/home/home_page.dart';
import 'package:vitalflow_connect/src/ui/widgets/bottom_menu.dart';
import 'package:vitalflow_connect/src/ui/widgets/custom_appbar.dart';

class GetUserCode extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  // final VoidCallback onPressed;

  GetUserCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          usersToMonitor: context.watch<CurrentUser>().allowedUsersToMonitor,
          context: context),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Al compartir este código, las personas podrán monitorear tus datos',
              style: TextStyle(
                color: Colors.red.shade300,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            QrImageView(
              data: FirebaseAuth.instance.currentUser?.uid ?? '',
              version: QrVersions.auto,
              size: 300,
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                  labelText: FirebaseAuth.instance.currentUser?.uid,
                  enabled: false),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // final String email = _controller.text;
                // MonitoringPermission().postUserPermissions(email);

                // _controller.clear();
                Clipboard.setData(ClipboardData(
                    text: FirebaseAuth.instance.currentUser?.uid ?? ''));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Código copiado al portapapeles.'),
                ));
              },
              child: const Text('Copiar'),
            ),
          ],
        ),
      ),
    );
  }
}

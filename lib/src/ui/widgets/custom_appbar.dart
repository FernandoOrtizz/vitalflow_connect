import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/doubleclickbidmanager/v2.dart';
import 'package:provider/provider.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/monitoring_permission.dart';
import 'package:vitalflow_connect/src/provider/drop_down_provider.dart';
import 'package:vitalflow_connect/src/provider/user.dart';
import 'package:vitalflow_connect/src/ui/pages/home/get_user_code_page.dart';
import 'package:vitalflow_connect/src/ui/pages/home/home_page.dart';
import 'package:vitalflow_connect/src/ui/pages/home/set_permissions.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final BuildContext context;
  List<Map<String, dynamic>> usersToMonitor = [];

  CustomAppBar({Key? key, required this.usersToMonitor, required this.context})
      : super(key: key);

  @override
  _CustomAppBarState createState() =>
      _CustomAppBarState(this.context, usersToMonitor);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String selectedOption = 'Mis datos';
  List<Map<String, dynamic>> usersTemp = [];

  List<Map<String, dynamic>> options = [];

  _CustomAppBarState(
      BuildContext context, List<Map<String, dynamic>> usersToMonitor) {
    usersTemp = usersToMonitor;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: MonitoringPermission()
            .getUserPermissions(FirebaseAuth.instance.currentUser?.email ?? ''),
        builder: _buildFuture);
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    if (!snapshot.hasData) {
      return AppBar();
    }

    options = [
      {'name': 'Ingresar token', 'mail': 'Ingresar token'},
      {'name': 'Generar token', 'mail': 'Generar token'},
      {'name': 'Mis datos', 'mail': FirebaseAuth.instance.currentUser?.email},
    ];

    options.addAll(snapshot.data);
    print('SNAPSHOT: $options');
    print('OPTIONS: $options');

    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text('VitalFlow'),
      actions: [
        _buildDropdownButton(context),
      ],
    );
  }

  Widget _buildDropdownButton(BuildContext context) {
    DorpDownProvider actualDropDownState =
        Provider.of<DorpDownProvider>(context, listen: false);

    return DropdownButton<String>(
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.white,
      ),
      value: actualDropDownState.dropDownEmail,
      onChanged: (String? newValue) {
        setState(() {
          selectedOption = newValue!;

          actualDropDownState.dropDownEmail = newValue;
        });

        if (newValue == 'Ingresar token') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SetPermissions(),
            ),
          );
          return;
        }

        if (newValue == 'Generar token') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GetUserCode(),
            ),
          );
          return;
        }

        setState(() {
          var user = Provider.of<CurrentUser>(context, listen: false);
          user.email = options
              .firstWhere((element) => element['mail'] == newValue)['mail'];

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        });
      },
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option['mail'],
          child: Container(
            decoration: BoxDecoration(
              color: option == selectedOption
                  ? Colors.deepPurple.shade400
                  : null, // Color de fondo blanco con opacidad
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(
                option['name'],
                style: TextStyle(
                  color: option == selectedOption
                      ? Colors.white
                      : Colors.deepPurple,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

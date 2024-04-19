import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalflow_connect/src/provider/user.dart';
import 'package:vitalflow_connect/src/ui/pages/home/set_permissions.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final BuildContext context;

  const CustomAppBar({Key? key, required this.context}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState(this.context);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String selectedOption = 'Mis datos';

  List<Map<String, dynamic>> options = [
    {'name': 'Ingresar token', 'mail': ''},
    {'name': 'Generar token', 'mail': ''},
    {'name': 'Mis datos', 'mail': FirebaseAuth.instance.currentUser?.email},
  ];

  _CustomAppBarState(BuildContext context) {
    options.addAll(context.watch<CurrentUser>().allowedUsersToMonitor);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text('VitalFlow'),
      actions: [
        _buildDropdownButton(context),
      ],
    );
  }

  Widget _buildDropdownButton(BuildContext context) {
    return DropdownButton<String>(
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.white,
      ),
      value: selectedOption,
      onChanged: (String? newValue) {
        setState(() {
          selectedOption = newValue!;

          // var user = context.read<CurrentUser>();
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
          return;
        }

        var user = Provider.of<CurrentUser>(context, listen: false);
        user.email = options
            .firstWhere((element) => element['name'] == newValue)['mail'];
      },
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option['name'],
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

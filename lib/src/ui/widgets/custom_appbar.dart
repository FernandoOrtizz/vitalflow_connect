import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalflow_connect/src/provider/user.dart';
import 'package:vitalflow_connect/src/ui/pages/home/set_permissions.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String selectedOption = 'Conectar mi VitalFlow';

  List<Map<String, dynamic>> options = [
    {'title': 'Conectar mi VitalFlow', 'email': ''},
    {'title': 'Vista General', 'email': ''},
  ];

  @override
  Widget build(BuildContext context) {
    options.addAll(context.watch<CurrentUser>().allowedUsersToMonitor);

    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text('VitalFlow'),
      actions: [
        _buildDropdownButton(),
      ],
    );
  }

  Widget _buildDropdownButton() {
    return DropdownButton<String>(
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.white,
      ),
      value: selectedOption,
      onChanged: (newValue) {
        setState(() {
          selectedOption = newValue!;

          var user = Provider.of<CurrentUser>(context, listen: true);
          user.email = user.allowedUsersToMonitor
              .firstWhere((element) => element['title'] == newValue)['email'];

          if (newValue == 'Conectar mi VitalFlow') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SetPermissions(),
              ),
            );
          }
        });
      },
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option['title'],
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
                option['title'],
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

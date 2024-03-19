import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text('VitalFlow'),
      actions: [
        _buildDropdownButton(),
      ],
    );
  }

  Widget _buildDropdownButton() {
    const List<String> options = [
      'Compartir mi VitalFlow',
      'Agregar un VitalFlow',
      'Vista General',
      'Fernando Manzanares',
      'Hernan Reyes',
      'Ericson Martinez',
    ];
    String selectedOption = options[3];

    return DropdownButton<String>(
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.white,
      ),
      value: selectedOption,
      onChanged: (newValue) {
        selectedOption = newValue!;
      },
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Container(
            decoration: BoxDecoration(
                color: option == selectedOption
                    ? Colors.deepPurple.shade400
                    : null, // Color de fondo blanco con opacidad
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(
                option,
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

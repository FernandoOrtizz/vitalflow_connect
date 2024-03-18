import 'package:flutter/material.dart';

class BottomMenu extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomMenu({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.shifting,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: 'Inicio',
          backgroundColor:
              Colors.deepPurple.shade400, // Color de fondo del ícono
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.history),
          label: 'Historial',
          backgroundColor:
              Colors.deepPurple.shade400, // Color de fondo del ícono
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: 'Perfil',
          backgroundColor:
              Colors.deepPurple.shade400, // Color de fondo del ícono
        ),
      ],
      selectedItemColor: Colors.white, // Color del texto e ícono seleccionado
      unselectedItemColor:
          Colors.deepPurple, // Color del texto e ícono no seleccionado
    );
  }
}

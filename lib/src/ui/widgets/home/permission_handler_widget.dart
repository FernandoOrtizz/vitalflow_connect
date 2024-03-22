import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDialog extends StatelessWidget {
  const PermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Permiso necesario'),
      content: const Text(
          'Para acceder a esta función, necesitamos el permiso de reconocimiento de actividad.'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            // Abrir la configuración de la aplicación para que el usuario pueda conceder el permiso manualmente
            openAppSettings();
          },
          child: const Text('Configuración'),
        ),
      ],
    );
  }
}

class PermissionHandlerWidget extends StatelessWidget {
  const PermissionHandlerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PermissionStatus>(
      future: Permission.activityRecognition.status,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var status = snapshot.data!;
          if (status.isGranted) {
            print('El permiso ACTIVITY_RECOGNITION ya está concedido.');
            return Container(); // Opcional: Devuelve un contenedor vacío si el permiso ya está concedido
          } else {
            // Muestra el diálogo de permisos si el permiso no está concedido
            return const PermissionDialog();
          }
        } else if (snapshot.hasError) {
          // Manejar errores si ocurren durante la obtención del estado del permiso
          print('Error al obtener el estado del permiso: ${snapshot.error}');
          return Container(); // Opcional: Devuelve un contenedor vacío en caso de error
        } else {
          // Muestra un indicador de carga mientras se obtiene el estado del permiso
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

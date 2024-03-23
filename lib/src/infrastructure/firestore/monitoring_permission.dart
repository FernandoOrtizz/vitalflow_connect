import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MonitoringPermission {
  final String collection = "monitoring_permissions";

  Future<List<Map<String, dynamic>>> getUserPermissions(String email) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('monitoring_permissions');

      QuerySnapshot querySnapshot =
          await users.where('user_id', isEqualTo: email).get();

      List<Map<String, dynamic>> permissions = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        permissions.addAll(data['monitoring_permissions'] ?? []);
      }

      return permissions;
    } catch (e) {
      print('Error al obtener los datos: $e');
      return [];
    }
  }

  Future<void> postUserPermissions(String email) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('monitoring_permissions');

      Map<String, dynamic> data = {
        'monitoring_permissions': [
          {
            'mail': FirebaseAuth.instance.currentUser?.email,
            'name': FirebaseAuth.instance.currentUser?.displayName,
          }
        ],
        'user_id': email,
      };

      // Agregar los datos a Firestore
      await users.add(data);

      print('Datos agregados exitosamente.');
    } catch (e) {
      print('Error al agregar los datos: $e');
    }
  }
}

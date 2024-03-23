import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MonitoringPermission {
  final String collection = "monitoring_permissions";

  Future<Map<String, dynamic>> getAvailableUserPermissions() async {
    final user = FirebaseAuth.instance.currentUser;
    var querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .orderBy("date", descending: true) // Ordenar por fecha descendente
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return {};
    }

    return querySnapshot.docs.first.data();
  }

  Future<bool> hasPermission() async {
    final user = FirebaseAuth.instance.currentUser;
    var querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .orderBy("date", descending: true) // Ordenar por fecha descendente
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return false;
    }

    return false;
  }
}

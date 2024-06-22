import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MonitoringPermission {
  final String collection = "monitoring_permissions";

  Future<List<Map<String, dynamic>>> getUserPermissions(String email) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('monitoring_permissions');

      //filtro .where no funciona
      QuerySnapshot querySnapshot =
          await users.where("user_id", isEqualTo: email).get();

      List<Map<String, dynamic>> permissions = [];

      List<MonitoringPermissionModel> permissionsModel = querySnapshot.docs
          .map((doc) => MonitoringPermissionModel(
              doc["monitoring_permissions"], doc["user_id"]))
          .toList();

      // for (var doc in querySnapshot.docs) {
      //   print("DATA");
      //   print(doc.data().monitoring_permissions);

      //   // Map<String, dynamic> data = doc.data()[" monitoring_permissions"] as Map<String, dynamic>;
      //   permissions.addAll(data['monitoring_permissions'] ?? []);
      // }

      for (int index = 0; index < permissionsModel.length; index++) {
        for (int i = 0;
            i < permissionsModel[index].monitoring_permissions.length;
            i++) {
          print('PERMISIONMODEL:');
          print(permissionsModel[index].monitoring_permissions[i]);
          permissions.add(permissionsModel[index].monitoring_permissions[i]);
        }
      }

      print('Arreglo de permisos: $permissions');

      // permissionsModel.map((permissionModel) => {
      //   print("----------------");

      //   permissionModel.monitoring_permissions.map((monitoringPermissionItem) {
      //     permissions.add(monitoringPermissionItem);
      //     print(monitoringPermissionItem);
      //   });
      // });

      // print("PERMISOS");
      // print(permissions);
      return permissions;
    } catch (e) {
      print('Error al obtener los datos: $e');
      return [];
    }
  }

  Future<void> postUserPermissions(String uid) async {
    var userInfo = await getUserToConnectEmail(uid);
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('monitoring_permissions');

      Map<String, dynamic> data = {
        'monitoring_permissions': [
          {
            'mail': userInfo['email'],
            'name': userInfo['displayName'],
          }
        ],
        'user_id': FirebaseAuth.instance.currentUser?.email,
      };

      // Agregar los datos a Firestore
      await users.add(data);

      print('Datos agregados exitosamente.');
    } catch (e) {
      print('Error al agregar los datos: $e');
    }
  }

  Future<Map<String, dynamic>> getUserToConnectEmail(String uid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where("userUID", isEqualTo: uid)
        .get();

    var userInfo = querySnapshot.docs.first.data();
    return userInfo as Map<String, dynamic>;
  }
}

class MonitoringPermissionModel {
  late String user_id;
  late List<dynamic> monitoring_permissions;

  MonitoringPermissionModel(this.monitoring_permissions, this.user_id);
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vitalflow_connect/src/application/sync/ports.dart';

class Activity implements Destination {
  @override
  Future<void> saveData(Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance.collection("steps").add(data);
      return Future.value();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Map<String, dynamic>> getData(String email) async {
    print(email);
    print('===============================');

    Map<String, dynamic> data = {};
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("steps")
          // .where("userEmail", isEqualTo: 'fernandomanzanares1999@gmail.com')
          .orderBy("date", descending: true) // Ordenar por fecha descendente
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        // Acceder a los datos del documento
        data = doc.data() as Map<String, dynamic>;
        print('Registro más reciente de pasos:');
        print(data);
      } else {
        print('No hay registros de pasos.');
      }

      return data;
    } catch (e) {
      throw Exception('Could not get steps from Google Fit. $e');
    }
  }
}

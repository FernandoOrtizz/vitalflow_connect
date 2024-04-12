import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vitalflow_connect/src/application/sync/ports.dart';

class HeartRate implements Destination {
  @override
  Future<void> saveData(Map<String, dynamic> data) async {
    try {
      // Save data to Firebase
      await FirebaseFirestore.instance.collection("bpm").add(data);
      return Future.value();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Map<String, dynamic>> getData(String email) async {
    Map<String, dynamic> data = {};
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("bpm")
          // .where("userEmail", isEqualTo: email)
          .orderBy("date", descending: true) // Ordenar por fecha descendente
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        // Acceder a los datos del documento
        data = doc.data() as Map<String, dynamic>;
        print('Registro más reciente de LPM:');
        print(data);
      } else {
        print('No hay registros de pasos.');
      }

      return data;
    } catch (e) {
      throw Exception('Could not get heart rate from Google Fit. $e');
    }
  }
}

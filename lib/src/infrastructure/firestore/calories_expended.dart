import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vitalflow_connect/src/application/sync/ports.dart';

class CaloriesExpended implements Destination {
  @override
  Future<void> saveData(Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection("calories_expended")
          .add(data);
      return Future.value();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<String> getData() async {
    Map<String, dynamic> data = {};
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("calories_expended")
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

      return data["value"];
    } catch (e) {
      throw Exception('Could not get calories_expended from Google Fit. $e');
    }
  }
}

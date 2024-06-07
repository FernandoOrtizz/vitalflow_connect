import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:vitalflow_connect/src/application/report/ports.dart';
import 'package:vitalflow_connect/src/application/sync/ports.dart';
import 'package:vitalflow_connect/src/infrastructure/firestore/activity.dart';

class CaloriesExpended implements Destination, VitalFlowRepository {
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

  Future<Map<String, dynamic>> getData(String email) async {
    Map<String, dynamic> data = {};
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("calories_expended")
          // .where("userEmail", isEqualTo: email)
          .orderBy("date", descending: true) // Ordenar por fecha descendente
          .limit(1)
          .get();

      print('MONITOREANDO A:');
      print(email);

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        // Acceder a los datos del documento
        data = doc.data() as Map<String, dynamic>;
        print('Registro más reciente de calorías:');
        print(data);
      } else {
        print('No hay registros de pasos.');
      }

      return data;
    } catch (e) {
      throw Exception('Could not get calories_expended from Google Fit. $e');
    }
  }

  Future<Map<String, double>> getDailyAverageData(
      String email, DateTime startDate, DateTime endDate) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("calories_expended")
          .where("userEmail", isEqualTo: email)
          .where("date", isLessThan: endDate)
          .where("date", isGreaterThan: startDate)
          .orderBy("date", descending: true)
          .get();

      Map<String, List<double>> data = {};
      for (var docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> doc = docSnapshot.data() as Map<String, dynamic>;

        DateTime date = doc['date'].toDate() ?? '';

        String weekDayKey = translateDay[DateFormat('EEEE').format(date)]!;
        List<double>? values = data[weekDayKey];
        values ??= [];
        values.add(doc['value']);

        data[weekDayKey] = values;
      }

      Map<String, double> averageData = {};

      data.forEach((key, value) {
        double average = 0;
        value.forEach((element) {
          average += element;
        });
        average /= value.length;
        averageData[key] = average;
      });

      return averageData;
    } catch (e) {
      throw Exception('Could not get calories from Google Fit. $e');
    }
  }

  Future<Map<String, double>> getWeeklyAverageData(
      String email, DateTime startDate, DateTime endDate) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("calories_expended")
          .where("userEmail", isEqualTo: email)
          .where("date", isLessThan: endDate)
          .where("date", isGreaterThan: startDate)
          .orderBy("date", descending: true)
          .get();

      Map<String, List<Map<String, dynamic>>> data = {};
      Map<String, List<Map<String, dynamic>>> dateFormatedData = {};
      Map<String, double> averageData = {};

      for (var docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> doc = docSnapshot.data() as Map<String, dynamic>;

        DateTime date = doc['date'].toDate() ?? '';

        String week =
            weeksBetween(DateTime(DateTime.now().year, 1, 1), date).toString();
        List<Map<String, dynamic>>? values = data[week];
        values ??= [];
        values.add({'value': doc['value'], 'date': date});
        data[week] = values;
      }

      // String name;

      data.forEach((key, value) {
        String startDate = DateFormat('yMMMMEEEEd').format(value[0]['date']);

        String endDate =
            DateFormat('yMMMMEEEEd').format(value[value.length - 1]['date']);

        String dateRange = 'From $startDate to $endDate';

        dateFormatedData[dateRange] = value;
      });

      dateFormatedData.forEach((key, value) {
        double average = 0;
        value.forEach((element) {
          average += element["value"];
        });
        average /= value.length;
        averageData[key] = average;
      });

      return averageData;
    } catch (e) {
      throw Exception('Could not get calories from Google Fit. $e');
    }
  }

  Future<Map<String, double>> getMonthlyAverageData(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("calories_expended")
          .where("userEmail", isEqualTo: email)
          .where("date", isLessThan: DateTime(DateTime.now().year, 1, 1))
          .where("date", isGreaterThan: DateTime.now())
          .orderBy("date", descending: true)
          .get();

      Map<String, List<double>> data = {};
      for (var docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> doc = docSnapshot.data() as Map<String, dynamic>;

        DateTime date = doc['date'].toDate() ?? '';

        String monthKey = translateDay[DateFormat('MMMM').format(date)]!;
        List<double>? values = data[monthKey];
        values ??= [];
        values.add(doc['value']);

        data[monthKey] = values;
      }

      Map<String, double> averageData = {};

      data.forEach((key, value) {
        double average = 0;
        for (var element in value) {
          average += element;
        }
        average /= value.length;
        averageData[key] = average;
      });

      return averageData;
    } catch (e) {
      throw Exception('Could not get calories from Google Fit. $e');
    }
  }

  String getVitalFlowName() {
    return 'calories_expended';
  }
}

int weeksBetween(DateTime from, DateTime to) {
  from = DateTime.utc(from.year, from.month, from.day);
  to = DateTime.utc(to.year, to.month, to.day);
  return (to.difference(from).inDays / 7).ceil();
}

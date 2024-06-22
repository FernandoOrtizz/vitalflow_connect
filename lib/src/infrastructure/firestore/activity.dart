import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vitalflow_connect/src/application/report/ports.dart';
import 'package:vitalflow_connect/src/application/sync/ports.dart';
import 'package:intl/intl.dart';

class Activity implements Destination, VitalFlowRepository {
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
    Map<String, dynamic> data = {};
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("steps")
          .where("userEmail", isEqualTo: email)
          .orderBy("date", descending: true) // Ordenar por fecha descendente
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        // Acceder a los datos del documento
        data = doc.data() as Map<String, dynamic>;
      } else {
        print('No hay registros de pasos.');
      }

      return data;
    } catch (e) {
      throw Exception('Could not get steps from Google Fit. $e');
    }
  }

  @override
  Future<Map<String, double>> getDailyAverageData(
      String email, DateTime startDate, DateTime endDate) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("steps")
          .where("userEmail", isEqualTo: email)
          .where("date", isLessThan: endDate)
          .where("date", isGreaterThan: startDate)
          .orderBy("date", descending: true)
          .get();

      Map<String, List<int>> data = {};
      for (var docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> doc = docSnapshot.data() as Map<String, dynamic>;

        DateTime date = doc['date'].toDate() ?? '';

        String weekDayKey = translateDay[DateFormat('EEEE').format(date)]!;
        List<int>? values = data[weekDayKey];
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
      throw Exception('Could not get steps from Google Fit. $e');
    }
  }

  @override
  Future<Map<String, double>> getWeeklyAverageData(
      String email, DateTime startDate, DateTime endDate) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("steps")
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

      data.forEach((key, value) {
        Map<String, DateTime> weekStartEndDate =
            getStartAndEndDateOfWeek(int.parse(key), 2024);

        String startDate = DateFormat('MMMM d', 'es_ES')
            .format(weekStartEndDate['startOfWeek'] ?? DateTime.now());

        String endDate = DateFormat('MMMM d', 'es_ES')
            .format(weekStartEndDate['endOfWeek'] ?? DateTime.now());

        String dateRange = '$startDate - $endDate';

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
      throw Exception('Could not get steps from Google Fit. $e');
    }
  }

  @override
  Future<Map<String, double>> getMonthlyAverageData(
      String email, DateTime startDate, DateTime endDate) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("steps")
          .where("userEmail", isEqualTo: email)
          .where("date", isGreaterThan: startDate)
          .where("date", isLessThan: endDate)
          .orderBy("date", descending: true)
          .get();

      Map<String, List<int>> data = {};
      for (var docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> doc = docSnapshot.data() as Map<String, dynamic>;

        DateTime date = doc['date'].toDate() ?? DateTime.now();

        String monthKey = translateMonth[DateFormat('MMMM').format(date)] ?? '';

        List<int>? values = data[monthKey];
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
      throw Exception('Could not get steps from Google Fit. $e');
    }
  }

  @override
  String getVitalFlowName() {
    return 'activity';
  }

  @override
  Future<List<double>> getDailyDataGroupedByHour(
      String email, DateTime startDate, DateTime endDate) async {
    List<double> valuePerHour = [];

    for (var i = 0; i < 24; i++) {
      valuePerHour.add(0);
    }

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("steps")
          .where("userEmail", isEqualTo: email)
          .where("date", isGreaterThan: startDate)
          .where("date", isLessThan: endDate)
          .orderBy("date", descending: true)
          .get();

      for (var docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> doc = docSnapshot.data() as Map<String, dynamic>;

        DateTime date = doc['date'].toDate() ?? '';
        int key = date.hour - 1;
        double currentValue = valuePerHour[key];
        currentValue += doc['value'];
        valuePerHour[key] = currentValue;
      }
    } catch (e) {
      throw Exception('Could not get steps from Google Fit. $e');
    }

    return valuePerHour;
  }

  @override
  Future<Map<String, double>> getWeeklyDataGroupedByDay(
      String email, DateTime startDate, DateTime endDate) async {
    Map<String, double> valuePerDay = {};

    for (var i = 0; i < 7; i++) {
      String weekDayKey = translateDay[
          DateFormat('EEEE').format(startDate.add(Duration(days: i)))]!;
      valuePerDay[weekDayKey] = 0;
    }

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("steps")
          .where("userEmail", isEqualTo: email)
          .where("date", isLessThan: endDate)
          .where("date", isGreaterThan: startDate)
          .orderBy("date", descending: true)
          .get();

      for (var docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> doc = docSnapshot.data() as Map<String, dynamic>;
        DateTime date = doc['date'].toDate() ?? '';

        String weekDayKey = translateDay[DateFormat('EEEE').format(date)]!;
        double currentValue = valuePerDay[weekDayKey] ?? 0;
        currentValue += doc['value'];
        valuePerDay[weekDayKey] = currentValue;
      }
    } catch (e) {
      throw Exception('Could not get steps from Google Fit. $e');
    }

    return valuePerDay;
  }

  @override
  Future<Map<String, double>> getMonthDataGroupedByWeek(
      String email, DateTime startDate, DateTime endDate) async {
    Map<String, double> valuePerWeek = {};
    Map<String, Map<String, dynamic>> tempValuePerWeek = {};

    for (var i = 0; i < 4; i++) {
      DateTime weekEndDate = endDate.add(Duration(days: -(7 * i)));
      if (weekEndDate.isBefore(startDate)) {
        continue;
      }
      String weekEndDateFormat =
          DateFormat('MMMM d', 'es_ES').format(weekEndDate);

      DateTime weekStartDate = weekEndDate.add(const Duration(days: -7));
      if (weekStartDate.isBefore(startDate)) {
        weekStartDate = startDate;
      }

      String weekStartDateFormat =
          DateFormat('MMMM d', 'es_ES').format(weekStartDate);

      tempValuePerWeek['$weekStartDateFormat - $weekEndDateFormat'] = {
        'startDate': weekStartDate,
        'endDate': weekEndDate,
        'value': 0,
      };
    }

    for (var key in tempValuePerWeek.keys) {
      var value = tempValuePerWeek[key];

      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("steps")
            .where("userEmail", isEqualTo: email)
            .where("date", isGreaterThan: value?['startDate'])
            .where("date", isLessThan: value?['endDate'])
            .orderBy("date", descending: true)
            .get();

        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> doc = docSnapshot.data() as Map<String, dynamic>;

          double currentValue = valuePerWeek[key] ?? 0;
          currentValue += doc['value'];

          valuePerWeek[key] = currentValue;
        }
      } catch (e) {
        throw Exception('Could not get steps from Google Fit. $e');
      }

      valuePerWeek = valuePerWeek;
    }

    return valuePerWeek;
  }
}

var translateDay = {
  'Monday': 'Lunes',
  'Tuesday': 'Martes',
  'Wednesday': 'Miércoles',
  'Thursday': 'Jueves',
  'Friday': 'Viernes',
  'Saturday': 'Sábado',
  'Sunday': 'Domingo'
};

var translateMonth = {
  'January': 'Enero',
  'February': 'Febrero',
  'March': 'Marzo',
  'April': 'Abril',
  'May': 'Mayo',
  'June': 'Junio',
  'July': 'Julio',
  'August': 'Agosto',
  'September': 'Septiembre',
  'October': 'Octubre',
  'November': 'Noviembre',
  'December': 'Diciembre'
};

int weeksBetween(DateTime from, DateTime to) {
  from = DateTime.utc(from.year, from.month, from.day);
  to = DateTime.utc(to.year, to.month, to.day);
  return (to.difference(from).inDays / 7).ceil();
}

Map<String, DateTime> getStartAndEndDateOfWeek(int weekNumber, int year) {
  // Encuentra el primer día del año
  DateTime firstDayOfYear = DateTime.utc(year);
  // Encuentra el primer lunes del año
  DateTime firstMonday =
      firstDayOfYear.add(Duration(days: (8 - firstDayOfYear.weekday) % 7));
  // Calcula la fecha de inicio de la semana dada
  DateTime startOfWeek = firstMonday.add(Duration(days: (weekNumber - 1) * 7));
  // Calcula la fecha de fin de la semana
  DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

  return {
    'startOfWeek': startOfWeek,
    'endOfWeek': endOfWeek,
  };
}

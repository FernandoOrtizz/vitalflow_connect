import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vitalflow_connect/src/infrastructure/google_signin/signin.dart';

class Request {
  GoogleAuth authService;

  Request({
    required this.authService,
  });

  Future<Map<String, dynamic>> get(String url) async {
    var date = DateTime.now();

    int startTime =
        convertToNanoseconds(DateTime(date.year, date.month, date.day, 0, 0));
    int endTime = convertToNanoseconds(DateTime.now());

    var token = authService.accessToken;
    Map<String, String> headers = {'Authorization': "Bearer $token"};

    try {
      http.Response response = await http
          .get(Uri.parse('$url/$startTime-$endTime'), headers: headers);

      if (response.statusCode != 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        throw Exception(
            'Could not get data from Google Fit, unexpected status code. $body');
      }

      Map<String, dynamic> responseToMap = jsonDecode(response.body);
      Map<String, dynamic> mapSerialized = extractLastPoint(responseToMap);

      return mapSerialized;
    } catch (e) {
      throw Exception('Could not get data from Google Fit. $e');
    }
  }

  int convertToNanoseconds(DateTime fecha) {
    int result = fecha.microsecondsSinceEpoch * 1000;
    return result;
  }

  Map<String, dynamic> extractLastPoint(
      Map<String, dynamic> responseSerialized) {
    List<dynamic> point = responseSerialized['point'];
    if (point.isEmpty) {
      return {};
    }
    Map<String, dynamic> lastPoint = point.last;

    var date = decodeMiliseconds(int.parse(lastPoint['modifiedTimeMillis']));

    Map<String, dynamic> extractedData = {
      'value': lastPoint['value'][0]['fpVal'],
      'modifiedTimeMillis': lastPoint['modifiedTimeMillis'],
      'date': date,
      'userMail': ''
    };

    return extractedData;
  }

  DateTime decodeMiliseconds(int miliseconds) {
    return DateTime.fromMillisecondsSinceEpoch(miliseconds);
  }
}

import 'package:http/http.dart' as http;
import 'package:vitalflow_connect/src/infrastructure/google_signin/signin.dart';

class Request {
  GoogleAuthService authService;

  Request({
    required this.authService,
  });

  Future<List<dynamic>> get(String url) async {
    try {
      int startTime = convertToNanoseconds(DateTime(2024, 3, 22, 0, 0));
      int endTime = convertToNanoseconds(DateTime.now());

      Map<String, String> headers = {
        'Authorization': "Bearer $authService.accessToken"
      };
      http.Response response = await http
          .get(Uri.parse('$url/$startTime-$endTime'), headers: headers);

      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      throw Exception('Could not get data from Google Fit.');
    }
    return [];
  }

  int convertToNanoseconds(DateTime fecha) {
    int result = fecha.microsecondsSinceEpoch * 1000;
    return result;
  }
}

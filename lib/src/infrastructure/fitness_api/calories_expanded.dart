import 'request.dart';
import 'package:vitalflow_connect/src/application/sync/ports.dart';

class CaloriesExpended implements Source {
  Request request;

  CaloriesExpended({required this.request});

  @override
  Future<Map<String, dynamic>> getData() async {
    try {
      Map<String, dynamic> data = await request.get(
          'https://www.googleapis.com/fitness/v1/users/me/dataSources/derived:com.google.calories.expended:com.google.android.gms:merge_calories_expended/datasets');

      print('Registro más reciente de calorías (API):');
      print(data);

      return data;
    } catch (e) {
      print('Error: $e');
    }

    return {};
  }
}

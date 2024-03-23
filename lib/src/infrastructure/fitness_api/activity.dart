import 'request.dart';
import 'package:vitalflow_connect/src/application/sync/ports.dart';

class Activity implements Source {
  Request request;

  Activity({required this.request});

  @override
  Future<Map<String, dynamic>> getData() async {
    try {
      Map<String, dynamic> data = await request.get(
          'https://www.googleapis.com/fitness/v1/users/me/dataSources/derived:com.google.step_count.delta:com.google.android.gms:estimated_steps/datasets');

      return data;
    } catch (e) {
      print('Error: $e');
    }

    return {};
  }
}

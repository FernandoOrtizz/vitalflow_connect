import 'request.dart';
import 'package:vitalflow_connect/src/application/sync/ports.dart';

class RestingHeartRate implements Source {
  Request request;

  RestingHeartRate({required this.request});

  @override
  Future<Map<String, dynamic>> getData() async {
    try {
      Map<String, dynamic> data = await request.get(
          'https://www.googleapis.com/fitness/v1/users/me/dataSources/derived:com.google.heart_rate.bpm:com.google.android.gms:resting_heart_rate<-merge_heart_rate_bpm/datasets');

      return data;
    } catch (e) {
      print('Error: $e');
    }

    return {};
  }
}

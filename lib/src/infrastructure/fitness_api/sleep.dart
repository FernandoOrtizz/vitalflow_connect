import 'request.dart';
import 'package:vitalflow_connect/src/application/sync/ports.dart';

class Sleep implements Source {
  Request request;

  Sleep({required this.request});

  @override
  Future<Map<String, dynamic>> getData() async {
    try {
      Map<String, dynamic> data = await request.get(
          'https://www.googleapis.com/fitness/v1/users/me/dataSources/derived:com.google.sleep.segment:com.google.android.gms:merged/datasets');

      return data;
    } catch (e) {
      print('Error: $e');
    }

    return {};
  }
}

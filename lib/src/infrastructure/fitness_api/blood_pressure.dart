import 'request.dart';
import 'package:vitalflow_connect/src/application/sync/ports.dart';

class BloodPreassure implements Source {
  Request request;

  BloodPreassure({required this.request});

  Future<Map<String, dynamic>> getData() async {
    try {
      Map<String, dynamic> data = await request.get('');

      return data;
    } catch (e) {
      print('Error: $e');
    }

    return {};
  }
}

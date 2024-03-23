import 'request.dart';
import 'package:vitalflow_connect/src/application/sync/ports.dart';

class BloodPreassure implements Source {
  Request request;

  BloodPreassure({required this.request});

  Future<List<dynamic>> getData() async {
    try {
      List<dynamic> data = await request.get('');

      return data;
    } catch (e) {
      print('Error: $e');
    }

    return [];
  }
}

import 'ports.dart';
import 'package:vitalflow_connect/src/application/runner/ports.dart';

class SyncUseCase implements Sync {
  Source _source;
  Destination _destination;

  SyncUseCase(this._source, this._destination);

  Future<void> sync() async {
    try {
      var data = await _source.getData();
      await _destination.saveData(data);
    } catch (e) {
      print('Error: $e');
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';

import 'ports.dart';
import 'package:vitalflow_connect/src/application/runner/ports.dart';

class SyncUseCase implements Sync {
  Source _source;
  Destination _destination;

  SyncUseCase(this._source, this._destination);

  Future<void> sync() async {
    try {
      var data = await _source.getData();
      if (data.isEmpty) {
        return;
      }

      var duplicatedData = await _destination
          .getData(FirebaseAuth.instance.currentUser?.email ?? '');
      if (duplicatedData.isNotEmpty) {
        return;
      }

      await _destination.saveData(data);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

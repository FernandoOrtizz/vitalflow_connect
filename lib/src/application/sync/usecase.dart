import 'package:firebase_auth/firebase_auth.dart';

import 'ports.dart';
import 'package:vitalflow_connect/src/application/runner/ports.dart';

class SyncUseCase implements Sync {
  Source _source;
  Destination _destination;

  SyncUseCase(this._source, this._destination);

  Future<void> sync() async {
    try {
      var dataSource = await _source.getData();
      if (dataSource.isEmpty) {
        return;
      }

      var dataDestination = await _destination
          .getData(FirebaseAuth.instance.currentUser?.email ?? '');
      if (dataDestination["modifiedTimeMillis"] ==
          dataSource["modifiedTimeMillis"]) {
        print("Duplicated data");
        return;
      }

      await _destination.saveData(dataSource);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

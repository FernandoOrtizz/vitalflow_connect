import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'ports.dart';
import 'package:vitalflow_connect/src/application/runner/ports.dart';

class SyncUseCase implements Sync {
  Source source;
  Destination destination;
  String email;

  SyncUseCase(this.source, this.destination, this.email);

  Future<void> sync() async {
    try {
      var dataSource = await source.getData();
      if (dataSource.isEmpty) {
        return;
      }

      var dataDestination = await destination.getData(email);
      if (dataDestination["modifiedTimeMillis"] ==
          dataSource["modifiedTimeMillis"]) {
        print("Duplicated data");
        return;
      }

      await destination.saveData(dataSource);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

import 'ports.dart';

class Runner {
  List<Sync> list;

  Runner(this.list);

  Future<void> execute() async {
    try {
      for (var sync in list) {
        await sync.sync();
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

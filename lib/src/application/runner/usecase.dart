import 'ports.dart';

class Runner {
  List<Sync> list;

  Runner(this.list);

  Future<void> execute() async {
    try {
      for (var item in list) {
        await item.sync();
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

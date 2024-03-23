abstract class Source {
  Future<List<dynamic>> getData();
}

abstract class Destination {
  Future<void> saveData(List<dynamic> data);
}

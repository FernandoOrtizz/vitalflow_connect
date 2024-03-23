abstract class Source {
  Future<Map<String, dynamic>> getData();
}

abstract class Destination {
  Future<void> saveData(Map<String, dynamic> data);
  Future<Map<String, dynamic>> getData(String email);
}

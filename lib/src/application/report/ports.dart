abstract class VitalFlowRepository {
  Future<Map<String, double>> getDailyAverageData(
      String email, DateTime startDate, DateTime endDate);
  Future<Map<String, double>> getWeeklyAverageData(
      String email, DateTime startDate, DateTime endDate);
  Future<Map<String, double>> getMonthlyAverageData(String email);
  String getVitalFlowName();
}

abstract class VitalFlowRepository {
  Future<Map<String, double>> getDailyAverageData(
      String email, DateTime startDate, DateTime endDate);
  Future<Map<String, double>> getWeeklyAverageData(
      String email, DateTime startDate, DateTime endDate);
  Future<Map<String, double>> getMonthlyAverageData(
      String email, DateTime startDate, DateTime endDate);

  // Data for charts
  Future<List<double>> getDailyDataGroupedByHour(
      String email, DateTime startDate, DateTime endDate);
  Future<Map<String, double>> getWeeklyDataGroupedByDay(
      String email, DateTime startDate, DateTime endDate);
  Future<Map<String, double>> getMonthDataGroupedByWeek(
      String email, DateTime startDate, DateTime endDate);

  String getVitalFlowName();
}

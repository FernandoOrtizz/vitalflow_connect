import 'package:vitalflow_connect/src/application/report/ports.dart';

class Report {
  late List<VitalFlowRepository> _vitalFlows;

  Report(List<VitalFlowRepository> vitalFlows) {
    _vitalFlows = vitalFlows;
  }

  Future<Map<String, Map<String, double>>> getDailyAverageData(
      String email, DateTime startDate, DateTime endDate) async {
    Map<String, Map<String, double>> result = {};
    for (var vitalFlow in _vitalFlows) {
      var data = await vitalFlow.getDailyAverageData(email, startDate, endDate);
      result.addAll({vitalFlow.getVitalFlowName(): data});
    }

    return result;
  }

  Future<Map<String, Map<String, double>>> getWeeklyAverageData(
      String email, DateTime startDate, DateTime endDate) async {
    Map<String, Map<String, double>> result = {};
    for (var vitalFlow in _vitalFlows) {
      var data =
          await vitalFlow.getWeeklyAverageData(email, startDate, endDate);
      result.addAll({vitalFlow.getVitalFlowName(): data});
    }

    return result;
  }

  Future<Map<String, Map<String, double>>> getMonthlyAverageData(
      String email, DateTime startDate, DateTime endDate) async {
    Map<String, Map<String, double>> result = {};
    for (var vitalFlow in _vitalFlows) {
      var data =
          await vitalFlow.getMonthlyAverageData(email, startDate, endDate);
      result.addAll({vitalFlow.getVitalFlowName(): data});
    }

    return result;
  }

  Future<Map<String, List<double>>> getDailyDataGroupedByHour(
      String email, DateTime startDate, DateTime endDate) async {
    Map<String, List<double>> result = {};
    for (var vitalFlow in _vitalFlows) {
      var data =
          await vitalFlow.getDailyDataGroupedByHour(email, startDate, endDate);
      result.addAll({vitalFlow.getVitalFlowName(): data});
    }

    return result;
  }

  Future<Map<String, Map<String, double>>> getWeeklyDataGroupedByDay(
      String email, DateTime startDate, DateTime endDate) async {
    Map<String, Map<String, double>> result = {};
    for (var vitalFlow in _vitalFlows) {
      var data =
          await vitalFlow.getWeeklyDataGroupedByDay(email, startDate, endDate);
      result.addAll({vitalFlow.getVitalFlowName(): data});
    }

    return result;
  }

  Future<Map<String, Map<String, double>>> getMonthlyDataGroupedByWeek(
      String email, DateTime startDate, DateTime endDate) async {
    Map<String, Map<String, double>> result = {};
    for (var vitalFlow in _vitalFlows) {
      var data =
          await vitalFlow.getMonthDataGroupedByWeek(email, startDate, endDate);
      result.addAll({vitalFlow.getVitalFlowName(): data});
    }

    return result;
  }
}

import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/dashboard_stats_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardStatsModel> getStats();
  Future<void> acknowledgeAlert(int alertId);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient apiClient;

  DashboardRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<DashboardStatsModel> getStats() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.dashboardStats);
      return DashboardStatsModel.fromJson(response.data);
    } on DioException catch (_) {
      // Return default prototype dataset if endpoint is in dev or network is unreachable
      return DashboardStatsModel.fromJson({});
    }
  }

  @override
  Future<void> acknowledgeAlert(int alertId) async {
    try {
      await apiClient.dio.patch(ApiConstants.updateIncidentStatus(alertId), data: {
        'status': 'acknowledged',
      });
    } catch (_) {
      // Local optimistic update
    }
  }
}

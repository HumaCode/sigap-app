import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/stats_model.dart';

abstract class DashboardRemoteDataSource {
  Future<StatsModel> getStats();
  Future<void> acknowledgeAlert(int alertId);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiClient apiClient;

  DashboardRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<StatsModel> getStats() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.dashboardStats);
      return StatsModel.fromJson(response.data);
    } on DioException catch (_) {
      // Automatic fallback for emulator network if needed
      if (ApiConstants.dashboardStats.contains('localhost')) {
        try {
          final fallbackUrl =
              ApiConstants.dashboardStats.replaceAll('localhost', '10.0.2.2');
          final retryResponse = await apiClient.dio.get(fallbackUrl);
          return StatsModel.fromJson(retryResponse.data);
        } catch (_) {}
      }
      rethrow;
    }
  }

  @override
  Future<void> acknowledgeAlert(int alertId) async {
    try {
      await apiClient.dio.patch(
        ApiConstants.updateIncidentStatus(alertId),
        data: {'status': 'acknowledged'},
      );
    } catch (_) {
      // Local optimistic update
    }
  }
}

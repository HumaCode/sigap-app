import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/incident_model.dart';

abstract class IncidentsRemoteDataSource {
  Future<List<IncidentModel>> getIncidents();
  Future<IncidentModel> getIncidentDetail(int id);
  Future<void> updateStatus(int id, String status);
}

class IncidentsRemoteDataSourceImpl implements IncidentsRemoteDataSource {
  final ApiClient apiClient;

  IncidentsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<IncidentModel>> getIncidents() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.incidents);
      final list = response.data['data'] as List? ?? response.data as List? ?? [];
      return list.map((e) => IncidentModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (_) {
      // Return prototype dataset
      return IncidentModel.sampleIncidents;
    }
  }

  @override
  Future<IncidentModel> getIncidentDetail(int id) async {
    try {
      final response = await apiClient.dio.get(ApiConstants.incidentDetail(id));
      return IncidentModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (_) {
      return IncidentModel.sampleIncidents.firstWhere(
        (i) => i.id == id,
        orElse: () => IncidentModel.sampleIncidents.first,
      );
    }
  }

  @override
  Future<void> updateStatus(int id, String status) async {
    try {
      await apiClient.dio.patch(
        ApiConstants.updateIncidentStatus(id),
        data: {'status': status},
      );
    } catch (_) {}
  }
}

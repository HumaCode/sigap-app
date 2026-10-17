import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/incident_model.dart';
import '../models/insiden_model.dart';

abstract class IncidentsRemoteDataSource {
  Future<InsidenModel> getIncidentsModel({int page = 1, String? severity, String? status});
  Future<List<IncidentModel>> getIncidents();
  Future<IncidentModel> getIncidentDetail(dynamic id);
  Future<void> updateStatus(dynamic id, String status);
  Future<void> addNote(dynamic id, String note);
}

class IncidentsRemoteDataSourceImpl implements IncidentsRemoteDataSource {
  final ApiClient apiClient;

  IncidentsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<InsidenModel> getIncidentsModel({int page = 1, String? severity, String? status}) async {
    final queryParams = <String, dynamic>{
      'page': page,
      if (severity != null && severity.isNotEmpty && severity != 'all') 'severity': severity,
      if (status != null && status.isNotEmpty && status != 'all') 'status': status,
    };
    final response = await apiClient.dio.get(
      ApiConstants.incidents,
      queryParameters: queryParams,
    );
    return InsidenModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<IncidentModel>> getIncidents() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.incidents);
      final rawData = response.data;
      if (rawData is Map<String, dynamic>) {
        if (rawData['data'] is Map<String, dynamic> &&
            (rawData['data'] as Map<String, dynamic>)['items'] is List) {
          final insidenModel = InsidenModel.fromJson(rawData);
          return insidenModel.data.items
              .map((e) => IncidentModel.fromItem(e))
              .toList();
        } else if (rawData['data'] is List) {
          final list = rawData['data'] as List;
          return list
              .map((e) => IncidentModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      } else if (rawData is List) {
        return rawData
            .map((e) => IncidentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (_) {
      return [];
    }
  }

  @override
  Future<IncidentModel> getIncidentDetail(dynamic id) async {
    try {
      final response = await apiClient.dio.get(ApiConstants.incidentDetail(id));
      final rawData = response.data;
      if (rawData is Map<String, dynamic> &&
          rawData['data'] is Map<String, dynamic>) {
        final dataMap = rawData['data'] as Map<String, dynamic>;
        if (dataMap.containsKey('incident_code') || dataMap.containsKey('metrics')) {
          return IncidentModel.fromItem(Item.fromJson(dataMap));
        }
        return IncidentModel.fromJson(dataMap);
      }
      return IncidentModel.fromJson(rawData as Map<String, dynamic>);
    } catch (_) {
      return IncidentModel.sampleIncidents.firstWhere(
        (i) => i.id.toString() == id.toString(),
        orElse: () => IncidentModel.sampleIncidents.first,
      );
    }
  }

  @override
  Future<void> updateStatus(dynamic id, String status) async {
    try {
      await apiClient.dio.patch(
        ApiConstants.updateIncidentStatus(id),
        data: {'status': status},
      );
    } catch (_) {}
  }

  @override
  Future<void> addNote(dynamic id, String note) async {
    try {
      await apiClient.dio.post(
        ApiConstants.incidentNotes(id),
        data: {'note': note},
      );
    } catch (_) {}
  }
}

import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/service_site_model.dart';

abstract class ServicesRemoteDataSource {
  Future<List<ServiceSiteModel>> getServices();
  Future<ServiceSiteModel> getServiceDetail(int id);
  Future<void> triggerCheck(int id);
}

class ServicesRemoteDataSourceImpl implements ServicesRemoteDataSource {
  final ApiClient apiClient;

  ServicesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ServiceSiteModel>> getServices() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.sites);
      final list = response.data['data'] as List? ?? response.data as List? ?? [];
      return list.map((e) => ServiceSiteModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (_) {
      // Fallback sample services dataset
      return ServiceSiteModel.sampleServices;
    }
  }

  @override
  Future<ServiceSiteModel> getServiceDetail(int id) async {
    try {
      final response = await apiClient.dio.get(ApiConstants.siteDetail(id));
      return ServiceSiteModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (_) {
      return ServiceSiteModel.sampleServices.firstWhere(
        (s) => s.id == id,
        orElse: () => ServiceSiteModel.sampleServices.first,
      );
    }
  }

  @override
  Future<void> triggerCheck(int id) async {
    try {
      await apiClient.dio.post(ApiConstants.siteCheck(id));
    } catch (_) {}
  }
}

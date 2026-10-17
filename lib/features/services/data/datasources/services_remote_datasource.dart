import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/service_site_model.dart';
import '../models/sites_model.dart';

abstract class ServicesRemoteDataSource {
  Future<SitesModel> getSites({int page = 1, String? search, String? status});
  Future<List<ServiceSiteModel>> getServices();
  Future<ServiceSiteModel> getServiceDetail(dynamic id);
  Future<void> triggerCheck(dynamic id);
}

class ServicesRemoteDataSourceImpl implements ServicesRemoteDataSource {
  final ApiClient apiClient;

  ServicesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<SitesModel> getSites({int page = 1, String? search, String? status}) async {
    final queryParams = <String, dynamic>{
      'page': page,
      if (search != null && search.isNotEmpty) 'search': search,
      if (status != null && status.isNotEmpty && status != 'all') 'status': status,
    };
    final response = await apiClient.dio.get(
      ApiConstants.sites,
      queryParameters: queryParams,
    );
    return SitesModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<ServiceSiteModel>> getServices() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.sites);
      final rawData = response.data;
      if (rawData is Map<String, dynamic>) {
        if (rawData['data'] is Map<String, dynamic> &&
            (rawData['data'] as Map<String, dynamic>)['items'] is List) {
          final sitesModel = SitesModel.fromJson(rawData);
          return sitesModel.data.items
              .map((e) => ServiceSiteModel.fromItem(e))
              .toList();
        } else if (rawData['data'] is List) {
          final list = rawData['data'] as List;
          return list
              .map((e) => ServiceSiteModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      } else if (rawData is List) {
        return rawData
            .map((e) => ServiceSiteModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (_) {
      return [];
    }
  }

  @override
  Future<ServiceSiteModel> getServiceDetail(dynamic id) async {
    try {
      final response = await apiClient.dio.get(ApiConstants.siteDetail(id));
      final rawData = response.data;
      if (rawData is Map<String, dynamic> &&
          rawData['data'] is Map<String, dynamic>) {
        final dataMap = rawData['data'] as Map<String, dynamic>;
        if (dataMap.containsKey('url') || dataMap.containsKey('latency')) {
          return ServiceSiteModel.fromItem(Item.fromJson(dataMap));
        }
        return ServiceSiteModel.fromJson(dataMap);
      }
      return ServiceSiteModel.fromJson(rawData as Map<String, dynamic>);
    } catch (_) {
      return ServiceSiteModel.sampleServices.firstWhere(
        (s) => s.id.toString() == id.toString(),
        orElse: () => ServiceSiteModel.sampleServices.first,
      );
    }
  }

  @override
  Future<void> triggerCheck(dynamic id) async {
    try {
      await apiClient.dio.post(ApiConstants.siteCheck(id));
    } catch (_) {}
  }
}

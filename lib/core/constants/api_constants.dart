import 'api_key.dart';

export 'api_key.dart';

/// Central API Constants wrapper that references ApiKey
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = ApiKey.baseUrl;
  static const String productionBaseUrl = ApiKey.productionBaseUrl;
  static const String apiKey = ApiKey.apiKey;

  // Auth endpoints
  static const String login = ApiKey.login;
  static const String logout = ApiKey.logout;
  static const String me = ApiKey.me;

  // Dashboard endpoints
  static const String dashboardStats = ApiKey.dashboardStats;

  // Sites / Services endpoints
  static const String sites = ApiKey.sites;
  static String siteDetail(dynamic id) => ApiKey.siteDetail(id);
  static String siteCheck(dynamic id) => ApiKey.siteCheck(id);

  // Incidents endpoints
  static const String incidents = ApiKey.incidents;
  static String incidentDetail(dynamic id) => ApiKey.incidentDetail(id);
  static String updateIncidentStatus(dynamic id) => ApiKey.updateIncidentStatus(id);

  // Device registration for FCM
  static const String deviceToken = ApiKey.deviceToken;

  // Network Timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}

import 'api_key.dart';

export 'api_key.dart';

/// Central API Constants wrapper that references ApiKey
class ApiConstants {
  ApiConstants._();

  static String get baseUrl => ApiKey.baseUrl;
  static const String productionBaseUrl = ApiKey.productionBaseUrl;
  static const String apiKey = ApiKey.apiKey;

  // Auth endpoints
  static String get login => ApiKey.login;
  static String get logout => ApiKey.logout;
  static String get me => ApiKey.me;

  // Dashboard endpoints (/api/v1/dashboard/stats)
  static const String dashboardStatsPath = ApiKey.dashboardStatsPath;
  static String get dashboardStats => ApiKey.dashboardStats;

  // Sites / Services endpoints
  static String get sites => ApiKey.sites;
  static String siteDetail(dynamic id) => ApiKey.siteDetail(id);
  static String siteCheck(dynamic id) => ApiKey.siteCheck(id);

  // Incidents endpoints
  static String get incidents => ApiKey.incidents;
  static String incidentDetail(dynamic id) => ApiKey.incidentDetail(id);
  static String updateIncidentStatus(dynamic id) => ApiKey.updateIncidentStatus(id);
  static String incidentNotes(dynamic id) => ApiKey.incidentNotes(id);

  // Deep Inspection endpoints (Modul 5)
  static String get inspect => ApiKey.inspect;
  static String inspectDetail(dynamic id) => ApiKey.inspectDetail(id);

  // Device registration for FCM
  static String get deviceToken => ApiKey.deviceToken;

  // Network Timeouts
  static const Duration connectTimeout = Duration(seconds: 45);
  static const Duration receiveTimeout = Duration(seconds: 45);
}

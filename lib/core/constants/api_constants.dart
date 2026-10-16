/// Central API constants according to SIGAP Mobile PRD
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://sigap.humacode.my.id/api/v1';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';

  // Dashboard endpoints
  static const String dashboardStats = '/dashboard/stats';

  // Sites / Services endpoints
  static const String sites = '/sites';
  static String siteDetail(int id) => '/sites/$id';
  static String siteCheck(int id) => '/sites/$id/check';

  // Incidents endpoints
  static const String incidents = '/incidents';
  static String incidentDetail(int id) => '/incidents/$id';
  static String updateIncidentStatus(int id) => '/incidents/$id/status';

  // Device registration for FCM
  static const String deviceToken = '/devices/token';

  // Network Timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}

/// Konfigurasi API & Daftar URL Endpoint
class ApiKey {
  ApiKey._();

  // Base URL Server
  static const String baseUrl = 'http://localhost:8000/api/v1/';

  // Base URL Server Produksi (Cadangan / Live)
  static const String productionBaseUrl = 'https://sigap.humacode.my.id/api/v1/';

  // API Key (jika backend menggunakan header X-API-KEY / Bearer ApiKey)
  static const String apiKey = '';

  // Auth Endpoints
  static const String login = '${baseUrl}auth/login';
  static const String logout = '${baseUrl}auth/logout';
  static const String me = '${baseUrl}auth/me';

  // Dashboard Endpoints
  static const String dashboardStats = '${baseUrl}dashboard/stats';

  // Sites / Services Endpoints
  static const String sites = '${baseUrl}sites';
  static String siteDetail(dynamic id) => '${baseUrl}sites/$id';
  static String siteCheck(dynamic id) => '${baseUrl}sites/$id/check';

  // Incidents Endpoints
  static const String incidents = '${baseUrl}incidents';
  static String incidentDetail(dynamic id) => '${baseUrl}incidents/$id';
  static String updateIncidentStatus(dynamic id) => '${baseUrl}incidents/$id/status';

  // Device Registration (Push Notification)
  static const String deviceToken = '${baseUrl}devices/token';
}

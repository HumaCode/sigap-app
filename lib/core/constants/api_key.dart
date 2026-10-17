/// Konfigurasi API & Daftar URL Endpoint
class ApiKey {
  ApiKey._();

  // Preset Base URLs untuk fleksibilitas Dev & Prod
  static const String emulatorBaseUrl = 'http://10.0.2.2:8000/api/v1/';
  static const String localhostBaseUrl = 'http://localhost:8000/api/v1/';
  static const String lanBaseUrl = 'http://192.168.1.4:8000/api/v1/';
  static const String productionBaseUrl = 'https://sigap.humacode.my.id/api/v1/';

  // Active Base URL Server (Default emulator Android menggunakan 10.0.2.2)
  static String baseUrl = emulatorBaseUrl;

  // Official Mobile App Key (dikirim melalui header X-App-Key)
  static const String apiKey = 'base64:OEa3k7TNWkuFpZ4FDrZhnT4eYq+KwbAoYoIFxl4NZKI=';

  // Auth Endpoints
  static String get login => '${baseUrl}auth/login';
  static String get logout => '${baseUrl}auth/logout';
  static String get me => '${baseUrl}auth/me';

  // Dashboard Endpoints (/api/v1/dashboard/stats)
  static const String dashboardStatsPath = '/api/v1/dashboard/stats';
  static String get dashboardStats => '${baseUrl}dashboard/stats';

  // Sites / Services Endpoints
  static String get sites => '${baseUrl}sites';
  static String siteDetail(dynamic id) => '${baseUrl}sites/$id';
  static String siteCheck(dynamic id) => '${baseUrl}sites/$id/check';

  // Incidents Endpoints
  static String get incidents => '${baseUrl}incidents';
  static String incidentDetail(dynamic id) => '${baseUrl}incidents/$id';
  static String updateIncidentStatus(dynamic id) => '${baseUrl}incidents/$id/status';

  // Device Registration (Push Notification)
  static String get deviceToken => '${baseUrl}devices/token';
}

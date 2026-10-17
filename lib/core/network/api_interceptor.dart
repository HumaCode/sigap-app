import 'package:dio/dio.dart';
import '../constants/api_key.dart';
import '../storage/secure_storage_service.dart';

/// Interceptor that attaches the Bearer token to all outgoing requests
/// and gracefully detects token expirations (401).
class ApiInterceptor extends Interceptor {
  final SecureStorageService secureStorage;
  final void Function()? onSessionExpired;

  ApiInterceptor({
    required this.secureStorage,
    this.onSessionExpired,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Accept'] = 'application/json';

    if (ApiKey.apiKey.isNotEmpty) {
      options.headers['X-App-Key'] = ApiKey.apiKey;
      options.headers['X-API-KEY'] = ApiKey.apiKey;
    }

    // Retrieve Bearer token if not explicitly excluded
    final token = await secureStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // 401 Token expired or invalid
      onSessionExpired?.call();
    }
    return handler.next(err);
  }
}

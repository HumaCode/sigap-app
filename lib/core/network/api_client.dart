import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../storage/secure_storage_service.dart';
import 'api_interceptor.dart';

/// Central Dio client wrapper configured for FrankenPHP Laravel Octane API
class ApiClient {
  late final Dio dio;
  final SecureStorageService secureStorage;

  ApiClient({
    required this.secureStorage,
    void Function()? onSessionExpired,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        responseType: ResponseType.json,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      ApiInterceptor(
        secureStorage: secureStorage,
        onSessionExpired: onSessionExpired,
      ),
    );
  }
}

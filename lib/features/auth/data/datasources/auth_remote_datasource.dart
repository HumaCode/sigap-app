import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel> getMe();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.login,
        data: {
          'login': email,
          'email': email,
          'password': password,
          'device_name': 'SIGAP_Android_Mobile',
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return UserModel.fromJson(data);
      }
      throw Exception('Format respon server tidak valid');
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is Map) {
        final resData = e.response!.data as Map<String, dynamic>;
        final message = resData['message']?.toString() ?? 'Login gagal, periksa email dan password.';
        throw Exception(message);
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Koneksi ke server timeout. Pastikan server Laravel aktif.');
      }
      if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Gagal terhubung ke API (${ApiConstants.baseUrl}). Pastikan Laravel Octane dev server aktif.',
        );
      }
      throw Exception(e.message ?? 'Terjadi kesalahan jaringan.');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.dio.post(ApiConstants.logout);
    } catch (_) {
      // Ignore network errors on logout
    }
  }

  @override
  Future<UserModel> getMe() async {
    final response = await apiClient.dio.get(ApiConstants.me);
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return UserModel.fromJson(data);
    }
    throw Exception('Format respon profil tidak valid');
  }
}

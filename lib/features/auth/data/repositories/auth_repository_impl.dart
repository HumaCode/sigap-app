import 'package:local_auth/local_auth.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorageService secureStorage;
  final LocalAuthentication localAuth;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
    LocalAuthentication? localAuth,
  }) : localAuth = localAuth ?? LocalAuthentication();

  @override
  Future<UserEntity> login(String email, String password) async {
    final model = await remoteDataSource.login(email, password);
    final user = model.toEntity();

    if (user.token != null) {
      await secureStorage.saveToken(user.token!);
    }
    await secureStorage.saveUserRole(user.primaryRole);
    await secureStorage.saveUsername(user.username.isNotEmpty ? user.username : user.email);
    return user;
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
    await secureStorage.deleteToken();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final token = await secureStorage.getToken();
    if (token == null) return null;

    final username = await secureStorage.getSavedUsername() ?? 'sre_admin';
    final role = await secureStorage.getUserRole() ?? 'admin';

    return UserEntity(
      id: '1',
      name: username.toUpperCase(),
      username: username,
      email: username.contains('@') ? username : '$username@sigap.id',
      roles: [role],
      permissions: const ['view_dashboard', 'manage_services', 'manage_incidents'],
      token: token,
    );
  }

  @override
  Future<bool> authenticateBiometric() async {
    final canCheckBiometrics = await localAuth.canCheckBiometrics;
    final isDeviceSupported = await localAuth.isDeviceSupported();

    if (!canCheckBiometrics || !isDeviceSupported) {
      return false;
    }

    try {
      return await localAuth.authenticate(
        localizedReason: 'Pindai sidik jari atau wajah untuk masuk ke SIGAP SRE',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      return false;
    }
  }
}

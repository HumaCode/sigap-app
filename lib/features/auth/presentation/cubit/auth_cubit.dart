import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/storage/secure_storage_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final SecureStorageService secureStorage;

  AuthCubit({
    required this.authRepository,
    required this.secureStorage,
  }) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    try {
      final user = await authRepository.getCurrentUser();
      final hasBiometric = await secureStorage.isBiometricEnabled();
      final savedUsername = await secureStorage.getSavedUsername();

      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated(
          canUseBiometric: hasBiometric,
          savedUsername: savedUsername,
        ));
      }
    } catch (_) {
      emit(const Unauthenticated());
    }
  }

  Future<void> login(String email, String password, {bool enableBiometric = false}) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.login(email, password);
      if (enableBiometric) {
        await secureStorage.setBiometricEnabled(true);
      }
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> loginWithBiometrics() async {
    final success = await authRepository.authenticateBiometric();
    if (success) {
      final user = await authRepository.getCurrentUser();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const AuthError('Sesi biometrik kadaluarsa, silakan login dengan password'));
      }
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await authRepository.logout();
    final hasBiometric = await secureStorage.isBiometricEnabled();
    final savedUsername = await secureStorage.getSavedUsername();
    emit(Unauthenticated(canUseBiometric: hasBiometric, savedUsername: savedUsername));
  }
}

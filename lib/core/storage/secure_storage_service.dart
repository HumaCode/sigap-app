import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure token & credential storage backed by Android Keystore / iOS Keychain
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const String _tokenKey = 'sigap_access_token';
  static const String _userRoleKey = 'sigap_user_role';
  static const String _biometricEnabledKey = 'sigap_biometric_enabled';
  static const String _savedUsernameKey = 'sigap_saved_username';

  // Token management
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // Role management
  Future<void> saveUserRole(String role) async {
    await _storage.write(key: _userRoleKey, value: role);
  }

  Future<String?> getUserRole() async {
    return await _storage.read(key: _userRoleKey);
  }

  // Biometric preferences
  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(key: _biometricEnabledKey, value: enabled.toString());
  }

  Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: _biometricEnabledKey);
    return value == 'true';
  }

  // Saved Username for fast Biometric Re-auth
  Future<void> saveUsername(String username) async {
    await _storage.write(key: _savedUsernameKey, value: username);
  }

  Future<String?> getSavedUsername() async {
    return await _storage.read(key: _savedUsernameKey);
  }

  // Clear all
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}

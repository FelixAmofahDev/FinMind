import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/storage_keys.dart';

class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage}) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<void> saveToken(String token) => _storage.write(key: StorageKeys.token, value: token);

  Future<String?> getToken() => _storage.read(key: StorageKeys.token);

  Future<void> deleteToken() => _storage.delete(key: StorageKeys.token);

  Future<void> saveRefreshToken(String token) => _storage.write(key: StorageKeys.refreshToken, value: token);

  Future<String?> getRefreshToken() => _storage.read(key: StorageKeys.refreshToken);

  Future<void> deleteRefreshToken() => _storage.delete(key: StorageKeys.refreshToken);

  Future<void> saveString(String key, String value) => _storage.write(key: key, value: value);

  Future<String?> getString(String key) => _storage.read(key: key);

  Future<void> delete(String key) => _storage.delete(key: key);

  Future<void> saveAuthSession({
    required String accessToken,
    required String refreshToken,
    required Map<String, dynamic> user,
    required Map<String, dynamic> business,
  }) async {
    await _storage.write(key: StorageKeys.token, value: accessToken);
    await _storage.write(key: StorageKeys.refreshToken, value: refreshToken);
    await _storage.write(key: StorageKeys.user, value: jsonEncode(user));
    await _storage.write(key: StorageKeys.business, value: jsonEncode(business));
  }

  Future<Map<String, dynamic>?> getUser() async {
    final userJson = await _storage.read(key: StorageKeys.user);
    if (userJson == null) return null;
    return jsonDecode(userJson) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>?> getBusiness() async {
    final businessJson = await _storage.read(key: StorageKeys.business);
    if (businessJson == null) return null;
    return jsonDecode(businessJson) as Map<String, dynamic>;
  }

  Future<void> clearAuthData() async {
    await _storage.delete(key: StorageKeys.token);
    await _storage.delete(key: StorageKeys.refreshToken);
    await _storage.delete(key: StorageKeys.user);
    await _storage.delete(key: StorageKeys.business);
  }
}

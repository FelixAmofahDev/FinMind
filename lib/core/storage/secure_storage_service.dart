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
}

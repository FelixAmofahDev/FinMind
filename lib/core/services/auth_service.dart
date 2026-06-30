import '../storage/secure_storage_service.dart';

class AuthService {
  AuthService(this._secureStorageService);

  final SecureStorageService _secureStorageService;

  Future<void> saveToken(String token) => _secureStorageService.saveToken(token);

  Future<String?> getToken() => _secureStorageService.getToken();

  Future<void> deleteToken() => _secureStorageService.deleteToken();

  Future<bool> refreshToken() async {
    final refreshToken = await _secureStorageService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    return false;
  }

  Future<void> saveRefreshToken(String token) => _secureStorageService.saveRefreshToken(token);

  Future<String?> getRefreshToken() => _secureStorageService.getRefreshToken();

  Future<void> clearAuthData() async {
    await _secureStorageService.deleteToken();
    await _secureStorageService.deleteRefreshToken();
  }
}

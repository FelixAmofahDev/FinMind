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

  Future<void> saveAuthSession({
    required String accessToken,
    required String refreshToken,
    required Map<String, dynamic> user,
    required Map<String, dynamic> business,
  }) => _secureStorageService.saveAuthSession(
        accessToken: accessToken,
        refreshToken: refreshToken,
        user: user,
        business: business,
      );

  Future<Map<String, dynamic>?> getUser() => _secureStorageService.getUser();

  Future<Map<String, dynamic>?> getBusiness() => _secureStorageService.getBusiness();

  Future<void> clearAuthData() => _secureStorageService.clearAuthData();
}

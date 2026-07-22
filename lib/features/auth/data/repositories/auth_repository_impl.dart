import 'dart:convert';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/onboarding_payload.dart';
import '../../domain/entities/signup_payload.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_session_model.dart';
import '../models/business_model.dart';
import '../models/onboarding_payload_model.dart';
import '../models/signup_payload_model.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDatasource remoteDatasource,
    required SecureStorageService secureStorageService,
    required LocalStorageService localStorageService,
  })  : _remoteDatasource = remoteDatasource,
        _secureStorageService = secureStorageService,
        _localStorageService = localStorageService;

  final AuthRemoteDatasource _remoteDatasource;
  final SecureStorageService _secureStorageService;
  final LocalStorageService _localStorageService;

  @override
  Future<String> signup({required SignupPayload payload}) {
    return _remoteDatasource.signup(
      payload: SignupPayloadModel.fromEntity(payload),
    );
  }

  @override
  Future<void> resendVerification({required String email}) {
    return _remoteDatasource.resendVerification(email: email);
  }

  @override
  Future<AuthSession> verifyEmail({required String email, required String code}) {
    return _remoteDatasource.verifyEmail(email: email, code: code);
  }

  @override
  Future<AuthSession> login({required String email, required String password}) {
    return _remoteDatasource.login(email: email, password: password);
  }

  @override
  Future<AuthSession> completeOnboarding({required OnboardingPayload payload}) async {
    final success = await _remoteDatasource.completeOnboarding(
      payload: OnboardingPayloadModel.fromEntity(payload),
    );
    if (!success) {
      throw const ServerException('Could not complete onboarding.');
    }
    final session = await restoreSession();
    if (session == null) {
      throw const CacheException('Auth session is missing. Please log in again.');
    }
    final updatedSession = session.copyWith(
      business: session.business.copyWith(onboardingComplete: true),
    );
    await saveAuthSession(updatedSession);
    return updatedSession;
  }

  @override
  Future<void> saveAuthSession(AuthSession session) async {
    final sessionModel = AuthSessionModel.fromEntity(session);
    final userModel = UserModel.fromEntity(session.user);
    final businessModel = BusinessModel.fromEntity(session.business);

    await _secureStorageService.saveToken(sessionModel.accessToken);
    await _secureStorageService.saveRefreshToken(sessionModel.refreshToken);
    await _localStorageService.setString(StorageKeys.user, jsonEncode(userModel.toJson()));
    await _localStorageService.setString(StorageKeys.business, jsonEncode(businessModel.toJson()));
  }

  @override
  Future<AuthSession?> restoreSession() async {
    final accessToken = await _secureStorageService.getToken();
    final refreshToken = await _secureStorageService.getRefreshToken();
    final userJson = _localStorageService.getString(StorageKeys.user);
    final businessJson = _localStorageService.getString(StorageKeys.business);

    if (accessToken == null ||
        accessToken.isEmpty ||
        refreshToken == null ||
        refreshToken.isEmpty ||
        userJson == null ||
        businessJson == null) {
      return null;
    }

    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      final businessMap = jsonDecode(businessJson) as Map<String, dynamic>;
      return AuthSessionModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
        user: UserModel.fromJson(userMap),
        business: BusinessModel.fromJson(businessMap),
      );
    } on FormatException {
      return null;
    }
  }

  @override
  Future<bool> checkOnboardingStatus() async {
    final session = await restoreSession();
    return session?.business.onboardingComplete ?? false;
  }

  @override
  Future<void> clearSession() async {
    await _secureStorageService.deleteToken();
    await _secureStorageService.deleteRefreshToken();
    await _localStorageService.remove(StorageKeys.user);
    await _localStorageService.remove(StorageKeys.business);
  }

  @override
  Future<void> logout() async {
    final refreshToken = await _secureStorageService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await clearSession();
      return;
    }
    try {
      await _remoteDatasource.logout(refreshToken: refreshToken);
    } on ServerException {
      // ignore API logout failure and still clear local session
    } catch (_) {
      // ignore
    }
    await clearSession();
  }
}
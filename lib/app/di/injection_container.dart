import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../core/api/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/network_constants.dart';
import '../../core/network/network_info.dart';
import '../../core/services/api_service.dart';
import '../../core/services/auth_service.dart';
import '../../core/storage/secure_storage_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/check_onboarding_status.dart';
import '../../features/auth/domain/usecases/save_auth_session.dart';
import '../../features/auth/domain/usecases/verify_email.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../config/env.dart';

final sl = GetIt.instance;

class InjectionContainer {
  const InjectionContainer._();

  static Future<void> init() async {
    AppEnv.current;

    await _initCore();
    _initAuth();
  }

  static Future<void> _initCore() async {
    sl.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    );

    sl.registerLazySingleton<SecureStorageService>(
      () => SecureStorageService(storage: sl<FlutterSecureStorage>()),
    );

    sl.registerLazySingleton<Connectivity>(
      () => Connectivity(),
    );

    sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(sl<Connectivity>()),
    );

    sl.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: NetworkConstants.connectTimeout,
          receiveTimeout: NetworkConstants.receiveTimeout,
          sendTimeout: NetworkConstants.sendTimeout,
          responseType: ResponseType.json,
          contentType: Headers.jsonContentType,
          headers: const <String, dynamic>{'Accept': 'application/json'},
        ),
      ),
    );

    sl.registerLazySingleton<AuthService>(
      () => AuthService(sl<SecureStorageService>()),
    );

    sl.registerLazySingleton<ApiClient>(
      () => ApiClient(
        dio: sl<Dio>(),
        authService: sl<AuthService>(),
      ),
    );

    sl.registerLazySingleton<ApiService>(
      () => ApiService(sl<ApiClient>()),
    );
  }

  static void _initAuth() {
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(sl<ApiClient>()),
    );

    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: sl<AuthRemoteDataSource>(),
        authService: sl<AuthService>(),
        secureStorageService: sl<SecureStorageService>(),
      ),
    );

    sl.registerLazySingleton<VerifyEmail>(
      () => VerifyEmail(sl<AuthRepository>()),
    );

    sl.registerLazySingleton<SaveAuthSession>(
      () => SaveAuthSession(sl<AuthRepository>()),
    );

    sl.registerLazySingleton<CheckOnboardingStatus>(
      () => CheckOnboardingStatus(sl<AuthRepository>()),
    );

    sl.registerLazySingleton<AuthNotifier>(
      () => AuthNotifier(
        verifyEmail: sl<VerifyEmail>(),
        checkOnboardingStatus: sl<CheckOnboardingStatus>(),
        authRepository: sl<AuthRepository>(),
      ),
    );
  }
}
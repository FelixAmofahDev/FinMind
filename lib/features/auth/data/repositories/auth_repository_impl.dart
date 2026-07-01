import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/business.dart';
import '../../domain/entities/signup_draft.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_response_model.dart';
import '../models/signup_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthService authService,
    required SecureStorageService secureStorageService,
  })  : _remoteDataSource = remoteDataSource,
        _authService = authService,
        _secureStorageService = secureStorageService;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthService _authService;
  final SecureStorageService _secureStorageService;

  @override
  Future<Either<Failure, String>> signup(SignupDraft draft) async {
    try {
      final response = await _remoteDataSource.signup(draft);

      if (!response.success) {
        return Left(ServerFailure(message: response.message));
      }

      return Right(response.data.email);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthSession>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.login(email: email, password: password);

      if (!response.success) {
        return Left(ServerFailure(message: response.message));
      }

      final authSession = _mapToAuthSession(response.data);

      await _saveAuthSessionToStorage(authSession);

      return Right(authSession);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthSession>> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _remoteDataSource.verifyEmail(
        email: email,
        code: code,
      );

      if (!response.success) {
        return Left(ServerFailure(message: response.message));
      }

      final authSession = _mapToAuthSession(response.data);
      
      await _saveAuthSessionToStorage(authSession);
      
      return Right(authSession);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resendVerification({required String email}) async {
    try {
      await _remoteDataSource.resendVerification(email: email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveAuthSession(AuthSession session) async {
    try {
      await _saveAuthSessionToStorage(session);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthSession?>> getAuthSession() async {
    try {
      final accessToken = await _secureStorageService.getToken();
      final refreshToken = await _secureStorageService.getRefreshToken();
      
      if (accessToken == null || refreshToken == null) {
        return const Right(null);
      }

      final userMap = await _secureStorageService.getUser();
      final businessMap = await _secureStorageService.getBusiness();
      
      if (userMap == null || businessMap == null) {
        return const Right(null);
      }

      final user = UserModel.fromJson(userMap).toEntity();
      final business = BusinessModel.fromJson(businessMap).toEntity();
      
      final authSession = AuthSession(
        accessToken: accessToken,
        refreshToken: refreshToken,
        user: user,
        business: business,
      );

      return Right(authSession);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearAuthSession() async {
    try {
      await _secureStorageService.clearAuthData();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkOnboardingStatus() async {
    try {
      final sessionResult = await getAuthSession();
      return sessionResult.fold(
        (failure) => Left(failure),
        (session) => Right(session?.business.onboardingComplete ?? false),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  AuthSession _mapToAuthSession(AuthResponseDataModel data) {
    final user = User(
      id: data.user.id,
      fullName: data.user.fullName,
      email: data.user.email,
      role: data.user.role,
      emailVerified: data.user.emailVerified,
    );

    final business = Business(
      id: data.business.id,
      name: data.business.name,
      tier: data.business.tier,
      onboardingComplete: data.business.onboardingComplete,
    );

    return AuthSession(
      accessToken: data.accessToken,
      refreshToken: data.refreshToken,
      user: user,
      business: business,
    );
  }

  Future<void> _saveAuthSessionToStorage(AuthSession session) async {
    await _authService.saveAuthSession(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      user: session.user.toJson(),
      business: session.business.toJson(),
    );
  }
}
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/onboarding_payload.dart';
import '../../domain/entities/signup_payload.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/check_onboarding_status.dart';
import '../../domain/usecases/clear_auth_session.dart';
import '../../domain/usecases/complete_onboarding.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/restore_auth_session.dart';
import '../../domain/usecases/save_auth_session.dart';
import '../../domain/usecases/resend_verification.dart';
import '../../domain/usecases/signup.dart';
import '../../domain/usecases/verify_email.dart';

enum AuthNavigationState {
  unauthenticated,
  needsEmailVerification,
  needsOnboarding,
  authenticated,
}

class SignupDraft {
  const SignupDraft({
    this.businessName = '',
    this.businessType = 'provision_store',
    this.ownerName = '',
    this.phoneNumber = '',
    this.locationRegion = '',
    this.locationDistrict = '',
    this.tier = 'tier2',
    this.recordingMode = 'transaction',
    this.email = '',
    this.password = '',
  });

  final String businessName;
  final String businessType;
  final String ownerName;
  final String phoneNumber;
  final String locationRegion;
  final String locationDistrict;
  final String tier;
  final String recordingMode;
  final String email;
  final String password;

  SignupDraft copyWith({
    String? businessName,
    String? businessType,
    String? ownerName,
    String? phoneNumber,
    String? locationRegion,
    String? locationDistrict,
    String? tier,
    String? recordingMode,
    String? email,
    String? password,
  }) {
    return SignupDraft(
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      ownerName: ownerName ?? this.ownerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      locationRegion: locationRegion ?? this.locationRegion,
      locationDistrict: locationDistrict ?? this.locationDistrict,
      tier: tier ?? this.tier,
      recordingMode: recordingMode ?? this.recordingMode,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

class SignupDraftNotifier extends Notifier<SignupDraft> {
  @override
  SignupDraft build() => const SignupDraft();

  void updateBusinessStep({required String businessName, required String businessType}) {
    state = state.copyWith(
      businessName: businessName,
      businessType: businessType,
    );
  }

  void updateLocationStep({
    required String ownerName,
    required String phoneNumber,
    required String locationRegion,
    required String locationDistrict,
  }) {
    state = state.copyWith(
      ownerName: ownerName,
      phoneNumber: phoneNumber,
      locationRegion: locationRegion,
      locationDistrict: locationDistrict,
    );
  }

  void updateTrackingStep({required String tier, required String recordingMode}) {
    state = state.copyWith(tier: tier, recordingMode: recordingMode);
  }

  void updateCredentialsStep({required String email, required String password}) {
    state = state.copyWith(email: email, password: password);
  }

  void reset() {
    state = const SignupDraft();
  }
}

final signupDraftProvider = NotifierProvider<SignupDraftNotifier, SignupDraft>(SignupDraftNotifier.new);
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final localStorageServiceProvider = FutureProvider<LocalStorageService>((ref) {
  return LocalStorageService.create();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read(secureStorageServiceProvider));
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(authService: ref.read(authServiceProvider));
});

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthRemoteDatasource(ref.read(apiClientProvider));
});

final authRepositoryProvider = FutureProvider<AuthRepository>((ref) async {
  final localStorage = await ref.watch(localStorageServiceProvider.future);
  return AuthRepositoryImpl(
    remoteDatasource: ref.read(authRemoteDatasourceProvider),
    secureStorageService: ref.read(secureStorageServiceProvider),
    localStorageService: localStorage,
  );
});

final verifyEmailUseCaseProvider = FutureProvider<VerifyEmail>((ref) async {
  return VerifyEmail(await ref.watch(authRepositoryProvider.future));
});

final saveAuthSessionUseCaseProvider = FutureProvider<SaveAuthSession>((ref) async {
  return SaveAuthSession(await ref.watch(authRepositoryProvider.future));
});

final checkOnboardingStatusUseCaseProvider = FutureProvider<CheckOnboardingStatus>((ref) async {
  return CheckOnboardingStatus(await ref.watch(authRepositoryProvider.future));
});

final loginUseCaseProvider = FutureProvider<Login>((ref) async {
  return Login(await ref.watch(authRepositoryProvider.future));
});

final signupUseCaseProvider = FutureProvider<Signup>((ref) async {
  return Signup(await ref.watch(authRepositoryProvider.future));
});

final resendVerificationUseCaseProvider = FutureProvider<ResendVerification>((ref) async {
  return ResendVerification(await ref.watch(authRepositoryProvider.future));
});

final restoreAuthSessionUseCaseProvider = FutureProvider<RestoreAuthSession>((ref) async {
  return RestoreAuthSession(await ref.watch(authRepositoryProvider.future));
});

final completeOnboardingUseCaseProvider = FutureProvider<CompleteOnboarding>((ref) async {
  return CompleteOnboarding(await ref.watch(authRepositoryProvider.future));
});

final clearAuthSessionUseCaseProvider = FutureProvider<ClearAuthSession>((ref) async {
  return ClearAuthSession(await ref.watch(authRepositoryProvider.future));
});

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthSession?>(AuthNotifier.new);

class VerificationResendController extends Notifier<int> {
  Timer? _timer;

  @override
  int build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return 0;
  }

  bool get canResend => state == 0;

  void startCooldown({int seconds = 60}) {
    _timer?.cancel();
    state = seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state <= 1) {
        timer.cancel();
        state = 0;
        return;
      }
      state = state - 1;
    });
  }

  String get label {
    if (state <= 0) {
      return 'Resend code';
    }
    final minutes = state ~/ 60;
    final seconds = state % 60;
    final secondsText = seconds.toString().padLeft(2, '0');
    return 'Resend code in ${minutes}:${secondsText}';
  }
}

final verificationResendCooldownProvider = NotifierProvider<VerificationResendController, int>(
  VerificationResendController.new,
);

final authNavigationStateProvider = FutureProvider<AuthNavigationState>((ref) async {
  final session = await ref.watch(authProvider.future);
  if (session == null) {
    return AuthNavigationState.unauthenticated;
  }
  if (!session.user.emailVerified) {
    return AuthNavigationState.needsEmailVerification;
  }
  final checkOnboardingStatus = await ref.watch(checkOnboardingStatusUseCaseProvider.future);
  final hasCompletedOnboarding = await checkOnboardingStatus();
  if (!hasCompletedOnboarding) {
    return AuthNavigationState.needsOnboarding;
  }
  return AuthNavigationState.authenticated;
});

class AuthNotifier extends AsyncNotifier<AuthSession?> {
  @override
  Future<AuthSession?> build() async {
    final restoreAuthSession = await ref.watch(restoreAuthSessionUseCaseProvider.future);
    return restoreAuthSession();
  }

  Future<AuthSession?> login({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final loginUseCase = await ref.read(loginUseCaseProvider.future);
      final saveAuthSessionUseCase = await ref.read(saveAuthSessionUseCaseProvider.future);
      final session = await loginUseCase(email: email, password: password);
      await saveAuthSessionUseCase(session);
      return session;
    });
    return state.asData?.value;
  }

  Future<String?> signup({required SignupDraft draft}) async {
    state = const AsyncLoading();
    try {
      final signupUseCase = await ref.read(signupUseCaseProvider.future);
      final email = await signupUseCase(
        payload: SignupPayload(
          businessName: draft.businessName.trim(),
          businessType: draft.businessType.trim(),
          ownerName: draft.ownerName.trim(),
          phoneNumber: draft.phoneNumber.trim(),
          locationRegion: draft.locationRegion.trim(),
          locationDistrict: draft.locationDistrict.trim(),
          tier: draft.tier.trim(),
          recordingMode: draft.recordingMode.trim(),
          email: draft.email.trim(),
          password: draft.password,
        ),
      );
      state = const AsyncData(null);
      return email;
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      return null;
    }
  }

  Future<AuthSession?> verifyEmail({required String email, required String code}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final verifyEmailUseCase = await ref.read(verifyEmailUseCaseProvider.future);
      final saveAuthSessionUseCase = await ref.read(saveAuthSessionUseCaseProvider.future);
      final session = await verifyEmailUseCase(email: email, code: code);
      await saveAuthSessionUseCase(session);
      return session;
    });
    return state.asData?.value;
  }

  Future<void> resendVerification({required String email}) async {
    try {
      final resendVerificationUseCase = await ref.read(resendVerificationUseCaseProvider.future);
      await resendVerificationUseCase(email: email);
      ref.read(verificationResendCooldownProvider.notifier).startCooldown(seconds: 60);
    } catch (error) {
      if (error is ServerException && error.code == 429) {
        ref.read(verificationResendCooldownProvider.notifier).startCooldown(seconds: 60);
      }
      rethrow;
    }
  }

  Future<AuthSession?> completeOnboarding({required OnboardingPayload payload}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final completeOnboardingUseCase = await ref.read(completeOnboardingUseCaseProvider.future);
      final session = await completeOnboardingUseCase(payload: payload);
      return session;
    });
    return state.asData?.value;
  }

  Future<void> signOut() async {
    final clearSessionUseCase = await ref.read(clearAuthSessionUseCaseProvider.future);
    await clearSessionUseCase();
    state = const AsyncData(null);
  }

  String toUserMessage(Object? error, {required String fallback}) {
    if (error is ServerException) {
      return _mapStatusCodeMessage(
        code: error.code,
        apiMessage: error.message,
        fallback: fallback,
      );
    }
    if (error is AppException) {
      return error.message;
    }
    return fallback;
  }

  String _mapStatusCodeMessage({
    required int? code,
    required String apiMessage,
    required String fallback,
  }) {
    if (apiMessage.trim().isNotEmpty) {
      return apiMessage;
    }

    switch (code) {
      case 400:
        return 'Invalid input. Please review your entries and try again.';
      case 401:
        return 'Authentication failed. Please try again.';
      case 403:
        return 'This action is not allowed for this account right now.';
      case 409:
        return 'This email is already in use. Try signing in or use another email.';
      case 429:
        return 'Too many attempts. Please wait and try again.';
      default:
        return fallback;
    }
  }
}
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/signup_draft.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/check_onboarding_status.dart';
import '../../domain/usecases/verify_email.dart';

class AuthState {
  const AuthState({
    this.authSession,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.needsOnboarding = false,
    this.signupDraft = const SignupDraft(),
  });

  final AuthSession? authSession;
  final bool isLoading;
  final Failure? error;
  final bool isAuthenticated;
  final bool needsOnboarding;
  final SignupDraft signupDraft;

  AuthState copyWith({
    AuthSession? authSession,
    bool clearAuthSession = false,
    bool? isLoading,
    Failure? error,
    bool clearError = false,
    bool? isAuthenticated,
    bool? needsOnboarding,
    SignupDraft? signupDraft,
    bool clearSignupDraft = false,
  }) {
    return AuthState(
      authSession: clearAuthSession ? null : authSession ?? this.authSession,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      needsOnboarding: needsOnboarding ?? this.needsOnboarding,
      signupDraft: clearSignupDraft ? const SignupDraft() : signupDraft ?? this.signupDraft,
    );
  }
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  final VerifyEmail _verifyEmail;
  final CheckOnboardingStatus _checkOnboardingStatus;
  final AuthRepository _authRepository;

  AuthNotifier({
    required VerifyEmail verifyEmail,
    required CheckOnboardingStatus checkOnboardingStatus,
    required AuthRepository authRepository,
  })  : _verifyEmail = verifyEmail,
        _checkOnboardingStatus = checkOnboardingStatus,
        _authRepository = authRepository;

  @override
  AuthState build() {
    return const AuthState();
  }

  void updateSignupDraft(SignupDraft draft) {
    state = AsyncValue.data(
      state.requireValue.copyWith(
        signupDraft: draft,
        clearError: true,
      ),
    );
  }

  Future<bool> signup() async {
    state = AsyncValue.data(state.requireValue.copyWith(isLoading: true, clearError: true));

    final result = await _authRepository.signup(state.requireValue.signupDraft);

    result.fold(
      (failure) {
        state = AsyncValue.data(
          state.requireValue.copyWith(
            isLoading: false,
            error: failure,
          ),
        );
      },
      (authSession) {
        state = AsyncValue.data(
          state.requireValue.copyWith(
            isLoading: false,
            isAuthenticated: false,
            needsOnboarding: true,
            clearError: true,
          ),
        );
        return true;
      },
    );

    return state.value?.error == null;
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = AsyncValue.data(state.requireValue.copyWith(isLoading: true, clearError: true));

    final result = await _authRepository.login(
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        state = AsyncValue.data(
          state.requireValue.copyWith(
            isLoading: false,
            error: failure,
          ),
        );
      },
      (authSession) {
        state = AsyncValue.data(
          state.requireValue.copyWith(
            isLoading: false,
            authSession: authSession,
            isAuthenticated: authSession.user.emailVerified,
            needsOnboarding: authSession.needsOnboarding,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> resendVerification({required String email}) async {
    state = AsyncValue.data(state.requireValue.copyWith(isLoading: true, clearError: true));

    final result = await _authRepository.resendVerification(email: email);

    result.fold(
      (failure) {
        state = AsyncValue.data(
          state.requireValue.copyWith(
            isLoading: false,
            error: failure,
          ),
        );
      },
      (_) {
        state = AsyncValue.data(
          state.requireValue.copyWith(
            isLoading: false,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> verifyEmail({
    required String email,
    required String code,
  }) async {
    state = AsyncValue.data(state.requireValue.copyWith(isLoading: true, clearError: true));

    final result = await _verifyEmail(email: email, code: code);

    result.fold(
      (failure) {
        state = AsyncValue.data(state.requireValue.copyWith(isLoading: false, error: failure));
      },
      (authSession) {
        state = AsyncValue.data(
          state.requireValue.copyWith(
            isLoading: false,
            authSession: authSession,
            isAuthenticated: authSession.user.emailVerified,
            needsOnboarding: authSession.needsOnboarding,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> checkAuthStatus() async {
    state = AsyncValue.data(state.requireValue.copyWith(isLoading: true, clearError: true));

    final sessionResult = await _authRepository.getAuthSession();

    sessionResult.fold(
      (failure) {
        state = AsyncValue.data(
          state.requireValue.copyWith(
            isLoading: false,
            isAuthenticated: false,
            needsOnboarding: false,
              clearAuthSession: true,
              error: failure,
          ),
        );
      },
      (session) async {
        if (session != null) {
          final onboardingResult = await _checkOnboardingStatus();
          onboardingResult.fold(
            (failure) {
              state = AsyncValue.data(
                state.requireValue.copyWith(
                  isLoading: false,
                  authSession: session,
                  isAuthenticated: session.canAccessDashboard,
                  needsOnboarding: session.needsOnboarding,
                    error: failure,
                ),
              );
            },
            (needsOnboarding) {
              state = AsyncValue.data(
                state.requireValue.copyWith(
                  isLoading: false,
                  authSession: session,
                  isAuthenticated: session.canAccessDashboard,
                  needsOnboarding: needsOnboarding,
                    clearError: true,
                ),
              );
            },
          );
        } else {
          state = AsyncValue.data(
            state.requireValue.copyWith(
              isLoading: false,
              isAuthenticated: false,
              needsOnboarding: false,
              clearAuthSession: true,
              clearError: true,
            ),
          );
        }
      },
    );
  }

  Future<void> logout() async {
    await _authRepository.clearAuthSession();
    state = const AsyncValue.data(AuthState());
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(() {
  throw UnimplementedError('authProvider must be overridden in main.dart with AuthNotifier from injection container');
});
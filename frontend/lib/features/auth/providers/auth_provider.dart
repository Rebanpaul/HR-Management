import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

/// Web auth uses browser localStorage (via dart:html) instead of flutter_secure_storage.
/// For simplicity in Phase 1, we use in-memory state with a basic implementation.
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final String? accessToken;
  final String? refreshToken;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.accessToken,
    this.refreshToken,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    String? accessToken,
    String? refreshToken,
    bool clearUser = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: error,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  late final ApiClient _apiClient;

  AuthNotifier() : super(const AuthState()) {
    _apiClient = ApiClient(
      getAccessToken: () async => state.accessToken,
      getRefreshToken: () async => state.refreshToken,
      onTokenRefreshed: (access, refresh) async {
        state = state.copyWith(accessToken: access, refreshToken: refresh);
      },
      onAuthFailure: () {
        state = const AuthState();
      },
    );
  }

  ApiClient get apiClient => _apiClient;

  Future<void> login(String email, String password, String tenantId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
          'tenantId': tenantId,
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);

      state = AuthState(
        user: authResponse.user,
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Login failed. Please check your credentials.',
      );
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.dio.post(ApiEndpoints.logout);
    } catch (_) {}
    state = const AuthState();
  }
}

// Riverpod providers
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ref.read(authProvider.notifier).apiClient;
});

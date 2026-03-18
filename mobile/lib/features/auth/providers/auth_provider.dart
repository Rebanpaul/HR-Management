import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import '../../../core/storage/secure_storage_service.dart';

// Auth state
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  bool get isAuthenticated => user != null;

  AuthState copyWith({UserModel? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  late final ApiClient _apiClient;

  AuthNotifier() : super(const AuthState()) {
    _apiClient = ApiClient(
      getAccessToken: SecureStorageService.getAccessToken,
      getRefreshToken: SecureStorageService.getRefreshToken,
      onTokenRefreshed: SecureStorageService.saveTokens,
      onAuthFailure: _onAuthFailure,
    );
    _tryAutoLogin();
  }

  ApiClient get apiClient => _apiClient;

  Future<void> _tryAutoLogin() async {
    final token = await SecureStorageService.getAccessToken();
    final userData = await SecureStorageService.getUserData();

    if (token != null && userData != null) {
      try {
        final userMap = jsonDecode(userData) as Map<String, dynamic>;
        state = AuthState(user: UserModel.fromJson(userMap));
      } catch (_) {
        await SecureStorageService.clearAll();
      }
    }
  }

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

      // Save tokens and user data securely
      await SecureStorageService.saveTokens(
        authResponse.accessToken,
        authResponse.refreshToken,
      );
      await SecureStorageService.saveUserData(
        jsonEncode(response.data['user']),
      );

      state = AuthState(user: authResponse.user);
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
    await SecureStorageService.clearAll();
    state = const AuthState();
  }

  void _onAuthFailure() {
    SecureStorageService.clearAll();
    state = const AuthState();
  }
}

// Riverpod providers
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Convenience provider for the shared API client
final apiClientProvider = Provider<ApiClient>((ref) {
  return ref.read(authProvider.notifier).apiClient;
});

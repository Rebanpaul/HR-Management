import 'package:dio/dio.dart';
import 'api_endpoints.dart';

/// Shared API client with JWT interceptor.
/// Both frontend (Web) and mobile apps use this client.
///
/// Usage:
/// ```dart
/// final client = ApiClient(
///   getAccessToken: () async => secureStorage.read('access_token'),
///   getRefreshToken: () async => secureStorage.read('refresh_token'),
///   onTokenRefreshed: (access, refresh) async {
///     await secureStorage.write('access_token', access);
///     await secureStorage.write('refresh_token', refresh);
///   },
///   onAuthFailure: () => navigateToLogin(),
/// );
/// ```
class ApiClient {
  late final Dio dio;

  final Future<String?> Function() getAccessToken;
  final Future<String?> Function() getRefreshToken;
  final Future<void> Function(String accessToken, String refreshToken)
      onTokenRefreshed;
  final void Function() onAuthFailure;

  ApiClient({
    required this.getAccessToken,
    required this.getRefreshToken,
    required this.onTokenRefreshed,
    required this.onAuthFailure,
    String? baseUrl,
  }) {
    if (baseUrl != null) {
      ApiEndpoints.baseUrl = baseUrl;
    }

    dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Add JWT interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequest,
      onError: _onError,
    ));
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth header for login/register
    final path = options.path;
    if (path.contains('/auth/login') || path.contains('/auth/register')) {
      return handler.next(options);
    }

    final token = await getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    // If 401, try refreshing the token
    if (error.response?.statusCode == 401) {
      try {
        final refreshToken = await getRefreshToken();
        if (refreshToken == null) {
          onAuthFailure();
          return handler.next(error);
        }

        // Attempt token refresh
        final refreshDio = Dio();
        final response = await refreshDio.post(
          ApiEndpoints.refresh,
          data: {'refreshToken': refreshToken},
        );

        final newAccessToken = response.data['accessToken'] as String;
        final newRefreshToken = response.data['refreshToken'] as String;

        await onTokenRefreshed(newAccessToken, newRefreshToken);

        // Retry the original request
        final opts = error.requestOptions;
        opts.headers['Authorization'] = 'Bearer $newAccessToken';
        final retryResponse = await dio.fetch(opts);
        return handler.resolve(retryResponse);
      } catch (e) {
        onAuthFailure();
        return handler.next(error);
      }
    }

    handler.next(error);
  }
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userDataKey = 'user_data';

  // Access Token
  static Future<String?> getAccessToken() =>
      _storage.read(key: _accessTokenKey);

  static Future<void> saveAccessToken(String token) =>
      _storage.write(key: _accessTokenKey, value: token);

  // Refresh Token
  static Future<String?> getRefreshToken() =>
      _storage.read(key: _refreshTokenKey);

  static Future<void> saveRefreshToken(String token) =>
      _storage.write(key: _refreshTokenKey, value: token);

  // User Data (JSON string)
  static Future<String?> getUserData() => _storage.read(key: _userDataKey);

  static Future<void> saveUserData(String jsonString) =>
      _storage.write(key: _userDataKey, value: jsonString);

  // Save both tokens at once
  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    await saveAccessToken(accessToken);
    await saveRefreshToken(refreshToken);
  }

  // Clear all auth data
  static Future<void> clearAll() => _storage.deleteAll();
}

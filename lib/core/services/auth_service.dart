import 'package:avatar_flow/core/services/secure_storage_service.dart';
import 'package:avatar_flow/core/constants/keys.dart';

class AuthService {
  // Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await SecureStorageService.readData(Keys.tokenKey);
    return token != null && token.isNotEmpty;
  }

  // Get access token
  static Future<String?> getAccessToken() async {
    return await SecureStorageService.readData(Keys.tokenKey);
  }

  // Get refresh token
  static Future<String?> getRefreshToken() async {
    return await SecureStorageService.readData(Keys.refreshTokenKey);
  }

  // Save authentication data
  static Future<void> saveAuthData({
    required String accessToken,
    String? refreshToken,
    Map<String, dynamic>? userData,
  }) async {
    await SecureStorageService.writeData(Keys.tokenKey, accessToken);

    if (refreshToken != null) {
      await SecureStorageService.writeData(Keys.refreshTokenKey, refreshToken);
    }

    if (userData != null) {
      await SecureStorageService.writeData(Keys.userData, userData.toString());
    }
  }

  // Clear authentication data (logout)
  static Future<void> clearAuthData() async {
    await SecureStorageService.deleteData(Keys.tokenKey);
    await SecureStorageService.deleteData(Keys.refreshTokenKey);
    await SecureStorageService.deleteData(Keys.userData);
    await SecureStorageService.deleteData(Keys.userId);
  }

  // Get user data
  static Future<String?> getUserData() async {
    return await SecureStorageService.readData(Keys.userData);
  }
}

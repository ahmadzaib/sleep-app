import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:avatar_flow/core/debug/debug_point.dart';
import 'package:avatar_flow/core/services/secure_storage_service.dart';
import 'package:avatar_flow/core/constants/keys.dart';
import 'package:avatar_flow/features/auth/models/user_model.dart';

class AuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // Check if user is authenticated
  static bool isAuthenticated() {
    final hasSession = _supabase.auth.currentSession != null;
    DebugPoint.log('[AUTH_SERVICE] isAuthenticated: $hasSession');
    DebugPoint.log(
      '[AUTH_SERVICE] Current session: ${_supabase.auth.currentSession?.toString()}',
    );
    return hasSession;
  }

  // Get current user
  static User? get currentUser => _supabase.auth.currentUser;

  // Get current session
  static Session? get currentSession => _supabase.auth.currentSession;

  // Get current user model
  static Future<UserModel?> getCurrentUserModel() async {
    final user = currentUser;
    DebugPoint.log('[AUTH_SERVICE] getCurrentUserModel - user: ${user?.id}');
    if (user == null) return null;

    try {
      DebugPoint.log('[AUTH_SERVICE] Querying users table for id: ${user.id}');
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      DebugPoint.log('[AUTH_SERVICE] Users table response: $response');

      if (response != null) {
        return UserModel.fromJson(response);
      }
    } catch (e, stackTrace) {
      DebugPoint.error('[AUTH_SERVICE] Error fetching from users table: $e');
      DebugPoint.log('[AUTH_SERVICE] Falling back to user metadata');
      // Fallback to user metadata if table query fails
      return UserModel(
        id: user.id,
        email: user.email!,
        name: user.userMetadata?['name'] as String?,
      );
    }
    return null;
  }

  // Sign up with email and password
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    DebugPoint.log('[AUTH_SERVICE] SignUp called - email: $email, name: $name');
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      DebugPoint.log(
        '[AUTH_SERVICE] SignUp response - userId: ${response.user?.id}',
      );
      DebugPoint.log(
        '[AUTH_SERVICE] SignUp response - hasSession: ${response.session != null}',
      );

      // Create user record in users table after successful signup
      if (response.user != null) {
        DebugPoint.log('[AUTH_SERVICE] Creating user in table...');
        await _createUserInTable(
          id: response.user!.id,
          email: email,
          name: name,
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugPoint.error('[AUTH_SERVICE] SignUp error: $e');
      DebugPoint.error('[AUTH_SERVICE] StackTrace: $stackTrace');
      rethrow;
    }
  }

  // Sign in with email and password
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    DebugPoint.log('[AUTH_SERVICE] SignIn called - email: $email');
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      DebugPoint.log(
        '[AUTH_SERVICE] SignIn success - userId: ${response.user?.id}',
      );
      return response;
    } catch (e, stackTrace) {
      DebugPoint.error('[AUTH_SERVICE] SignIn error: $e');
      DebugPoint.error('[AUTH_SERVICE] StackTrace: $stackTrace');
      rethrow;
    }
  }

  // Sign out
  static Future<void> signOut() async {
    await _supabase.auth.signOut();
    await clearAuthData();
  }

  // Reset password
  static Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  // Update password
  static Future<void> updatePassword(String newPassword) async {
    await _supabase.auth.updateUser(UserAttributes(password: newPassword));
  }

  // Listen to auth state changes
  static Stream<AuthState> get onAuthStateChange =>
      _supabase.auth.onAuthStateChange;

  // Create user in users table
  static Future<void> _createUserInTable({
    required String id,
    required String email,
    String? name,
  }) async {
    try {
      DebugPoint.log(
        '[AUTH_SERVICE] Inserting into users table - id: $id, email: $email',
      );
      await _supabase.from('users').insert({
        'id': id,
        'email': email,
        'name': name,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
      DebugPoint.log('[AUTH_SERVICE] User inserted successfully');
    } catch (e, stackTrace) {
      DebugPoint.error('[AUTH_SERVICE] Error creating user in table: $e');
      DebugPoint.error('[AUTH_SERVICE] StackTrace: $stackTrace');
      // Table might not exist or other error - ignore for now
    }
  }

  // Legacy methods for backward compatibility
  static Future<String?> getAccessToken() async {
    return currentSession?.accessToken;
  }

  static Future<String?> getRefreshToken() async {
    return currentSession?.refreshToken;
  }

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
      await SecureStorageService.writeData(Keys.userData, jsonEncode(userData));
    }
  }

  static Future<void> clearAuthData() async {
    await SecureStorageService.deleteData(Keys.tokenKey);
    await SecureStorageService.deleteData(Keys.refreshTokenKey);
    await SecureStorageService.deleteData(Keys.userData);
    await SecureStorageService.deleteData(Keys.userId);
  }

  static Future<UserModel?> getUserData() async {
    return await getCurrentUserModel();
  }
}

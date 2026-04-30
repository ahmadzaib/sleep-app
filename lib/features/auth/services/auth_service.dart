import 'dart:io';
import 'package:avatar_flow/core/constants/db_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:avatar_flow/features/auth/models/user_model.dart';

class AuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: dotenv.env['SERVE_CLIENT_ID'] ?? '',
    clientId: Platform.isIOS || Platform.isMacOS
        ? dotenv.env['IOS_CLIENT_ID'] ?? ''
        : null,
  );

  // Check if user is authenticated
  static bool isAuthenticated() {
    try {
      return _supabase.auth.currentSession != null;
    } catch (e) {
      // Session recovery failed (e.g., invalid refresh token)
      return false;
    }
  }

  // Get current user
  static User? get currentUser {
    try {
      return _supabase.auth.currentUser;
    } catch (e) {
      return null;
    }
  }

  // Get current session
  static Session? get currentSession {
    try {
      return _supabase.auth.currentSession;
    } catch (e) {
      return null;
    }
  }

  // Get current user model
  static Future<UserModel?> getCurrentUser() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      final response = await _supabase
          .from(DBConstansts.users)
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      // Fallback to user metadata if table query fails
      return UserModel(
        id: user.id,
        email: user.email!,
        name: user.userMetadata?['name'] as String?,
      );
    }
  }

  // Sign up with email and password
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );
  }

  // Sign in with email and password
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign in with Google
  static Future<AuthResponse> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google Sign-In cancelled');

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final String? idToken = googleAuth.idToken;
    if (idToken == null) throw Exception('No ID Token found');

    final response = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: googleAuth.accessToken,
    );

    // Create/update user in users table
    if (response.user != null) {
      await createUserProfile(
        id: response.user!.id,
        email: response.user!.email ?? googleUser.email,
        name:
            response.user!.userMetadata?['full_name'] as String? ??
            googleUser.displayName,
        avatarUrl:
            response.user!.userMetadata?['avatar_url'] as String? ??
            googleUser.photoUrl,
      );
    }

    return response;
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    try {
      await _supabase.auth.signOut();
    } catch (_) {
      // Force local session clear if server sign out fails
      await _supabase.auth.signOut(scope: SignOutScope.local);
    }
  }

  // Verify OTP
  static Future<AuthResponse> verifyOTP({
    required String email,
    required String token,
    required OtpType type,
  }) async {
    final response = await _supabase.auth.verifyOTP(
      email: email,
      token: token,
      type: type,
    );

    return response;
  }

  // Resend OTP
  static Future<void> resendOTP({
    required String email,
    required OtpType type,
  }) async {
    await _supabase.auth.resend(email: email, type: type);
  }

  // Send OTP for password recovery
  static Future<void> sendRecoveryOTP(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  // Update password
  static Future<void> updatePassword(String newPassword) async {
    await _supabase.auth.updateUser(UserAttributes(password: newPassword));
  }

  // Listen to auth state changes
  static Stream<AuthState> get onAuthStateChange =>
      _supabase.auth.onAuthStateChange;

  // Create user profile in users table
  static Future<void> createUserProfile({
    required String id,
    required String email,
    String? name,
    String? avatarUrl,
    bool? voiceAgreementAccepted,
  }) async {
    try {
      // Build data map for upsert - always update all fields
      final data = <String, dynamic>{
        'id': id,
        'email': email,
        'name': name,
        'avatar_url': avatarUrl,
        'voice_agreement_accepted': voiceAgreementAccepted ?? false,
      };

      debugPrint('[AUTH_SERVICE] Inserting user data: $data');

      final result = await _supabase
          .from(DBConstansts.users)
          .upsert(data, onConflict: 'id')
          .select();
      debugPrint('[AUTH_SERVICE] User upsert successful: $result');
    } catch (e) {
      debugPrint('[AUTH_SERVICE] ERROR creating user in table: $e');
      // Don't rethrow - auth should work even if user table insert fails
    }
  }

  // Update user voice agreement status
  static Future<void> updateVoiceAgreement({
    required String id,
    required bool accepted,
  }) async {
    try {
      final data = <String, dynamic>{'voice_agreement_accepted': accepted};

      await _supabase.from(DBConstansts.users).update(data).eq('id', id);

      debugPrint('[AUTH_SERVICE] Voice agreement updated: $accepted');
    } catch (e) {
      debugPrint('[AUTH_SERVICE] ERROR updating voice agreement: $e');
    }
  }

  // Update user profile in users table
  static Future<void> updateUserProfile({
    required String id,
    String? name,
    String? avatarUrl,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (avatarUrl != null) data['avatar_url'] = avatarUrl;

      if (data.isEmpty) return;

      debugPrint('[AUTH_SERVICE] Updating user profile: $data');

      final result = await _supabase
          .from(DBConstansts.users)
          .update(data)
          .eq('id', id)
          .select();
      debugPrint('[AUTH_SERVICE] User update successful: $result');
    } catch (e) {
      debugPrint('[AUTH_SERVICE] ERROR updating user profile: $e');
      rethrow;
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';

class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();
  AuthService._();

  final SupabaseClient _client = SupabaseService.instance.client;

  // Get current user
  User? get currentUser => _client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  // Sign Up
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'phone': phoneNumber,
        },
      );

      if (response.user != null) {
        debugPrint('✅ User signed up successfully: ${response.user!.email}');
      }

      return response;
    } catch (error) {
      debugPrint('❌ Sign up failed: $error');
      rethrow;
    }
  }

  // Sign In
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        debugPrint('✅ User signed in successfully: ${response.user!.email}');
      }

      return response;
    } catch (error) {
      debugPrint('❌ Sign in failed: $error');
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      debugPrint('✅ User signed out successfully');
    } catch (error) {
      debugPrint('❌ Sign out failed: $error');
      rethrow;
    }
  }

  // Send Password Reset Email
  Future<void> resetPassword({required String email}) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      debugPrint('✅ Password reset email sent to: $email');
    } catch (error) {
      debugPrint('❌ Password reset failed: $error');
      rethrow;
    }
  }

  // Listen to auth state changes
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Get user profile data
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (!isAuthenticated) return null;

    try {
      final response = await _client
          .from('user_profiles')
          .select()
          .eq('id', currentUser!.id)
          .single();

      return response;
    } catch (error) {
      debugPrint('❌ Failed to get user profile: $error');
      return null;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile({
    String? fullName,
    String? phoneNumber,
    String? address,
    String? city,
  }) async {
    if (!isAuthenticated) return false;

    try {
      final updates = <String, dynamic>{};
      if (fullName != null) updates['full_name'] = fullName;
      if (phoneNumber != null) updates['phone_number'] = phoneNumber;
      if (address != null) updates['address'] = address;
      if (city != null) updates['city'] = city;
      updates['updated_at'] = DateTime.now().toIso8601String();

      await _client
          .from('user_profiles')
          .update(updates)
          .eq('id', currentUser!.id);

      debugPrint('✅ User profile updated successfully');
      return true;
    } catch (error) {
      debugPrint('❌ Failed to update user profile: $error');
      return false;
    }
  }
}

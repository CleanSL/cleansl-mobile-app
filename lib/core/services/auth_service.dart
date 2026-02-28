import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // Get the global Supabase instance
  final _supabase = Supabase.instance.client;

  /// Signs up a new resident and saves their profile details
  Future<void> signUpResident({
    required String fullName,
    required String mobile,
    required String email,
    required String password,
  }) async {
    // 1. Create the secure Auth User
    final AuthResponse response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;

    // 2. If Auth succeeded, save the extra details into the 'profiles' table
    if (user != null) {
      await _supabase.from('profiles').insert({
        'id': user.id, // Links directly to the auth user
        'full_name': fullName,
        'mobile': mobile,
        'email': email,
      });
    }
  }

  /// Logs in an existing resident
  Future<void> signInResident({
    required String email,
    required String password,
  }) async {
    await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
}
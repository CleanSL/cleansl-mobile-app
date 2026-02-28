import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // The global Supabase connection
  final _supabase = Supabase.instance.client;

  /// Signs up a new resident and saves their profile details
  Future<void> signUpResident({
    required String fullName,
    required String mobile,
    required String email,
    required String password,
  }) async {
    // 1. Create the secure Auth User using Email (Free and standard)
    final AuthResponse response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;

    // 2. Save all details, including mobile, into the 'profiles' table
    if (user != null) {
      await _supabase.from('profiles').insert({
        'id': user.id,
        'full_name': fullName,
        'mobile': mobile,
        'email': email,
      });
    }
  }

  /// Logs in an existing resident using either Email OR Mobile Number
  Future<void> signInResident({
    required String identifier, // Catches either email or mobile from the UI
    required String password,
  }) async {
    String loginEmail = identifier;

    // STEP 1: Check if the account actually exists in our profiles table
    if (identifier.contains('@')) {
      // It's an email, let's verify it exists
      final response = await _supabase
          .from('profiles')
          .select('email')
          .eq('email', identifier)
          .maybeSingle();

      if (response == null) {
        throw Exception("No account found with this email address.");
      }
    } else {
      // It's a mobile number, let's find the attached email
      final response = await _supabase
          .from('profiles')
          .select('email')
          .eq('mobile', identifier)
          .maybeSingle();

      if (response == null) {
        throw Exception("No account found with this mobile number.");
      }
      
      // Grab the email attached to that phone number
      loginEmail = response['email'];
    }

    // STEP 2: Log into the secure Auth system using the verified email
    try {
      await _supabase.auth.signInWithPassword(
        email: loginEmail,
        password: password,
      );
    } on AuthException catch (e) {
      // Supabase throws an AuthException if the password doesn't match
      if (e.message == 'Invalid login credentials') {
        throw Exception("Incorrect password. Please try again.");
      }
      // If it's a different error (like rate limiting), show the default message
      throw Exception(e.message);
    }
  }
}
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 

class AuthService {
  // The global Supabase connection
  final _supabase = Supabase.instance.client;

  // ==========================================
  // RESIDENT AUTHENTICATION (EMAIL/MOBILE)
  // ==========================================

  Future<void> signUpResident({
    required String fullName,
    required String mobile,
    required String email,
    required String password,
  }) async {
    final AuthResponse response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;

    if (user != null) {
      await _supabase.from('users').insert({
        'id': user.id,
        'role': 'resident', 
        'full_name': fullName,
        'phone_number': mobile, 
        'email': email, 
      });

      await _supabase.from('resident_profiles').insert({
        'user_id': user.id,
        'total_points': 0,
      });
    }
  }

  Future<void> signInResident({
    required String identifier, 
    required String password,
  }) async {
    String loginEmail = identifier;

    if (identifier.contains('@')) {
      final response = await _supabase
          .from('users')
          .select('email')
          .eq('email', identifier)
          .eq('role', 'resident') 
          .maybeSingle();

      if (response == null) {
        throw Exception("No resident account found with this email address.");
      }
    } else {
      final response = await _supabase
          .from('users')
          .select('email')
          .eq('phone_number', identifier) 
          .eq('role', 'resident')
          .maybeSingle();

      if (response == null) {
        throw Exception("No resident account found with this mobile number.");
      }
      loginEmail = response['email'];
    }

    try {
      await _supabase.auth.signInWithPassword(
        email: loginEmail,
        password: password,
      );
    } on AuthException catch (e) {
      if (e.message == 'Invalid login credentials') {
        throw Exception("Incorrect password. Please try again.");
      }
      throw Exception(e.message);
    }
  }

  // ==========================================
  // GOOGLE AUTHENTICATION (v7.2.0 COMPLIANT)
  // ==========================================

  Future<void> signInWithGoogle() async {
    final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'];
    
    if (webClientId == null) {
      throw Exception('Missing GOOGLE_WEB_CLIENT_ID in .env file');
    }

    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize(
      clientId: webClientId,       
      serverClientId: webClientId, 
    );

    final scopes = ['email', 'profile'];

    await googleSignIn.signOut();
    final googleUser = await googleSignIn.authenticate(scopeHint: scopes);

    if (googleUser == null) return; 

    final authorization = await googleUser.authorizationClient.authorizationForScopes(scopes) ?? 
                          await googleUser.authorizationClient.authorizeScopes(scopes);

    final idToken = googleUser.authentication.idToken;
    final accessToken = authorization.accessToken;

    if (idToken == null) {
      throw Exception('Failed to retrieve Google ID token.');
    }

    final response = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    final user = response.user;
    
    if (user != null) {
      final existingUser = await _supabase
          .from('users')
          .select('id')
          .eq('id', user.id)
          .maybeSingle();

      if (existingUser == null) {
        await _supabase.from('users').insert({
          'id': user.id,
          'role': 'resident',
          'full_name': user.userMetadata?['full_name'] ?? 'Google User',
          'email': user.email ?? '',
        });

        await _supabase.from('resident_profiles').insert({
          'user_id': user.id,
          'total_points': 0,
        });
      }
    }
  }

  // ==========================================
  // DRIVER AUTHENTICATION (OTP FLOW)
  // ==========================================

  Future<void> sendDriverOTP({required String mobile}) async {
    final driverCheck = await _supabase
        .from('users')
        .select('id')
        .eq('phone_number', mobile)
        .eq('role', 'driver')
        .maybeSingle();

    if (driverCheck == null) {
      throw Exception("No authorized driver account found for this number.");
    }

    final formattedNumber = '+94$mobile';
    await _supabase.auth.signInWithOtp(phone: formattedNumber);
  }

  Future<void> verifyDriverOTP({required String mobile, required String token}) async {
    final formattedNumber = '+94$mobile';
    final AuthResponse response = await _supabase.auth.verifyOTP(
      phone: formattedNumber,
      token: token,
      type: OtpType.sms,
    );
    
    if (response.user == null) {
      throw Exception("Verification failed. Please try again.");
    }
  }
}
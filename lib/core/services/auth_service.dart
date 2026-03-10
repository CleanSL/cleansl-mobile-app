import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// To grab your Web Client ID securely

class AuthService {
  // The global Supabase connection
  final _supabase = Supabase.instance.client;

  // ==========================================
  // RESIDENT AUTHENTICATION (EMAIL/MOBILE)
  // ==========================================

  /// Signs up a new resident and saves their profile details
  Future<void> signUpResident({required String fullName, required String mobile, required String email, required String password}) async {
    // 1. Create the secure Auth User using Email (Free and standard)
    final AuthResponse response = await _supabase.auth.signUp(email: email, password: password);

    final user = response.user;

    // 2. Save all details, including mobile, into the 'resident_profiles' table
    if (user != null) {
      await _supabase.from('resident_profiles').insert({'id': user.id, 'full_name': fullName, 'mobile': mobile, 'email': email});
    }
  }

  /// Logs in an existing resident using either Email OR Mobile Number
  Future<void> signInResident({
    required String identifier, // Catches either email or mobile from the UI
    required String password,
  }) async {
    String loginEmail = identifier;

    // STEP 1: Check if the account actually exists in our resident_profiles table
    if (identifier.contains('@')) {
      // It's an email, let's verify it exists
      final response = await _supabase.from('resident_profiles').select('email').eq('email', identifier).maybeSingle();

      if (response == null) {
        throw Exception("No account found with this email address.");
      }
    } else {
      // It's a mobile number, let's find the attached email
      final response = await _supabase.from('resident_profiles').select('email').eq('mobile', identifier).maybeSingle();

      if (response == null) {
        throw Exception("No account found with this mobile number.");
      }

      // Grab the email attached to that phone number
      loginEmail = response['email'];
    }

    // STEP 2: Log into the secure Auth system using the verified email
    try {
      await _supabase.auth.signInWithPassword(email: loginEmail, password: password);
    } on AuthException catch (e) {
      // Supabase throws an AuthException if the password doesn't match
      if (e.message == 'Invalid login credentials') {
        throw Exception("Incorrect password. Please try again.");
      }
      // If it's a different error (like rate limiting), show the default message
      throw Exception(e.message);
    }
  }
  // ==========================================
  // GOOGLE AUTHENTICATION (v7.2.0 COMPLIANT)
  // ==========================================

  /// Triggers the native Google Sign-In and passes the token to Supabase
  Future<void> signInWithGoogle() async {
    // 1. Grab your Web Client ID from the hidden .env file
    final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'];

    if (webClientId == null) {
      throw Exception('Missing GOOGLE_WEB_CLIENT_ID in .env file');
    }

    // 2. Initialize the v7 Singleton
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize(clientId: webClientId, serverClientId: webClientId);

    // 3. NEW v7 LOGIC: Define what permissions we need to get the Access Token
    final scopes = ['email', 'profile'];

    // 4. Trigger the bottom sheet for the user to select their Gmail account
    await googleSignIn.signOut();
    final googleUser = await googleSignIn.authenticate(scopeHint: scopes);

    // 5. NEW v7 LOGIC: Fetch the Access Token using the new Authorization Client
    final authorization = await googleUser.authorizationClient.authorizationForScopes(scopes) ?? await googleUser.authorizationClient.authorizeScopes(scopes);

    // 6. Gather the two tokens from their new, completely separate locations
    final idToken = googleUser.authentication.idToken;
    if (idToken == null) {
      throw Exception('Failed to get ID token from Google.');
    }
    final accessToken = authorization.accessToken;

    // 7. Hand the tokens to Supabase to verify and log the user in!
    await _supabase.auth.signInWithIdToken(provider: OAuthProvider.google, idToken: idToken, accessToken: accessToken);
  }
  // ==========================================
  // DRIVER AUTHENTICATION (OTP FLOW)
  // ==========================================

  /// 1. Sends the OTP to the driver's phone
  Future<void> sendDriverOTP({required String mobile}) async {
    // Append the Sri Lanka country code automatically
    final formattedNumber = '+94$mobile';
    await _supabase.auth.signInWithOtp(phone: formattedNumber);
  }

  /// 2. Verifies the code the driver typed in
  Future<void> verifyDriverOTP({required String mobile, required String token}) async {
    final formattedNumber = '+94$mobile';
    final AuthResponse response = await _supabase.auth.verifyOTP(phone: formattedNumber, token: token, type: OtpType.sms);

    if (response.user == null) {
      throw Exception("Verification failed. Please try again.");
    }
  }
}

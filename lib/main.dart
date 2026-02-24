import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // 1. Import Supabase

// Import custom theme file
import 'core/theme/app_theme.dart';
// Import feature pages
import 'features/onboarding/presentation/pages/language_selection_page.dart';
import 'features/onboarding/presentation/pages/role_selection_page.dart';
import 'features/driver_auth/presentation/pages/driver_login_page.dart';
import 'features/driver_auth/presentation/pages/driver_otp_page.dart';
import 'features/resident_auth/presentation/pages/resident_auth_hub_page.dart';
import 'features/resident_auth/presentation/pages/resident_login_page.dart';
import 'features/resident_auth/presentation/pages/resident_signup_page.dart';

// 2. Change main to be an asynchronous function
Future<void> main() async {
  // Ensure Flutter bindings are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  
  // 3. Initialize Supabase
  // You can find these keys in your Supabase Dashboard under Project Settings -> API
  await Supabase.initialize(
    url: 'https://stpfrtvhfwlpdlmgmhbo.supabase.co',
    anonKey: 'sb_publishable_ChBz3flKPHZRVL0jR2mQqg_e6FrkAYM',
  );

  runApp(const SmartResidentApp());
}

// 4. Create a global variable for easy access to the client throughout your app
final supabase = Supabase.instance.client;

class SmartResidentApp extends StatelessWidget {
  const SmartResidentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Removes the "Debug" banner from the top right corner
      debugShowCheckedModeBanner: false,

      title: 'Smart Resident',

      // Using your custom brand guidelines from app_theme.dart
      theme: AppTheme.lightTheme,

      // Setting the initial flow: Language -> Role -> Specific Auth
      initialRoute: '/language',

      // Define the routes for navigation
      routes: {
        '/language': (context) => const LanguageSelectionPage(),
        '/role': (context) => const RoleSelectionPage(),
        '/driver-login': (context) => const DriverLoginPage(),
        '/driver-otp': (context) => const DriverOtpPage(),
        '/resident-auth-hub': (context) => const ResidentAuthHubPage(), 
        '/resident-login': (context) => const ResidentLoginPage(), 
        '/resident-signup': (context) => const ResidentSignUpPage(), 
      },
    );
  }
}
import 'package:flutter/material.dart';
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

void main() {
  // Ensure Flutter bindings are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartResidentApp());
}

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
        '/resident-auth-hub': (context) => const ResidentAuthHubPage(), // This is the hub where residents choose to log in or sign up
        '/resident-login': (context) => const ResidentLoginPage(), // Placeholder for the actual login page
        '/resident-signup': (context) => const ResidentSignUpPage(), // Placeholder for the actual sign-up page
      },
    );
  }
}
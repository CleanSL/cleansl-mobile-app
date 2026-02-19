import 'package:flutter/material.dart';
// Import custom theme file
import 'core/theme/app_theme.dart';
// Import feature pages
import 'features/onboarding/presentation/pages/language_selection_page.dart';
import 'features/onboarding/presentation/pages/role_selection_page.dart';
import 'features/driver_auth/presentation/pages/driver_login_page.dart';

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

        // Placeholder for the next screen we build
        '/driver-otp': (context) => const Scaffold(body: Center(child: Text("Enter OTP Screen"))),
        '/resident-auth': (context) => const Scaffold(body: Center(child: Text("Resident Auth Hub"))),
      },
    );
  }
}

// --- Placeholder Classes ---
// I've added these placeholders so the code doesn't crash when you run it.
// We will replace these with real files as we build them.

class ResidentAuthHub extends StatelessWidget {
  const ResidentAuthHub({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text("Resident Sign In / Sign Up Screen")));
}

class ResidentSignUpPage extends StatelessWidget {
  const ResidentSignUpPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text("Resident Sign Up Form")));
}

class CreateUsernamePage extends StatelessWidget {
  const CreateUsernamePage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text("Create Username Screen")));
}
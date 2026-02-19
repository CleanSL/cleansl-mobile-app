import 'package:flutter/material.dart';
// Import custom theme file
import 'core/theme/app_theme.dart'; 
// Import feature pages
import 'features/auth/presentation/pages/language_selection_page.dart';
import 'features/auth/presentation/pages/role_selection_page.dart';

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
        // Initial Screen
        '/language': (context) => const LanguageSelectionPage(),
        
        // Secondary Common Screen
        '/role': (context) => const RoleSelectionPage(),
        
        // Resident Auth Flow
        '/resident-auth': (context) => const ResidentAuthHub(), // We can build this next
        '/resident-signup': (context) => const ResidentSignUpPage(),
        '/resident-username': (context) => const CreateUsernamePage(),
        
        // Driver Auth Flow
        '/driver-login': (context) => const DriverLoginPage(), // OTP flow
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

class DriverLoginPage extends StatelessWidget {
  const DriverLoginPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text("Driver OTP Login Screen")));
}
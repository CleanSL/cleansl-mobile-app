import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../core/services/auth_service.dart'; //  ADDED:backend service
import '../../../../../shared/widgets/cleansl_button.dart';
import '../../../../../shared/widgets/cleansl_text_input.dart';
import '../../../../../shared/widgets/cleansl_mobnum_input.dart';
import '../widgets/resident_auth_template.dart';

class ResidentLoginPage extends StatefulWidget {
  const ResidentLoginPage({super.key});

  @override
  State<ResidentLoginPage> createState() => _ResidentLoginPageState();
}

class _ResidentLoginPageState extends State<ResidentLoginPage> {
  // Teammate's original UI toggle
  bool _isEmailMode = false;

  // 🟢 ADDED: Memory and Connection setup
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 🟢 ADDED: Cleanup to prevent memory leaks
  @override
  void dispose() {
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double gap = Responsive.h(context, AppTheme.space16);
    final double sectionGap = Responsive.h(context, AppTheme.space16);

    return ResidentAuthTemplate(
      title: "Welcome back",
      subtitle: "Please enter your account details to continue making a difference in your community.",
      topSpacing: AppTheme.space16,
      formChildren: [
        // 🟢 CHANGED: Removed 'const' and added your controllers to his inputs
        _isEmailMode
            ? CleanSlTextInput(hintText: "Email", keyboardType: TextInputType.emailAddress, controller: _emailController)
            : CleanSlMobNumInput(controller: _mobileController),
        SizedBox(height: gap),
        
        CleanSlTextInput(hintText: "Password", isPassword: true, controller: _passwordController),

        SizedBox(height: gap),

        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {},
            child: Text(
              "Forgot Password?",
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: AppTheme.accentColor, fontSize: Responsive.sp(context, 16)),
            ),
          ),
        ),

        SizedBox(height: gap),

        // 🟢 CHANGED: Wrapped his button in your loading state and database logic
        _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppTheme.accentColor))
            : CleanSlButton(
                text: "Sign In",
                variant: ButtonVariant.primary,
                onPressed: () async {
                  // Basic Validation
                  final identifier = _isEmailMode ? _emailController.text.trim() : _mobileController.text.trim();
                  final password = _passwordController.text.trim();

                  if (identifier.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill in all fields")));
                    return;
                  }

                  setState(() => _isLoading = true);

                  try {
                    // Right now, Supabase expects an email to log in
                    await _authService.signInResident(
                      identifier: identifier,
                      password: password,
                    );
                    
                    // If Supabase says the password is correct, go to the main app!
                    if (mounted) Navigator.pushReplacementNamed(context, '/resident-main');
                  } catch (e) {
                    // Show error if password is wrong or user doesn't exist
                    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                  } finally {
                    if (mounted) setState(() => _isLoading = false);
                  }
                },
              ),

        SizedBox(height: gap),

        Row(
          children: [
            const Expanded(child: Divider(color: Colors.white38, thickness: 1)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, AppTheme.space16)),
              child: Text("or", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
            ),
            const Expanded(child: Divider(color: Colors.white38, thickness: 1)),
          ],
        ),

        SizedBox(height: gap),

        CleanSlButton(
          text: "Continue with Google",
          variant: ButtonVariant.secondary,
          icon: SvgPicture.asset(
            'assets/icons/google_logo.svg',
            height: Responsive.h(context, 32),
            width: Responsive.w(context, 32),
          ),
      onPressed: () async {
            setState(() => _isLoading = true);

            try {
              // 1. Run your new Google Sign-In function
              await _authService.signInWithGoogle();
              
              // 2. If successful, push them to the main app dashboard!
              if (mounted) Navigator.pushReplacementNamed(context, '/resident-main');
            } catch (e) {
              // Show any errors (like if they closed the Google popup)
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
            } finally {
              if (mounted) setState(() => _isLoading = false);
            }
          },
        
        ),

        SizedBox(height: gap),

        CleanSlButton(
          text: _isEmailMode ? "Continue with Mobile " : "Continue with Email",
          variant: ButtonVariant.secondary,
          icon: _isEmailMode
              ? Icon(Icons.phone_android_rounded, color: AppTheme.textColor, size: Responsive.w(context, 28))
              : Icon(Icons.email_outlined, color: AppTheme.textColor, size: Responsive.w(context, 28)),
          onPressed: () {
            setState(() {
              _isEmailMode = !_isEmailMode;
            });
          },
        ),

        SizedBox(height: sectionGap),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryBackground.withValues(alpha: 0.8),
                fontSize: Responsive.sp(context, 14),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(context, '/resident-signup'),
              child: Text(
                "Sign Up",
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: AppTheme.accentColor, fontSize: Responsive.sp(context, 16)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
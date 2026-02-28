import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/widgets/cleansl_button.dart';
import '../../../../../shared/widgets/cleansl_text_input.dart';
import '../../../../../shared/widgets/cleansl_mobnum_input.dart';
import '../widgets/resident_auth_template.dart';
import '../../../../../core/services/auth_service.dart';

class ResidentSignUpPage extends StatefulWidget {
  const ResidentSignUpPage({super.key});

  @override
  State<ResidentSignUpPage> createState() => _ResidentSignUpPageState();
}

class _ResidentSignUpPageState extends State<ResidentSignUpPage> {
  // 2. Initialized the service, loading state, and all controllers
  final AuthService _authService = AuthService();
  bool _agreedToTerms = false;
  bool _isLoading = false;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // Always dispose controllers to prevent memory leaks
    _fullNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double fieldGap = Responsive.h(context, 20);
    final double sectionGap = Responsive.h(context, AppTheme.space16);
    final double smallGap = Responsive.h(context, AppTheme.space16);
    final double checkboxSize = Responsive.w(context, 24);

    return ResidentAuthTemplate(
      title: "Get Started",
      subtitle: "Please enter your details to create a new account.",
      topSpacing: AppTheme.space16,
      formChildren: [
        // 3. Attached the controllers to your inputs!
        CleanSlTextInput(hintText: "Full Name", controller: _fullNameController),
        SizedBox(height: fieldGap),
        
        CleanSlMobNumInput(controller: _mobileController),
        SizedBox(height: fieldGap),
        
        CleanSlTextInput(hintText: "Email", keyboardType: TextInputType.emailAddress, controller: _emailController),
        SizedBox(height: fieldGap),
        
        CleanSlTextInput(hintText: "Create Password", isPassword: true, controller: _passwordController),
        SizedBox(height: fieldGap),
        
        CleanSlTextInput(hintText: "Confirm Password", isPassword: true, controller: _confirmPasswordController),

        SizedBox(height: fieldGap),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: checkboxSize,
              height: checkboxSize,
              child: Checkbox(
                value: _agreedToTerms,
                onChanged: (value) {
                  setState(() {
                    _agreedToTerms = value ?? false;
                  });
                },
                activeColor: AppTheme.accentColor,
                checkColor: Colors.white,
                side: const BorderSide(color: Colors.white54, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
            SizedBox(width: Responsive.w(context, 8)),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _agreedToTerms = !_agreedToTerms;
                  });
                },
                child: Text.rich(
                  TextSpan(
                    text: "I agree to the ",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.primaryBackground.withValues(alpha: 0.8),
                      fontSize: Responsive.sp(context, 12),
                    ),
                    children: [
                      TextSpan(
                        text: "Terms & Conditions",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.accentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: Responsive.sp(context, 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: sectionGap),

        // 4. Fixed the onPressed syntax and added the loading spinner
        _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppTheme.accentColor))
            : CleanSlButton(
                text: "Sign Up",
                variant: ButtonVariant.primary,
                onPressed: () async { // <-- Fixed async syntax here
                  // Basic Validation
                  if (!_agreedToTerms) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please agree to the Terms & Conditions.")));
                    return;
                  }
                  if (_passwordController.text != _confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords do not match.")));
                    return;
                  }

                  setState(() => _isLoading = true);

                  try {
                    await _authService.signUpResident(
                      fullName: _fullNameController.text.trim(),
                      mobile: _mobileController.text.trim(),
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    );

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Account created successfully!")));
                      Navigator.pushReplacementNamed(context, '/resident-login');
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  } finally {
                    if (mounted) {
                      setState(() => _isLoading = false);
                    }
                  }
                },
              ),

        SizedBox(height: smallGap),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account? ",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryBackground.withValues(alpha: 0.8),
                fontSize: Responsive.sp(context, 14),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(context, '/resident-login'),
              child: Text(
                "Sign In",
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
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/cleansl_button.dart';
import '../../../../shared/widgets/cleansl_text_input.dart';
import '../../../../shared/widgets/cleansl_mobNum_input.dart';
import '../widgets/resident_auth_template.dart';

class ResidentLoginPage extends StatelessWidget {
  const ResidentLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResidentAuthTemplate(
      title: "Welcome back",
      subtitle: "Please enter your account details to continue making a difference in your community.",
      formChildren: [
        const CleanSlMobNumInput(),
        const SizedBox(height: AppTheme.space24),
        const CleanSlTextInput(hintText: "Password", isPassword: true),

        const SizedBox(height: AppTheme.space24),

        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {},
            child: Text(
              "Forgot Password?",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppTheme.accentColor),
            ),
          ),
        ),

        const SizedBox(height: AppTheme.space24),

        CleanSlButton(text: "Sign In", variant: ButtonVariant.primary, onPressed: () {}),

        const SizedBox(height: AppTheme.space24),

        Row(
          children: [
            const Expanded(child: Divider(color: Colors.white38, thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.space16),
              child: Text("or", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
            ),
            const Expanded(child: Divider(color: Colors.white38, thickness: 1)),
          ],
        ),

        const SizedBox(height: AppTheme.space24),

        CleanSlButton(
          text: "Continue with Google",
          variant: ButtonVariant.secondary,
          icon: SvgPicture.asset('assets/icons/google_logo.svg', height: 32, width: 32),
          onPressed: () {},
        ),

        const SizedBox(height: AppTheme.space16),

        CleanSlButton(
          text: "Continue with Email",
          variant: ButtonVariant.secondary,
          icon: const Icon(Icons.email_outlined, color: AppTheme.textColor, size: 28),
          onPressed: () {},
        ),

        const SizedBox(height: AppTheme.space32),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.primaryBackground.withValues(alpha: 0.8)),
            ),
            GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(context, '/resident-signup'),
              child: Text(
                "Sign Up",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppTheme.accentColor),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

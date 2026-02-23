import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/cleansl_button.dart';
import '../../../../shared/widgets/cleansl_text_input.dart';
import '../../../../shared/widgets/cleansl_mobnum_input.dart';
import '../widgets/resident_auth_template.dart';

class ResidentLoginPage extends StatelessWidget {
  const ResidentLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double gap = Responsive.h(context, AppTheme.space16);
    final double smallGap = Responsive.h(context, AppTheme.space8);
    final double sectionGap = Responsive.h(context, AppTheme.space16);

    return ResidentAuthTemplate(
      title: "Welcome back",
      subtitle: "Please enter your account details to continue making a difference in your community.",
      topSpacing: AppTheme.space16,
      formChildren: [
        const CleanSlMobNumInput(),
        SizedBox(height: gap),
        const CleanSlTextInput(hintText: "Password", isPassword: true),

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

        CleanSlButton(text: "Sign In", variant: ButtonVariant.primary, onPressed: () {}),

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
          onPressed: () {},
        ),

        SizedBox(height: gap),

        CleanSlButton(
          text: "Continue with Email",
          variant: ButtonVariant.secondary,
          icon: Icon(Icons.email_outlined, color: AppTheme.textColor, size: Responsive.w(context, 28)),
          onPressed: () {},
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

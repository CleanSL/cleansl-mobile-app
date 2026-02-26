import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/widgets/cleansl_button.dart';
import '../../../../../shared/widgets/cleansl_text_input.dart';
import '../../../../../shared/widgets/cleansl_mobnum_input.dart';
import '../widgets/resident_auth_template.dart';

class ResidentSignUpPage extends StatefulWidget {
  const ResidentSignUpPage({super.key});

  @override
  State<ResidentSignUpPage> createState() => _ResidentSignUpPageState();
}

class _ResidentSignUpPageState extends State<ResidentSignUpPage> {
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    final double fieldGap = Responsive.h(context, 20);
    final double sectionGap = Responsive.h(context, AppTheme.space16);
    final double smallGap = Responsive.h(context, AppTheme.space16);
    final double checkboxSize = Responsive.w(context, 24);

    return ResidentAuthTemplate(
      title: "Get Started",
      subtitle: "Please enter your details to create an new account.",
      topSpacing: AppTheme.space16,
      formChildren: [
        const CleanSlTextInput(hintText: "Full Name"),
        SizedBox(height: fieldGap),
        const CleanSlMobNumInput(),
        SizedBox(height: fieldGap),
        const CleanSlTextInput(hintText: "Email", keyboardType: TextInputType.emailAddress),
        SizedBox(height: fieldGap),
        const CleanSlTextInput(hintText: "Create Password", isPassword: true),
        SizedBox(height: fieldGap),
        const CleanSlTextInput(hintText: "Confirm Password", isPassword: true),

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

        CleanSlButton(text: "Sign Up", variant: ButtonVariant.primary, onPressed: () {}),

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

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/widgets/cleansl_button.dart';
import '../../../../../shared/widgets/cleansl_otp_input.dart';
import '../../../../../shared/widgets/cleansl_resend_timer.dart';
import '../../../../common/onboarding/presentation/widgets/auth_screen_template.dart';

class DriverOtpPage extends StatelessWidget {
  const DriverOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScreenTemplate(
      title: "Verify your number",
      subtitle: "Enter the 4-digit code we just sent to +94 77 123 4567",
      actionButtons: [
        const CleanSlOtpInput(),

        SizedBox(height: Responsive.h(context, 32)),

        CleanSlButton(
          text: "Verify & Login",
          variant: ButtonVariant.primary,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  "OTP Verified Successfully!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.primaryBackground, fontWeight: FontWeight.w500),
                ),
                backgroundColor: AppTheme.accentColor,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(
                  bottom: Responsive.h(context, 32),
                  left: Responsive.w(context, 48),
                  right: Responsive.w(context, 48),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.r(context, 30))),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),

        SizedBox(height: Responsive.h(context, 24)),

        CleanSlResendTimer(
          onResend: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("New OTP sent!", textAlign: TextAlign.center),
                backgroundColor: AppTheme.accentColor,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(
                  bottom: Responsive.h(context, 32),
                  left: Responsive.w(context, 80),
                  right: Responsive.w(context, 80),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.r(context, 30))),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),

        SizedBox(height: Responsive.h(context, 16)),

        CleanSlButton(
          text: "Change mobile number",
          variant: ButtonVariant.text,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

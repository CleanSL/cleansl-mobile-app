import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/cleansl_button.dart';
import '../../../../shared/widgets/cleansl_otp_input.dart';
import '../../../../shared/widgets/cleansl_resend_timer.dart'; // Import the new timer
import '../../../onboarding/presentation/widgets/auth_screen_template.dart';

// Back to a StatelessWidget! So much cleaner.
class DriverOtpPage extends StatelessWidget {
  const DriverOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScreenTemplate(
      title: "Verify your number",
      subtitle: "Enter the 4-digit code we just sent to +94 77 123 4567",
      actionButtons: [
        const CleanSlOtpInput(),

        const SizedBox(height: 32),

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
                margin: const EdgeInsets.only(bottom: 32, left: 48, right: 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),

        const SizedBox(height: 24),

        // Just ONE line of code for your complex timer!
        CleanSlResendTimer(
          onResend: () {
            // This is where you actually tell the backend to send a new SMS
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("New OTP sent!", textAlign: TextAlign.center),
                backgroundColor: AppTheme.accentColor,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.only(bottom: 32, left: 80, right: 80),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        CleanSlButton(
          text: "Change mobile number",
          variant: ButtonVariant.text,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

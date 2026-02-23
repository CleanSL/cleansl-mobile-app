import 'package:flutter/material.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/cleansl_mobnum_input.dart';
import '../../../../shared/widgets/cleansl_button.dart';
import '../../../onboarding/presentation/widgets/auth_screen_template.dart';

class DriverLoginPage extends StatelessWidget {
  const DriverLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScreenTemplate(
      title: "Driver Access",
      subtitle: "Enter your registered mobile number. We'll send you an OTP to verify it's you.",
      actionButtons: [
        // 1. Mobile Number Input Field
        const CleanSlMobNumInput(),

        SizedBox(height: Responsive.h(context, 32)),

        // 2. Send OTP Button
        CleanSlButton(
          text: "Send OTP",
          variant: ButtonVariant.primary,
          onPressed: () {
            Navigator.pushNamed(context, '/driver-otp');
          },
        ),

        SizedBox(height: Responsive.h(context, 16)),

        // 3. Back Button
        CleanSlButton(text: "Cancel", variant: ButtonVariant.text, onPressed: () => Navigator.pop(context)),
      ],
    );
  }
}

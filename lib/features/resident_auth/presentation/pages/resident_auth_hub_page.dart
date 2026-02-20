import 'package:flutter/material.dart';
import '../../../../shared/widgets/cleansl_button.dart';
import '../../../onboarding/presentation/widgets/auth_screen_template.dart';

class ResidentAuthHubPage extends StatelessWidget {
  const ResidentAuthHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScreenTemplate(
      title: "Resident Access",
      subtitle: "Log in to schedule your waste collection, or sign up to start making a difference.",
      actionButtons: [
        // 1. Sign In Button
        CleanSlButton(
          text: "Log In",
          variant: ButtonVariant.primary,
          onPressed: () {
            // Navigate to the Resident Login form
            Navigator.pushNamed(context, '/resident-login');
          },
        ),

        const SizedBox(height: 16), // Spacing between buttons
        // 2. Create Account Button
        CleanSlButton(
          text: "Create an Account",
          variant: ButtonVariant.secondary, // Uses the outlined/secondary style
          onPressed: () {
            // Navigate to the Resident Sign-Up form
            Navigator.pushNamed(context, '/resident-signup');
          },
        ),

        const SizedBox(height: 24), // A bit more space before the cancel button
        // 3. Go Back / Cancel Button
        CleanSlButton(
          text: "Back to Role Selection",
          variant: ButtonVariant.text,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

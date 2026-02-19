import 'package:flutter/material.dart';
import '../../../../shared/widgets/cleansl_button.dart';
import '../widgets/auth_screen_template.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScreenTemplate(
      title: "Select your role",
      subtitle: "Tell us how you'll be using the app",
      actionButtons: [
        CleanSlButton(
          text: "Resident",
          onPressed: () => Navigator.pushNamed(context, '/resident-auth'),
          variant: ButtonVariant.primary,
        ),
        const SizedBox(height: 24),
        CleanSlButton(
          text: "Driver",
          onPressed: () => Navigator.pushNamed(context, '/driver-login'),
          variant: ButtonVariant.secondary,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../shared/widgets/cleansl_mobnum_input.dart';
import '../../../../../shared/widgets/cleansl_button.dart';
import '../../../../common/onboarding/presentation/widgets/auth_screen_template.dart';

class DriverLoginPage extends StatefulWidget {
  const DriverLoginPage({super.key});

  @override
  State<DriverLoginPage> createState() => _DriverLoginPageState();
}

class _DriverLoginPageState extends State<DriverLoginPage> {
  final TextEditingController _mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mobileController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool canSendOtp = _mobileController.text.length == 9;

    return AuthScreenTemplate(
      title: "Driver Access",
      subtitle: "Enter your registered mobile number. We'll send you an OTP to verify it's you.",
      actionButtons: [
        // 1. Mobile Number Input Field
        CleanSlMobNumInput(controller: _mobileController),

        SizedBox(height: Responsive.h(context, 32)),

        // 2. Send OTP Button
        CleanSlButton(
          text: "Send OTP",
          variant: ButtonVariant.primary,
          onPressed: canSendOtp
              ? () {
                  Navigator.pushNamed(context, '/driver-otp', arguments: _mobileController.text.trim());
                }
              : null,
        ),

        SizedBox(height: Responsive.h(context, 16)),

        // 3. Back Button
        CleanSlButton(text: "Cancel", variant: ButtonVariant.text, onPressed: () => Navigator.pop(context)),
      ],
    );
  }
}

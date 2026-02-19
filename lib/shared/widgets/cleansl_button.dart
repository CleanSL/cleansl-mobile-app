import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

// 1. Define all your possible button types here
enum ButtonVariant { primary, secondary, outline, text }

class CleanSlButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final double width;

  const CleanSlButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary, // Defaults to primary if not specified
    this.width = double.infinity, // Defaults to full width
  });

  @override
  Widget build(BuildContext context) {
    // 2. Set up default empty variables
    Color bgColor = Colors.transparent;
    Color textColor = Colors.black;
    Color shadowColor = Colors.transparent;
    double elevation = 0;
    BorderSide borderSide = BorderSide.none;

    // 3. Switch styling based on the variant chosen
    switch (variant) {
      case ButtonVariant.primary:
        bgColor = AppTheme.accentColor;
        textColor = AppTheme.textColor;
        shadowColor = AppTheme.accentColor.withValues(alpha: 0.2);
        elevation = 8;
        break;
      case ButtonVariant.secondary:
        bgColor = AppTheme.primaryBackground;
        textColor = AppTheme.textColor;
        shadowColor = AppTheme.primaryBackground.withValues(alpha: 0.2);
        elevation = 8;
        break;
      case ButtonVariant.outline:
        bgColor = Colors.transparent;
        textColor = AppTheme.secondaryColor1;
        borderSide = const BorderSide(color: AppTheme.secondaryColor1, width: 2);
        break;
      case ButtonVariant.text:
        bgColor = Colors.transparent;
        textColor = AppTheme.accentColor; // Usually just colored text, no background
        break;
    }

    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          shadowColor: shadowColor,
          elevation: elevation,
          // Using the tall 28px padding you defined in your theme
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: borderSide, // Only shows up if it's the 'outline' variant
          ),
          textStyle: const TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.w600, 
            fontFamily: 'Inter',
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

// 1. Define all your possible button types here
enum ButtonVariant { primary, secondary, outline, text }

class CleanSlButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final double width;
  final Widget? icon; // Optional icon parameter

  const CleanSlButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary, // Defaults to primary if not specified
    this.width = double.infinity, // Defaults to full width
    this.icon, 
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.transparent;
    Color textColor = Colors.black;
    Color shadowColor = Colors.transparent;
    double elevation = 0;
    BorderSide borderSide = BorderSide.none;

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
        textColor = AppTheme.hoverColor.withValues(alpha: 0.8);
        break;
    }

    // 2. CONSTANT PADDING LOCKED IN
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: bgColor,
      foregroundColor: textColor,
      shadowColor: shadowColor,
      elevation: elevation,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24), // Constant padding for all buttons
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: borderSide, 
      ),
      textStyle: const TextStyle(
        fontSize: 16, 
        fontWeight: FontWeight.w600, 
        fontFamily: 'Inter',
      ),
    );

    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle,
        // 3. Force the inside content to always be exactly 32px tall (the size of your icon)
        child: SizedBox(
          height: 32,
          child: Row(
            mainAxisAlignment: icon != null ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 24), // The exact spacing between the Google icon and the text
              ],
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CleanSlBranding extends StatelessWidget {
  const CleanSlBranding({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/img/logo.png', height: 150, width: 150, fit: BoxFit.contain),
        Transform.translate(
          offset: const Offset(0, -20),
          child: Column(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Clean",
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: AppTheme.textColor,
                            letterSpacing: 1.2,
                          ),
                    ),
                    TextSpan(
                      text: "SL",
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: AppTheme.accentColor,
                            letterSpacing: 1.2,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.space8),
              Text(
                "Welcome to a cleaner future",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textColor.withValues(alpha: 0.7),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
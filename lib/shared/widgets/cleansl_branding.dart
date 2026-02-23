import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

// 1. Define the two different styles
enum BrandingLayout { vertical, horizontal }

class CleanSlBranding extends StatelessWidget {
  final BrandingLayout layout; // 2. Add layout parameter

  const CleanSlBranding({
    super.key,
    this.layout = BrandingLayout.vertical, // Defaults to vertical so it doesn't break old screens!
  });

  @override
  Widget build(BuildContext context) {
    // 3. Return the correct layout based on what was passed
    if (layout == BrandingLayout.horizontal) {
      return _buildHorizontalLayout(context);
    }
    return _buildVerticalLayout(context);
  }

  // --- THE NEW HORIZONTAL RESIDENT STYLE ---
  Widget _buildHorizontalLayout(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/img/logo.png', height: 72, width: 72),
        Transform.translate(
          offset: const Offset(-8, 0),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Clean",
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppTheme.textColor,
                        letterSpacing: 1.2,
                      ),
                ),
                TextSpan(
                  text: "SL",
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppTheme.accentColor,
                        letterSpacing: 1.2,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- THE ORIGINAL VERTICAL DRIVER/ONBOARDING STYLE ---
  Widget _buildVerticalLayout(BuildContext context) {
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
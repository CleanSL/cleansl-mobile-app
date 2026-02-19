import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 1. Top Section: Logo and Welcome (Branding Area)
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.space8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset('assets/img/logo.png', height: 150, width: 150, fit: BoxFit.contain),

                  // Dual-colored Title: Clean (TextColor) SL (AccentColor)
                  Transform.translate(
                    offset: const Offset(0, -20), // -20 moves it up, closing the gap
                    child: Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Clean",
                                style: Theme.of(
                                  context,
                                ).textTheme.displayLarge?.copyWith(color: AppTheme.textColor, letterSpacing: 1.2),
                              ),
                              TextSpan(
                                text: "SL",
                                style: Theme.of(
                                  context,
                                ).textTheme.displayLarge?.copyWith(color: AppTheme.accentColor, letterSpacing: 1.2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppTheme.space8),
                        Text(
                          "Welcome to a cleaner future",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(color: AppTheme.textColor.withValues(alpha: 0.7)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Bottom Section: Language Selection Container
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppTheme.secondaryColor1,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppTheme.space48),
                topRight: Radius.circular(AppTheme.space48),
              ),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))],
            ),
            // We use EdgeInsets.only and add the device's specific bottom padding (the home bar)
            padding: EdgeInsets.only(
              top: AppTheme.space32,
              left: AppTheme.space32,
              right: AppTheme.space32,
              bottom: AppTheme.space32 + MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Choose your language",
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppTheme.primaryBackground),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.space8),
                Text(
                  "භාෂාව තෝරන්න | மொழியைத்",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppTheme.primaryBackground.withValues(alpha: 0.7)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.space32),

                // Language Buttons
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/role'),
                  style: AppTheme.secondaryButton,
                  child: const Text("English"),
                ),
                const SizedBox(height: AppTheme.space16),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/role'),
                  style: AppTheme.secondaryButton,
                  child: const Text("සිංහල"),
                ),
                const SizedBox(height: AppTheme.space16),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/role'),
                  style: AppTheme.secondaryButton,
                  child: const Text("தமிழ்"),
                ),
                const SizedBox(height: AppTheme.space16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

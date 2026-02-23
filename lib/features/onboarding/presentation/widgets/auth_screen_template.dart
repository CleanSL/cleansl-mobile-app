import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/cleansl_branding.dart';

class AuthScreenTemplate extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> actionButtons;

  const AuthScreenTemplate({
    super.key,
    required this.title,
    required this.subtitle,
    required this.actionButtons,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                // 1. Top Section (Global Branding)
                const Expanded(
                  flex: 3,
                  child: CleanSlBranding(),
                ),

                // 2. Bottom Section (Curved Container)
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppTheme.secondaryColor1,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppTheme.space48),
                      topRight: Radius.circular(AppTheme.space48),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))
                    ],
                  ),
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
                        title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.primaryBackground,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.space8),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.primaryBackground.withValues(alpha: 0.7),
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.space32),
                      
                      // Unpacks your list of buttons here
                      ...actionButtons, 
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
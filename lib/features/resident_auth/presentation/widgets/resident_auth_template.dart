import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/cleansl_branding.dart';

class ResidentAuthTemplate extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> formChildren; // The inputs and buttons that go inside the green card

  const ResidentAuthTemplate({
    super.key,
    required this.title,
    required this.subtitle,
    required this.formChildren,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // 1. Header (Fixed Logo)
                  const Padding(
                    padding: EdgeInsets.only(top: AppTheme.space24),
                    child: CleanSlBranding(layout: BrandingLayout.horizontal),
                  ),

                  // 2. The Magic Spacer
                  const Spacer(),
                  const SizedBox(height: AppTheme.space32),

                  // 3. Dynamic Titles
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.space24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: AppTheme.textColor, 
                                fontSize: 36,
                              ),
                        ),
                        const SizedBox(height: AppTheme.space16),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textColor.withValues(alpha: 0.8),
                              ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppTheme.space48),

                  // 4. The Green Form Card
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppTheme.secondaryColor1,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                    ),
                    padding: const EdgeInsets.only(
                      top: AppTheme.space48,
                      left: AppTheme.space32,
                      right: AppTheme.space32,
                      bottom: AppTheme.space48,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      // We inject whatever inputs and buttons you pass in right here!
                      children: formChildren, 
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
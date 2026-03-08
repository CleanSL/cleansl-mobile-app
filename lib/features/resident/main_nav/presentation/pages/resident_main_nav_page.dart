import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive.dart';
import '../../../home/presentation/pages/resident_home_page.dart';

class ResidentMainNavPage extends StatefulWidget {
  const ResidentMainNavPage({super.key});

  @override
  State<ResidentMainNavPage> createState() => _ResidentMainNavPageState();
}

class _ResidentMainNavPageState extends State<ResidentMainNavPage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
  const ResidentHomePage(),
  const Center(child: Text("Schedule & Calendar Placeholder")),
  const Center(child: Text("ML Complaint Scanner Placeholder")),
  const Center(child: Text("Resident Profile Placeholder")),
];

  // 1. Define your icons and labels in simple lists
  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.calendar_month_rounded,
    Icons.document_scanner_rounded,
    Icons.person_rounded,
  ];

  final List<String> _labels = [
    "Home",
    "Schedule",
    "Complaints",
    "Profile",
  ];

  @override
  Widget build(BuildContext context) {
    final double bottomSafe = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      extendBody: true,
      body: _screens[_currentIndex],
      
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: Responsive.w(context, AppTheme.space16), // Slightly tighter to fit the horizontal text
          right: Responsive.w(context, AppTheme.space16),
          bottom: Responsive.h(context, AppTheme.space24) + bottomSafe,
        ),
        child: Container(
          // Inner padding for the whole nav bar
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.w(context, AppTheme.space8),
            vertical: Responsive.h(context, AppTheme.space8),
          ),
          decoration: BoxDecoration(
            color: AppTheme.secondaryColor1.withValues(alpha: 0.95), // The dark green background
            borderRadius: BorderRadius.circular(Responsive.r(context, 40)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentColor.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          // 2. Custom Row instead of BottomNavigationBar
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_icons.length, (index) {
              final isSelected = _currentIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                // 3. AnimatedContainer handles the smooth expansion when clicked
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? Responsive.w(context, 16) : Responsive.w(context, 12),
                    vertical: Responsive.h(context, 12),
                  ),
                  decoration: BoxDecoration(
                    // Lighter background only for the active item
                    color: isSelected 
                        ? AppTheme.accentColor.withValues(alpha: 0.2) 
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(Responsive.r(context, 30)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _icons[index],
                        color: isSelected ? AppTheme.hoverColor : Colors.white54,
                        size: Responsive.w(context, 24),
                      ),
                      // 4. Smoothly show text only if selected
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        child: SizedBox(
                          width: isSelected ? null : 0,
                          child: Row(
                            children: [
                              SizedBox(width: Responsive.w(context, 8)),
                              Text(
                                _labels[index],
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: AppTheme.hoverColor,
                                  fontSize: Responsive.sp(context, 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive.dart';
import '../widgets/live_tracking_card.dart';
import '../widgets/schedule_calendar.dart';
import '../pages/pickup_details_page.dart';
import '../pages/completed_pickup_page.dart';

class ScheduleMainPage extends StatefulWidget {
  const ScheduleMainPage({super.key});

  @override
  State<ScheduleMainPage> createState() => _ScheduleMainPageState();
}

class _ScheduleMainPageState extends State<ScheduleMainPage> {
  // 1. STATE: Track which upcoming pickups have active reminders
  final Set<int> _notifiedPickups = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: Responsive.h(context, AppTheme.space64),
        leading: Padding(
          padding: EdgeInsets.only(top: Responsive.h(context, AppTheme.space8)),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.textColor, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Padding(
          padding: EdgeInsets.only(top: Responsive.h(context, AppTheme.space8)),
          child: Text("Pickup Schedule", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 24)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: Responsive.w(context, AppTheme.space24),
          right: Responsive.w(context, AppTheme.space24),
          top: Responsive.h(context, AppTheme.space16),
          bottom: Responsive.h(context, 120),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. THE CALENDAR
            const ScheduleCalendar(),
            SizedBox(height: Responsive.h(context, AppTheme.space32)),

            // 2. IN PROGRESS SECTION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("In Progress", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.accentColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, color: AppTheme.accentColor, size: 8),
                      const SizedBox(width: 4),
                      Text(
                        "LIVE",
                        style: TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: Responsive.h(context, AppTheme.space16)),
            const LiveTrackingCard(
              wasteType: "Recyclables (Plastic/Paper)",
              zone: "Colombo 07 - Cinnamon\nGardens",
              team: "Team C-04",
              etaTime: "12m",
              etaDistance: "1.2km",
              themeColor: AppTheme.accentColor,
              wasteIcon: Icons.recycling_rounded,
              checklistItems: ["Bins washed and clean", "Plastics sorted together", "Cardboard flattened"],
            ),
            SizedBox(height: Responsive.h(context, AppTheme.space32)),

            // 3. UPCOMING SECTION
            Text("Upcoming", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: Responsive.h(context, AppTheme.space16)),
            _buildUpcomingCard(context: context, index: 0, dateText: "OCT\n10", title: "Recyclables (Plastic/Paper)", timeText: "Scheduled for 08:30 AM", dateColor: AppTheme.accentColor),
            _buildUpcomingCard(context: context, index: 1, dateText: "OCT\n13", title: "General Waste", timeText: "Scheduled for 07:00 AM", dateColor: AppTheme.accentColor),
            SizedBox(height: Responsive.h(context, AppTheme.space32)),

            // 4. COMPLETED SECTION
            Text("Completed", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: Responsive.h(context, AppTheme.space16)),
            _buildCompletedCard(context: context, dateText: "OCT\n07", title: "Recyclables (Metal/Glass)", timeText: "Completed at 09:15 AM"),
            _buildCompletedCard(context: context, dateText: "OCT\n04", title: "Organic Waste", timeText: "Completed at 08:45 AM"),
          ],
        ),
      ),
    );
  }

  // --- THE BLURRED REMINDER DIALOG LOGIC ---
  void _showReminderDialog(int index, String title, String timeText) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            insetPadding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 24)),
            child: Padding(
              padding: EdgeInsets.all(Responsive.w(context, 24)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: AppTheme.accentColor, shape: BoxShape.circle),
                        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 16),
                      ),
                      SizedBox(width: Responsive.w(context, 12)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("CLEANSL", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                          Text("Just now", style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.h(context, 20)),
                  Text("Reminder: $title", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: Responsive.h(context, 8)),
                  Text(
                    "The truck will be at your location at ${timeText.replaceAll('Scheduled for ', '')} tomorrow. Please ensure your bin is at the curb.",
                    style: TextStyle(color: Colors.grey.shade600, height: 1.4, fontSize: 14),
                  ),
                  SizedBox(height: Responsive.h(context, 24)),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _notifiedPickups.add(index);
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentColor,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: Responsive.h(context, 14)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text(
                            "Confirm",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(width: Responsive.w(context, 12)),
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFF3F4F6),
                            padding: EdgeInsets.symmetric(vertical: Responsive.h(context, 14)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text(
                            "Dismiss",
                            style: TextStyle(color: AppTheme.textColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- COMPONENT HELPERS ---

  Widget _buildUpcomingCard({required BuildContext context, required int index, required String dateText, required String title, required String timeText, required Color dateColor}) {
    final bool isNotified = _notifiedPickups.contains(index);

    return GestureDetector(
      onTap: () async {
        final bool? updatedReminderState = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) => PickupDetailsPage(
              statusLabel: "UPCOMING",
              title: title,
              date: "Friday, Oct ${dateText.replaceAll('\n', ' ').split(' ')[1]}",
              time: timeText.replaceAll("Scheduled for ", ""),
              wasteType: title,
              themeColor: dateColor,
              wasteIcon: title.contains("Recyclable") ? Icons.recycling_rounded : Icons.delete_outline_rounded,
              disposalTips: _getDisposalTipsForWasteType(title),
              initialReminderSet: isNotified,
              onReminderChanged: (value) {
                if (!mounted) return;
                setState(() {
                  if (value) {
                    _notifiedPickups.add(index);
                  } else {
                    _notifiedPickups.remove(index);
                  }
                });
              },
            ),
          ),
        );

        if (!mounted || updatedReminderState == null) return;
        setState(() {
          if (updatedReminderState) {
            _notifiedPickups.add(index);
          } else {
            _notifiedPickups.remove(index);
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: Responsive.h(context, AppTheme.space16)),
        padding: EdgeInsets.all(Responsive.w(context, 16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Responsive.r(context, 20)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 16), vertical: Responsive.h(context, 12)),
              decoration: BoxDecoration(color: dateColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(Responsive.r(context, 16))),
              child: Text(
                dateText,
                textAlign: TextAlign.center,
                style: TextStyle(color: dateColor, fontWeight: FontWeight.bold, fontSize: 13, height: 1.2),
              ),
            ),
            SizedBox(width: Responsive.w(context, 16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: Responsive.h(context, 4)),
                  Text(timeText, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                if (isNotified) {
                  setState(() => _notifiedPickups.remove(index));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reminder cancelled")));
                } else {
                  _showReminderDialog(index, title, timeText);
                }
              },
              icon: Icon(isNotified ? Icons.notifications_active_rounded : Icons.notifications_rounded, color: isNotified ? AppTheme.accentColor : Colors.grey.shade400, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getDisposalTipsForWasteType(String wasteType) {
    final String normalized = wasteType.toLowerCase();

    if (normalized.contains('recycl')) {
      return [
        "Rinse and dry plastic, glass, and metal containers before placing them in the bin.",
        "Flatten cardboard and paper packs to save space and avoid overflow.",
        "Do not mix food-soiled items like greasy pizza boxes with recyclables.",
      ];
    }

    if (normalized.contains('organic')) {
      return [
        "Drain excess liquids from food waste to reduce odor and leakage.",
        "Wrap wet kitchen scraps in biodegradable liners before disposal.",
        "Avoid mixing plastics, foil, or glass with organic waste.",
      ];
    }

    if (normalized.contains('general')) {
      return [
        "Use tightly tied heavy-duty bags to prevent spills during lifting.",
        "Place your bin at the curb before 6:00 AM on collection day.",
        "Keep hazardous items such as batteries, oils, and chemicals out of general waste.",
      ];
    }

    return ["Bag all waste securely and keep bin lids fully closed.", "Place bins at the curbside before the scheduled pickup time.", "Separate recyclable and organic materials whenever possible."];
  }

  Widget _buildCompletedCard({required BuildContext context, required String dateText, required String title, required String timeText}) {
    return GestureDetector(
      // --- ADD NAVIGATION TO COMPLETED TEMPLATE ---
      onTap: () {
        // Generate dynamic data based on the waste category
        final categoryData = _getCompletedDataForCategory(title);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompletedPickupDetailsPage(
              title: "Successfully Collected",
              subtitle: categoryData['subtitle'],
              imagePath: categoryData['imagePath'],
              certificateId: "#CSL-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}",
              date: "October ${dateText.replaceAll('\n', ' ')}, 2023 • ${timeText.replaceAll('Completed at ', '')}",
              location: "24 Green Valley Ave, Colombo",
              wasteType: title,
              collectedBy: "EcoCollector Team B-12",
              impactMessage: categoryData['impactMessage'],
              themeColor: categoryData['themeColor'],
              impactIcon: categoryData['impactIcon'],
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: Responsive.h(context, AppTheme.space16)),
        padding: EdgeInsets.all(Responsive.w(context, 16)),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(Responsive.r(context, 20)),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 16), vertical: Responsive.h(context, 12)),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(Responsive.r(context, 16))),
              child: Text(
                dateText,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 13, height: 1.2),
              ),
            ),
            SizedBox(width: Responsive.w(context, 16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor.withValues(alpha: 0.8)),
                  ),
                  SizedBox(height: Responsive.h(context, 4)),
                  Row(
                    children: [
                      Icon(Icons.check_circle_rounded, color: Colors.grey.shade400, size: 14),
                      const SizedBox(width: 4),
                      Text(timeText, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER: GENERATE DYNAMIC DATA FOR COMPLETED PICKUPS ---
  Map<String, dynamic> _getCompletedDataForCategory(String wasteType) {
    final String normalized = wasteType.toLowerCase();

    if (normalized.contains('organic')) {
      return {
        'subtitle': "Your organic waste has been processed and is ready for composting.",
        'imagePath': 'assets/img/organic_waste.jpg', // Placeholder - add your image to assets
        'impactMessage': "This collection prevented approx. 1.8kg of CO2 equivalent from entering the atmosphere.",
        'themeColor': AppTheme.accentColor,
        'impactIcon': Icons.eco_rounded,
      };
    } else if (normalized.contains('recycl')) {
      return {
        'subtitle': "Your recyclable materials have been sorted and sent to processing facilities.",
        'imagePath': 'assets/img/recyclable_waste.jpg', // Placeholder
        'impactMessage': "You helped save 45 liters of water and 12 kWh of energy through recycling!",
        'themeColor': AppTheme.accentColor,
        'impactIcon': Icons.water_drop_rounded,
      };
    } else if (normalized.contains('general') || normalized.contains('non-recyclable')) {
      return {
        'subtitle': "Your general waste has been safely disposed of according to city guidelines.",
        'imagePath': 'assets/img/general_waste.jpg', // Placeholder
        'impactMessage': "Proper disposal ensures a cleaner, safer community and prevents illegal dumping.",
        'themeColor': AppTheme.accentColor,
        'impactIcon': Icons.health_and_safety_rounded,
      };
    }

    // "Other" Category Fallback
    return {
      'subtitle': "Your waste pickup has been successfully completed.",
      'imagePath': 'assets/img/other_waste.jpg', // Placeholder
      'impactMessage': "Thank you for using CleanSL to manage your waste responsibly.",
      'themeColor': AppTheme.accentColor,
      'impactIcon': Icons.stars_rounded,
    };
  }
}

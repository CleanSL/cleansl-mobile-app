import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';

class ResidentHomePage extends StatelessWidget {
  const ResidentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // We use a SafeArea and SingleChildScrollView so the content doesn't hit the notch
    // and can scroll behind your new floating nav bar.
    return SafeArea(
      bottom: false, // Let the bottom scroll behind the floating nav bar
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: Responsive.w(context, AppTheme.space24),
          right: Responsive.w(context, AppTheme.space24),
          top: Responsive.h(context, AppTheme.space32),
          // Extra bottom padding so the last item doesn't get hidden under the floating nav bar
          bottom: Responsive.h(context, 120),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            SizedBox(height: Responsive.h(context, AppTheme.space32)),

            // 1. Live Map Tracking Section
            _buildLiveMapTracking(context),
            SizedBox(height: Responsive.h(context, AppTheme.space32)),

            // 2. Next Scheduled Pickup
            _buildNextPickupCard(context),
            SizedBox(height: Responsive.h(context, AppTheme.space32)),

            Text("Quick Actions", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: Responsive.h(context, AppTheme.space16)),
            _buildQuickActionsRow(context),

            SizedBox(height: Responsive.h(context, AppTheme.space32)),
            Text("Recent Activity", style: Theme.of(context).textTheme.titleLarge),
            Text(
              "See All",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.secondaryColor1.withValues(alpha: 0.7)),
            ),
            SizedBox(height: Responsive.h(context, AppTheme.space16)),
            _buildRecentActivityList(context),
          ],
        ),
      ),
    );
  }

  // --- COMPONENT WIDGETS ---
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, User Name",
              style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppTheme.textColor),
            ),
            SizedBox(height: Responsive.h(context, 4)),
            Text(
              "Good morning", // Updated as requested
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppTheme.secondaryColor1.withValues(alpha: 0.7)),
            ),
          ],
        ),
        // Notification bell icon
        Container(
          padding: EdgeInsets.all(Responsive.w(context, 12)),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: const Icon(Icons.notifications_outlined, color: AppTheme.textColor),
        ),
      ],
    );
  }

  Widget _buildLiveMapTracking(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Live Truck Tracking", style: Theme.of(context).textTheme.titleLarge),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 12), vertical: Responsive.h(context, 6)),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Responsive.r(context, 20)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: AppTheme.accentColor, shape: BoxShape.circle),
                  ),
                  SizedBox(width: Responsive.w(context, 6)),
                  Text(
                    "Active",
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppTheme.accentColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: Responsive.h(context, AppTheme.space16)),

        // Placeholder for future map integration
        Container(
          height: Responsive.h(context, 220),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(Responsive.r(context, 16)),
          ),
          child: const Center(
            child: Text('Map Integration goes here', style: TextStyle(color: Colors.grey)),
          ),
        ),
      ],
    );
  }

  Widget _buildNextPickupCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.w(context, AppTheme.space24)),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor1, // Dark green premium background
        borderRadius: BorderRadius.circular(Responsive.r(context, 24)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.secondaryColor1.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping_rounded, color: AppTheme.accentColor, size: Responsive.w(context, 24)),
              SizedBox(width: Responsive.w(context, AppTheme.space8)),
              Text(
                "Next Scheduled Pickup",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppTheme.accentColor),
              ),
              Text(
                "Organic Waste", // Updated as requested
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppTheme.accentColor.withValues(alpha: 0.8)),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(context, AppTheme.space16)),
          Text("8:00 AM", style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppTheme.primaryBackground)),
          SizedBox(height: Responsive.h(context, AppTheme.space8)),
          Text(
            "General Waste & Recyclables",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.primaryBackground.withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionCard(context, icon: Icons.recycling_rounded, label: "Report", onTap: () {}),
        _buildActionCard(context, icon: Icons.support_agent_rounded, label: "Guide", onTap: () {}),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Responsive.w(context, 100),
        padding: EdgeInsets.symmetric(vertical: Responsive.h(context, AppTheme.space16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Responsive.r(context, 16)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.accentColor, size: Responsive.w(context, 32)),
            SizedBox(height: Responsive.h(context, AppTheme.space8)),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: Responsive.sp(context, 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityList(BuildContext context) {
    return Column(
      children: [
        _buildActivityTile(context, title: "Recycle Pickup Completed", date: "Yesterday, 9:45 AM", isCompleted: true),
        SizedBox(height: Responsive.h(context, AppTheme.space16)),
        _buildActivityTile(context, title: "Issue Reported: Missed Pick up", date: "Mon, 14th Feb", isCompleted: true),
        SizedBox(height: Responsive.h(context, AppTheme.space16)),
        _buildActivityTile(context, title: "Extra Pickup Requested", date: "Sun, 13th Feb", isCompleted: false),
      ],
    );
  }

  Widget _buildActivityTile(
    BuildContext context, {
    required String title,
    required String date,
    required bool isCompleted,
  }) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(context, AppTheme.space16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(context, 16)),
        border: Border.all(color: AppTheme.secondaryColor1.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(Responsive.w(context, 10)),
            decoration: BoxDecoration(
              color: isCompleted ? AppTheme.accentColor.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted ? Icons.check_circle_outline_rounded : Icons.pending_actions_rounded,
              color: isCompleted ? AppTheme.accentColor : Colors.orange,
              size: Responsive.w(context, 20),
            ),
          ),
          SizedBox(width: Responsive.w(context, AppTheme.space16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.labelLarge),
                SizedBox(height: Responsive.h(context, 4)),
                Text(
                  date,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppTheme.secondaryColor1.withValues(alpha: 0.6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../complaints/presentation/pages/file_complaint_page.dart';
import '../../../guide/presentation/pages/guide_main_page.dart';
import 'notifications_page.dart';
import 'recent_activity_page.dart';

class ResidentHomePage extends StatefulWidget {
  const ResidentHomePage({super.key});

  @override
  State<ResidentHomePage> createState() => _ResidentHomePageState();
}

class _ResidentHomePageState extends State<ResidentHomePage> {
  // Placeholder for backend data
  final String userName = "Vinuu";

  // Dynamic greeting based on current time
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good morning";
    if (hour < 17) return "Good afternoon";
    return "Good evening";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: Responsive.w(context, AppTheme.space24),
          right: Responsive.w(context, AppTheme.space24),
          top: Responsive.h(context, AppTheme.space32),
          bottom: Responsive.h(context, 120),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER (Dynamic Greeting & Name)
            _buildHeader(context),
            SizedBox(height: Responsive.h(context, AppTheme.space24)),

            // 2. LIVE GOOGLE MAP TRACKING
            _buildLiveMapTracking(context),
            SizedBox(height: Responsive.h(context, AppTheme.space24)),

            // 3. NEXT PICKUP CARD
            _buildNextPickupCard(context),
            SizedBox(height: Responsive.h(context, AppTheme.space24)),

            // 4. QUICK ACTIONS
            _buildQuickActionsRow(context),
            SizedBox(height: Responsive.h(context, AppTheme.space32)),

            // 5. RECENT ACTIVITY
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Recent Activity", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RecentActivityPage()));
                  },
                  child: Text(
                    "See All",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.accentColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
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
              "Hello, $userName",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.secondaryColor1.withValues(alpha: 0.6), fontWeight: FontWeight.bold, letterSpacing: 1.1),
            ),
            SizedBox(height: Responsive.h(context, 4)),
            Text(
              _getGreeting(),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppTheme.textColor, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsPage()));
          },
          child: Padding(
            padding: EdgeInsets.all(Responsive.w(context, 4)),
            child: Stack(
              children: [
                const Icon(Icons.notifications_none_rounded, color: AppTheme.textColor, size: 28),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLiveMapTracking(BuildContext context) {
    return Container(
      height: Responsive.h(context, 260),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(Responsive.r(context, 24)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Responsive.r(context, 24)),
        child: Stack(
          children: [
            // REAL GOOGLE MAP
            const GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(6.8398, 79.8646), // Set to Mount Lavinia context
                zoom: 14.5,
              ),
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
            ),

            // ETA OVERLAY CARD
            Positioned(
              bottom: Responsive.h(context, 20),
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 16), vertical: Responsive.h(context, 12)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Responsive.r(context, 20)),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Mount Lavinia", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text(
                            "Arriving in 10m",
                            style: TextStyle(color: AppTheme.secondaryColor1.withValues(alpha: 0.7), fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(width: Responsive.w(context, 16)),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: AppTheme.accentColor, shape: BoxShape.circle),
                        child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // LOCATION BUTTON OVERLAY
            Positioned(
              bottom: Responsive.h(context, 20),
              right: Responsive.w(context, 16),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
                ),
                child: const Icon(Icons.my_location_rounded, color: AppTheme.textColor, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextPickupCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.w(context, AppTheme.space24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(context, 24)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Next Pickup", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppTheme.accentColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: const [
                    Icon(Icons.schedule_rounded, color: AppTheme.accentColor, size: 14),
                    SizedBox(width: 4),
                    Text(
                      "Today",
                      style: TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(context, 4)),
          Text("Organic Waste", style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          SizedBox(height: Responsive.h(context, 16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text("10:30", style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(width: 4),
                  Text(
                    "AM",
                    style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppTheme.accentColor.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: const Icon(Icons.recycling_rounded, color: AppTheme.accentColor, size: 32),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(context, 16)),
          // Custom Progress Bar
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4)),
              ),
              Container(
                height: 8,
                width: Responsive.w(context, 200),
                decoration: BoxDecoration(color: AppTheme.accentColor, borderRadius: BorderRadius.circular(4)),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(context, 8)),
          Text("Driver is 2 stops away", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildQuickActionsRow(BuildContext context) {
    return Row(
      children: [
        // Primary Action (Green)
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FileComplaintPage()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: Responsive.h(context, 20), horizontal: Responsive.w(context, 16)),
              decoration: BoxDecoration(color: AppTheme.accentColor, borderRadius: BorderRadius.circular(Responsive.r(context, 20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_rounded, color: Colors.white, size: 28),
                  SizedBox(height: Responsive.h(context, 12)),
                  const Text(
                    "Report",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: Responsive.h(context, 4)),
                  const Text("Missed pickup or\noverflow", style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4)),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: Responsive.w(context, 16)),
        // Secondary Action (White)
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GuideMainPage()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: Responsive.h(context, 20), horizontal: Responsive.w(context, 16)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Responsive.r(context, 20)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                    child: const Icon(Icons.recycling_rounded, color: Colors.blueAccent, size: 24),
                  ),
                  SizedBox(height: Responsive.h(context, 12)),
                  const Text(
                    "Guide",
                    style: TextStyle(color: AppTheme.textColor, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: Responsive.h(context, 4)),
                  Text("Sorting rules\nand tips", style: TextStyle(color: Colors.grey.shade600, fontSize: 12, height: 1.4)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivityList(BuildContext context) {
    return Column(
      children: [
        _buildActivityTile(
          context,
          title: "Recycling Pickup Completed",
          date: "Yesterday, 9:45 AM",
          icon: Icons.check_circle_rounded,
          iconColor: AppTheme.accentColor,
          bgColor: AppTheme.accentColor.withValues(alpha: 0.1),
        ),
        SizedBox(height: Responsive.h(context, AppTheme.space16)),
        _buildActivityTile(context, title: "Issue Reported: Missed Bin", date: "Mon, 14 Aug", icon: Icons.history_rounded, iconColor: Colors.orange, bgColor: Colors.orange.withValues(alpha: 0.1)),
        SizedBox(height: Responsive.h(context, AppTheme.space16)),
        _buildActivityTile(
          context,
          title: "Organic Pickup Completed",
          date: "Sat, 12 Aug",
          icon: Icons.check_circle_rounded,
          iconColor: AppTheme.accentColor,
          bgColor: AppTheme.accentColor.withValues(alpha: 0.1),
        ),
      ],
    );
  }

  Widget _buildActivityTile(BuildContext context, {required String title, required String date, required IconData icon, required Color iconColor, required Color bgColor}) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(context, 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(context, 16)),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(Responsive.w(context, 10)),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: Responsive.w(context, 22)),
          ),
          SizedBox(width: Responsive.w(context, 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: Responsive.h(context, 4)),
                Text(date, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

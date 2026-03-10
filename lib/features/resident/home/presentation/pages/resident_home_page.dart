import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';

class ResidentHomePage extends StatefulWidget {
  const ResidentHomePage({super.key});

  @override
  State<ResidentHomePage> createState() => _ResidentHomePageState();
}

class _ResidentHomePageState extends State<ResidentHomePage> {
  final _supabase = Supabase.instance.client;

  GoogleMapController? _mapController;
  LatLng? _truckPosition;
  Set<Marker> _markers = {};
  StreamSubscription<List<Map<String, dynamic>>>? _locationSub;

  static const LatLng _colombo = LatLng(6.9271, 79.8612);

  @override
  void initState() {
    super.initState();
    _subscribeToDriverLocation();
  }

  void _subscribeToDriverLocation() {
    _locationSub = _supabase.from('driver_tracking').stream(primaryKey: ['id']).listen((rows) {
      if (!mounted || rows.isEmpty) return;
      final row = rows.first;
      final lat = (row['lat'] as num).toDouble();
      final lng = (row['lng'] as num).toDouble();
      final newPos = LatLng(lat, lng);

      setState(() {
        _truckPosition = newPos;
        _markers = {
          Marker(
            markerId: const MarkerId('truck'),
            position: newPos,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            infoWindow: const InfoWindow(title: 'Garbage Truck', snippet: 'Live location'),
          ),
        };
      });

      // Animate after the frame so the (possibly rebuilt) map is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController?.animateCamera(CameraUpdate.newLatLng(newPos));
      });
    });
  }

  // Called on every hot reload — null out the stale native controller so
  // onMapCreated can assign the fresh one when the map widget rebuilds.
  @override
  void reassemble() {
    super.reassemble();
    _mapController = null;
  }

  @override
  void dispose() {
    _locationSub?.cancel();
    _mapController?.dispose();
    super.dispose();
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
            _buildHeader(context),
            SizedBox(height: Responsive.h(context, AppTheme.space32)),

            // 1. Live Map Tracking Section (Now with actual Google Maps)
            _buildLiveMapTracking(context),
            SizedBox(height: Responsive.h(context, AppTheme.space24)),

            // 2. Next Scheduled Pickup
            _buildNextPickupCard(context),
            SizedBox(height: Responsive.h(context, AppTheme.space16)),

            // 3. Quick Actions
            _buildQuickActionsRow(context),
            SizedBox(height: Responsive.h(context, AppTheme.space32)),

            // 4. Recent Activity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Recent Activity", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/recent-activity'),
                  child: Text(
                    "See All",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.accentColor, fontWeight: FontWeight.w600),
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
            Text("Hello, User Name", style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppTheme.textColor)),
            SizedBox(height: Responsive.h(context, 4)),
            Text("Good morning", style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.secondaryColor1.withValues(alpha: 0.7))),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/notifications'),
          child: Container(
            padding: EdgeInsets.all(Responsive.w(context, 12)),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: const Icon(Icons.notifications_outlined, color: AppTheme.textColor),
          ),
        ),
      ],
    );
  }

  // UPDATED: Live Google Map Integration with real-time truck tracking
  Widget _buildLiveMapTracking(BuildContext context) {
    final bool isActive = _truckPosition != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Live Truck Tracking", style: Theme.of(context).textTheme.titleLarge),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 12), vertical: Responsive.h(context, 6)),
              decoration: BoxDecoration(color: (isActive ? AppTheme.accentColor : Colors.grey).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(Responsive.r(context, 20))),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: isActive ? AppTheme.accentColor : Colors.grey, shape: BoxShape.circle),
                  ),
                  SizedBox(width: Responsive.w(context, 6)),
                  Text(
                    isActive ? "Active" : "No Signal",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: isActive ? AppTheme.accentColor : Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: Responsive.h(context, AppTheme.space16)),

        // Google Map with live truck marker
        Container(
          height: Responsive.h(context, 220),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Responsive.r(context, 16)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Responsive.r(context, 16)),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: _truckPosition ?? _colombo, zoom: 13.5),
              onMapCreated: (controller) => _mapController = controller,
              markers: _markers,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
            ),
          ),
        ),

        if (!isActive)
          Padding(
            padding: EdgeInsets.only(top: Responsive.h(context, 8)),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 14, color: Colors.grey.shade500),
                SizedBox(width: Responsive.w(context, 4)),
                Text("Waiting for truck location...", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade500)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildNextPickupCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/guide'),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(Responsive.w(context, AppTheme.space24)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Responsive.r(context, 24)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Next Pickup", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 10), vertical: Responsive.h(context, 6)),
                  decoration: BoxDecoration(color: AppTheme.accentColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(Responsive.r(context, 20))),
                  child: Row(
                    children: [
                      Icon(Icons.schedule_rounded, color: AppTheme.accentColor, size: Responsive.w(context, 14)),
                      SizedBox(width: Responsive.w(context, 4)),
                      Text(
                        "Today",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.accentColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: Responsive.h(context, 4)),
            Text("Organic Waste", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
            SizedBox(height: Responsive.h(context, AppTheme.space24)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "10:30",
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor),
                          ),
                          SizedBox(width: Responsive.w(context, 4)),
                          Text(
                            "AM",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(height: Responsive.h(context, 12)),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Responsive.r(context, 10)),
                        child: LinearProgressIndicator(
                          value: 0.6,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
                          minHeight: Responsive.h(context, 8),
                        ),
                      ),
                      SizedBox(height: Responsive.h(context, 8)),
                      Text("Driver is 2 stops away", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                SizedBox(width: Responsive.w(context, AppTheme.space16)),
                Container(
                  padding: EdgeInsets.all(Responsive.w(context, 16)),
                  decoration: BoxDecoration(color: AppTheme.accentColor.withValues(alpha: 0.15), shape: BoxShape.circle),
                  child: Icon(Icons.recycling_rounded, color: AppTheme.accentColor, size: Responsive.w(context, 32)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(Responsive.w(context, 20)),
              decoration: BoxDecoration(
                color: AppTheme.accentColor,
                borderRadius: BorderRadius.circular(Responsive.r(context, 20)),
                boxShadow: [BoxShadow(color: AppTheme.accentColor.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(Responsive.w(context, 8)),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.3), shape: BoxShape.circle),
                    child: Icon(Icons.warning_rounded, color: Colors.white, size: Responsive.w(context, 24)),
                  ),
                  SizedBox(height: Responsive.h(context, AppTheme.space24)),
                  Text(
                    "Report",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: Responsive.h(context, 4)),
                  Text("Missed pickup or\noverflow", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.9))),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: Responsive.w(context, AppTheme.space16)),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/guide'),
            child: Container(
              padding: EdgeInsets.all(Responsive.w(context, 20)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Responsive.r(context, 20)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 8))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(Responsive.w(context, 8)),
                    decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: Icon(Icons.recycling_rounded, color: Colors.blue, size: Responsive.w(context, 24)),
                  ),
                  SizedBox(height: Responsive.h(context, AppTheme.space24)),
                  Text(
                    "Guide",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.textColor, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: Responsive.h(context, 4)),
                  Text("Sorting rules", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
                  SizedBox(height: Responsive.h(context, 16)),
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
        _buildActivityTile(context, title: "Recycling Pickup Completed", date: "Yesterday, 9:45 AM", icon: Icons.check_circle_rounded, iconColor: AppTheme.accentColor),
        SizedBox(height: Responsive.h(context, AppTheme.space16)),
        _buildActivityTile(context, title: "Issue Reported: Missed Bin", date: "Mon, 14 Aug", icon: Icons.history_rounded, iconColor: Colors.orange.shade700),
      ],
    );
  }

  Widget _buildActivityTile(BuildContext context, {required String title, required String date, required IconData icon, required Color iconColor}) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(context, 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(context, 20)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(Responsive.w(context, 12)),
            decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: Responsive.w(context, 24)),
          ),
          SizedBox(width: Responsive.w(context, AppTheme.space16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: Responsive.h(context, 4)),
                Text(date, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

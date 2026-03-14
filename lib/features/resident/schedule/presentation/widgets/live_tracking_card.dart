import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive.dart';
import '../pages/live_tracking_page.dart';

class LiveTrackingCard extends StatefulWidget {
  // --- TEMPLATE PARAMETERS ---
  final String wasteType;
  final String zone;
  final String team;
  final String etaTime;
  final String etaDistance;
  final Color themeColor;
  final IconData wasteIcon;
  final List<String> checklistItems;

  const LiveTrackingCard({
    super.key,
    required this.wasteType,
    required this.zone,
    required this.team,
    required this.etaTime,
    required this.etaDistance,
    required this.themeColor,
    required this.wasteIcon,
    required this.checklistItems,
  });

  @override
  State<LiveTrackingCard> createState() => _LiveTrackingCardState();
}

class _LiveTrackingCardState extends State<LiveTrackingCard> {
  static const CameraPosition _initialCameraPosition = CameraPosition(target: LatLng(6.9061, 79.8687), zoom: 13.5);

  GoogleMapController? _mapController;
  bool _isRefreshing = false;

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      final controller = _mapController;
      if (controller != null) {
        await controller.animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
      }
    } catch (_) {}

    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  void dispose() {
    _mapController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // PASS ALL TEMPLATE DATA TO THE NEXT PAGE
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LiveTrackingPage(
              wasteType: widget.wasteType,
              zone: widget.zone,
              team: widget.team,
              etaTime: widget.etaTime,
              etaDistance: widget.etaDistance,
              themeColor: widget.themeColor,
              wasteIcon: widget.wasteIcon,
              checklistItems: widget.checklistItems,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            SizedBox(
              height: Responsive.h(context, 210),
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    IgnorePointer(
                      child: GoogleMap(
                        initialCameraPosition: _initialCameraPosition,
                        onMapCreated: (controller) => _mapController = controller,
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        mapToolbarEnabled: false,
                        compassEnabled: false,
                      ),
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: widget.themeColor, // Dynamic Marker Color
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 6)],
                          ),
                          child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
                          ),
                          child: Text("${widget.etaTime} away", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(Responsive.w(context, 16)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CURRENT ZONE",
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: AppTheme.secondaryColor1.withValues(alpha: 0.75), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                        ),
                        const SizedBox(height: 4),
                        Text(widget.zone, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, height: 1.2)),
                      ],
                    ),
                  ),
                  SizedBox(width: Responsive.w(context, 12)),
                  SizedBox(
                    width: Responsive.w(context, 122),
                    child: ElevatedButton(
                      onPressed: _isRefreshing ? null : _handleRefresh,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.themeColor, // Dynamic Button Color
                        disabledBackgroundColor: widget.themeColor.withValues(alpha: 0.7),
                        disabledForegroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isRefreshing) ...[const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)), const SizedBox(width: 8)],
                          const Text(
                            "Refresh",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive.dart';

class LiveTrackingPage extends StatefulWidget {
  // --- TEMPLATE PARAMETERS ---
  final String wasteType;
  final String zone;
  final String team;
  final String etaTime;
  final String etaDistance;
  final Color themeColor;
  final IconData wasteIcon;
  final List<String> checklistItems;

  const LiveTrackingPage({
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
  State<LiveTrackingPage> createState() => _LiveTrackingPageState();
}

class _LiveTrackingPageState extends State<LiveTrackingPage> {
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(6.9061, 79.8687), // Colombo 07 coordinates
    zoom: 14.0,
  );

  GoogleMapController? _mapController;
  bool _isMapReady = false;
  bool _isRefreshing = false;

  // Dynamic Checklist State Map
  final Map<String, bool> _checklistState = {};

  @override
  void initState() {
    super.initState();
    // Initialize the dynamic checklist (set first two as checked for realism)
    for (int i = 0; i < widget.checklistItems.length; i++) {
      _checklistState[widget.checklistItems[i]] = i < 2; // 0 and 1 are true, rest false
    }
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing || !_isMapReady) return;
    setState(() => _isRefreshing = true);

    try {
      final controller = _mapController;
      if (controller != null) {
        await controller.animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Live map updated"), duration: Duration(milliseconds: 900)));
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Map refresh failed. Please try again.")));
      }
    }

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _isRefreshing = false);
  }

  @override
  void dispose() {
    _mapController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: Responsive.h(context, AppTheme.space64),
        title: Padding(
          padding: EdgeInsets.only(top: Responsive.h(context, AppTheme.space8)),
          child: Text("Live Tracking", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        ),
        leading: Padding(
          padding: EdgeInsets.only(top: Responsive.h(context, AppTheme.space8)),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.textColor, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: Responsive.h(context, 40)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. THE MAP SECTION
            SizedBox(
              height: Responsive.h(context, 380),
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  GoogleMap(
                    initialCameraPosition: _initialCameraPosition,
                    onMapCreated: (controller) {
                      _mapController = controller;
                      if (!mounted) return;
                      setState(() => _isMapReady = true);
                    },
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    mapToolbarEnabled: false,
                    compassEnabled: false,
                  ),

                  // Custom Center Marker Overlay (Truck)
                  Positioned(
                    top: Responsive.h(context, 120),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.home_rounded, size: 16),
                              SizedBox(width: 4),
                              Text("Your Home", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // DYNAMIC Truck Marker Color
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: widget.themeColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 6)],
                          ),
                          child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 28),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 8)],
                          ),
                          child: Text("Arriving in ${widget.etaTime}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ],
                    ),
                  ),

                  // Bottom Overlay Card
                  Positioned(
                    bottom: Responsive.h(context, 18),
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: Responsive.w(context, 16)),
                      padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 20), vertical: Responsive.h(context, 16)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 15, offset: const Offset(0, 5))],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "ESTIMATED ARRIVAL",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(color: AppTheme.secondaryColor1.withValues(alpha: 0.55), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                                ),
                                const SizedBox(height: 4),
                                Text("Truck is ${widget.etaDistance} away", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          SizedBox(width: Responsive.w(context, 12)),
                          SizedBox(
                            width: Responsive.w(context, 122),
                            child: ElevatedButton(
                              onPressed: (_isRefreshing || !_isMapReady) ? null : _handleRefresh,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.themeColor,
                                disabledBackgroundColor: widget.themeColor.withValues(alpha: 0.7),
                                disabledForegroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_isRefreshing) ...[const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)), const SizedBox(width: 8)],
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
                  ),
                ],
              ),
            ),

            SizedBox(height: Responsive.h(context, 24)),

            // 2. COLLECTION DETAILS
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Collection Details", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: Responsive.h(context, 16)),
                  Container(
                    padding: EdgeInsets.all(Responsive.w(context, 20)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      children: [
                        // DYNAMIC Theme Injection
                        _buildDetailRow(widget.wasteIcon, "WASTE TYPE", widget.wasteType, widget.themeColor.withValues(alpha: 0.15), widget.themeColor),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1, color: Color(0xFFF3F4F6)),
                        ),
                        _buildDetailRow(Icons.location_on_outlined, "CURRENT ZONE", widget.zone, AppTheme.secondaryColor1.withValues(alpha: 0.12), AppTheme.secondaryColor1),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1, color: Color(0xFFF3F4F6)),
                        ),
                        _buildDetailRow(Icons.people_outline_rounded, "ASSIGNED TEAM", widget.team, AppTheme.secondaryColor2.withValues(alpha: 0.08), AppTheme.secondaryColor2),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: Responsive.h(context, 32)),

            // 3. PREPARATION CHECKLIST
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Preparation Checklist", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: Responsive.h(context, 16)),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: Responsive.h(context, 8)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      children: widget.checklistItems.map((item) {
                        return _buildChecklistItem(item, _checklistState[item] ?? false, (val) => setState(() => _checklistState[item] = val!));
                      }).toList(),
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

  // --- HELPERS ---
  Widget _buildDetailRow(IconData icon, String label, String value, Color iconBg, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        SizedBox(width: Responsive.w(context, 16)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.secondaryColor1.withValues(alpha: 0.55), letterSpacing: 1.1),
              ),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, height: 1.3)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChecklistItem(String text, bool isChecked, Function(bool?) onChanged) {
    return CheckboxListTile(
      value: isChecked,
      onChanged: onChanged,
      title: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: AppTheme.textColor),
      ),
      activeColor: widget.themeColor, // Dynamic Checkbox color!
      checkColor: Colors.white,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 16)),
      visualDensity: VisualDensity.compact,
      side: BorderSide(color: Colors.grey.shade300, width: 2),
      checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }
}

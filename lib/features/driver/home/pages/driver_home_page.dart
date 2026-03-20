import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';

// --- DATA MODEL ---
class WasteWard {
  final String id;
  final String name;
  final String sector;

  WasteWard({required this.id, required this.name, required this.sector});
}

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  // Hardcoded District 5 Wards
  final List<WasteWard> _wards = [
    WasteWard(id: '01', name: 'Bambalapitiya', sector: 'District Sector Alpha'),
    WasteWard(id: '02', name: 'Milagiriya', sector: 'District Sector Alpha'),
    WasteWard(id: '03', name: 'Havelock Town', sector: 'District Sector Beta'),
    WasteWard(id: '04', name: 'Wellawatta North', sector: 'District Sector Gamma'),
    WasteWard(id: '05', name: 'Wellawatta South', sector: 'District Sector Gamma'),
    WasteWard(id: '06', name: 'Pamankada West', sector: 'District Sector Delta'),
  ];

  late WasteWard _selectedWard;

  @override
  void initState() {
    super.initState();
    // Default selected ward
    _selectedWard = _wards.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, AppTheme.space24), vertical: Responsive.h(context, AppTheme.space24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: Responsive.h(context, 32)),

              _buildCurrentAssignedArea(context),
              SizedBox(height: Responsive.h(context, 40)),

              _buildSectionTitle(context),
              SizedBox(height: Responsive.h(context, 24)),

              // Render the list of wards
              ..._wards.map((ward) => _buildWardCard(context, ward)),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, Driver",
              style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppTheme.secondaryColor1, fontSize: Responsive.sp(context, 28)),
            ),
            SizedBox(height: Responsive.h(context, 8)),
            Row(
              children: [
                Icon(Icons.location_on, color: AppTheme.secondaryColor1, size: Responsive.w(context, 16)),
                SizedBox(width: Responsive.w(context, 4)),
                Text(
                  "COLOMBO DISTRICT 5",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textColor.withValues(alpha: 0.6), letterSpacing: 1.2, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
        CircleAvatar(
          radius: Responsive.r(context, 22),
          backgroundColor: AppTheme.accentColor,
          child: Icon(Icons.person_rounded, color: AppTheme.secondaryColor2, size: Responsive.w(context, 24)),
        ),
      ],
    );
  }

  Widget _buildCurrentAssignedArea(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.w(context, 24)),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 240, 226, 206),
        borderRadius: BorderRadius.circular(Responsive.r(context, 24)),
        border: Border.all(color: AppTheme.textColor.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "CURRENT ASSIGNED AREA",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.secondaryColor1, fontWeight: FontWeight.w800, letterSpacing: 1.0),
              ),
              SizedBox(height: Responsive.h(context, 4)),
              Text(_selectedWard.name, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppTheme.textColor)),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 16), vertical: Responsive.h(context, 8)),
            decoration: BoxDecoration(color: AppTheme.accentColor, borderRadius: BorderRadius.circular(Responsive.r(context, 20))),
            child: Text(
              "ACTIVE",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white, fontSize: Responsive.sp(context, 12), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Your Current", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.secondaryColor1)),
        Text("Assignment Area", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.secondaryColor1)),
        SizedBox(height: Responsive.h(context, 4)),
        Container(height: 3, width: Responsive.w(context, 60), color: AppTheme.accentColor),
      ],
    );
  }

  Widget _buildWardCard(BuildContext context, WasteWard ward) {
    final bool isSelected = _selectedWard.id == ward.id;

    return GestureDetector(
      // onTap: () {
      //   if (_selectedWard.name == 'Bambalapitiya') {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => const BambalapitiyaRoutePage()),
      //     );
      //   } else {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text("${_selectedWard.name} routes are locked for this truck."),
      //         backgroundColor: AppTheme.secondaryColor1,
      //         behavior: SnackBarBehavior.floating,
      //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.r(context, 30))),
      //       ),
      //     );
      //   }
      // },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        margin: EdgeInsets.only(bottom: Responsive.h(context, 16)),
        padding: EdgeInsets.all(Responsive.w(context, 24)),
        decoration: BoxDecoration(color: isSelected ? AppTheme.accentColor : Color.fromARGB(255, 240, 226, 206), borderRadius: BorderRadius.circular(Responsive.r(context, 24))),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ward ID Pill
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 10), vertical: Responsive.h(context, 4)),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.secondaryColor1.withValues(alpha: 0.2) : AppTheme.textColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Responsive.r(context, 12)),
                  ),
                  child: Text(
                    "WARD ${ward.id}",
                    style: TextStyle(fontSize: Responsive.sp(context, 10), fontWeight: FontWeight.w800, color: isSelected ? AppTheme.secondaryColor2 : AppTheme.textColor.withValues(alpha: 0.8)),
                  ),
                ),
                SizedBox(height: Responsive.h(context, 16)),

                // Ward Name
                Text(
                  ward.name,
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge?.copyWith(color: isSelected ? AppTheme.secondaryColor2 : AppTheme.textColor.withValues(alpha: 0.7), fontSize: Responsive.sp(context, 32)),
                ),
                SizedBox(height: Responsive.h(context, 4)),
              ],
            ),

            // Checkmark Icon for Selected State
            if (isSelected)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: AppTheme.secondaryColor2, shape: BoxShape.circle),
                  child: Icon(Icons.check_rounded, color: AppTheme.accentColor, size: Responsive.w(context, 16)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

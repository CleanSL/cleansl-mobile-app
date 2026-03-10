import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive.dart';

class NonRecyclablePage extends StatelessWidget {
  const NonRecyclablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        toolbarHeight: Responsive.h(context, AppTheme.space64),
        title: Text(
          "Non-recyclable Waste",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor),
        ),
        // Custom Pill-Shaped Back Button
        leadingWidth: Responsive.w(context, 100),
        leading: Padding(
          padding: EdgeInsets.only(left: Responsive.w(context, AppTheme.space16)),
          child: Center(
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(Responsive.r(context, 30)),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 12), vertical: Responsive.h(context, 8)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Responsive.r(context, 30)),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 5, offset: const Offset(0, 2))],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_rounded, color: AppTheme.secondaryColor1, size: Responsive.w(context, 18)),
                    SizedBox(width: Responsive.w(context, 4)),
                    Text(
                      "Back",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Top Right Icon
        actions: [
          Padding(
            padding: EdgeInsets.only(right: Responsive.w(context, AppTheme.space24)),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(Responsive.w(context, 8)),
                decoration: BoxDecoration(color: AppTheme.accentColor.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: Icon(Icons.recycling_rounded, color: AppTheme.accentColor, size: Responsive.w(context, 20)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: Responsive.w(context, AppTheme.space24),
          right: Responsive.w(context, AppTheme.space24),
          top: Responsive.h(context, AppTheme.space16),
          bottom: Responsive.h(context, AppTheme.space48),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Image
            _buildHeroCard(context, AppTheme.secondaryColor1),
            SizedBox(height: Responsive.h(context, AppTheme.space32)),

            // 2. Items List
            Text(
              "Items for Landfill",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.secondaryColor1),
            ),
            SizedBox(height: Responsive.h(context, AppTheme.space16)),

            _buildWasteItemCard(context, title: "Sanitary Products & Diapers", description: "Used diapers, wipes, and feminine hygiene products.", icon: Icons.baby_changing_station_rounded),
            _buildWasteItemCard(context, title: "Styrofoam & Polystyrene", description: "Takeout containers, packing peanuts, and foam cups.", icon: Icons.takeout_dining_rounded),
            _buildWasteItemCard(context, title: "Contaminated Packaging", description: "Greasy pizza boxes, food-soaked wrappers, and soiled paper.", icon: Icons.fastfood_rounded),
            _buildWasteItemCard(context, title: "Hazardous Materials", description: "Light bulbs, ceramics, mirrors, and specific medical waste.", icon: Icons.warning_rounded),

            SizedBox(height: Responsive.h(context, AppTheme.space32)),

            // 3. Proper Disposal Tips Box
            _buildTipsBox(context),
          ],
        ),
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  Widget _buildHeroCard(BuildContext context, Color accentColor) {
    return Container(
      width: double.infinity,
      height: Responsive.h(context, 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Responsive.r(context, 24)),
        image: const DecorationImage(
          image: AssetImage('assets/img/non_recyclable_waste.jpg'), // Make sure to add this image
          fit: BoxFit.cover,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Responsive.r(context, 24)),
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)]),
        ),
        padding: EdgeInsets.all(Responsive.w(context, 24)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 10), vertical: Responsive.h(context, 4)),
              decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(Responsive.r(context, 8))),
              child: Text(
                "GUIDE",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0),
              ),
            ),
            SizedBox(height: Responsive.h(context, 8)),
            Text("Landfill Guide", style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white)),
            SizedBox(height: Responsive.h(context, 4)),
            Text("Dispose of general waste safely.", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.9))),
          ],
        ),
      ),
    );
  }

  Widget _buildWasteItemCard(BuildContext context, {required String title, required String description, required IconData icon}) {
    return Container(
      margin: EdgeInsets.only(bottom: Responsive.h(context, AppTheme.space16)),
      padding: EdgeInsets.all(Responsive.w(context, 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(context, 16)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(Responsive.w(context, 12)),
            decoration: BoxDecoration(color: AppTheme.secondaryColor1.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(Responsive.r(context, 12))),
            child: Icon(icon, color: AppTheme.secondaryColor1, size: Responsive.w(context, 24)),
          ),
          SizedBox(width: Responsive.w(context, 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor),
                ),
                SizedBox(height: Responsive.h(context, 4)),
                Text(description, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.secondaryColor1.withValues(alpha: 0.7), height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(context, 24)),
      decoration: BoxDecoration(
        color: AppTheme.primaryBackground,
        borderRadius: BorderRadius.circular(Responsive.r(context, 16)),
        border: Border.all(color: AppTheme.secondaryColor1.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_rounded, color: AppTheme.accentColor, size: Responsive.w(context, 24)),
              SizedBox(width: Responsive.w(context, 12)),
              Text(
                "Proper Disposal Tips",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(context, 16)),
          _buildTipRow(context, "Bag all loose items to prevent litter during collection."),
          _buildTipRow(context, "Double-bag pet waste and sharp objects for safety."),
          _buildTipRow(context, "Check local regulations for large furniture or bulky items."),
        ],
      ),
    );
  }

  Widget _buildTipRow(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: Responsive.h(context, 12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: Responsive.h(context, 4)),
            child: Icon(Icons.check_circle_rounded, color: AppTheme.accentColor, size: Responsive.w(context, 16)),
          ),
          SizedBox(width: Responsive.w(context, 12)),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.secondaryColor1.withValues(alpha: 0.8), height: 1.4)),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive.dart';

class RecyclablesPage extends StatelessWidget {
  const RecyclablesPage({super.key});

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
          "Recyclable Waste",
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
                    Icon(Icons.arrow_back_rounded, color: AppTheme.accentColor, size: Responsive.w(context, 18)),
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
            // 1. Hero Image Card (Matches Organic Waste style)
            _buildHeroCard(context, AppTheme.accentColor),
            SizedBox(height: Responsive.h(context, AppTheme.space32)),

            // 2. Cleaning Instructions Box
            _buildInfoBox(
              context,
              title: "Cleaning Instructions",
              description: "Always rinse containers thoroughly before recycling. Food residue can contaminate an entire batch of recyclables.",
              icon: Icons.wash_rounded,
            ),
            SizedBox(height: Responsive.h(context, AppTheme.space32)),

            // 3. Accepted Items List
            Row(
              children: [
                Icon(Icons.list_alt_rounded, color: AppTheme.accentColor, size: Responsive.w(context, 24)),
                SizedBox(width: Responsive.w(context, 8)),
                Text(
                  "Accepted Items",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor),
                ),
              ],
            ),
            SizedBox(height: Responsive.h(context, AppTheme.space16)),

            _buildAcceptedItem(context, title: "Plastic Bottles", subtitle: "PET 1 and HDPE 2 Plastics", icon: Icons.local_drink_rounded, iconColor: Colors.blue.shade600, iconBg: Colors.blue.shade50),
            _buildAcceptedItem(
              context,
              title: "Paper & Cardboard",
              subtitle: "Magazines, envelopes, and boxes",
              icon: Icons.description_rounded,
              iconColor: AppTheme.secondaryColor1,
              iconBg: AppTheme.secondaryColor1.withValues(alpha: 0.1),
            ),
            _buildAcceptedItem(
              context,
              title: "Glass Jars",
              subtitle: "Food and beverage containers",
              icon: Icons.liquor_rounded,
              iconColor: AppTheme.accentColor,
              iconBg: AppTheme.accentColor.withValues(alpha: 0.15),
            ),
            _buildAcceptedItem(
              context,
              title: "Metal Cans",
              subtitle: "Aluminum and steel tin cans",
              icon: Icons.inventory_2_rounded,
              iconColor: Colors.blueGrey.shade600,
              iconBg: Colors.blueGrey.shade50,
            ),

            SizedBox(height: Responsive.h(context, AppTheme.space32)),

            // 4. "Did you know?" Banner
            _buildDidYouKnowCard(context),
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
          image: AssetImage('assets/img/recyclable_waste.jpg'),
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
            Text("Recycling Guide", style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white)),
            SizedBox(height: Responsive.h(context, 4)),
            Text("Proper sorting helps reduce landfill waste.", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.9))),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(BuildContext context, {required String title, required String description, required IconData icon}) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(context, 20)),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Responsive.r(context, 16)),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.accentColor, size: Responsive.w(context, 28)),
          SizedBox(width: Responsive.w(context, 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor),
                ),
                SizedBox(height: Responsive.h(context, 8)),
                Text(description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.secondaryColor1.withValues(alpha: 0.8), height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptedItem(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color iconColor, required Color iconBg}) {
    return Container(
      margin: EdgeInsets.only(bottom: Responsive.h(context, AppTheme.space16)),
      padding: EdgeInsets.all(Responsive.w(context, 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(context, 16)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(Responsive.w(context, 12)),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: Responsive.w(context, 24)),
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
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.secondaryColor1.withValues(alpha: 0.6))),
              ],
            ),
          ),
          SizedBox(width: Responsive.w(context, 8)),
          Icon(Icons.check_circle_rounded, color: Colors.grey.shade300, size: Responsive.w(context, 24)),
        ],
      ),
    );
  }

  Widget _buildDidYouKnowCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.w(context, 24)),
      decoration: BoxDecoration(
        color: AppTheme.accentColor,
        borderRadius: BorderRadius.circular(Responsive.r(context, 16)),
        boxShadow: [BoxShadow(color: AppTheme.accentColor.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -10,
            bottom: -20,
            child: Icon(Icons.lightbulb_outline_rounded, color: Colors.white.withValues(alpha: 0.15), size: Responsive.w(context, 120)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Did you know?",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: Responsive.h(context, 12)),
              Padding(
                padding: EdgeInsets.only(right: Responsive.w(context, 40)),
                child: Text(
                  "Recycling one aluminum can saves enough energy to run a TV for three hours.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.9), height: 1.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

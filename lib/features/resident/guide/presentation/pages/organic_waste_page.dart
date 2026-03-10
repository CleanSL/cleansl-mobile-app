import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive.dart';

class OrganicWastePage extends StatelessWidget {
  const OrganicWastePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Defining the specific accents for this page
    final Color pageAccent = AppTheme.accentColor;
    final Color pageAccentLight = AppTheme.accentColor.withValues(alpha: 0.12);

    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        toolbarHeight: Responsive.h(context, AppTheme.space64),
        title: Text(
          "Organic Waste",
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
                    Icon(
                      Icons.arrow_back_rounded,
                      color: pageAccent, // Orange arrow to match the theme
                      size: Responsive.w(context, 18),
                    ),
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
            // 1. Hero Image Card
            _buildHeroCard(context, pageAccent),
            SizedBox(height: Responsive.h(context, AppTheme.space32)),

            // 2. Compostable Items Section
            Text(
              "Compostable Items",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, color: AppTheme.textColor),
            ),
            SizedBox(height: Responsive.h(context, 4)),
            Text("What can go in your organic bin?", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.secondaryColor1.withValues(alpha: 0.8))),
            SizedBox(height: Responsive.h(context, AppTheme.space16)),

            // Grid of Items
            Row(
              children: [
                Expanded(child: _buildGridItem(context, "Fruit Peels", Icons.local_florist_rounded, pageAccent, pageAccentLight)),
                SizedBox(width: Responsive.w(context, AppTheme.space16)),
                Expanded(child: _buildGridItem(context, "Vegetable Scraps", Icons.eco_rounded, pageAccent, pageAccentLight)),
              ],
            ),
            SizedBox(height: Responsive.h(context, AppTheme.space16)),
            Row(
              children: [
                Expanded(child: _buildGridItem(context, "Coffee Grounds", Icons.coffee_rounded, pageAccent, pageAccentLight)),
                SizedBox(width: Responsive.w(context, AppTheme.space16)),
                Expanded(child: _buildGridItem(context, "Eggshells", Icons.egg_rounded, pageAccent, pageAccentLight)),
              ],
            ),
            SizedBox(height: Responsive.h(context, AppTheme.space16)),
            // Full width item
            _buildFullWidthItem(context, "Yard Waste", Icons.grass_rounded, pageAccent, pageAccentLight),

            SizedBox(height: Responsive.h(context, AppTheme.space32)),

            // 3. Benefits of Composting Section
            Text(
              "Benefits of Composting",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, color: AppTheme.textColor),
            ),
            SizedBox(height: Responsive.h(context, AppTheme.space16)),

            _buildBenefitCard(
              context,
              title: "Reduces Landfill Waste",
              description: "Organic waste in landfills produces methane, a potent greenhouse gas. Composting prevents this.",
              icon: Icons.energy_savings_leaf_rounded,
              iconColor: pageAccent,
            ),
            _buildBenefitCard(
              context,
              title: "Enriches Soil",
              description: "Adds vital nutrients back into your garden, improving soil structure and water retention.",
              icon: Icons.spa_rounded,
              iconColor: pageAccent,
            ),
            _buildBenefitCard(
              context,
              title: "Saves Money",
              description: "Reduces the need for chemical fertilizers and can lower waste collection fees.",
              icon: Icons.savings_rounded, // Piggy bank icon
              iconColor: pageAccent,
            ),
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
        image: const DecorationImage(image: AssetImage('assets/img/organic_waste.jpg'), fit: BoxFit.cover),
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
            Text("Composting 101", style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white)),
            SizedBox(height: Responsive.h(context, 4)),
            Text("Turn your kitchen scraps into black gold.", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.9))),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, String title, IconData icon, Color iconColor, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Responsive.h(context, 24), horizontal: Responsive.w(context, 12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(context, 16)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(Responsive.w(context, 16)),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: Responsive.w(context, 24)),
          ),
          SizedBox(height: Responsive.h(context, 16)),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildFullWidthItem(BuildContext context, String title, IconData icon, Color iconColor, Color bgColor) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: Responsive.h(context, 24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(context, 16)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(Responsive.w(context, 16)),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: Responsive.w(context, 24)),
          ),
          SizedBox(height: Responsive.h(context, 16)),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitCard(BuildContext context, {required String title, required String description, required IconData icon, required Color iconColor}) {
    return Container(
      margin: EdgeInsets.only(bottom: Responsive.h(context, AppTheme.space16)),
      padding: EdgeInsets.all(Responsive.w(context, 20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(context, 16)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: Responsive.w(context, 28)),
          SizedBox(width: Responsive.w(context, 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 16)),
                ),
                SizedBox(height: Responsive.h(context, 6)),
                Text(description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.secondaryColor1.withValues(alpha: 0.8), height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive.dart';

// --- 1. DATA MODEL ---
// This represents a single activity. Later, Husni's backend will provide this data.
class ActivityItem {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String category; // 'Pickups' or 'Reports'
  final String? statusText;
  final List<Map<IconData, String>> details;
  final String actionText;

  ActivityItem({required this.title, required this.icon, required this.iconColor, required this.iconBgColor, required this.category, this.statusText, required this.details, required this.actionText});
}

class RecentActivityPage extends StatefulWidget {
  const RecentActivityPage({super.key});

  @override
  State<RecentActivityPage> createState() => _RecentActivityPageState();
}

class _RecentActivityPageState extends State<RecentActivityPage> {
  String _selectedFilter = 'All';
  String _searchQuery = '';

  // --- 2. THE DATA SOURCE ---
  final List<ActivityItem> _allActivities = [
    ActivityItem(
      title: "Recycling Pickup Completed",
      icon: Icons.recycling_rounded,
      iconColor: AppTheme.accentColor,
      iconBgColor: AppTheme.accentColor.withValues(alpha: 0.15),
      category: 'Pickups',
      details: [
        {Icons.calendar_today_rounded: "Oct 24, 2023 • 09:15 AM"},
        {Icons.location_on_rounded: "123 Maple Avenue"},
      ],
      actionText: "VIEW DETAILS",
    ),
    ActivityItem(
      title: "Issue Reported: Missed Bin",
      icon: Icons.warning_rounded,
      iconColor: Colors.orange.shade700,
      iconBgColor: Colors.orange.shade50,
      category: 'Reports',
      statusText: "IN PROGRESS",
      details: [
        {Icons.numbers_rounded: "Reference ID: #CSL-88291"},
      ],
      actionText: "TRACK STATUS",
    ),
    ActivityItem(
      title: "General Waste Collected",
      icon: Icons.delete_rounded,
      iconColor: Colors.blue.shade600,
      iconBgColor: Colors.blue.shade50,
      category: 'Pickups',
      details: [
        {Icons.calendar_today_rounded: "Oct 22, 2023 • 07:30 AM"},
      ],
      actionText: "RECEIPT",
    ),
    ActivityItem(
      title: "Report Resolved: Broken Bin Lid",
      icon: Icons.check_circle_rounded,
      iconColor: AppTheme.accentColor,
      iconBgColor: AppTheme.accentColor.withValues(alpha: 0.15),
      category: 'Reports',
      statusText: "RESOLVED",
      details: [
        {Icons.verified_rounded: "Action: Lid Replaced"},
      ],
      actionText: "FEEDBACK",
    ),
  ];

  // --- 3. FILTERING LOGIC ---
  List<ActivityItem> get _filteredActivities {
    return _allActivities.where((activity) {
      // Filter by Category
      final matchesCategory = _selectedFilter == 'All' || activity.category == _selectedFilter;
      // Filter by Search Query
      final matchesSearch = activity.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

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
          "Recent Activity",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor),
        ),
        // FIXED: Removed white circle background from back button
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.textColor),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, AppTheme.space24)),
            child: Column(
              children: [
                SizedBox(height: Responsive.h(context, AppTheme.space16)),
                _buildSearchBar(),
                SizedBox(height: Responsive.h(context, AppTheme.space16)),
              ],
            ),
          ),
          _buildFiltersRow(),
          SizedBox(height: Responsive.h(context, AppTheme.space24)),

          // SCROLLABLE LIST (Dynamic)
          Expanded(
            child: _filteredActivities.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, AppTheme.space24)),
                    itemCount: _filteredActivities.length,
                    itemBuilder: (context, index) {
                      return _buildActivityCard(context, _filteredActivities[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(context, 12)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value), // TRIGGER SEARCH
        decoration: InputDecoration(
          hintText: "Search activities...",
          prefixIcon: Icon(Icons.search_rounded, color: Colors.blueGrey.shade300),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildFiltersRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, AppTheme.space24)),
      child: Row(
        children: [
          _buildFilterChip(label: 'All', icon: Icons.done_all_rounded, isSelected: _selectedFilter == 'All'),
          SizedBox(width: Responsive.w(context, 12)),
          _buildFilterChip(label: 'Pickups', icon: Icons.local_shipping_rounded, isSelected: _selectedFilter == 'Pickups'),
          SizedBox(width: Responsive.w(context, 12)),
          _buildFilterChip(label: 'Reports', icon: Icons.warning_rounded, isSelected: _selectedFilter == 'Reports'),
        ],
      ),
    );
  }

  Widget _buildFilterChip({required String label, required IconData icon, required bool isSelected}) {
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 16), vertical: Responsive.h(context, 10)),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.textColor : Colors.white,
          borderRadius: BorderRadius.circular(Responsive.r(context, 24)),
          border: Border.all(color: isSelected ? AppTheme.textColor : Colors.grey.shade300, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, size: Responsive.w(context, 18), color: isSelected ? Colors.white : Colors.blueGrey.shade400),
            SizedBox(width: Responsive.w(context, 8)),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isSelected ? Colors.white : Colors.blueGrey.shade600, fontWeight: isSelected ? FontWeight.bold : FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context, ActivityItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: Responsive.h(context, AppTheme.space16)),
      padding: EdgeInsets.all(Responsive.w(context, 20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(context, 16)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(Responsive.w(context, 12)),
                decoration: BoxDecoration(color: item.iconBgColor, shape: BoxShape.circle),
                child: Icon(item.icon, color: item.iconColor, size: Responsive.w(context, 24)),
              ),
              SizedBox(width: Responsive.w(context, 16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor),
                    ),
                    if (item.statusText != null) ...[SizedBox(height: Responsive.h(context, 8)), _buildStatusPill(item.statusText!, item.iconColor, item.iconBgColor)],
                    SizedBox(height: Responsive.h(context, 12)),
                    // Map details list to detail rows
                    ...item.details.map((detail) {
                      final entry = detail.entries.first;
                      return _buildDetailRow(entry.key, entry.value);
                    }),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(context, 16)),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [_buildActionButton(item.actionText, () {})]),
        ],
      ),
    );
  }

  // --- SMALL HELPER WIDGETS ---

  Widget _buildStatusPill(String text, Color color, Color bg) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 8), vertical: Responsive.h(context, 4)),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(Responsive.r(context, 6))),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: Responsive.h(context, 6)),
      child: Row(
        children: [
          Icon(icon, size: Responsive.w(context, 16), color: Colors.blueGrey.shade400),
          SizedBox(width: Responsive.w(context, 8)),
          Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.blueGrey.shade600)),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 16), vertical: Responsive.h(context, 8)),
        decoration: BoxDecoration(color: AppTheme.accentColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(Responsive.r(context, 20))),
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppTheme.accentColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text("No activities found matching your criteria.", style: TextStyle(color: Colors.grey.shade500)),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive.dart';
import '../../data/complaint_model.dart';
import '../widgets/complaint_card.dart';
import 'help_support_page.dart';
import 'file_complaint_page.dart';

class ComplaintsMainPage extends StatefulWidget {
  const ComplaintsMainPage({super.key});

  @override
  State<ComplaintsMainPage> createState() => _ComplaintsMainPageState();
}

class _ComplaintsMainPageState extends State<ComplaintsMainPage> {
  String _selectedFilter = 'All';
  bool _isLoading = false;
  bool _isAscending = false;

  final List<Complaint> _allComplaints = [
    Complaint(
      id: "8821",
      category: "Missed Pickup",
      status: "Pending",
      statusTitle: "Under Review",
      statusDescription: "Our team is currently verifying your report. You can cancel if it was made in error.",
      dateSubmitted: "Oct 12, 2023",
      fullDescription: "The trash collection truck skipped our block this morning despite the scheduled pickup.",
      imagePath: 'assets/img/missed_pickup.jpg',
      isLocal: true,
    ),
    Complaint(
      id: "8795",
      category: "Overflowing Bin",
      status: "In Progress",
      statusTitle: "Team Assigned",
      statusDescription: "A field team has been dispatched to resolve the issue.",
      dateSubmitted: "Oct 10, 2023",
      fullDescription: "Public bin at the corner of 5th Ave is overflowing and causing a health hazard.",
      imagePath: 'assets/img/overflowing_bin.jpg',
      isLocal: true,
      assignedTo: "Field Team B",
    ),
    Complaint(
      id: "8612",
      category: "Broken Bin Lid",
      status: "Resolved",
      statusTitle: "Issue Resolved",
      statusDescription: "The issue has been resolved. Thank you for helping us keep Colombo clean.",
      dateSubmitted: "Oct 05, 2023",
      fullDescription: "The lid of my green recycling bin has snapped off due to wear and tear.",
      imagePath: 'assets/img/broken_bin.jpg',
      isLocal: true,
      completionDate: "Oct 07",
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("List updated successfully")));
  }

  void _handleSort() {
    setState(() {
      _isAscending = !_isAscending;
      _allComplaints.sort((a, b) => _isAscending
          ? a.id.compareTo(b.id)
          : b.id.compareTo(a.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        centerTitle: true,
        title: Text("My Complaints", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            elevation: 10,
            shadowColor: Colors.black.withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            offset: const Offset(0, 50),
            color: Colors.white,
            icon: const Icon(Icons.more_vert_rounded, color: AppTheme.textColor),
            onSelected: (value) {
              if (value == 'refresh') _handleRefresh();
              if (value == 'sort') _handleSort();
              if (value == 'help') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportPage()));
              }
            },
            itemBuilder: (context) => [
              _buildMenuItem('refresh', Icons.refresh_rounded, "Refresh List"),
              _buildMenuItem('sort', Icons.sort_rounded, _isAscending ? "Newest First" : "Oldest First"),
              const PopupMenuDivider(height: 1),
              _buildMenuItem('help', Icons.help_outline_rounded, "Help & Support"),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(height: Responsive.h(context, AppTheme.space16)),
                _buildFiltersRow(),
                SizedBox(height: Responsive.h(context, AppTheme.space16)),
                Expanded(child: _buildComplaintList(_filtered())),
              ],
            ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const FileComplaintPage()));
          },
          backgroundColor: AppTheme.accentColor,
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 36),
        ),
      ),
    );
  }

  List<Complaint> _filtered() {
    if (_selectedFilter == 'Active') {
      return _allComplaints.where((c) => c.status != 'Resolved').toList();
    }
    if (_selectedFilter == 'Resolved') {
      return _allComplaints.where((c) => c.status == 'Resolved').toList();
    }
    return _allComplaints;
  }

  Widget _buildFiltersRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, AppTheme.space24)),
      child: Row(
        children: [
          _buildFilterChip(label: "All", icon: Icons.done_all_rounded, isSelected: _selectedFilter == 'All'),
          SizedBox(width: Responsive.w(context, 12)),
          _buildFilterChip(label: "Active", icon: Icons.pending_rounded, isSelected: _selectedFilter == 'Active'),
          SizedBox(width: Responsive.w(context, 12)),
          _buildFilterChip(label: "Resolved", icon: Icons.check_circle_rounded, isSelected: _selectedFilter == 'Resolved'),
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? Colors.white : Colors.blueGrey.shade600,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(String value, IconData icon, String text) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: AppTheme.secondaryColor1, size: 20),
          const SizedBox(width: 14),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildComplaintList(List<Complaint> items) {
    if (items.isEmpty) {
      return const Center(child: Text("No complaints found."));
    }
    return ListView.builder(
      padding: EdgeInsets.only(
        left: Responsive.w(context, AppTheme.space24),
        right: Responsive.w(context, AppTheme.space24),
        top: Responsive.h(context, AppTheme.space16),
        bottom: Responsive.h(context, AppTheme.space16) + MediaQuery.of(context).padding.bottom,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => ComplaintCard(
        complaint: items[index],
      ),
    );
  }
}
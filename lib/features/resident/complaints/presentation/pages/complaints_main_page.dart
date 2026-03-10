import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive.dart';
import '../widgets/complaint_card.dart'; // New Import
import 'help_support_page.dart';
import 'file_complaint_page.dart';

class Complaint {
  final String id;
  final String title;
  final DateTime date;
  final String description;
  final String status;
  final String imagePath;
  final bool isLocal;
  final String? assignment;
  final String? completionDate;

  Complaint({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.status,
    required this.imagePath,
    this.isLocal = false,
    this.assignment,
    this.completionDate,
  });
}

class ComplaintsMainPage extends StatefulWidget {
  const ComplaintsMainPage({super.key});

  @override
  State<ComplaintsMainPage> createState() => _ComplaintsMainPageState();
}

class _ComplaintsMainPageState extends State<ComplaintsMainPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  bool _isAscending = false;

  final List<Complaint> _allComplaints = [
    Complaint(
      id: "8821",
      title: "Missed Pickup",
      date: DateTime(2023, 10, 12),
      status: "Pending",
      description: "The trash collection truck skipped our block this morning...",
      imagePath: 'assets/img/missed_pickup.jpg',
      isLocal: true,
    ),
    Complaint(
      id: "8795",
      title: "Overflowing Bin",
      date: DateTime(2023, 10, 10),
      status: "In Progress",
      description: "Public bin at the corner of 5th Ave is overflowing...",
      imagePath: 'assets/img/overflowing_bin.jpg',
      isLocal: true,
      assignment: "Assigned to Field Team B",
    ),
    Complaint(
      id: "8612",
      title: "Broken Bin Lid",
      date: DateTime(2023, 10, 05),
      status: "Resolved",
      description: "The lid of my green recycling bin has snapped off...",
      imagePath: 'assets/img/broken_bin.jpg',
      isLocal: true,
      completionDate: "Oct 07",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _handleRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("List updated successfully")));
    }
  }

  void _handleSort() {
    setState(() {
      _isAscending = !_isAscending;
      _allComplaints.sort((a, b) => _isAscending ? a.date.compareTo(b.date) : b.date.compareTo(a.date));
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
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.textColor),
        ),
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accentColor,
          labelColor: AppTheme.accentColor,
          unselectedLabelColor: Colors.grey,
          tabs: const [Tab(text: "All"), Tab(text: "Active"), Tab(text: "Resolved")],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildComplaintList(_allComplaints),
                _buildComplaintList(_allComplaints.where((c) => c.status != "Resolved").toList()),
                _buildComplaintList(_allComplaints.where((c) => c.status == "Resolved").toList()),
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
        onViewDetails: () {
          // TODO: Navigate to Details page
        },
      ),
    );
  }
}
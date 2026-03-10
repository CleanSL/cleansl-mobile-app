import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive.dart';
import 'help_support_page.dart';

class Complaint {
  final String id;
  final String title;
  final DateTime date; // Changed to DateTime for actual sorting logic
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

  // Initial Data
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

  // --- MENU LOGIC FUNCTIONS ---

  Future<void> _handleRefresh() async {
    setState(() => _isLoading = true);
    // Simulate a 2-second network call to Husni's backend
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
          // THE MODERN POPUP MENU
          PopupMenuButton<String>(
            elevation: 10,
            shadowColor: Colors.black.withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            offset: const Offset(0, 50), // Moves it down so it doesn't cover the icon
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
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Active"),
            Tab(text: "Resolved"),
          ],
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
          onPressed: () {}, // Navigate to Form
          backgroundColor: AppTheme.accentColor,
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 36),
        ),
      ),
    );
  }

  // --- REUSABLE MENU ITEM UI ---
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

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
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
      itemBuilder: (context, index) => _buildComplaintCard(context, items[index]),
    );
  }

  Widget _buildComplaintCard(BuildContext context, Complaint complaint) {
    return Container(
      margin: EdgeInsets.only(bottom: Responsive.h(context, 20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(context, 24)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: complaint.isLocal
                ? Image.asset(complaint.imagePath, height: Responsive.h(context, 160), width: double.infinity, fit: BoxFit.cover)
                : Image.network(
                    complaint.imagePath,
                    height: Responsive.h(context, 160),
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: Responsive.h(context, 160),
                        color: Colors.grey.shade100,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: Responsive.h(context, 160),
                      color: Colors.grey.shade100,
                      child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
                    ),
                  ),
          ),
          Padding(
            padding: EdgeInsets.all(Responsive.w(context, 16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusBadge(complaint.status),
                    Text("ID: #${complaint.id}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                SizedBox(height: Responsive.h(context, 12)),
                Text(complaint.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: Responsive.h(context, 4)),
                Text(
                  "Submitted on ${_formatDate(complaint.date)}",
                  style: const TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: Responsive.h(context, 8)),
                Text(
                  complaint.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                ),
                SizedBox(height: Responsive.h(context, 16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (complaint.status == "In Progress")
                      _buildInfoRow(Icons.stars_rounded, complaint.assignment ?? "", Colors.orange)
                    else if (complaint.status == "Resolved")
                      _buildInfoRow(Icons.check_circle_rounded, "Completed ${complaint.completionDate}", AppTheme.accentColor)
                    else
                      const Icon(Icons.person_outline_rounded, color: AppTheme.accentColor, size: 20),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("View Details"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color text;
    if (status == "In Progress") {
      bg = Colors.orange.shade50;
      text = Colors.orange.shade700;
    } else if (status == "Resolved") {
      bg = AppTheme.accentColor.withValues(alpha: 0.1);
      text = AppTheme.accentColor;
    } else {
      bg = Colors.grey.shade100;
      text = Colors.grey.shade700;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(
        status,
        style: TextStyle(color: text, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

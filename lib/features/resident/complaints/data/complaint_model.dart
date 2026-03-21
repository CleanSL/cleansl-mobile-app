class Complaint {
  final String id;
  final String category;
  final String status; // "Pending", "In Progress", "Resolved"
  final String statusTitle;
  final String statusDescription;
  final String dateSubmitted;
  final String fullDescription;
  final String imagePath;
  final bool isLocal;
  final String? assignedTo;
  final String? completionDate;

  Complaint({
    required this.id,
    required this.category,
    required this.status,
    required this.statusTitle,
    required this.statusDescription,
    required this.dateSubmitted,
    required this.fullDescription,
    required this.imagePath,
    this.isLocal = true,
    this.assignedTo,
    this.completionDate,
  });

  /// Parses a complaint row returned by GET /api/complaints
  factory Complaint.fromJson(Map<String, dynamic> json) {
    final rawStatus = (json['status'] as String?) ?? 'pending';
    final fullId = (json['id'] as String?) ?? '';
    return Complaint(
      id: fullId.length >= 8 ? fullId.substring(0, 8).toUpperCase() : fullId.toUpperCase(),
      category: (json['location_name'] as String?) ?? 'General Complaint',
      status: _mapStatus(rawStatus),
      statusTitle: _mapStatusTitle(rawStatus),
      statusDescription: _mapStatusDesc(rawStatus),
      dateSubmitted: _formatDate(json['created_at'] as String?),
      fullDescription: (json['complaint_text'] as String?) ?? '',
      imagePath: (json['photo_url'] as String?) ?? '',
      isLocal: false,
    );
  }

  static String _mapStatus(String raw) {
    switch (raw) {
      case 'reviewed':  return 'In Progress';
      case 'resolved':  return 'Resolved';
      case 'rejected':  return 'Resolved';
      default:          return 'Pending';
    }
  }

  static String _mapStatusTitle(String raw) {
    switch (raw) {
      case 'reviewed':  return 'Under Review';
      case 'resolved':  return 'Issue Resolved';
      case 'rejected':  return 'Complaint Rejected';
      default:          return 'Pending Review';
    }
  }

  static String _mapStatusDesc(String raw) {
    switch (raw) {
      case 'reviewed':  return 'A field team has been dispatched to resolve the issue.';
      case 'resolved':  return 'The issue has been successfully resolved. Thank you!';
      case 'rejected':  return 'This complaint was reviewed and rejected by the authority.';
      default:          return 'Our team is currently reviewing your report. You will be notified of updates.';
    }
  }

  static String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return '';
    }
  }
}

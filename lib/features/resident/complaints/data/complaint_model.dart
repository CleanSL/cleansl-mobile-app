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
}

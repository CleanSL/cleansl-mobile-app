import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive.dart';
import '../../../../../../core/utils/classifier_service.dart';
import '../widgets/evidence_picker.dart'; // New Import
import 'complaint_success_page.dart';

class FileComplaintPage extends StatefulWidget {
  const FileComplaintPage({super.key});

  @override
  State<FileComplaintPage> createState() => _FileComplaintPageState();
}

class _FileComplaintPageState extends State<FileComplaintPage> {
  final ImagePicker _picker = ImagePicker();
  File? _evidenceImage;
  String? _selectedCategory;
  final TextEditingController _descriptionController = TextEditingController();
  final ClassifierService _classifier = ClassifierService();
  bool _isMLProcessing = false;

  final List<String> _issueCategories = ['Missed Pickup', 'Overflowing Bin', 'Illegal Dumping', 'Other'];

  @override
  void initState() {
    super.initState();
    _classifier.initialize();
  }

  Future<void> _handleImageAction() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera, maxWidth: 1024, maxHeight: 1024, imageQuality: 85);

    if (image != null) {
      final File pickedFile = File(image.path);
      setState(() {
        _evidenceImage = pickedFile;
        _isMLProcessing = true;
      });

      final String? mlSuggestedCategory = await _classifier.classifyImage(pickedFile);

      setState(() {
        _isMLProcessing = false;
        if (mlSuggestedCategory != null && _issueCategories.contains(mlSuggestedCategory)) {
          _selectedCategory = mlSuggestedCategory;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("AI suggests: $mlSuggestedCategory")));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        title: Text("Report Issue", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.textColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, AppTheme.space24), vertical: Responsive.h(context, AppTheme.space16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("What's the problem?", style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, color: AppTheme.secondaryColor2)),
            SizedBox(height: Responsive.h(context, 8)),
            Text("Help us keep Colombo clean by reporting missed pickups or illegal dumping.", style: TextStyle(color: AppTheme.textColor.withValues(alpha: 0.7), height: 1.5)),
            SizedBox(height: Responsive.h(context, 32)),

            Text("Issue Category", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: AppTheme.secondaryColor1)),
            SizedBox(height: Responsive.h(context, 8)),
            _buildDropdown(),
            SizedBox(height: Responsive.h(context, 24)),

            Text("Description", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: AppTheme.secondaryColor1)),
            SizedBox(height: Responsive.h(context, 8)),
            _buildDescriptionField(),
            SizedBox(height: Responsive.h(context, 24)),

            Text("Evidence", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: AppTheme.secondaryColor1)),
            SizedBox(height: Responsive.h(context, 8)),
            
            // Using extracted Widget
            EvidencePicker(
              image: _evidenceImage, 
              onTap: _handleImageAction, 
              isProcessing: _isMLProcessing
            ),
            
            SizedBox(height: Responsive.h(context, 24)),
            _buildLocationBox(),
            SizedBox(height: Responsive.h(context, 40)),
            _buildSubmitButton(),
            SizedBox(height: Responsive.h(context, 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Responsive.r(context, 8))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          hint: Text("Select a category", style: TextStyle(color: AppTheme.secondaryColor1.withValues(alpha: 0.5))),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.secondaryColor1),
          items: _issueCategories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (v) => setState(() => _selectedCategory = v),
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionController,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: "Briefly describe the waste issue...",
        hintStyle: TextStyle(color: AppTheme.secondaryColor1.withValues(alpha: 0.5)),
      ),
    );
  }

  Widget _buildLocationBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Location", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: AppTheme.secondaryColor1)),
        SizedBox(height: Responsive.h(context, 8)),
        Container(
          padding: EdgeInsets.all(Responsive.w(context, AppTheme.space16)),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Responsive.r(context, 16))),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(Responsive.w(context, 12)),
                decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.location_searching_rounded, color: Colors.blue, size: 24),
              ),
              SizedBox(width: Responsive.w(context, 16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("CURRENT LOCATION", style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                    SizedBox(height: Responsive.h(context, 4)),
                    Text("No. 45, Lotus Road, Colombo 01", style: TextStyle(color: AppTheme.textColor.withValues(alpha: 0.8), fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ComplaintSuccessPage(referenceId: "CMC-89201")));
        },
        icon: const Icon(Icons.send_rounded, size: 18),
        label: Text("Submit Report", style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: Responsive.h(context, 18)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.r(context, 24))),
          elevation: 2,
        ),
      ),
    );
  }
}
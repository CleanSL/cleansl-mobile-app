import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive.dart';
import '../../data/ml_service.dart'; // Import Nafhath'S ML Service
import '../widgets/evidence_picker.dart';
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

  // 1. Initialize Nafhath's Real ML Service
  final MLService _mlService = MLService();
  bool _isMLProcessing = false;

  // Added 'Waste Sorting Issue' to match the ML model's purpose!
  final List<String> _issueCategories = ['Waste Sorting Issue', 'Missed Pickup', 'Overflowing Bin', 'Illegal Dumping', 'Other'];

  @override
  void initState() {
    super.initState();
    // 2. Load the .tflite brain into memory when the page opens
    _mlService.loadModel();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleImageAction() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera, maxWidth: 1024, maxHeight: 1024, imageQuality: 85);

    if (image != null) {
      setState(() {
        _evidenceImage = File(image.path);
      });
    }
  }

  // --- 3. THE 85% RULE SUBMISSION LOGIC ---
  // --- 3. THE SMART SUBMISSION LOGIC ---
  Future<void> _submitComplaintWithML() async {
    // Validation
    if (_evidenceImage == null || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a category and add evidence.")));
      return;
    }

    setState(() => _isMLProcessing = true);

    try {
      // BRANCH 1: ONLY Run ML if it is a Waste Sorting Issue!
      if (_selectedCategory == 'Waste Sorting Issue') {
        final mlResult = await _mlService.predict(_evidenceImage!);
        String detectedMaterial = mlResult['label']; // e.g., "plastic"
        double confidence = mlResult['confidence']; // e.g., 0.88 (88%)

        debugPrint("ML Detected: $detectedMaterial with ${(confidence * 100).toStringAsFixed(1)}% confidence");

        // Apply the 85% Rule
        if (confidence >= 0.85) {
          debugPrint("ROUTING TO RESIDENT LOG: Auto-verified $detectedMaterial issue.");
          // TODO for Husni: Insert directly into user's resolved log
        } else {
          debugPrint("ROUTING TO CMC ADMIN: Confidence too low. Needs human verification.");
          // TODO for Husni: Insert into CMC manual review queue
        }
      }
      // 🚛 BRANCH 2: Standard Complaints (Missed Pickups, Overflowing Bins)
      else {
        debugPrint("STANDARD REPORT: Bypassing AI for '$_selectedCategory'.");
        // TODO for Husni: Insert standard complaint straight to the database
      }

      // Success! Stop processing and go to the Success Page
      if (!mounted) return;
      setState(() => _isMLProcessing = false);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ComplaintSuccessPage(referenceId: "CMC-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}")));
    } catch (e) {
      if (!mounted) return;
      setState(() => _isMLProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error processing request: $e")));
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
            Text(
              "What's the problem?",
              style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, color: AppTheme.secondaryColor2),
            ),
            SizedBox(height: Responsive.h(context, 8)),
            Text("Help us keep Colombo clean by reporting missed pickups or illegal dumping.", style: TextStyle(color: AppTheme.textColor.withValues(alpha: 0.7), height: 1.5)),
            SizedBox(height: Responsive.h(context, 32)),

            Text(
              "Issue Category",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: AppTheme.secondaryColor1),
            ),
            SizedBox(height: Responsive.h(context, 8)),
            _buildDropdown(),
            SizedBox(height: Responsive.h(context, 24)),

            Text(
              "Description",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: AppTheme.secondaryColor1),
            ),
            SizedBox(height: Responsive.h(context, 8)),
            _buildDescriptionField(),
            SizedBox(height: Responsive.h(context, 24)),

            Text(
              "Evidence",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: AppTheme.secondaryColor1),
            ),
            SizedBox(height: Responsive.h(context, 8)),

            // Using extracted Widget (Now spins when processing ML!)
            EvidencePicker(image: _evidenceImage, onTap: _handleImageAction, isProcessing: _isMLProcessing),

            SizedBox(height: Responsive.h(context, 24)),
            _buildLocationBox(),
            SizedBox(height: Responsive.h(context, 40)),

            // 4. Update the Button to call the ML function!
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
        Text(
          "Location",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: AppTheme.secondaryColor1),
        ),
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
                    const Text(
                      "CURRENT LOCATION",
                      style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                    ),
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
        // CALL THE NEW ML FUNCTION HERE
        onPressed: _isMLProcessing ? null : _submitComplaintWithML,
        icon: _isMLProcessing ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.send_rounded, size: 18),
        label: Text(
          _isMLProcessing ? "Verifying via AI..." : "Submit Report",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
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
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive.dart';
import '../../../../../../core/utils/classifier_service.dart'; // Import our conceptual service
import 'complaint_success_page.dart'; // Import the success page to navigate to after submission

class FileComplaintPage extends StatefulWidget {
  const FileComplaintPage({super.key});

  @override
  State<FileComplaintPage> createState() => _FileComplaintPageState();
}

class _FileComplaintPageState extends State<FileComplaintPage> {
  // --- CORE STATE ---
  final ImagePicker _picker = ImagePicker();
  File? _evidenceImage;
  String? _selectedCategory;
  final TextEditingController _descriptionController = TextEditingController();

  // Instantiate our classifier service (conceptual for now)
  final ClassifierService _classifier = ClassifierService();
  bool _isMLProcessing = false;

  // Static list for the dropdown (synced with ML conceptual labels for now)
  final List<String> _issueCategories = ['Missed Pickup', 'Overflowing Bin', 'Illegal Dumping', 'Other'];

  @override
  void initState() {
    super.initState();
    // Conceptually initialize the model
    _classifier.initialize();
  }

  // --- IMAGE PICKING & ML LOGIC ---

  Future<void> _handleImageAction() async {
    // 1. User selects a photo source (Conceptual logic: we'll use camera for ML testing)
    final XFile? image = await _picker.pickImage(source: ImageSource.camera, maxWidth: 1024, maxHeight: 1024, imageQuality: 85);

    if (image != null) {
      final File pickedFile = File(image.path);
      // 2. Immediately update UI with the picked photo
      setState(() {
        _evidenceImage = pickedFile;
        _isMLProcessing = true; // Show loading indicator
      });

      // 3. Pass the photo path to Nafhath's conceptual classifier logic
      print("Sending photo to ML service conceptual logic...");
      final String? mlSuggestedCategory = await _classifier.classifyImage(pickedFile);

      // 4. Update the form based on the model's suggestion
      setState(() {
        _isMLProcessing = false;
        if (mlSuggestedCategory != null && _issueCategories.contains(mlSuggestedCategory)) {
          _selectedCategory = mlSuggestedCategory;
          print("ML model conceptually suggests: $mlSuggestedCategory");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("AI suggests: $mlSuggestedCategory")));
        } else {
          print("ML model conceptual prediction failed or didn't match.");
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
            // --- HEADER ---
            Text(
              "What's the problem?",
              style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, color: AppTheme.secondaryColor2),
            ),
            SizedBox(height: Responsive.h(context, 8)),
            Text("Help us keep Colombo clean by reporting missed pickups or illegal dumping.", style: TextStyle(color: AppTheme.textColor.withValues(alpha: 0.7), height: 1.5)),
            SizedBox(height: Responsive.h(context, 32)),

            // --- CATEGORY DROPDOWN ---
            Text(
              "Issue Category",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: AppTheme.secondaryColor1),
            ),
            SizedBox(height: Responsive.h(context, 8)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Responsive.r(context, 8))),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  hint: Text("Select a category", style: TextStyle(color: AppTheme.secondaryColor1.withValues(alpha: 0.5))),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.secondaryColor1),
                  items: _issueCategories.map((String category) {
                    return DropdownMenuItem<String>(value: category, child: Text(category));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: Responsive.h(context, 24)),

            // --- DESCRIPTION ---
            Text(
              "Description",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: AppTheme.secondaryColor1),
            ),
            SizedBox(height: Responsive.h(context, 8)),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Briefly describe the waste issue (e.g., location details, amount of waste)...",
                hintStyle: TextStyle(color: AppTheme.secondaryColor1.withValues(alpha: 0.5)),
              ),
            ),
            SizedBox(height: Responsive.h(context, 24)),

            // --- EVIDENCE (IMAGE PICKER & ML) ---
            Text(
              "Evidence",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: AppTheme.secondaryColor1),
            ),
            SizedBox(height: Responsive.h(context, 8)),
            _buildEvidencePicker(), // Separate helper for the dotted box
            SizedBox(height: Responsive.h(context, 24)),

            // --- CURRENT LOCATION ---
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
            SizedBox(height: Responsive.h(context, 40)),

            // --- SUBMIT BUTTON ---
            _buildSubmitButton(),
            SizedBox(height: Responsive.h(context, 24)), // Bottom padding
          ],
        ),
      ),
    );
  }

  // --- UI HELPER WIDGETS ---

  // Separate widget for the Evidence dotted box/picked image
  Widget _buildEvidencePicker() {
    return GestureDetector(
      onTap: _handleImageAction, // Call image picking + ML
      child: Container(
        height: Responsive.h(context, 180),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Responsive.r(context, 16)),
          border: Border.all(
            color: AppTheme.accentColor.withValues(alpha: 0.3),
            style: BorderStyle.solid,
          ), // Dotted border is hard to do in static flutter, this is a placeholder with a solid, faded accent border. For a true dotted look you'd use a CustomPainter or special package.
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Case 1: An image has been picked
            if (_evidenceImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(Responsive.r(context, 16)),
                child: Image.file(_evidenceImage!, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
              ),

            // Case 2: No image, show "Tap to add photo" content
            if (_evidenceImage == null)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppTheme.accentColor.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.add_a_photo_rounded, color: AppTheme.accentColor, size: 32),
                  ),
                  SizedBox(height: Responsive.h(context, 12)),
                  Text(
                    "Tap to add photo",
                    style: TextStyle(color: AppTheme.secondaryColor1.withValues(alpha: 0.7), fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ],
              ),

            // Case 3: Image is processing by ML (Conceptual spinner overlay)
            if (_isMLProcessing)
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(Responsive.r(context, 16))),
                child: const Center(child: CircularProgressIndicator(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: () {
        // 1. (Optional) Validate that a category and image are present
        // if (_selectedCategory == null || _evidenceImage == null) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text("Please select a category and add a photo")),
        //   );
        //   return;
        // }

        // 2. Simulate a brief "Sending" state
        // In the future, Husni's backend logic goes here.

        // 3. Navigate to Success Screen
        // We pass a dummy Reference ID for now
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ComplaintSuccessPage(
              referenceId: "CMC-89201", 
            ),
          ),
        );
      },
      icon: const Icon(Icons.send_rounded, size: 18),
      label: Text(
        "Submit Report",
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Colors.white, 
          fontWeight: FontWeight.bold, 
          fontSize: 16,
        ),
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

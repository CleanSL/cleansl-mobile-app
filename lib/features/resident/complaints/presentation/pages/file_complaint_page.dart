import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../../core/constants/api_constants.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/responsive.dart';
import '../../data/ml_service.dart';
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

  final MLService _mlService = MLService();
  bool _isMLProcessing = false;

  // AI analysis result (shown after photo analysis, before submission)
  String? _mlLabel;
  double? _mlConfidence;
  bool _mlAnalyzed = false;

  final List<String> _issueCategories = [
    'Waste Sorting Issue',
    'Missed Pickup',
    'Overflowing Bin',
    'Illegal Dumping',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _mlService.loadModel();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleImageAction() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() {
        _evidenceImage = File(image.path);
        // Reset ML result when a new photo is taken
        _mlAnalyzed = false;
        _mlLabel = null;
        _mlConfidence = null;
      });
    }
  }

  // ─── STEP 1: Analyse image and show result card ───────────────────────────

  Future<void> _analyzeImage() async {
    if (_evidenceImage == null) return;
    setState(() => _isMLProcessing = true);
    try {
      final result = await _mlService.predict(_evidenceImage!);
      final label      = result['label']      as String;
      final confidence = result['confidence'] as double;
      setState(() {
        _mlLabel      = label;
        _mlConfidence = confidence;
        _mlAnalyzed   = true;
        _isMLProcessing = false;
      });
    } catch (e) {
      setState(() => _isMLProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('AI analysis failed: $e')),
        );
      }
    }
  }

  // ─── STEP 2: Submit complaint ─────────────────────────────────────────────

  Future<void> _submitComplaintWithML() async {
    if (_evidenceImage == null || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category and add evidence.')),
      );
      return;
    }

    setState(() => _isMLProcessing = true);

    try {
      final supabaseClient = Supabase.instance.client;

      // Use stored ML result (already analysed in Step 1)
      final String? materialLabel     = _mlLabel;
      final double? aiConfidence      = _mlConfidence;
      final int    aiSortedPercentage = _mlAnalyzed
          ? ((_mlConfidence ?? 0) * 100).round()
          : 0;

      // Low-confidence warning (only for Waste Sorting Issue)
      if (_selectedCategory == 'Waste Sorting Issue' &&
          _mlAnalyzed &&
          (_mlConfidence ?? 0) < 0.6 &&
          mounted) {
        final proceed = await _showLowConfidenceDialog();
        if (!proceed) {
          setState(() => _isMLProcessing = false);
          return;
        }
      }

      // Compress image before uploading
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        _evidenceImage!.path,
        quality: 70,
        minWidth: 1024,
        minHeight: 1024,
      );
      final imageBytes = compressedBytes ?? await _evidenceImage!.readAsBytes();

      // Upload to Supabase Storage bucket 'complaints'
      final fileName = 'complaint_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await supabaseClient.storage.from('complaints').uploadBinary(
        fileName,
        imageBytes,
        fileOptions: const FileOptions(contentType: 'image/jpeg'),
      );
      final photoUrl = supabaseClient.storage.from('complaints').getPublicUrl(fileName);

      // Get user's address_id (optional — may not exist for new users)
      final userId = supabaseClient.auth.currentUser?.id;
      String? addressId;
      if (userId != null) {
        final addr = await supabaseClient
            .from('addresses')
            .select('id')
            .eq('resident_id', userId)
            .maybeSingle();
        addressId = addr?['id'] as String?;
      }

      // Calculate priority level locally (same logic as backend)
      String priorityLevel;
      if (aiSortedPercentage >= 85) {
        priorityLevel = 'high';
      } else if (aiSortedPercentage >= 60) {
        priorityLevel = 'medium';
      } else {
        priorityLevel = 'low';
      }

      // Write directly to Supabase (cloud — no firewall issues)
      await supabaseClient.from('complaints').insert({
        'resident_id':        userId,
        'address_id':         addressId,
        'photo_url':          photoUrl,
        'ai_sorted_percentage': aiSortedPercentage,
        'material_label':     materialLabel,
        'ai_confidence':      aiConfidence,
        'priority_level':     priorityLevel,
        'complaint_text':     _descriptionController.text.isNotEmpty
                                  ? _descriptionController.text
                                  : null,
        'location_name':      _selectedCategory,   // stores category
        'status':             'pending',
      });

      if (!mounted) return;
      setState(() => _isMLProcessing = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ComplaintSuccessPage(
            referenceId:
                "CMC-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isMLProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to submit: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<bool> _showLowConfidenceDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange.shade600),
                const SizedBox(width: 8),
                const Text("Low AI Confidence"),
              ],
            ),
            content: const Text(
              "The AI couldn't clearly identify the waste type. Your complaint will be sent for manual review by the CMC team.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text("Retake Photo"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text("Submit Anyway", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ) ??
        false;
  }

  // ─── BUILD ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBackground,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        title: Text(
          "Report Issue",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.textColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.w(context, AppTheme.space24),
          vertical: Responsive.h(context, AppTheme.space16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What's the problem?",
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(fontWeight: FontWeight.w900, color: AppTheme.secondaryColor2),
            ),
            SizedBox(height: Responsive.h(context, 8)),
            Text(
              "Help us keep Colombo clean by reporting missed pickups or illegal dumping.",
              style: TextStyle(color: AppTheme.textColor.withValues(alpha: 0.7), height: 1.5),
            ),
            SizedBox(height: Responsive.h(context, 32)),

            Text(
              "Issue Category",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600, color: AppTheme.secondaryColor1),
            ),
            SizedBox(height: Responsive.h(context, 8)),
            _buildDropdown(),
            SizedBox(height: Responsive.h(context, 24)),

            Text(
              "Description",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600, color: AppTheme.secondaryColor1),
            ),
            SizedBox(height: Responsive.h(context, 8)),
            _buildDescriptionField(),
            SizedBox(height: Responsive.h(context, 24)),

            Text(
              "Evidence",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600, color: AppTheme.secondaryColor1),
            ),
            SizedBox(height: Responsive.h(context, 8)),
            EvidencePicker(
              image: _evidenceImage,
              onTap: _handleImageAction,
              isProcessing: _isMLProcessing,
            ),

            // ── AI result card (shown after analysis) ──
            if (_mlAnalyzed && _evidenceImage != null) ...[
              SizedBox(height: Responsive.h(context, 12)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200, width: 1.5),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Detected: ${_mlLabel?.toUpperCase() ?? "UNKNOWN"}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            'Confidence: ${((_mlConfidence ?? 0) * 100).toStringAsFixed(1)}%',
                            style: TextStyle(color: Colors.orange.shade700, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(() {
                        _mlAnalyzed   = false;
                        _mlLabel      = null;
                        _mlConfidence = null;
                      }),
                      child: const Text('Re-Scan'),
                    ),
                  ],
                ),
              ),
            ],

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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.r(context, 8)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          hint: Text(
            "Select a category",
            style: TextStyle(color: AppTheme.secondaryColor1.withValues(alpha: 0.5)),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.secondaryColor1),
          items: _issueCategories
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
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
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.w600, color: AppTheme.secondaryColor1),
        ),
        SizedBox(height: Responsive.h(context, 8)),
        Container(
          padding: EdgeInsets.all(Responsive.w(context, AppTheme.space16)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Responsive.r(context, 16)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(Responsive.w(context, 12)),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_searching_rounded, color: Colors.blue, size: 24),
              ),
              SizedBox(width: Responsive.w(context, 16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "CURRENT LOCATION",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: Responsive.h(context, 4)),
                    Text(
                      "No. 45, Lotus Road, Colombo 01",
                      style: TextStyle(
                        color: AppTheme.textColor.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
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
    // For Waste Sorting Issue: first tap = Analyse, second tap = Submit
    final bool needsAnalysis =
        _selectedCategory == 'Waste Sorting Issue' &&
        _evidenceImage != null &&
        !_mlAnalyzed;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isMLProcessing
            ? null
            : needsAnalysis
                ? _analyzeImage
                : _submitComplaintWithML,
        icon: _isMLProcessing
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Icon(needsAnalysis ? Icons.analytics_rounded : Icons.send_rounded, size: 18),
        label: Text(
          _isMLProcessing
              ? (needsAnalysis ? 'Analysing...' : 'Submitting...')
              : (needsAnalysis ? 'Analyse Image' : 'Submit Report'),
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: Responsive.h(context, 18)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Responsive.r(context, 24)),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
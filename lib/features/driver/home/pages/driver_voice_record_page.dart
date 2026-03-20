import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/cleansl_button.dart';

class VoiceRecordPage extends StatefulWidget {
  final String laneName;
  final int houseNumber;

  const VoiceRecordPage({super.key, required this.laneName, required this.houseNumber});

  @override
  State<VoiceRecordPage> createState() => _VoiceRecordPageState();
}

class _VoiceRecordPageState extends State<VoiceRecordPage> {
  bool _isRecording = false;
  bool _isReadyToSend = false;
  int _seconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleRecording() {
    if (_isRecording) {
      // Stop recording
      _timer?.cancel();
      setState(() {
        _isRecording = false;
      });
      _showConfirmationDialog();
    } else {
      // Start recording
      setState(() {
        _isRecording = true;
        _seconds = 0;
        _isReadyToSend = false;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() => _seconds++);
      });
    }
  }

  String get _formattedTime {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (_seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$remainingSeconds";
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Force them to choose an option
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.primaryBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Responsive.r(context, 20))),
          title: Text("Review Recording", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.secondaryColor1)),
          content: Text("You recorded $_formattedTime of audio. Do you want to submit this issue report?", style: Theme.of(context).textTheme.bodyMedium),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                setState(() {
                  _seconds = 0; // Reset timer
                  _isReadyToSend = false; // <-- 3a. ADD THIS: Keep button disabled
                });
              },
              child: const Text(
                "Discard",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                setState(() {
                  _isReadyToSend = true; // <-- 3b. ADD THIS: Enable the Send Report button!
                });
              },
              child: const Text(
                "Confirm",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Seamless flat header
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.secondaryColor1),
          // Returning FALSE means they hit back without reporting an issue
          onPressed: () => Navigator.pop(context, false),
        ),
        title: Text(
          "${widget.laneName} — House ${widget.houseNumber}",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.secondaryColor1, fontSize: Responsive.sp(context, 22)),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Responsive.w(context, 24)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // 1. The Massive Mic Button
              GestureDetector(
                onTap: _toggleRecording,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: Responsive.w(context, 200),
                  height: Responsive.w(context, 200),
                  decoration: BoxDecoration(
                    color: _isRecording ? Colors.red.shade500 : AppTheme.secondaryColor1,
                    shape: BoxShape.circle,
                    boxShadow: [if (_isRecording) BoxShadow(color: Colors.red.withValues(alpha: 0.4), blurRadius: 30, spreadRadius: 10)],
                  ),
                  child: Icon(_isRecording ? Icons.stop_rounded : Icons.mic_rounded, color: Colors.white, size: Responsive.w(context, 80)),
                ),
              ),

              SizedBox(height: Responsive.h(context, 48)),

              // 2. Helper Text & Timer
              Text(
                _isRecording ? "Recording... tap to stop" : "Tap and speak to record the issue",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textColor.withValues(alpha: 0.7)),
              ),
              SizedBox(height: Responsive.h(context, 16)),
              Text(
                _formattedTime,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(color: AppTheme.textColor, fontSize: Responsive.sp(context, 48)),
              ),

              const Spacer(),

              // 3. Footer Data (Task & Ward)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "CURRENT TASK",
                        style: TextStyle(color: AppTheme.textColor.withValues(alpha: 0.5), fontSize: Responsive.sp(context, 12), fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: Responsive.h(context, 4)),
                      Text("Waste Collection", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.secondaryColor1)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "WARD",
                        style: TextStyle(color: AppTheme.textColor.withValues(alpha: 0.5), fontSize: Responsive.sp(context, 12), fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: Responsive.h(context, 4)),
                      Text("District 5", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.textColor)),
                    ],
                  ),
                ],
              ),

              SizedBox(height: Responsive.h(context, 32)),

              // 4. Send Report Button
              CleanSlButton(
                text: "Send Report",
                variant: ButtonVariant.primary,
                onPressed: _isReadyToSend ? () {
                  Navigator.pop(context, true);
                } : null, 
              ),
              SizedBox(height: Responsive.h(context, 24)),
            ],
          ),
        ),
      ),
    );
  }
}

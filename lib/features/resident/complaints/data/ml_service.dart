import 'dart:io';
import 'package:flutter/foundation.dart';

class MLService {
  Future<void> loadModel() async {
    debugPrint("ML SERVICE DISABLED FOR WEB UI DEVELOPMENT.");
  }

  Future<Map<String, dynamic>> predict(File imageFile) async {
    debugPrint("Simulating AI processing for 2 seconds...");
    // Simulates a loading spinner for 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    
    // Forces a fake detection so the app doesn't crash
    return {
      "label": "plastic", 
      "confidence": 0.92, 
      "allScores": [0.0, 0.0, 0.0, 0.0, 0.0, 0.92],
    };
  }
}
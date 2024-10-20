import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get_storage/get_storage.dart'; // Import GetStorage for local storage

class SplashScreenController {
  Color backgroundColor = const Color(0xFFFEFFFE); // Custom white color
  Color textColor =
      const Color(0xFFFEB0D9); // Custom pink color for text on white background
  String logoAsset =
      'assets/images/pink_logo.png'; // Initial logo for white background

  final GetStorage storage = GetStorage(); // Initialize GetStorage

  void startSplashSequence(VoidCallback onTimerComplete) {
    Timer(const Duration(seconds: 2), onTimerComplete);
  }

  void changeSplashAppearance(VoidCallback onTimerComplete) {
    backgroundColor = const Color(0xFFFEB0D9); // Change to custom pink color
    textColor = Colors.white; // Text color for pink background
    logoAsset = 'assets/images/white_logo.png'; // Logo for pink background
    Timer(
        const Duration(seconds: 2), onTimerComplete); // Delay before navigation
  }

  void handleUserNavigation(BuildContext context) {
    // Check if the token is stored in local storage
    String? token = storage.read('auth_token'); // Read the token from storage
    print('my token here  is $token'); // Print the token for debugging purposes

    if (token == null) {
      // Navigate to onboarding if the token is null
      Navigator.pushReplacementNamed(context, '/onboarding');
    } else {
      print('my token here  is $token');
      print('my email here  is ${storage.read('email')}');

      // Navigate to ClientDashboard if the token exists
      Navigator.pushReplacementNamed(context, '/clientDashboard');
    }
  }
}

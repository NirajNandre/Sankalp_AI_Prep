import 'package:flutter/material.dart';

// Use a class with static members for easy access without instantiation
class AppColors {
  // Static final properties for constant colors
  static const Color primaryColor = Color(0xFF4CAF50); // Example Green
  static const Color blueColor = Color(0xFFCFEAFC);
  static const Color greenColor = Color(0xFFCDF6DB);
  static const Color yellowColor = Color(0xFFFFF6DA);
  static const Color purpleColor = Color(0xFFD1D6FD);// Example Orange
  static const Color accentColor =Color.fromRGBO(52, 228, 255, 0.612); // Example Blue
  static const Color backgroundColor = Color(0xFFF5F5F5); // Example Light Gray
}

// A separate class to handle dynamic screen dimensions
class ScreenSize {
  // Static method to get the screen width
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Static method to get the screen height
  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}

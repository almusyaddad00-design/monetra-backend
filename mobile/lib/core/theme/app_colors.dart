import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF0D47A1); // Deep Blue
  static const Color primaryLight = Color(0xFF5472D3);
  static const Color primaryDark = Color(0xFF002171);

  // Secondary / Accent Colors
  static const Color secondary = Color(0xFF00BFA5); // Teal Accent
  static const Color secondaryLight = Color(0xFF5DF2D6);
  static const Color secondaryDark = Color(0xFF008E76);

  // Background Colors
  static const Color background = Color(0xFFF5F7FA);
  static const Color cardBackground = Colors.white;

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA000);

  // Text Colors
  static const Color textPrimary = Color(0xFF263238);
  static const Color textSecondary = Color(0xFF78909C);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0D2140), // Very Dark Blue matching logo background
      Color(0xFF051025), // Even darker for depth
    ],
  );
}

import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9C94FF);
  static const Color primaryDark = Color(0xFF3D35CC);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color accent = Color(0xFFFF6B6B);

  // AI bubble colors
  static const Color aiBubble = Color(0xFF1E1E2E);
  static const Color aiBubbleLight = Color(0xFFF0EEFF);
  static const Color userBubble = Color(0xFF6C63FF);

  // Semantic
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);

  // Neutrals (light)
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8F9FA);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE0E0E0);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6E6E8A);
  static const Color textHint = Color(0xFFB0B0C8);

  // Dark surfaces
  static const Color darkBackground = Color(0xFF0F0F1A);
  static const Color darkSurface = Color(0xFF1A1A2E);
  static const Color darkCard = Color(0xFF252540);
  static const Color darkBorder = Color(0xFF3A3A5C);
  static const Color darkTextPrimary = Color(0xFFE8E8FF);
  static const Color darkTextSecondary = Color(0xFF9898C0);

  // Input
  static const Color inputFill = Color(0xFFF5F5FF);
  static const Color darkInputFill = Color(0xFF1E1E35);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: <Color>[primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient darkGradient = LinearGradient(
    colors: <Color>[Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

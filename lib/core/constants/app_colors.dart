import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF8B5CF6);
  static const Color primaryDark = Color(0xFF7C3AED);
  static const Color secondary = Color(0xFFA78BFA);

  static const Color lightBackground = Color(0xFFF8F7FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE9E7F1);
  static const Color lightTextPrimary = Color(0xFF171717);
  static const Color lightTextSecondary = Color(0xFF6B7280);

  static const Color darkBackground = Color(0xFF09090B);
  static const Color darkSurface = Color(0xFF111114);
  static const Color darkCard = Color(0xFF15151B);
  static const Color darkBorder = Color(0xFF27272A);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFA1A1AA);

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  static const Color white = Colors.white;
  static const Color black = Colors.black;

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF7C3AED),
      Color(0xFFA855F7),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkBackgroundGlow = LinearGradient(
    colors: [
      Color(0xFF140B2E),
      Color(0xFF09090B),
      Color(0xFF1A0B2E),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
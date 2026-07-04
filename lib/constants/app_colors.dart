import 'package:flutter/material.dart';

// Centralized color palette so every screen/widget pulls from one source.
// Matches the spec: Primary Green, Secondary Orange, Accent Light Green.
class AppColors {
  AppColors._();

  // Brand colors
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFF81C784);
  static const Color secondaryOrange = Color(0xFFFF7043);

  // Light theme
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF7F8F5);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1B1B1B);
  static const Color lightTextSecondary = Color(0xFF6E6E6E);

  // Dark theme
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF262626);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  // Semantic / status colors
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFFA000);
  static const Color error = Color(0xFFE53935);
  static const Color ratingGold = Color(0xFFFFC107);

  // Difficulty badge colors
  static const Color easyBadge = Color(0xFF66BB6A);
  static const Color mediumBadge = Color(0xFFFFA726);
  static const Color hardBadge = Color(0xFFEF5350);
}
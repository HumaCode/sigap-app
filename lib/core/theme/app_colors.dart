import 'package:flutter/material.dart';

/// Clean Telemetry Light Design System Colors
class AppColors {
  AppColors._();

  // Primary & Interactive Brand (Teal & Mint)
  static const Color primary = Color(0xFF00685F);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF008378);
  static const Color onPrimaryContainer = Color(0xFFF4FFFC);
  static const Color accentTeal = Color(0xFF14B8A6);
  static const Color accentTealDark = Color(0xFF0F766E);
  static const Color mintBadgeTint = Color(0xFFCCFBF1);

  // Canvas & Surfaces
  static const Color canvasBg = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFAF8FF);
  static const Color surfaceSubtle = Color(0xFFF8FAFC);
  static const Color surfaceBorder = Color(0xFFE2E8F0);
  static const Color surfaceContainerLow = Color(0xFFF2F3FF);
  static const Color surfaceContainer = Color(0xFFEAEDFF);
  static const Color surfaceContainerHigh = Color(0xFFE2E7FF);
  static const Color outline = Color(0xFF6D7A77);
  static const Color outlineVariant = Color(0xFFBCC9C6);

  // Semantic Status Architecture
  // Operational (Up)
  static const Color statusOperational = Color(0xFF10B981);
  static const Color statusOperationalBg = Color(0xFFECFDF5);

  // Outage / Critical P1 (Down)
  static const Color statusOutage = Color(0xFFEF4444);
  static const Color statusOutageBg = Color(0xFFFEF2F2);
  static const Color secondary = Color(0xFFB61722);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // Degraded / Warning
  static const Color statusDegraded = Color(0xFFF59E0B);
  static const Color statusDegradedBg = Color(0xFFFFFBEB);
  static const Color tertiary = Color(0xFF825100);

  // Text Hierarchy (Slate Tones)
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textCaption = Color(0xFF94A3B8);
}

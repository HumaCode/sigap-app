import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography tokens based on Clean Telemetry Light specs:
/// - Plus Jakarta Sans for Headlines & Titles
/// - Inter for Body text & narrative
/// - JetBrains Mono for Metrics, HTTP status, and code
class AppTypography {
  AppTypography._();

  // Plus Jakarta Sans - Headlines & Titles
  static TextStyle headlineXl = GoogleFonts.plusJakartaSans(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    height: 34 / 26,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineLg = GoogleFonts.plusJakartaSans(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 28 / 20,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineMd = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 26 / 18,
    color: AppColors.textPrimary,
  );

  static TextStyle titleSm = GoogleFonts.plusJakartaSans(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 22 / 15,
    color: AppColors.textPrimary,
  );

  // Inter - Body text
  static TextStyle bodyLg = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 22 / 15,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMd = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.textSecondary,
  );

  static TextStyle bodySm = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 18 / 12,
    color: AppColors.textSecondary,
  );

  // JetBrains Mono - Precision Telemetry & Code
  static TextStyle codeLg = GoogleFonts.jetBrainsMono(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    color: AppColors.textPrimary,
  );

  static TextStyle codeMd = GoogleFonts.jetBrainsMono(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    color: AppColors.textPrimary,
  );

  static TextStyle codeSm = GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 14 / 11,
    color: AppColors.textSecondary,
  );

  static TextStyle labelXs = GoogleFonts.jetBrainsMono(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    height: 12 / 10,
    color: AppColors.textCaption,
  );
}

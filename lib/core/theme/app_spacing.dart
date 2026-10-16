import 'package:flutter/material.dart';

/// Spacing and Radius tokens according to Clean Telemetry Light specs
class AppSpacing {
  AppSpacing._();

  // Spacing
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 12.0;
  static const double spaceLg = 16.0;
  static const double spaceXl = 24.0;

  static const double marginMobile = 16.0;
  static const double gutterMobile = 12.0;

  // Corner Radius
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusFull = 9999.0;

  static BorderRadius roundedSm = BorderRadius.circular(radiusSm);
  static BorderRadius roundedMd = BorderRadius.circular(radiusMd);
  static BorderRadius roundedLg = BorderRadius.circular(radiusLg);
  static BorderRadius roundedXl = BorderRadius.circular(radiusXl);
  static BorderRadius roundedFull = BorderRadius.circular(radiusFull);

  // Elevation Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.02),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.05),
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.03),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
}

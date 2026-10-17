import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Ambient telemetry background with soft glowing radial blobs and subtle grid
class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Base canvas
        Container(
          color: const Color(0xFFF9FBFC),
        ),

        // Top-Right Ambient Glow (Mint / Teal)
        Positioned(
          top: -size.width * 0.25,
          right: -size.width * 0.2,
          child: Container(
            width: size.width * 0.85,
            height: size.width * 0.85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.mintBadgeTint.withValues(alpha: 0.65),
                  AppColors.accentTeal.withValues(alpha: 0.20),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),

        // Center-Left Ambient Glow (Soft Emerald)
        Positioned(
          top: size.height * 0.35,
          left: -size.width * 0.3,
          child: Container(
            width: size.width * 0.7,
            height: size.width * 0.7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFE0F2FE).withValues(alpha: 0.5),
                  AppColors.mintBadgeTint.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),
        ),

        // Bottom-Right Ambient Glow
        Positioned(
          bottom: -size.width * 0.2,
          right: -size.width * 0.15,
          child: Container(
            width: size.width * 0.6,
            height: size.width * 0.6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.mintBadgeTint.withValues(alpha: 0.4),
                  Colors.transparent,
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
        ),

        // Subtle Telemetry Grid Overlay
        Positioned.fill(
          child: CustomPaint(
            painter: _TelemetryGridPainter(),
          ),
        ),

        // Foreground content
        Positioned.fill(child: child),
      ],
    );
  }
}

/// Custom painter for subtle telemetry grid dots
class _TelemetryGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = const Color(0xFF0F172A).withValues(alpha: 0.035)
      ..style = PaintingStyle.fill;

    const spacing = 24.0;
    for (double x = 12; x < size.width; x += spacing) {
      for (double y = 12; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.0, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

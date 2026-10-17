import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Interactive pulsating radar waves with multi-ring animation
class SplashRadarPulse extends StatelessWidget {
  final Animation<double> animation;
  final double size;
  final Offset? tapOffset;

  const SplashRadarPulse({
    super.key,
    required this.animation,
    this.size = 280,
    this.tapOffset,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(size, size),
          painter: _RadarPulsePainter(
            progress: animation.value,
          ),
        );
      },
    );
  }
}

class _RadarPulsePainter extends CustomPainter {
  final double progress;

  _RadarPulsePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // Draw 3 wave rings offset by phase
    for (int i = 0; i < 3; i++) {
      final ringProgress = (progress + (i * 0.33)) % 1.0;
      final radius = 40.0 + (maxRadius - 40.0) * ringProgress;
      final opacity = (1.0 - ringProgress).clamp(0.0, 1.0) * 0.45;

      // Outer wave stroke
      final strokePaint = Paint()
        ..color = AppColors.accentTeal.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      // Soft wave fill
      final fillPaint = Paint()
        ..color = AppColors.mintBadgeTint.withValues(alpha: opacity * 0.35)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, radius, fillPaint);
      canvas.drawCircle(center, radius, strokePaint);

      // Decorative radar blip dots on the perimeter
      if (ringProgress > 0.3 && ringProgress < 0.9) {
        final angle = (progress * 2 * math.pi) + (i * 1.8);
        final blipX = center.dx + radius * math.cos(angle);
        final blipY = center.dy + radius * math.sin(angle);

        final dotPaint = Paint()
          ..color = AppColors.primary.withValues(alpha: opacity * 1.5)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(blipX, blipY), 3.0, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPulsePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

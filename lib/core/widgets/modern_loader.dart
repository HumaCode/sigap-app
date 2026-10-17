import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Reusable Modern, Interactive, & Animated Telemetry Loader
/// Features dual orbital spin, breathing pulse core, rotating status phrases,
/// and interactive tap speed-boost with haptic feedback.
class ModernLoader extends StatefulWidget {
  final String? message;
  final String? subMessage;
  final List<String>? cyclingMessages;
  final Color? accentColor;
  final double size;
  final bool isCompact;

  const ModernLoader({
    super.key,
    this.message,
    this.subMessage,
    this.cyclingMessages,
    this.accentColor,
    this.size = 72.0,
    this.isCompact = false,
  });

  /// Compact variation for cards, bottom-sheets, or dialogs
  const ModernLoader.compact({
    super.key,
    this.message,
    this.accentColor,
    this.size = 40.0,
  })  : subMessage = null,
        cyclingMessages = null,
        isCompact = true;

  @override
  State<ModernLoader> createState() => _ModernLoaderState();
}

class _ModernLoaderState extends State<ModernLoader> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _dotController;

  Timer? _cycleTimer;
  int _currentMessageIndex = 0;
  bool _isBoosted = false;

  late final List<String> _defaultMessages = [
    'Menghubungkan ke node telemetri...',
    'Mengambil metrik server & endpoint...',
    'Sinkronisasi status real-time...',
    'Memvalidasi handshake SSL/TLS...',
  ];

  @override
  void initState() {
    super.initState();

    // Primary orbital rotation
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    // Breathing pulse for center core
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    // Three bouncing dots
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    // Cycling messages
    if (!widget.isCompact && widget.message == null) {
      _cycleTimer = Timer.periodic(const Duration(milliseconds: 2400), (timer) {
        if (!mounted) return;
        final list = widget.cyclingMessages ?? _defaultMessages;
        setState(() {
          _currentMessageIndex = (_currentMessageIndex + 1) % list.length;
        });
      });
    }
  }

  @override
  void dispose() {
    _cycleTimer?.cancel();
    _rotationController.dispose();
    _pulseController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  void _triggerBoost() {
    HapticFeedback.lightImpact();
    setState(() => _isBoosted = true);
    _rotationController.duration = const Duration(milliseconds: 800);
    _rotationController.repeat();

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() => _isBoosted = false);
        _rotationController.duration = const Duration(milliseconds: 2200);
        _rotationController.repeat();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.accentColor ?? AppColors.primary;
    final secondaryColor = AppColors.accentTeal;

    if (widget.isCompact) {
      return Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: AnimatedBuilder(
                animation: _rotationController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _OrbitalSpinnerPainter(
                      progress: _rotationController.value,
                      primaryColor: primaryColor,
                      secondaryColor: secondaryColor,
                      strokeWidth: 2.8,
                    ),
                  );
                },
              ),
            ),
            if (widget.message != null) ...[
              const SizedBox(width: 12),
              Text(
                widget.message!,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      );
    }

    final messageList = widget.cyclingMessages ?? _defaultMessages;
    final activeMessage = widget.message ?? messageList[_currentMessageIndex];

    return Center(
      child: GestureDetector(
        onTap: _triggerBoost,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: _isBoosted
                  ? primaryColor.withValues(alpha: 0.5)
                  : const Color(0xFFE2E8F0),
              width: _isBoosted ? 1.6 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: primaryColor.withValues(alpha: _isBoosted ? 0.12 : 0.05),
                blurRadius: _isBoosted ? 24 : 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Orbital Multi-Ring Graphic
              SizedBox(
                width: widget.size + 24,
                height: widget.size + 24,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Sonar Pulse Glow
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        final pulseVal = _pulseController.value;
                        return Container(
                          width: (widget.size + 16) + (pulseVal * 12),
                          height: (widget.size + 16) + (pulseVal * 12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor.withValues(
                              alpha: (0.12 - (pulseVal * 0.08)).clamp(0.01, 0.12),
                            ),
                          ),
                        );
                      },
                    ),

                    // Rotating Dual Orbit Rings
                    AnimatedBuilder(
                      animation: _rotationController,
                      builder: (context, child) {
                        return CustomPaint(
                          size: Size(widget.size + 12, widget.size + 12),
                          painter: _OrbitalSpinnerPainter(
                            progress: _rotationController.value,
                            primaryColor: primaryColor,
                            secondaryColor: secondaryColor,
                            strokeWidth: 3.2,
                          ),
                        );
                      },
                    ),

                    // Pulsing Core Shield
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        final scale = 0.92 + (_pulseController.value * 0.12);
                        return Transform.scale(
                          scale: _isBoosted ? scale * 1.15 : scale,
                          child: Container(
                            width: widget.size * 0.52,
                            height: widget.size * 0.52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  primaryColor,
                                  secondaryColor,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withValues(alpha: 0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.sensors_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Animated Transition Text
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.25),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  activeMessage,
                  key: ValueKey<String>(activeMessage),
                  textAlign: TextAlign.center,
                  style: AppTypography.titleSm.copyWith(
                    color: const Color(0xFF0F172A),
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                    letterSpacing: 0.2,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Sub-caption & interactive hint
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.subMessage ?? (_isBoosted ? 'Turboboost aktif!' : 'Menghubungi gateway SIGAP'),
                    style: AppTypography.bodySm.copyWith(
                      fontSize: 12,
                      color: _isBoosted ? primaryColor : const Color(0xFF64748B),
                      fontWeight: _isBoosted ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  _BouncingDots(
                    controller: _dotController,
                    color: _isBoosted ? primaryColor : const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter to draw dual nested orbital neon arcs with satellite dots
class _OrbitalSpinnerPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;
  final double strokeWidth;

  _OrbitalSpinnerPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = (size.width - strokeWidth) / 2;
    final innerRadius = outerRadius * 0.76;

    // Track circle (outer subtle)
    final trackPaint = Paint()
      ..color = const Color(0xFFE2E8F0).withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, outerRadius, trackPaint);
    canvas.drawCircle(center, innerRadius, trackPaint);

    // Outer Arc (Clockwise rotation)
    final outerAngle = progress * 2 * math.pi;
    final outerPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          primaryColor.withValues(alpha: 0.0),
          primaryColor.withValues(alpha: 0.5),
          primaryColor,
        ],
        stops: const [0.0, 0.6, 1.0],
        transform: GradientRotation(outerAngle),
      ).createShader(Rect.fromCircle(center: center, radius: outerRadius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      outerAngle,
      1.5 * math.pi * 0.75,
      false,
      outerPaint,
    );

    // Outer Satellite Node
    final outerDotAngle = outerAngle + (1.5 * math.pi * 0.75);
    final outerDotOffset = Offset(
      center.dx + outerRadius * math.cos(outerDotAngle),
      center.dy + outerRadius * math.sin(outerDotAngle),
    );
    final nodePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(outerDotOffset, strokeWidth * 0.9, nodePaint);

    // Inner Arc (Counter-Clockwise rotation)
    final innerAngle = -progress * 2 * math.pi;
    final innerPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          secondaryColor.withValues(alpha: 0.0),
          secondaryColor.withValues(alpha: 0.6),
          secondaryColor,
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: GradientRotation(innerAngle),
      ).createShader(Rect.fromCircle(center: center, radius: innerRadius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth * 0.85;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerRadius),
      innerAngle,
      math.pi * 0.8,
      false,
      innerPaint,
    );

    // Inner Satellite Node
    final innerDotAngle = innerAngle + (math.pi * 0.8);
    final innerDotOffset = Offset(
      center.dx + innerRadius * math.cos(innerDotAngle),
      center.dy + innerRadius * math.sin(innerDotAngle),
    );
    final innerNodePaint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(innerDotOffset, strokeWidth * 0.75, innerNodePaint);
  }

  @override
  bool shouldRepaint(covariant _OrbitalSpinnerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor;
  }
}

/// Dynamic 3-dot jumping wave
class _BouncingDots extends StatelessWidget {
  final AnimationController controller;
  final Color color;

  const _BouncingDots({required this.controller, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final val = (controller.value - delay) % 1.0;
            final bounce = math.sin(val * math.pi).clamp(0.0, 1.0);
            return Transform.translate(
              offset: Offset(0, -bounce * 3),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                width: 3.5,
                height: 3.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.5 + (bounce * 0.5)),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

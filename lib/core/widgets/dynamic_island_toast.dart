import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum ToastType {
  success,
  warning,
  info,
  danger,
}

/// Interactive Dynamic Island Toast for modern alerts with spring entrance & pulse animation
class DynamicIslandToast {
  static OverlayEntry? _currentEntry;

  static void show(
    BuildContext context, {
    required String message,
    String? title,
    ToastType type = ToastType.info,
    Duration duration = const Duration(milliseconds: 3500),
  }) {
    // Remove previous entry if active
    _currentEntry?.remove();
    _currentEntry = null;

    final overlay = Overlay.of(context);

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _DynamicIslandToastWidget(
        message: message,
        title: title,
        type: type,
        duration: duration,
        onDismiss: () {
          if (_currentEntry == entry) {
            entry.remove();
            _currentEntry = null;
          }
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }

  static void success(BuildContext context, String message, {String? title}) {
    show(
      context,
      message: message,
      title: title ?? 'BERHASIL',
      type: ToastType.success,
    );
  }

  static void danger(BuildContext context, String message, {String? title}) {
    show(
      context,
      message: message,
      title: title ?? 'GANGGUAN TERDETEKSI',
      type: ToastType.danger,
    );
  }

  static void warning(BuildContext context, String message, {String? title}) {
    show(
      context,
      message: message,
      title: title ?? 'PERINGATAN SISTEM',
      type: ToastType.warning,
    );
  }

  static void info(BuildContext context, String message, {String? title}) {
    show(
      context,
      message: message,
      title: title ?? 'INFORMASI TELEMETRY',
      type: ToastType.info,
    );
  }
}

class _DynamicIslandToastWidget extends StatefulWidget {
  final String message;
  final String? title;
  final ToastType type;
  final Duration duration;
  final VoidCallback onDismiss;

  const _DynamicIslandToastWidget({
    required this.message,
    this.title,
    required this.type,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_DynamicIslandToastWidget> createState() =>
      _DynamicIslandToastWidgetState();
}

class _DynamicIslandToastWidgetState extends State<_DynamicIslandToastWidget>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _pulseController;
  late final Animation<double> _slideAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  bool _isExiting = false;

  @override
  void initState() {
    super.initState();

    // Haptic feedback for Dynamic Island expansion
    HapticFeedback.lightImpact();

    // Entrance Spring Controller
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Continuous pulse controller for status beacon
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _slideAnimation = Tween<double>(begin: -70.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutBack,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeIn,
      ),
    );

    _entranceController.forward();

    // Auto dismiss after duration
    Future.delayed(widget.duration, () {
      if (mounted && !_isExiting) {
        _dismissWithAnimation();
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _dismissWithAnimation() {
    if (_isExiting) return;
    _isExiting = true;
    _entranceController.reverse().then((_) {
      if (mounted) {
        widget.onDismiss();
      }
    });
  }

  Color get _accentColor {
    switch (widget.type) {
      case ToastType.success:
        return AppColors.statusOperational;
      case ToastType.danger:
        return AppColors.statusOutage;
      case ToastType.warning:
        return AppColors.statusDegraded;
      case ToastType.info:
        return AppColors.accentTeal;
    }
  }

  IconData get _iconData {
    switch (widget.type) {
      case ToastType.success:
        return Icons.check_circle_rounded;
      case ToastType.danger:
        return Icons.error_rounded;
      case ToastType.warning:
        return Icons.warning_amber_rounded;
      case ToastType.info:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final accent = _accentColor;

    return Positioned(
      top: topPadding + 8,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: AnimatedBuilder(
          animation: _entranceController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: child,
                ),
              ),
            );
          },
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta != null && details.primaryDelta! < -4) {
                _dismissWithAnimation();
              }
            },
            onTap: _dismissWithAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.14),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: accent.withValues(alpha: 0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Pulsing Status Icon / Beacon
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, _) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 38 + (_pulseController.value * 6),
                            height: 38 + (_pulseController.value * 6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: accent.withValues(
                                alpha: 0.25 * (1.0 - _pulseController.value),
                              ),
                            ),
                          ),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: accent.withValues(alpha: 0.18),
                              border: Border.all(
                                color: accent.withValues(alpha: 0.5),
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              _iconData,
                              size: 20,
                              color: accent,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(width: 12),

                  // Message and Title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.title != null) ...[
                          Row(
                            children: [
                              Text(
                                widget.title!,
                                style: AppTypography.labelXs.copyWith(
                                  color: accent,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.6,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: accent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                        ],
                        Text(
                          widget.message,
                          style: AppTypography.bodySm.copyWith(
                            color: Colors.white.withValues(alpha: 0.95),
                            fontWeight: FontWeight.w500,
                            fontSize: 12.5,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Close Button
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 15,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

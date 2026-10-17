import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../navigation/presentation/screens/main_navigation_shell.dart';
import '../widgets/splash_countdown_bar.dart';
import '../widgets/splash_radar_pulse.dart';
import '../widgets/splash_telemetry_terminal.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback? onFinish;

  const SplashScreen({super.key, this.onFinish});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _timerController;
  late final AnimationController _radarController;
  late final AnimationController _entranceController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _textFade;

  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();

    // 5-second countdown controller
    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    // Continuous looping radar pulse
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    // Staggered entrance animation
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _logoScale = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
    );

    _logoFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _textFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.35, 0.8, curve: Curves.easeIn),
    );

    // Start entrance and 5s timer
    _entranceController.forward();
    _timerController.forward();

    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToTarget();
      }
    });
  }

  @override
  void dispose() {
    _timerController.dispose();
    _radarController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  void _navigateToTarget() {
    if (_isNavigating || !mounted) return;
    _isNavigating = true;

    if (widget.onFinish != null) {
      widget.onFinish!();
      return;
    }

    final authState = context.read<AuthCubit>().state;
    final Widget destination =
        authState is Authenticated ? const MainNavigationShell() : const LoginScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 650),
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fadeAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );
          final scaleAnimation = Tween<double>(begin: 0.96, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          );

          return FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _handleInteractiveTap() {
    HapticFeedback.lightImpact();
    // Provide visual feedback by briefly accelerating pulse
    _radarController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _handleInteractiveTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient Glowing Background Mesh
            Positioned(
              top: -size.width * 0.2,
              right: -size.width * 0.15,
              child: Container(
                width: size.width * 0.85,
                height: size.width * 0.85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.mintBadgeTint.withValues(alpha: 0.6),
                      AppColors.accentTeal.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -size.width * 0.2,
              left: -size.width * 0.15,
              child: Container(
                width: size.width * 0.75,
                height: size.width * 0.75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFE0F2FE).withValues(alpha: 0.45),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Continuous Radar Waves Behind Logo
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 120),
                child: SplashRadarPulse(
                  animation: _radarController,
                  size: size.width * 0.75,
                ),
              ),
            ),

            // Foreground Staggered Content
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Brand Hero Logo
                  FadeTransition(
                    opacity: _logoFade,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFE6FFFA),
                              Color(0xFFCCFBF1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: AppColors.accentTeal.withValues(alpha: 0.4),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.16),
                              blurRadius: 28,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: AppColors.accentTeal.withValues(alpha: 0.25),
                              blurRadius: 14,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                            const Icon(
                              Icons.radar_rounded,
                              size: 48,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title and Subtitle
                  SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textFade,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'SIGAP',
                                style: AppTypography.headlineXl.copyWith(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.6,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColors.primary,
                                      AppColors.primaryContainer,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'SRE MOBILE',
                                  style: AppTypography.codeSm.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sistem Informasi Gangguan & Analisis Performa',
                            textAlign: TextAlign.center,
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Telemetry Boot Sequence Terminal Box
                  AnimatedBuilder(
                    animation: _timerController,
                    builder: (context, _) {
                      return SplashTelemetryTerminal(
                        progress: _timerController.value,
                      );
                    },
                  ),

                  const Spacer(flex: 2),

                  // 5-Second Animated Progress Bar and Skip Button
                  AnimatedBuilder(
                    animation: _timerController,
                    builder: (context, _) {
                      return SplashCountdownBar(
                        progress: _timerController.value,
                        onSkip: _navigateToTarget,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

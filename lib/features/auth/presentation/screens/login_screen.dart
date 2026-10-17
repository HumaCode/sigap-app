import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/dynamic_island_toast.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_biometric_card.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/auth_server_status_badge.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'admin@gmail.com');
  final _passwordController = TextEditingController(text: '123');
  bool _obscurePassword = true;
  bool _enableBiometric = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      DynamicIslandToast.warning(
        context,
        'Mohon lengkapi email/username dan kata sandi Anda.',
        title: 'VALIDASI INPUT',
      );
      return;
    }

    context.read<AuthCubit>().login(
          email,
          password,
          enableBiometric: _enableBiometric,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthError) {
                    DynamicIslandToast.danger(
                      context,
                      state.message,
                      title: 'AUTENTIKASI GAGAL',
                    );
                  }
                  if (state is Authenticated) {
                    DynamicIslandToast.success(
                      context,
                      'Selamat datang kembali, ${state.user.name}!',
                      title: 'LOGIN BERHASIL',
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading = state is AuthLoading;
                  final canUseBiometric = state is Unauthenticated && state.canUseBiometric;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Header Section (Status Pill, Glowing Logo, Title)
                      const AuthHeader(),
                      const SizedBox(height: 28),

                      // Floating Modern Login Card
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0F172A).withValues(alpha: 0.06),
                              blurRadius: 28,
                              offset: const Offset(0, 12),
                            ),
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.04),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Card Header Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Akses Kredensial',
                                  style: AppTypography.titleSm.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.mintBadgeTint.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.shield_outlined,
                                        size: 13,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'SECURE',
                                        style: AppTypography.labelXs.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),

                            // Email / Username Input
                            AuthInputField(
                              controller: _emailController,
                              label: 'Email / Username',
                              hint: 'Masukkan email atau username',
                              prefixIcon: Icons.alternate_email_rounded,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 14),

                            // Password Input
                            AuthInputField(
                              controller: _passwordController,
                              label: 'Password',
                              hint: 'Masukkan password kredensial',
                              prefixIcon: Icons.lock_outline_rounded,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _onLoginPressed(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 20,
                                  color: const Color(0xFF64748B),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Biometric Switch & Instant Login Button
                            AuthBiometricSection(
                              enableBiometric: _enableBiometric,
                              onToggle: (val) {
                                setState(() {
                                  _enableBiometric = val;
                                });
                              },
                              canUseBiometric: canUseBiometric,
                              onBiometricLogin: () {
                                context.read<AuthCubit>().loginWithBiometrics();
                              },
                            ),
                            const SizedBox(height: 20),

                            // Primary Modern Gradient Action Button
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF00685F),
                                    Color(0xFF008378),
                                    Color(0xFF0D9488),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.35),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: isLoading ? null : _onLoginPressed,
                                  borderRadius: BorderRadius.circular(16),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    child: Center(
                                      child: isLoading
                                          ? const Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 18,
                                                  height: 18,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2.2,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Text(
                                                  'Memverifikasi Kredensial...',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Masuk ke SIGAP SRE',
                                                  style: AppTypography.titleSm.copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                const Icon(
                                                  Icons.arrow_forward_rounded,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Server Status & API Endpoint Capsule
                      const AuthServerStatusBadge(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

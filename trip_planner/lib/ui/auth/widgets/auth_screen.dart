import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:trip_planner/config/app_theme.dart';
import 'package:trip_planner/domain/models/auth/auth_error.dart';
import 'package:trip_planner/ui/auth/view_models/auth_viewmodel.dart';
import 'package:trip_planner/ui/core/responsive.dart';

part 'auth_screen_mobile.dart';
part 'auth_screen_web.dart';

/// Dispatcher for the Auth screen. Owns the shared scaffold (background +
/// listenable view model) and picks the layout — [AuthMobileView] or
/// [AuthWebView] — passing the view model down. The view files only arrange the
/// shared presentational pieces ([_AuthLogo], [_AuthTabBar], [_AuthCard]).
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key, required this.viewModel});

  final AuthViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    // Web has its own split layout (image left / form right) and supplies its
    // own background, so the full-screen background image is mobile-only.
    final isWeb = context.isWebLayout;
    return Scaffold(
      backgroundColor: isWeb ? AppColors.sheetBackground : null,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (!isWeb) const _Background(),
          SafeArea(
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) {
                if (context.isWebLayout) {
                  return AuthWebView(viewModel: viewModel);
                }
                return AuthMobileView(viewModel: viewModel);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared presentational components used by both the mobile and web layouts.
// ---------------------------------------------------------------------------

class _AuthLogo extends StatelessWidget {
  const _AuthLogo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.map_outlined, color: AppColors.textPrimary, size: 48),
        SizedBox(height: 8),
        Text(
          'Trip Planner',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _AuthTabBar extends StatelessWidget {
  const _AuthTabBar({required this.viewModel});

  final AuthViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: AppColors.authCardBg,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    _AuthTab(
                      viewModel: viewModel,
                      label: 'Sign in',
                      tab: SelectedTab.login,
                    ),
                    _AuthTab(
                      viewModel: viewModel,
                      label: 'Sign up',
                      tab: SelectedTab.signup,
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: _GlassCardPainter()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthTab extends StatelessWidget {
  const _AuthTab({
    required this.viewModel,
    required this.label,
    required this.tab,
  });

  final AuthViewModel viewModel;
  final String label;
  final SelectedTab tab;

  @override
  Widget build(BuildContext context) {
    final isSelected = viewModel.selectedTab == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () => viewModel.selectedTab = tab,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? AppColors.textSecondary
                  : AppColors.labelDisabled,
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard({required this.viewModel});

  final AuthViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.authCardBg,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    _buildFields(),
                    const SizedBox(height: 100),
                    _buildContinueButton(),
                  ],
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: _GlassCardPainter()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFields() {
    final error = viewModel.authError;
    final isSignUp = viewModel.selectedTab == SelectedTab.signup;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AuthTextField(
          controller: viewModel.emailController,
          hint: 'Email',
          keyboardType: TextInputType.emailAddress,
          errorText: error?.type == AuthErrorType.email
              ? error!.description
              : null,
        ),
        const SizedBox(height: 12),
        _AuthTextField(
          controller: viewModel.passwordController,
          hint: 'Password',
          obscure: viewModel.obscurePassword,
          onToggleObscure: viewModel.togglePasswordVisibility,
          errorText: error?.type == AuthErrorType.password
              ? error!.description
              : null,
        ),
        // Fixed-height section: repeat password (sign-up) or forgot password
        // (sign-in).
        SizedBox(
          height: 64,
          child: isSignUp
              ? Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: _AuthTextField(
                    controller: viewModel.repeatPasswordController,
                    hint: 'Repeat password',
                    obscure: viewModel.obscurePassword,
                    errorText: error?.type == AuthErrorType.repeatPassword
                        ? error!.description
                        : null,
                  ),
                )
              : Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => viewModel.resetPassword.execute(),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(color: AppColors.hint, fontSize: 13),
                      ),
                    ),
                  ),
                ),
        ),
        if (error?.type == AuthErrorType.general) ...[
          const SizedBox(height: 4),
          Text(
            error!.description,
            style: const TextStyle(color: Colors.redAccent, fontSize: 13),
          ),
        ],
      ],
    );
  }

  Widget _buildContinueButton() {
    final isLogin = viewModel.selectedTab == SelectedTab.login;
    final command = isLogin
        ? viewModel.loginWithEmail
        : viewModel.registerWithEmail;

    return ListenableBuilder(
      listenable: command,
      builder: (context, _) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: command.running ? null : () => command.execute(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.textSecondary,
              disabledBackgroundColor: AppColors.accentDisabled,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: command.running
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.textSecondary,
                    ),
                  )
                : const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        );
      },
    );
  }
}

class _GlassCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(30),
    );

    // Light highlight overlay (-45° = top-left to bottom-right, 80% intensity)
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.18),
          Colors.white.withValues(alpha: 0.06),
          Colors.transparent,
        ],
        stops: const [0.0, 0.35, 1.0],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rect, highlightPaint);

    // Dispersion border (rainbow gradient, dispersion=50 → moderate saturation)
    final borderPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.7),
          const Color(0xFFADD8FF).withValues(alpha: 0.5),
          const Color(0xFFD4AAFF).withValues(alpha: 0.4),
          const Color(0xFFFFAACC).withValues(alpha: 0.3),
          Colors.white.withValues(alpha: 0.1),
        ],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(rect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/background.png', fit: BoxFit.cover);
  }
}

class _AuthTextField extends StatelessWidget {
  const _AuthTextField({
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.onToggleObscure,
    this.errorText,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final String? errorText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.textFieldBackground,
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            style: const TextStyle(color: AppColors.textSecondary),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.hint),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: onToggleObscure != null
                  ? IconButton(
                      icon: Icon(
                        obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.hint,
                      ),
                      onPressed: onToggleObscure,
                    )
                  : null,
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trip_planner/config/app_theme.dart';

/// A circular, frosted-glass icon button. The background is translucent and
/// heavily blurs whatever sits behind it, so the button reads on top of both
/// the home hero image and the light content sheets.
///
/// Reused by [AppTopBar] (settings entry point) and the Settings header
/// (back button) to keep a single visual language for round icon buttons.
class FrostedCircleButton extends StatelessWidget {
  const FrostedCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 40,
    this.iconColor = AppColors.textSecondary,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final Color iconColor;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Material(
          color: AppColors.heroPillBackground,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: size,
              height: size,
              child: Icon(icon, color: iconColor, size: size * 0.5),
            ),
          ),
        ),
      ),
    );
    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}

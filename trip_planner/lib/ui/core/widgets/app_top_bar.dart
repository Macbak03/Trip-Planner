import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner/config/app_theme.dart';
import 'package:trip_planner/routing/routes.dart';
import 'package:trip_planner/ui/core/responsive.dart';
import 'package:trip_planner/ui/core/widgets/frosted_circle_button.dart';

/// Universal, transparent top bar shown on top of every authenticated content
/// screen (Home, Trip Details, Place Details) via [AppShell]. It is a thin,
/// transparent strip with two frosted circular buttons: a leading Back button
/// (hidden on Home, where there is nothing to go back to) and a trailing
/// Settings button.
class AppTopBar extends StatelessWidget {
  const AppTopBar({super.key});

  /// Height of the bar content, excluding the status bar inset. [AppShell]
  /// reserves this much extra top padding so screen content clears the bar.
  static const double height = 44;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final showBack = location != Routes.home && context.canPop();
    return ClipRect(
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (showBack)
                  FrostedCircleButton(
                    icon: Icons.arrow_back,
                    tooltip: 'Back',
                    onTap: () => context.pop(),
                  )
                else
                  const SizedBox.square(dimension: 40),
                FrostedCircleButton(
                  icon: Icons.settings_outlined,
                  tooltip: 'Settings',
                  onTap: () => context.push(Routes.settings),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Wraps the authenticated content routes with the universal [AppTopBar].
///
/// The bar floats over the screen (so the home hero image and content sheets
/// show through its blur). To keep the bar from covering content, the wrapped
/// [child] receives an enlarged top padding via [MediaQuery]; every screen
/// already wraps its body in a [SafeArea], so content shifts below the bar
/// without any per-screen changes.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Web: a conventional opaque header sits above the content (content flows
    // beneath it). Mobile: the floating, transparent bar overlays the content.
    if (context.isWebLayout) {
      return Column(
        children: [
          const WebHeader(),
          Expanded(child: child),
        ],
      );
    }
    final mediaQuery = MediaQuery.of(context);
    return Stack(
      children: [
        MediaQuery(
          data: mediaQuery.copyWith(
            padding: mediaQuery.padding.copyWith(
              top: mediaQuery.padding.top + AppTopBar.height,
            ),
          ),
          child: child,
        ),
        const Positioned(top: 0, left: 0, right: 0, child: AppTopBar()),
      ],
    );
  }
}

/// Web/desktop top navigation header shown above every authenticated content
/// screen via [AppShell]. A solid bar with the app's brand (which routes back to
/// Home), an optional Back button, and a Settings entry point — the web
/// counterpart of the mobile floating [AppTopBar].
class WebHeader extends StatelessWidget {
  const WebHeader({super.key});

  static const double height = 64;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final showBack = location != Routes.home && context.canPop();
    return Material(
      color: AppColors.cardBackground,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.separator)),
        ),
        child: SizedBox(
          height: height,
          child: MaxWidthCenter(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                if (showBack) ...[
                  _HeaderIconButton(
                    icon: Icons.arrow_back,
                    tooltip: 'Back',
                    onTap: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                ],
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => context.go(Routes.home),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          color: AppColors.accent,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Trip Planner',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                _HeaderIconButton(
                  icon: Icons.settings_outlined,
                  tooltip: 'Settings',
                  onTap: () => context.push(Routes.settings),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Plain circular icon button used inside [WebHeader]; reads on the light header
/// and gains a hover/splash affordance on web via [InkWell].
class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: AppColors.label, size: 22),
        ),
      ),
    );
    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}

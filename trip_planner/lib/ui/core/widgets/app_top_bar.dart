import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner/routing/routes.dart';
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

import 'package:flutter/widgets.dart';

/// Shared layout breakpoints used to switch every screen between its mobile
/// (touch, single-column) presentation and its web (wide, multi-column) one.
///
/// The same widgets, view models and repositories drive both layouts — only the
/// arrangement changes — so the app effectively ships "two versions" of each
/// view from a single responsive build.
abstract final class Breakpoints {
  /// At or above this logical width a screen renders its web layout.
  static const double web = 800;

  /// Upper bound for centered page content on very wide windows, so cards and
  /// text don't stretch uncomfortably across large desktop monitors.
  static const double content = 1180;
}

extension ResponsiveContext on BuildContext {
  /// Whether the current window is wide enough to use the web layout.
  bool get isWebLayout => MediaQuery.sizeOf(this).width >= Breakpoints.web;
}

/// Horizontally centers [child] and caps its width at [maxWidth] (defaults to
/// [Breakpoints.content]), adding optional [padding] gutters. Used by the web
/// layouts to keep content readable on large screens.
class MaxWidthCenter extends StatelessWidget {
  const MaxWidthCenter({
    super.key,
    required this.child,
    this.maxWidth = Breakpoints.content,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

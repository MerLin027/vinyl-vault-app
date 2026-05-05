import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../config/theme.dart';

// ---------------------------------------------------------------------------
// VaultCard
// ---------------------------------------------------------------------------
/// A themed surface container used throughout VinylVault.
///
/// Applies the standard card decoration:
///   - `AppColors.surface` background
///   - 14 px corner radius
///   - 1 px `AppColors.border` stroke
///
/// Usage:
/// ```dart
/// VaultCard(
///   padding: const EdgeInsets.all(16),
///   child: Text('Hello'),
/// )
/// ```
class VaultCard extends StatelessWidget {
  const VaultCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// shimmerBox
// ---------------------------------------------------------------------------
/// Returns a rectangular shimmer placeholder using the app's standard
/// base/highlight colours (`surfaceVariant` → `surface`).
///
/// Prefer this function over inline `Shimmer.fromColors` calls to keep
/// shimmer appearance consistent and reduce boilerplate.
///
/// Usage:
/// ```dart
/// shimmerBox(width: 80, height: 80, radius: 8)
/// ```
Widget shimmerBox({
  double? width,
  double? height,
  double radius = 8,
  EdgeInsetsGeometry? margin,
}) {
  return Shimmer.fromColors(
    baseColor: AppColors.surfaceVariant,
    highlightColor: AppColors.surface,
    child: Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// NavGuard mixin
// ---------------------------------------------------------------------------
/// Mixin for [State] subclasses that need to prevent duplicate navigation
/// events when a user taps a button rapidly.
///
/// Usage:
/// ```dart
/// class _MyScreenState extends State<MyScreen> with NavGuard {
///   // In button onTap:
///   onTap: () => guardedNavigate(() {
///     Navigator.push(context, ...);
///   }),
/// }
/// ```
mixin NavGuard<T extends StatefulWidget> on State<T> {
  bool _isNavigating = false;

  /// Executes [action] only if no navigation is already in progress.
  /// Resets the guard after [cooldown] (default 300 ms).
  void guardedNavigate(
    VoidCallback action, {
    Duration cooldown = const Duration(milliseconds: 300),
  }) {
    if (_isNavigating) return;
    _isNavigating = true;
    action();
    Future.delayed(cooldown, () {
      if (mounted) setState(() => _isNavigating = false);
    });
  }
}

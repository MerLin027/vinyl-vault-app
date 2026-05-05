import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import
import '../widgets/nav_transition.dart';
import './main_screen.dart';
class OrderFailedScreen extends StatefulWidget {
  const OrderFailedScreen({super.key});

  @override
  State<OrderFailedScreen> createState() => _OrderFailedScreenState();
}

class _OrderFailedScreenState extends State<OrderFailedScreen> {
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with close button and title
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Order Status', style: AppTypography.titleLarge),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            // Centered error content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Error icon with glow effect
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.2), width: 2),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 48,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Title
                  Text(
                    'Order Failed',
                    style: AppTypography.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  // Subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Text(
                      'Something went wrong while placing your order. Please try again.',
                      style: AppTypography.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            // Footer action buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_isNavigating) return;
                      _isNavigating = true;
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (mounted) setState(() => _isNavigating = false);
                      });
                      // CheckoutScreen is still on the stack below this screen
                      // (pushReplacement was used to get here). Pop back to it.
                      Navigator.pop(context);
                    },
                    child: const Text('Try Again'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      if (_isNavigating) return;
                      _isNavigating = true;
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (mounted) setState(() => _isNavigating = false);
                      });
                      Navigator.pushAndRemoveUntil(
                          context,
                          fadeSlideRoute(const MainScreen(initialIndex: 2)),
                          (route) => false,
                      );
                    },
                    child: const Text('Go to Cart'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

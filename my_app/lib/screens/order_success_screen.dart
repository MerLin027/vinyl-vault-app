import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import
import './home_screen.dart';
import './order_history_screen.dart';
import '../widgets/nav_transition.dart';
class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({super.key});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  bool _isNavigating = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
          child: Column(
            children: [
              // Header row with back arrow and title
              const SizedBox(height: 8),
              Row(
                children: [
                   Expanded(
                    child: Center(
                      child: Text('Order Status', style: AppTypography.titleLarge),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Success icon — double ring with checkmark
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, size: 48, color: AppColors.background),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Success heading
              Text(
                'Order Placed Successfully!',
                style: AppTypography.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Your vinyl is being prepared for shipping and will be with you shortly.',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Order reference card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Column(
                  children: [
                    Text(
                      'ORDER REFERENCE',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.accent,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('#VV-98231', style: AppTypography.headlineLarge),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.local_shipping_outlined,
                            size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(
                          'Estimated delivery: Oct 24 – Oct 27',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Vinyl image banner
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCfYNPlEqcUySky1UilBV3gMPY1dE9SFhvHLSYXUWtIfvtEgSKhxM2x7YaO36ahiLYBMFVbnm_qJDmuK1N3oq3xpckIRdIVtipR5inws7rKQTS0KQ_YjhfF_iDnlL2Am3KG4KZiKMO87BUs3bdOJU5578lqNTjHLgxZLLjMKDGEm5IfdFciZL6KW6JMZLl3LfQ2VIm17MlqnF5KpFhY4lARRNYKfkzUeIyeWcL9NW5zEdS8KGwd_RERmJgJBu-FoMkqKJ2CwDMZxpj5',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(height: 180, color: AppColors.surfaceVariant),
                ),
              ),
              const SizedBox(height: 32),
              // Continue Shopping
              ElevatedButton(
                onPressed: () {
                  if (_isNavigating) return;
                  _isNavigating = true;
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) setState(() => _isNavigating = false);
                  });
                  Navigator.pushReplacement(
                      context,
                      fadeSlideRoute(const HomeScreen()));
                },
                child: const Text('Continue Shopping'),
              ),
              const SizedBox(height: 12),
              // View Orders
              OutlinedButton(
                onPressed: () {
                  if (_isNavigating) return;
                  _isNavigating = true;
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) setState(() => _isNavigating = false);
                  });
                  Navigator.pushReplacement(
                      context,
                      fadeSlideRoute(const OrderHistoryScreen()));
                },
                child: const Text('View Orders'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

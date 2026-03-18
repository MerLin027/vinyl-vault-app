import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import
import './login_screen.dart';
import '../widgets/nav_transition.dart';

class SessionExpiredScreen extends StatefulWidget {
  const SessionExpiredScreen({super.key});

  @override
  State<SessionExpiredScreen> createState() => _SessionExpiredScreenState();
}

class _SessionExpiredScreenState extends State<SessionExpiredScreen> {
  bool _isNavigating = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Blurred background (simulated app state)
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                    Colors.grey, BlendMode.saturation),
                child: Column(
                  children: [
                    // Fake app bar
                    Container(
                      height: 56,
                      color: AppColors.surface,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.album,
                              color: AppColors.accent, size: 24),
                          const SizedBox(width: 8),
                          Text('VinylVault',
                              style: AppTypography.titleLarge),
                          const Spacer(),
                          const Icon(Icons.menu,
                              color: AppColors.textPrimary),
                        ],
                      ),
                    ),
                    // Fake product grid
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        padding: const EdgeInsets.all(16),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(
                            4,
                            (_) => Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceVariant,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Overlay tint
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.8)),
          ),
          // Session expired modal
          Center(
            child: Container(
              width: 340,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border, width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 64,
                    spreadRadius: -12,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Lock icon
                  const Icon(
                    Icons.lock_outline,
                    size: 40,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 20),
                  // Title
                  Text(
                    'Session Expired',
                    style: AppTypography.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Subtitle
                  Text(
                    'Please log in again to continue',
                    style: AppTypography.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Log In outlined button
                  OutlinedButton(
                    onPressed: () {
                      if (_isNavigating) return;
                      _isNavigating = true;
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (mounted) setState(() => _isNavigating = false);
                      });
                      Navigator.pushReplacement(
                          context,
                          fadeSlideRoute(const LoginScreen()));
                    },
                    child: const Text('Log In'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

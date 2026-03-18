import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import
import './order_history_screen.dart';
import './login_screen.dart';
import './edit_profile_screen.dart';
import '../widgets/nav_transition.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isNavigating = false;

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('Profile', style: AppTypography.headlineMedium),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        switchInCurve: Curves.easeOut,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // Avatar + user info
                _buildUserHeader(),
                const SizedBox(height: 24),
                // Stats row
                _buildStatsRow(),
                const SizedBox(height: 24),
                // Account settings section
                Text(
                  'ACCOUNT SETTINGS',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.accent.withValues(alpha: 0.7),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                _buildMenuItem(
                  icon: Icons.person_outline,
                  label: 'Edit Profile',
                  onTap: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const EditProfileScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        final tween = Tween(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero)
                            .chain(CurveTween(curve: Curves.easeOutCubic));
                        final fadeTween =
                            Tween<double>(begin: 0.0, end: 1.0)
                                .chain(CurveTween(curve: Curves.easeOut));
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: FadeTransition(
                            opacity: animation.drive(fadeTween),
                            child: child,
                          ),
                        );
                      },
                      transitionDuration:
                          const Duration(milliseconds: 280),
                      reverseTransitionDuration:
                          const Duration(milliseconds: 220),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildMenuItem(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Order History',
                  badge: '12',
                  onTap: () {
                    if (_isNavigating) return;
                    _isNavigating = true;
                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (mounted) setState(() => _isNavigating = false);
                    });
                    Navigator.push(
                        context,
                        fadeSlideRoute(const OrderHistoryScreen()));
                  },
                ),
                const SizedBox(height: 8),
                _buildMenuItem(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  onTap: () => _showSnack('Coming soon'),
                ),
                const SizedBox(height: 24),
                // Support section
                Text(
                  'SUPPORT',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.accent.withValues(alpha: 0.7),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                _buildMenuItem(
                  icon: Icons.help_outline,
                  label: 'Help Center',
                  onTap: () => _showSnack('Coming soon'),
                ),
                const SizedBox(height: 8),
                // Logout with accent color
                _buildMenuItem(
                  icon: Icons.logout,
                  label: 'Log Out',
                  isAccent: true,
                  onTap: () {
                    if (_isNavigating) return;
                    _isNavigating = true;
                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (mounted) setState(() => _isNavigating = false);
                    });
                    Navigator.pushAndRemoveUntil(
                        context,
                        fadeSlideRoute(const LoginScreen()),
                        (route) => false);
                  },
                ),
              ],
            ),
          ),
        ),
      ), // Fixed: added missing ')' to close AnimatedSwitcher before Scaffold params
    );
  }

  // Avatar circle + name + email
  Widget _buildUserHeader() {
    return Center(
      child: Column(
        children: [
          // Initials avatar with edit FAB
          Stack(
            children: [
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Center(
                  child: Text(
                    'JD',
                    style: AppTypography.displayLarge
                        .copyWith(fontSize: 40, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => _showSnack('Coming soon'),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit,
                        size: 14, color: AppColors.background),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Julian Denson', style: AppTypography.headlineLarge),
          const SizedBox(height: 4),
          Text(
            'julian.vinyl@provider.com',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.accent.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  // Collection / Wishlist stats
  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('COLLECTION', '124')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('WISHLIST', '38')),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.accent.withValues(alpha: 0.7),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(value, style: AppTypography.headlineLarge),
        ],
      ),
    );
  }

  // Menu item row with icon, label, optional badge, optional accent color
  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    String? badge,
    bool isAccent = false,
  }) {
    final color = isAccent ? AppColors.accent : AppColors.accent;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: AppTypography.titleMedium.copyWith(
                  color: isAccent ? AppColors.accent : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (badge != null) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(badge,
                    style: AppTypography.labelSmall
                        .copyWith(color: AppColors.background)),
              ),
              const SizedBox(width: 8),
            ],
            Icon(Icons.chevron_right,
                color: AppColors.accent.withValues(alpha: 0.4), size: 20),
          ],
        ),
      ),
    );
  }
}

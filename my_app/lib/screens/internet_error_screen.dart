import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import
import './home_screen.dart';
import './search_screen.dart';
import './cart_screen.dart';
import './order_history_screen.dart';
import './profile_screen.dart';
import '../widgets/nav_transition.dart';
class InternetErrorScreen extends StatefulWidget {
  const InternetErrorScreen({super.key});

  @override
  State<InternetErrorScreen> createState() => _InternetErrorScreenState();
}

class _InternetErrorScreenState extends State<InternetErrorScreen> {
  int _selectedNavIndex = 0;
  bool _isNavigating = false;

  void _onNavTap(int index) {
    if (index == _selectedNavIndex) return;
    if (_isNavigating) return;
    _isNavigating = true;
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _isNavigating = false);
    });
    setState(() => _selectedNavIndex = index);
    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, fadeSlideRoute(const HomeScreen()));
        break;
      case 1:
        Navigator.pushReplacement(
            context, fadeSlideRoute(const SearchScreen()));
        break;
      case 2:
        Navigator.pushReplacement(
            context, fadeSlideRoute(const CartScreen()));
        break;
      case 3:
        Navigator.pushReplacement(
            context, fadeSlideRoute(const OrderHistoryScreen()));
        break;
      case 4:
        Navigator.pushReplacement(
            context, fadeSlideRoute(const ProfileScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with VinylVault wordmark
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'VinylVault',
                  style: GoogleFonts.tenorSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 2.0,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            // Centered error content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // WiFi off icon in circular container
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.wifi_off_outlined,
                      size: 52,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Title
                  Text(
                    'No Internet Connection',
                    style: AppTypography.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  // Subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Text(
                      'Please check your connection and try again',
                      style: AppTypography.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Retry outlined button
                  SizedBox(
                    width: 160,
                    child: OutlinedButton(
                      onPressed: () {
                        if (_isNavigating) return;
                        _isNavigating = true;
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (mounted) setState(() => _isNavigating = false);
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Retry'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: _onNavTap,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Orders'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile'),
        ],
      ),
    );
  }
}

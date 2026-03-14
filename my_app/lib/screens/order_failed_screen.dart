import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import
import './home_screen.dart';
import './search_screen.dart';
import './cart_screen.dart';
import './order_history_screen.dart';
import './profile_screen.dart';
import './checkout_screen.dart';
import '../widgets/nav_transition.dart';
class OrderFailedScreen extends StatefulWidget {
  const OrderFailedScreen({super.key});

  @override
  State<OrderFailedScreen> createState() => _OrderFailedScreenState();
}

class _OrderFailedScreenState extends State<OrderFailedScreen> {
  int _selectedNavIndex = 2;
  bool _isNavigating = false;

  void _onNavTap(int index) {
    if (index == _selectedNavIndex) return;
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
                      color: AppColors.error.withOpacity(0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.error.withOpacity(0.2), width: 2),
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
                      Navigator.pushReplacement(
                          context,
                          fadeSlideRoute(const CheckoutScreen()));
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
                      Navigator.pushReplacement(
                          context,
                          fadeSlideRoute(const CartScreen()));
                    },
                    child: const Text('Go to Cart'),
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

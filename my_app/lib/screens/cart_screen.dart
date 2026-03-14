import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import
import './home_screen.dart';
import './search_screen.dart';
import './checkout_screen.dart';
import './order_history_screen.dart';
import './profile_screen.dart';
import '../widgets/nav_transition.dart';

class _CartItem {
  const _CartItem({
    required this.imageUrl,
    required this.title,
    required this.artist,
    required this.price,
  });
  final String imageUrl;
  final String title;
  final String artist;
  final String price;
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _selectedNavIndex = 2;
  bool _isNavigating = false;

  final List<_CartItem> _items = const [
    _CartItem(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuACe2jnkwaRFgU2KkHerOXOtP3ZTltzZOlpZWdxoCqWP_3Z1Puj11q_qAET3ZrV5GEAynYwYFwxWeqs4G51SJMOpgWo_V3Zz5-bLu12MVniX1Uoi13LgkIrBZqi2FoCDSMDId3R8h1blh5hHDitsLN1bP6RuDc-USpS7vwbbGf0lRl9gldnR1Vd86DqCu73M015yS2sOs2Mozmw5u1v3MFcirpcpPTAjrkPtg6qlsd60F7wCDELrZe0U0AUJ5t7rJDJL7gmJy7qf4Kt',
      title: 'Midnights',
      artist: 'Taylor Swift',
      price: r'$29.99',
    ),
    _CartItem(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBKBKfaE0r6ybgtXJ07IldaNjDAD03ukCO271rVfhtFzfnSGxCa0luixhF1VlglNYQGnOfRuOyRXzcOdwu6o9QOCCeYuB8RwjMb2a4I7caLiy-Oxz-UkQ2eStdw3l-R4qdprBSlP_QqA5hHkk6gMr6MkASEAM1t1gKnsRrwU0PCH24olD1Iv7mB3emHGvJ23tbZedlmv5C8wvQpsW21hstIL0Wy8PCdNGR0SLsKFi7j_Fsc4uf39dhQohlxApYZDw5oVA70OxdiAhbe',
      title: 'Rumours',
      artist: 'Fleetwood Mac',
      price: r'$35.00',
    ),
  ];

  final List<int> _quantities = [1, 1];

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('Shopping Cart', style: AppTypography.headlineMedium),
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
                const SizedBox(height: 16),
                // Cart Items
                ..._items.asMap().entries.map((e) => _buildCartItem(e.key, e.value)),
                const SizedBox(height: 20),
                // Order Summary
                _buildOrderSummary(),
                const SizedBox(height: 20),
                // Checkout button
                _buildCheckoutButton(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // Individual cart item card
  Widget _buildCartItem(int index, _CartItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          children: [
            // Album art thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(width: 80, height: 80, color: AppColors.surfaceVariant),
              ),
            ),
            const SizedBox(width: 16),
            // Title / artist / price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: AppTypography.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(item.artist, style: AppTypography.bodySmall),
                  const SizedBox(height: 6),
                  Text(item.price,
                      style:
                          AppTypography.titleMedium.copyWith(color: AppColors.accent)),
                ],
              ),
            ),
            // Quantity & delete controls
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 22),
                  color: AppColors.textSecondary,
                  onPressed: () => _showSnack('Coming soon'),
                ),
                const SizedBox(height: 4),
                _buildQuantityControl(index),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Quantity stepper
  Widget _buildQuantityControl(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => setState(() {
              if (_quantities[index] > 1) _quantities[index]--;
            }),
            child: const Icon(Icons.remove, size: 16, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Text('${_quantities[index]}',
              style: AppTypography.titleMedium),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => setState(() => _quantities[index]++),
            child: const Icon(Icons.add, size: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  // Order summary card
  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: AppTypography.headlineMedium),
          const SizedBox(height: 16),
          // Subtotal row
          _buildSummaryRow('Subtotal', r'$64.99'),
          const SizedBox(height: 8),
          // Shipping row
          _buildSummaryRow('Shipping', r'$5.00'),
          const Divider(height: 24),
          // Total row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: AppTypography.titleLarge),
              Text(r'$69.99',
                  style: AppTypography.headlineMedium
                      .copyWith(color: AppColors.accent)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyMedium),
        Text(value, style: AppTypography.bodyLarge),
      ],
    );
  }

  // Proceed to checkout button
  Widget _buildCheckoutButton() {
    return ElevatedButton(
      onPressed: () {
        if (_isNavigating) return;
        _isNavigating = true;
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) setState(() => _isNavigating = false);
        });
        Navigator.push(
          context, fadeSlideRoute(const CheckoutScreen()));
      },
      child: const Text('Proceed to Checkout'),
    );
  }

  // Standard bottom navigation bar
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: AppColors.navBackground,
      selectedItemColor: AppColors.navSelected,
      unselectedItemColor: AppColors.navUnselected,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import
import './home_screen.dart';
import './search_screen.dart';
import './cart_screen.dart';
import './profile_screen.dart';
import './order_detail_screen.dart';
import '../widgets/nav_transition.dart';
class _OrderData {
  const _OrderData({
    required this.imageUrl,
    required this.status,
    required this.statusPrimary,
    required this.id,
    required this.date,
    required this.total,
    this.showActions = false,
    this.opacity = 1.0,
  });
  final String imageUrl;
  final String status;
  final bool statusPrimary;
  final String id;
  final String date;
  final String total;
  final bool showActions;
  final double opacity;
}

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  int _selectedNavIndex = 3;
  bool _isNavigating = false;
  int _selectedTabIndex = 0;

  static const _tabs = ['All', 'Processing', 'Shipped', 'Delivered'];

  static const _orders = [
    _OrderData(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCSIZhqkDc8UmNvTu0VwQ6nRRaaiIpvIbpr-M61ql0BbJONkPSpX717WgWIOVyaZC7zN-Vl_KCSAcCzFnGMwVyiKiiB7zU5RF_rbHmUNrAHFeSeDSU0WAQmhPFqikBdMxP_NOCFLN38q_o5LrycLqfEWCgkPxaq3e8Ir3ZrRT7qvHRJFn9nf8uA_riDJjgb-VCSiOMKkwdQ5E-SVkY7B2hFkx6EpuLW0EN9EfDAomDW0_2U8GiY7y4Vrqu4UBVEpw7kemilvP4sARND',
      status: 'Delivered',
      statusPrimary: true,
      id: 'Order #VV-98421',
      date: 'Oct 24, 2023 • 3 Items',
      total: r'$145.00',
      showActions: true,
    ),
    _OrderData(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAyElZjUe4i9CwNLNFvP0dPySJuLkLUufiVrsxM8hzX_pdejx4IEJH-Q_Ntr4hlNesMBXH18TwbDhaOUgw1DuKS76PBaK4CPlOxuma2Wm5vUWJOvyfOIkWFUw-d8YyWDaeZKGwW62Sy6P1_dbyqGjR51zKDhwymI3dPV4ICf6VU7xUtW9jxM2IOp9bEvqloSUU-J_9GM7kLjIfjyC4BlKJqgi9oGp_AmTFcUfFqmAiKfmIG-Fv19X-v8CdiHfakE8_O9APJoxOlCo9k',
      status: 'Shipped',
      statusPrimary: false,
      id: 'Order #VV-98405',
      date: 'Oct 21, 2023 • 1 Item',
      total: r'$32.50',
    ),
    _OrderData(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDh8QNMYcrgyHboUOaeODjI9jSRCiOIZiBqV9Yoy67kksJS6Z2dRK-iQsQoiDBzdThZT81MCPNpm7ka4PYQGoavWk2NFHmoCraI2IBEj5-Ze5tnxTiWvYNt5zYDkuFZQJIDBaOZBei9_KOtrBqFXyrQozeoL4fD9whye7-4jjSZgHYVI9D9JtQmXRAT6_p3XYhBcXI93BVx32fQr4WuWJJuxuvfZHYwvlggmb2y7Y-xPQs5bul5y969yGDsNagA9H0Cg0UEVAESMNmS',
      status: 'Processing',
      statusPrimary: false,
      id: 'Order #VV-98392',
      date: 'Oct 19, 2023 • 2 Items',
      total: r'$89.99',
    ),
    _OrderData(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBWvl9VIXYSNMZW-7I9nla6m3HHinM5DRi6-wcBMgX1i5ikO9bghT-idKKO2xNIx7suKPMMhcA3b8zxF9tV3_MXi-dYKiF2I1z7rf99ndvmaiwX65VEjTimmefQ2aIYWgnpgwi2gPUKmhPXVCXu_rG_ULXblOHs2c3ZVaT7lGd3PgQXj8lrSZRX-_sGbC8cHij_9HTLGKBuvXDxaqbbKsGb4P3EJI51EHwdPEACDRiHECDNEKE3KpTgw5m5t6RbfH7MANZiIMMaURC1',
      status: 'Cancelled',
      statusPrimary: false,
      id: 'Order #VV-98311',
      date: 'Oct 12, 2023 • 1 Item',
      total: r'$24.00',
      opacity: 0.75,
    ),
    _OrderData(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBGT6aC2YwXdmZ4AABmVQf2AnunuO3RzMCGdbOZee4bpQnd-0immYsxmS5H6kjAaRGR6tG4HfQsUx3LlBtNi9rfTMNqPPuN0P8yvRW8D0bjHygX30iQ_5mmmQwi9NG_qgAgy35mpBQw_Wqe1ZRCWEnZqykl5__AfsuUlOOlBxjySMUEDkdeR_1lyHxfonEwNXXSOlFuvVBKQHRlk7Q9-RRzdtWv0QY8Bxwo_OEJpP6oBii-zog4jfL4qK-DR-KLOdB1ZhEJMbnXgXcM',
      status: 'Delivered',
      statusPrimary: true,
      id: 'Order #VV-98288',
      date: 'Sep 28, 2023 • 4 Items',
      total: r'$210.00',
      showActions: true,
    ),
  ];

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

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
        title: Text('Order History', style: AppTypography.headlineMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_outlined,
                color: AppColors.textSecondary),
            onPressed: () => _showSnack('Coming soon'),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        switchInCurve: Curves.easeOut,
        child: SafeArea(
          child: Column(
            children: [
              // Tab filter bar
              _buildTabBar(),
              // Order list
              Expanded(
                child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 48),
                child: Column(
                  children: _orders
                      .map((o) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildOrderCard(o),
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }

  // Horizontal tab filter selector
  Widget _buildTabBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: _tabs.asMap().entries.map((e) {
          final selected = e.key == _selectedTabIndex;
          return GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = e.key),
            child: Container(
              margin: const EdgeInsets.only(right: 24),
              padding: const EdgeInsets.only(bottom: 10, top: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: selected ? AppColors.accent : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                e.value,
                style: AppTypography.labelLarge.copyWith(
                  color: selected ? AppColors.accent : AppColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Individual order card
  Widget _buildOrderCard(_OrderData o) {
    return Opacity(
      opacity: o.opacity,
      child: GestureDetector(
        onTap: () => Navigator.push(
            context, fadeSlideRoute(const OrderDetailScreen())),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Column(
            children: [
              // Order header row
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Album thumb
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        o.imageUrl,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                            width: 64,
                            height: 64,
                            color: AppColors.surfaceVariant),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Order info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: o.statusPrimary
                                  ? AppColors.accent
                                  : AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              o.status.toUpperCase(),
                              style: AppTypography.labelSmall.copyWith(
                                color: o.statusPrimary
                                    ? AppColors.background
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(o.id, style: AppTypography.titleMedium),
                          Text(o.date, style: AppTypography.bodySmall),
                        ],
                      ),
                    ),
                    // Total + arrow
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(o.total, style: AppTypography.titleLarge),
                        const Icon(Icons.chevron_right,
                            color: AppColors.textSecondary),
                      ],
                    ),
                  ],
                ),
              ),
              // Action buttons for delivered orders
              if (o.showActions)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 40)),
                          onPressed: () => _showSnack('Coming soon'),
                          child: const Text('Track Order'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 40)),
                          onPressed: () => _showSnack('Coming soon'),
                          child: const Text('Reorder'),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

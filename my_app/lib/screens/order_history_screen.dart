import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import
import './order_detail_screen.dart';
import '../widgets/nav_transition.dart';

// Order data model
class _OrderData {
  const _OrderData({
    required this.imageUrl,
    required this.id,
    required this.date,
    required this.total,
    required this.isDelivered,
  });
  final String imageUrl;
  final String id;
  final String date;
  final String total;
  final bool isDelivered; // false = 'Ordered' chip (shown first), true = 'Delivered'
}

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  // Orders sorted: active (Ordered) first, delivered last
  static const _orders = [
    _OrderData(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAyElZjUe4i9CwNLNFvP0dPySJuLkLUufiVrsxM8hzX_pdejx4IEJH-Q_Ntr4hlNesMBXH18TwbDhaOUgw1DuKS76PBaK4CPlOxuma2Wm5vUWJOvyfOIkWFUw-d8YyWDaeZKGwW62Sy6P1_dbyqGjR51zKDhwymI3dPV4ICf6VU7xUtW9jxM2IOp9bEvqloSUU-J_9GM7kLjIfjyC4BlKJqgi9oGp_AmTFcUfFqmAiKfmIG-Fv19X-v8CdiHfakE8_O9APJoxOlCo9k',
      id: 'Order #VV-98405',
      date: 'Oct 21, 2023 • 1 Item',
      total: r'$32.50',
      isDelivered: false,
    ),
    _OrderData(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDh8QNMYcrgyHboUOaeODjI9jSRCiOIZiBqV9Yoy67kksJS6Z2dRK-iQsQoiDBzdThZT81MCPNpm7ka4PYQGoavWk2NFHmoCraI2IBEj5-Ze5tnxTiWvYNt5zYDkuFZQJIDBaOZBei9_KOtrBqFXyrQozeoL4fD9whye7-4jjSZgHYVI9D9JtQmXRAT6_p3XYhBcXI93BVx32fQr4WuWJJuxuvfZHYwvlggmb2y7Y-xPQs5bul5y969yGDsNagA9H0Cg0UEVAESMNmS',
      id: 'Order #VV-98392',
      date: 'Oct 19, 2023 • 2 Items',
      total: r'$89.99',
      isDelivered: false,
    ),
    _OrderData(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBWvl9VIXYSNMZW-7I9nla6m3HHinM5DRi6-wcBMgX1i5ikO9bghT-idKKO2xNIx7suKPMMhcA3b8zxF9tV3_MXi-dYKiF2I1z7rf99ndvmaiwX65VEjTimmefQ2aIYWgnpgwi2gPUKmhPXVCXu_rG_ULXblOHs2c3ZVaT7lGd3PgQXj8lrSZRX-_sGbC8cHij_9HTLGKBuvXDxaqbbKsGb4P3EJI51EHwdPEACDRiHECDNEKE3KpTgw5m5t6RbfH7MANZiIMMaURC1',
      id: 'Order #VV-98311',
      date: 'Oct 12, 2023 • 1 Item',
      total: r'$24.00',
      isDelivered: false,
    ),
    _OrderData(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCSIZhqkDc8UmNvTu0VwQ6nRRaaiIpvIbpr-M61ql0BbJONkPSpX717WgWIOVyaZC7zN-Vl_KCSAcCzFnGMwVyiKiiB7zU5RF_rbHmUNrAHFeSeDSU0WAQmhPFqikBdMxP_NOCFLN38q_o5LrycLqfEWCgkPxaq3e8Ir3ZrRT7qvHRJFn9nf8uA_riDJjgb-VCSiOMKkwdQ5E-SVkY7B2hFkx6EpuLW0EN9EfDAomDW0_2U8GiY7y4Vrqu4UBVEpw7kemilvP4sARND',
      id: 'Order #VV-98421',
      date: 'Oct 24, 2023 • 3 Items',
      total: r'$145.00',
      isDelivered: true,
    ),
    _OrderData(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBGT6aC2YwXdmZ4AABmVQf2AnunuO3RzMCGdbOZee4bpQnd-0immYsxmS5H6kjAaRGR6tG4HfQsUx3LlBtNi9rfTMNqPPuN0P8yvRW8D0bjHygX30iQ_5mmmQwi9NG_qgAgy35mpBQw_Wqe1ZRCWEnZqykl5__AfsuUlOOlBxjySMUEDkdeR_1lyHxfonEwNXXSOlFuvVBKQHRlk7Q9-RRzdtWv0QY8Bxwo_OEJpP6oBii-zog4jfL4qK-DR-KLOdB1ZhEJMbnXgXcM',
      id: 'Order #VV-98288',
      date: 'Sep 28, 2023 • 4 Items',
      total: r'$210.00',
      isDelivered: true,
    ),
  ];

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // App bar — preserved exactly
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
          // Flat list — Ordered items first, Delivered items below
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 48),
            itemCount: _orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _buildOrderCard(_orders[i]),
          ),
        ),
      ),
    );
  }

  // Order card — thumbnail + order number/date + status chip + total + chevron
  Widget _buildOrderCard(_OrderData o) {
    final chipLabel = o.isDelivered ? 'Delivered' : 'Ordered';
    final chipTextColor =
        o.isDelivered ? AppColors.accent : AppColors.textSecondary;

    return GestureDetector(
      onTap: () => Navigator.push(
          context, fadeSlideRoute(const OrderDetailScreen())),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          children: [
            // Album thumbnail
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
            // Order info — id, date, status chip
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: order number + status chip
                  Row(
                    children: [
                      Expanded(
                        child: Text(o.id,
                            style: AppTypography.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 8),
                      // Status chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          chipLabel,
                          style: AppTypography.labelSmall.copyWith(
                            color: chipTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Bottom row: date + total + chevron
                  Row(
                    children: [
                      Expanded(
                        child: Text(o.date, style: AppTypography.bodySmall),
                      ),
                      Text(o.total, style: AppTypography.titleMedium),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right,
                          color: AppColors.textSecondary, size: 20),
                    ],
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

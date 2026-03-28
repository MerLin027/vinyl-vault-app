import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../config/theme.dart';
import '../models/order.dart';
import '../providers/order_provider.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import
import './order_detail_screen.dart';
import '../widgets/nav_transition.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  void initState() {
    super.initState();
    context.read<OrderProvider>().loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final activeOrders = orderProvider.orders
        .where((order) => _isActiveStatus(order.status))
        .toList();
    final deliveredOrders = orderProvider.orders
        .where((order) => order.status.toLowerCase() == 'delivered')
        .toList();

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
          child: orderProvider.isLoading
              ? _buildShimmerList()
              : orderProvider.orders.isEmpty
                  ? _buildEmptyState()
                  : ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 48),
                      children: [
                        if (activeOrders.isNotEmpty) ...[
                          Text('Active', style: AppTypography.titleLarge),
                          const SizedBox(height: 12),
                          ...activeOrders.map(_buildOrderCard),
                          const SizedBox(height: 20),
                        ],
                        if (deliveredOrders.isNotEmpty) ...[
                          Text('Delivered', style: AppTypography.titleLarge),
                          const SizedBox(height: 12),
                          ...deliveredOrders.map(_buildOrderCard),
                        ],
                      ],
                    ),
        ),
      ),
    );
  }

  // Order card — thumbnail + order number/date + status chip + total + chevron
  Widget _buildOrderCard(Order o) {
    final chipLabel = o.status;
    final chipTextColor =
        o.status.toLowerCase() == 'delivered' ? AppColors.accent : AppColors.textSecondary;

    final itemCount = o.items.length;
    final dateLabel =
        '${_formatDate(o.createdAt)} • $itemCount ${itemCount == 1 ? 'Item' : 'Items'}';

    return GestureDetector(
      onTap: () => Navigator.push(
          context, fadeSlideRoute(OrderDetailScreen(order: o))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          children: [
            // Album thumbnail
            _buildOrderThumbs(o),
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
                        child: Text(o.orderNumber,
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
                        child: Text(dateLabel, style: AppTypography.bodySmall),
                      ),
                      Text('\$${o.total.toStringAsFixed(2)}', style: AppTypography.titleMedium),
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

  bool _isActiveStatus(String status) {
    final normalized = status.toLowerCase();
    return normalized == 'ordered' ||
        normalized == 'processing' ||
        normalized == 'shipped';
  }

  String _formatDate(DateTime date) {
    final month = _months[date.month - 1];
    return '$month ${date.day}, ${date.year}';
  }

  Widget _buildOrderThumbs(Order order) {
    final thumbs = order.items
        .map((item) => item.imageUrl)
        .where((url) => url.isNotEmpty)
        .take(3)
        .toList();
    final extra = order.items.length - thumbs.length;

    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        children: [
          for (var i = 0; i < thumbs.length; i++)
            Positioned(
              left: i * 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  thumbs[i],
                  width: 36,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 36,
                    height: 64,
                    color: AppColors.surfaceVariant,
                  ),
                ),
              ),
            ),
          if (extra > 0)
            Positioned(
              right: 0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    '+$extra',
                    style: AppTypography.labelSmall,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No orders yet',
        style: AppTypography.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 48),
      itemCount: 4,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.surfaceVariant,
          highlightColor: AppColors.surface,
          child: Container(
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border, width: 1),
            ),
          ),
        );
      },
    );
  }

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
}

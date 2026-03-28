import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../models/order.dart';
import '../providers/cart_provider.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import
import './main_screen.dart';
import '../widgets/nav_transition.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, this.order});

  final Order? order;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool _isNavigating = false;
  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    final order = widget.order ?? (routeArgs is Order ? routeArgs : null);

    if (order == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text('Order Details', style: AppTypography.headlineMedium),
        ),
        body: Center(
          child: Text('Order not found', style: AppTypography.bodyMedium),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(order.orderNumber, style: AppTypography.headlineMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_outlined,
                color: AppColors.textSecondary),
            onPressed: () => _showSnack('Coming soon'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Status + date info card
              _buildStatusCard(order),
              const SizedBox(height: 20),
              // Shipping address
              Text('Shipping Address', style: AppTypography.titleLarge),
              const SizedBox(height: 12),
              _buildInfoCard(
                icon: Icons.local_shipping_outlined,
                children: [
                  Text('Address', style: AppTypography.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    order.shippingAddress,
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Payment method
              Text('Payment Method', style: AppTypography.titleLarge),
              const SizedBox(height: 12),
              _buildInfoCard(
                icon: Icons.credit_card_outlined,
                children: [
                  Text(order.paymentMethod.isNotEmpty ? order.paymentMethod : 'N/A',
                      style: AppTypography.titleMedium),
                  Text(_formatDate(order.createdAt), style: AppTypography.bodySmall),
                ],
              ),
              const SizedBox(height: 20),
              // Order items
              Text('Items (${order.items.length})', style: AppTypography.titleLarge),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Column(
                  children: order.items
                      .map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.imageUrl,
                                    width: 72,
                                    height: 72,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                        width: 72,
                                        height: 72,
                                        color: AppColors.surfaceVariant),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item.title,
                                          style: AppTypography.titleMedium),
                                      Text(item.artist,
                                          style: AppTypography.bodySmall),
                                      const SizedBox(height: 4),
                                        Text('\$${item.price.toStringAsFixed(2)} x ${item.quantity}',
                                          style: AppTypography.titleMedium
                                              .copyWith(
                                                  color: AppColors.accent)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),
              // Price breakdown
              _buildBreakdown(order),
              const SizedBox(height: 20),
              _buildStepTracker(order.status),
              const SizedBox(height: 24),
              // Track order
              ElevatedButton(
                onPressed: () => _showSnack('Coming soon'),
                child: const Text('Track Order'),
              ),
              const SizedBox(height: 12),
              // Reorder
              OutlinedButton(
                onPressed: () async {
                  final cartProvider = context.read<CartProvider>();
                  final navigator = Navigator.of(context);

                  for (final item in order.items) {
                    await cartProvider.addToCart(item.productId, item.quantity);
                  }

                  if (!mounted) return;

                  if (_isNavigating) return;
                  _isNavigating = true;
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) setState(() => _isNavigating = false);
                  });
                    navigator.push(
                      fadeSlideRoute(const MainScreen(initialIndex: 2)));
                },
                child: const Text('Reorder'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Status badge card at the top
  Widget _buildStatusCard(Order order) {
    final status = order.status.toUpperCase();
    final itemCount = order.items.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: AppTypography.labelSmall.copyWith(
                      color: AppColors.background, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${_formatDate(order.createdAt)} • $itemCount ${itemCount == 1 ? 'Item' : 'Items'}',
                style: AppTypography.bodySmall,
              ),
            ],
          ),
          Text('\$${order.total.toStringAsFixed(2)}', style: AppTypography.headlineMedium),
        ],
      ),
    );
  }

  // Reusable info card with leading icon
  Widget _buildInfoCard(
      {required IconData icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.accent, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children)),
        ],
      ),
    );
  }

  // Price breakdown section
  Widget _buildBreakdown(Order order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        children: [
          _priceRow('Subtotal', '\$${order.subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 6),
          _priceRow('Shipping', '\$${order.shipping.toStringAsFixed(2)}'),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: AppTypography.titleLarge),
              Text('\$${order.total.toStringAsFixed(2)}',
                  style: AppTypography.headlineMedium
                      .copyWith(color: AppColors.accent)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium),
          Text(value, style: AppTypography.bodyLarge),
        ],
      );

  Widget _buildStepTracker(String status) {
    final steps = ['Ordered', 'Processing', 'Shipped', 'Delivered'];
    final activeStep = _activeStepForStatus(status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length, (index) {
          final step = index + 1;
          final isActive = step == activeStep;

          return Column(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.accent : AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$step',
                    style: AppTypography.labelSmall.copyWith(
                      color: isActive ? AppColors.background : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                steps[index],
                style: AppTypography.labelSmall,
              ),
            ],
          );
        }),
      ),
    );
  }

  int _activeStepForStatus(String status) {
    switch (status.toLowerCase()) {
      case 'ordered':
        return 1;
      case 'processing':
        return 2;
      case 'shipped':
        return 3;
      case 'delivered':
        return 4;
      default:
        return 1;
    }
  }

  String _formatDate(DateTime date) {
    final month = _months[date.month - 1];
    return '$month ${date.day}, ${date.year}';
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

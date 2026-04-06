import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../config/theme.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import
import './checkout_screen.dart';
import './main_screen.dart';
import '../widgets/nav_transition.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartProvider>().loadCart();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

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
                if (cartProvider.isLoading) ...[
                  _buildShimmerList(),
                  const SizedBox(height: 20),
                  _buildShimmerSummary(),
                ] else if (cartProvider.error != null && cartProvider.items.isEmpty) ...[
                  _buildErrorState(cartProvider),
                ] else if (cartProvider.items.isEmpty) ...[
                  _buildEmptyState(),
                ] else ...[
                  // Cart Items
                  ...cartProvider.items.map(_buildCartItem),
                  const SizedBox(height: 20),
                  // Order Summary
                  _buildOrderSummary(cartProvider),
                  const SizedBox(height: 20),
                  // Checkout button
                  _buildCheckoutButton(cartProvider),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Individual cart item card
  Widget _buildCartItem(CartItem item) {
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
              child: item.imageUrl.isNotEmpty
                  ? Image.network(
                      item.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 80,
                        height: 80,
                        color: AppColors.surfaceVariant,
                      ),
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      color: AppColors.surfaceVariant,
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
                    Text('\$${item.price.toStringAsFixed(2)}',
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
                  onPressed: () async {
                    await context.read<CartProvider>().removeItem(item.productId);
                  },
                ),
                const SizedBox(height: 4),
                _buildQuantityControl(item),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Quantity stepper
  Widget _buildQuantityControl(CartItem item) {
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
            onTap: () async {
              if (item.quantity > 1) {
                await context
                    .read<CartProvider>()
                    .updateQuantity(item.productId, item.quantity - 1);
              }
            },
            child: const Icon(Icons.remove, size: 16, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Text('${item.quantity}',
              style: AppTypography.titleMedium),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () async {
              await context
                  .read<CartProvider>()
                  .updateQuantity(item.productId, item.quantity + 1);
            },
            child: const Icon(Icons.add, size: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  // Order summary card
  Widget _buildOrderSummary(CartProvider cartProvider) {
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
          _buildSummaryRow('Subtotal', '\$${cartProvider.subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          // Shipping row
          _buildSummaryRow('Shipping', '\$${cartProvider.shipping.toStringAsFixed(2)}'),
          const Divider(height: 24),
          // Total row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: AppTypography.titleLarge),
              Text('\$${cartProvider.total.toStringAsFixed(2)}',
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
  Widget _buildCheckoutButton(CartProvider cartProvider) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          fadeSlideRoute(const CheckoutScreen()),
        );
      },
      child: const Text('Proceed to Checkout'),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            Text('Your cart is empty', style: AppTypography.headlineMedium),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  fadeSlideRoute(const MainScreen(initialIndex: 0)),
                );
              },
              child: const Text('Browse Records'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(CartProvider cartProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            Text(
              cartProvider.error ?? 'Failed to load cart',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                cartProvider.loadCart();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return Column(
      children: List.generate(2, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Shimmer.fromColors(
            baseColor: AppColors.surfaceVariant,
            highlightColor: AppColors.surface,
            child: Container(
              height: 112,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border, width: 1),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildShimmerSummary() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: AppColors.surface,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 1),
        ),
      ),
    );
  }

}

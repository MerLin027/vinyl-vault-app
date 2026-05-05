import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../config/theme.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../widgets/shared_widgets.dart';
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
          key: ValueKey(
            cartProvider.isLoading
                ? 'loading'
                : (cartProvider.error != null && cartProvider.items.isEmpty)
                    ? 'error'
                    : cartProvider.items.isEmpty
                        ? 'empty'
                        : 'content',
          ),
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
                ] else if (cartProvider.error != null &&
                    cartProvider.items.isEmpty) ...[
                  _buildErrorState(cartProvider),
                ] else if (cartProvider.items.isEmpty) ...[
                  _buildEmptyState(),
                ] else ...[
                  // Cart Items — each card is a StatelessWidget keyed by
                  // productId so Flutter can diff and skip unchanged cards.
                  ...cartProvider.items.map(
                    (item) => _CartItemCard(
                      key: ValueKey(item.productId),
                      item: item,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Order Summary
                  _buildOrderSummary(cartProvider),
                  const SizedBox(height: 20),
                  // Checkout button
                  _buildCheckoutButton(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Order summary card
  Widget _buildOrderSummary(CartProvider cartProvider) {
    return VaultCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: AppTypography.headlineMedium),
          const SizedBox(height: 16),
          _buildSummaryRow(
              'Subtotal', '\$${cartProvider.subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildSummaryRow(
              'Shipping', '\$${cartProvider.shipping.toStringAsFixed(2)}'),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: AppTypography.titleLarge),
              Text(
                '\$${cartProvider.total.toStringAsFixed(2)}',
                style: AppTypography.headlineMedium
                    .copyWith(color: AppColors.accent),
              ),
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
                Navigator.pushAndRemoveUntil(
                  context,
                  fadeSlideRoute(const MainScreen(initialIndex: 0)),
                  (route) => false,
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
          child: shimmerBox(height: 112, radius: 14),
        );
      }),
    );
  }

  Widget _buildShimmerSummary() {
    return shimmerBox(height: 180, radius: 14);
  }
}

// ---------------------------------------------------------------------------
// Extracted StatelessWidget — renders a single cart item card.
// Using a dedicated widget allows Flutter's element diffing to skip unchanged
// cards rather than rebuilding all N cards on every CartProvider notification.
// ---------------------------------------------------------------------------
class _CartItemCard extends StatelessWidget {
  const _CartItemCard({required super.key, required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: VaultCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Album art thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: item.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: AppColors.surfaceVariant,
                        highlightColor: AppColors.surface,
                        child: Container(color: AppColors.surface),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 80,
                        height: 80,
                        color: AppColors.surfaceVariant,
                        child: const Icon(
                          Icons.error_outline,
                          color: AppColors.textSecondary,
                        ),
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
                  Text(
                    item.title,
                    style: AppTypography.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.artist,
                    style: AppTypography.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: AppTypography.titleMedium
                        .copyWith(color: AppColors.accent),
                  ),
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
                    await context
                        .read<CartProvider>()
                        .removeItem(item.productId);
                  },
                ),
                const SizedBox(height: 4),
                _QuantityControl(item: item),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Extracted StatelessWidget — quantity stepper for a cart item.
// ---------------------------------------------------------------------------
class _QuantityControl extends StatelessWidget {
  const _QuantityControl({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
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
            child: const Icon(
              Icons.remove,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Text('${item.quantity}', style: AppTypography.titleMedium),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () async {
              await context
                  .read<CartProvider>()
                  .updateQuantity(item.productId, item.quantity + 1);
            },
            child: const Icon(
              Icons.add,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

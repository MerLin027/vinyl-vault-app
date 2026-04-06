import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import
import './order_failed_screen.dart';
import './order_success_screen.dart';
import '../widgets/nav_transition.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _shippingAddressCtrl = TextEditingController();
  bool _didPrefillAddress = false;
  bool _isLoading = false;

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  void dispose() {
    _shippingAddressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final orderProvider = context.watch<OrderProvider>();
    final userProvider = context.watch<UserProvider>();

    if (!_didPrefillAddress) {
      final address = userProvider.currentUser?.address ?? '';
      if (address.isNotEmpty) {
        _shippingAddressCtrl.text = address;
      }
      _didPrefillAddress = true;
    }

    final checkoutItems = cartProvider.items;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('Checkout', style: AppTypography.headlineMedium),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              TextField(
                controller: _shippingAddressCtrl,
                decoration: const InputDecoration(
                  labelText: 'Shipping Address',
                  hintText: 'Enter your shipping address',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              // Cart items review
              ...checkoutItems.asMap().entries.map((e) => _buildItemRow(e.key, e.value)),
              const SizedBox(height: 20),
              // Order summary
              _buildOrderSummary(cartProvider),
              const SizedBox(height: 20),
              // Place order button
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        final cartProviderRead = context.read<CartProvider>();
                        final checkoutItems = cartProviderRead.items;
                        final shippingAddress = _shippingAddressCtrl.text.trim();

                        setState(() {
                          _isLoading = true;
                        });

                        final orderProviderRead = context.read<OrderProvider>();
                        final navigator = Navigator.of(context);

                        if (checkoutItems.isEmpty) {
                          _showSnack('Your cart is empty');
                          setState(() {
                            _isLoading = false;
                          });
                          return;
                        }

                        if (shippingAddress.isEmpty) {
                          _showSnack('Shipping address is required');
                          setState(() {
                            _isLoading = false;
                          });
                          return;
                        }

                        final success =
                            await orderProviderRead.placeOrder(shippingAddress);

                        if (!mounted) {
                          return;
                        }

                        if (success) {
                          await cartProviderRead.clearCart();
                          final orderNumber =
                              orderProviderRead.currentOrder?.orderNumber ?? '';
                          navigator.pushReplacement(
                            fadeSlideRoute(OrderSuccessScreen(orderNumber: orderNumber)),
                          );
                        } else {
                          setState(() {
                            _isLoading = false;
                          });
                          navigator.pushReplacement(
                            fadeSlideRoute(const OrderFailedScreen()),
                          );
                        }
                      },
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.background,
                        ),
                      )
                    : const Text('Place Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Item review row
  Widget _buildItemRow(int index, CartItem item) {
    final imageUrl = item.imageUrl;
    final title = item.title;
    final artist = item.artist;
    final price = '\$${item.price.toStringAsFixed(2)}';

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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                    width: 80, height: 80, color: AppColors.surfaceVariant),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTypography.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(artist, style: AppTypography.bodySmall),
                  const SizedBox(height: 6),
                  Text(price,
                      style: AppTypography.titleMedium
                          .copyWith(color: AppColors.accent)),
                ],
              ),
            ),
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
                _buildQtyControl(item),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQtyControl(CartItem item) {
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
          Text('${item.quantity}', style: AppTypography.titleMedium),
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

  // Order summary section
  Widget _buildOrderSummary(CartProvider cartProvider) {
    final subtotal = cartProvider.subtotal;
    final shipping = cartProvider.shipping;
    final total = cartProvider.total;

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
          _row('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _row('Shipping', '\$${shipping.toStringAsFixed(2)}'),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: AppTypography.titleLarge),
              Text('\$${total.toStringAsFixed(2)}',
                  style: AppTypography.headlineMedium
                      .copyWith(color: AppColors.accent)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium),
          Text(value, style: AppTypography.bodyLarge),
        ],
      );
}

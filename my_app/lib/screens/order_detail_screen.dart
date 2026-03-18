import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import
import './cart_screen.dart';
import '../widgets/nav_transition.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool _isNavigating = false;
  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  // Order items data
  static const _items = [
    (
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCSIZhqkDc8UmNvTu0VwQ6nRRaaiIpvIbpr-M61ql0BbJONkPSpX717WgWIOVyaZC7zN-Vl_KCSAcCzFnGMwVyiKiiB7zU5RF_rbHmUNrAHFeSeDSU0WAQmhPFqikBdMxP_NOCFLN38q_o5LrycLqfEWCgkPxaq3e8Ir3ZrRT7qvHRJFn9nf8uA_riDJjgb-VCSiOMKkwdQ5E-SVkY7B2hFkx6EpuLW0EN9EfDAomDW0_2U8GiY7y4Vrqu4UBVEpw7kemilvP4sARND',
      title: 'Vintage Turntable Classic',
      artist: 'Rock Legend',
      price: r'$45.00',
    ),
    (
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAyElZjUe4i9CwNLNFvP0dPySJuLkLUufiVrsxM8hzX_pdejx4IEJH-Q_Ntr4hlNesMBXH18TwbDhaOUgw1DuKS76PBaK4CPlOxuma2Wm5vUWJOvyfOIkWFUw-d8YyWDaeZKGwW62Sy6P1_dbyqGjR51zKDhwymI3dPV4ICf6VU7xUtW9jxM2IOp9bEvqloSUU-J_9GM7kLjIfjyC4BlKJqgi9oGp_AmTFcUfFqmAiKfmIG-Fv19X-v8CdiHfakE8_O9APJoxOlCo9k',
      title: 'Jazz Fusion Original',
      artist: 'The Quintet',
      price: r'$52.00',
    ),
    (
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDh8QNMYcrgyHboUOaeODjI9jSRCiOIZiBqV9Yoy67kksJS6Z2dRK-iQsQoiDBzdThZT81MCPNpm7ka4PYQGoavWk2NFHmoCraI2IBEj5-Ze5tnxTiWvYNt5zYDkuFZQJIDBaOZBei9_KOtrBqFXyrQozeoL4fD9whye7-4jjSZgHYVI9D9JtQmXRAT6_p3XYhBcXI93BVx32fQr4WuWJJuxuvfZHYwvlggmb2y7Y-xPQs5bul5y969yGDsNagA9H0Cg0UEVAESMNmS',
      title: 'Electronic Waves EP',
      artist: 'Synthwave Collective',
      price: r'$48.00',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('Order #VV-98421', style: AppTypography.headlineMedium),
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
              _buildStatusCard(),
              const SizedBox(height: 20),
              // Shipping address
              Text('Shipping Address', style: AppTypography.titleLarge),
              const SizedBox(height: 12),
              _buildInfoCard(
                icon: Icons.local_shipping_outlined,
                children: [
                  Text('John Doe', style: AppTypography.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    '123 Vinyl Street, Apartment 4B\nBrooklyn, NY 11201\nUnited States',
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
                  Text('Mastercard •••• 5902',
                      style: AppTypography.titleMedium),
                  Text('Exp: 12/26', style: AppTypography.bodySmall),
                ],
              ),
              const SizedBox(height: 20),
              // Order items
              Text('Items (${_items.length})', style: AppTypography.titleLarge),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Column(
                  children: _items
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
                                    errorBuilder: (_, __, ___) => Container(
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
                                      Text(item.price,
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
              _buildBreakdown(),
              const SizedBox(height: 24),
              // Track order
              ElevatedButton(
                onPressed: () => _showSnack('Coming soon'),
                child: const Text('Track Order'),
              ),
              const SizedBox(height: 12),
              // Reorder
              OutlinedButton(
                onPressed: () {
                  if (_isNavigating) return;
                  _isNavigating = true;
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) setState(() => _isNavigating = false);
                  });
                  Navigator.push(
                      context,
                      fadeSlideRoute(const CartScreen()));
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
  Widget _buildStatusCard() {
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
                  'DELIVERED',
                  style: AppTypography.labelSmall.copyWith(
                      color: AppColors.background, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 6),
              Text('Oct 24, 2023 • 3 Items', style: AppTypography.bodySmall),
            ],
          ),
          Text(r'$145.00', style: AppTypography.headlineMedium),
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
  Widget _buildBreakdown() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        children: [
          _priceRow('Subtotal', r'$145.00'),
          const SizedBox(height: 6),
          _priceRow('Shipping', r'Free'),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: AppTypography.titleLarge),
              Text(r'$145.00',
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
}

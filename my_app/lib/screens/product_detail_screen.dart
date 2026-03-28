import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../config/theme.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, this.product});

  final Product? product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    final product =
        widget.product ?? (routeArgs is Product ? routeArgs : null);
    final primaryImageUrl =
      product != null && product.images.isNotEmpty ? product.images[0] : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('Product Details', style: AppTypography.headlineMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined,
                color: AppColors.textSecondary),
            onPressed: () => _showSnack('Coming soon'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Full-width square album art
              AspectRatio(
                aspectRatio: 1,
                child: primaryImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.zero,
                        child: CachedNetworkImage(
                          imageUrl: primaryImageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: AppColors.surfaceVariant,
                            highlightColor: AppColors.surface,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: AppColors.surfaceVariant,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.surfaceVariant,
                            child: Icon(
                              Icons.album,
                              color: AppColors.border,
                              size: 40,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.surface,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.music_note,
                          color: AppColors.textSecondary,
                          size: 40,
                        ),
                      ),
              ),
              // Content section
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and artist
                    Text(product?.title ?? '',
                        style: AppTypography.displayLarge
                            .copyWith(fontSize: 28, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(product?.artist ?? '',
                        style: AppTypography.headlineMedium
                            .copyWith(color: AppColors.accent)),
                    const SizedBox(height: 16),
                    // Genre / decade / condition chips
                    _buildChips(product),
                    const SizedBox(height: 16),
                    // Star rating
                    _buildRatingRow(product?.rating ?? 0.0),
                    const SizedBox(height: 20),
                    // Price + availability + quantity
                    _buildPriceRow(product?.price ?? 0.0),
                    const SizedBox(height: 20),
                    // Description
                    const Divider(),
                    const SizedBox(height: 16),
                    Text('About this record', style: AppTypography.headlineMedium),
                    const SizedBox(height: 8),
                    Text(
                      product?.description ?? '',
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: 28),
                    // Add to Cart button
                    ElevatedButton(
                      onPressed: product == null
                          ? null
                          : () async {
                              final cartProvider = context.read<CartProvider>();
                              final messenger = ScaffoldMessenger.of(context);

                              final success = await cartProvider
                                  .addToCart(product.id, _quantity);

                              if (!mounted) return;

                              if (success) {
                                messenger.showSnackBar(
                                  const SnackBar(content: Text('Added to cart')),
                                );
                              } else {
                                final error = cartProvider.error;
                                messenger.showSnackBar(
                                  SnackBar(content: Text(error ?? 'Failed to add to cart')),
                                );
                              }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Add to Cart'),
                        ],
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

  // Genre / decade / condition chip pills
  Widget _buildChips(Product? product) {
    final chips = [
      product?.genre ?? '',
      product?.decade ?? '',
      product?.condition ?? '',
    ].where((chip) => chip.isNotEmpty).toList();

    return Wrap(
      spacing: 8,
      children: chips
          .map(
            (chip) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                chip,
                style: AppTypography.labelSmall.copyWith(
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  // Star rating row
  Widget _buildRatingRow(double rating) {
    return Row(
      children: [
        const Icon(Icons.star, size: 20, color: AppColors.accent),
        const SizedBox(width: 6),
        Text(rating.toStringAsFixed(1), style: AppTypography.bodySmall),
      ],
    );
  }

  // Price, in-stock indicator, quantity stepper
  Widget _buildPriceRow(double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: AppTypography.displayMedium
                  .copyWith(color: AppColors.accent, letterSpacing: -0.5),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'IN STOCK',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.accent,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        // Quantity stepper
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 16),
                color: AppColors.textSecondary,
                onPressed: () =>
                    setState(() { if (_quantity > 1) _quantity--; }),
              ),
              SizedBox(
                width: 28,
                child: Text(
                  '$_quantity',
                  style: AppTypography.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 16),
                color: AppColors.textSecondary,
                onPressed: () => setState(() => _quantity++),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

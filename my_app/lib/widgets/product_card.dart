import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../config/theme.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../screens/product_detail_screen.dart';

/// A fully responsive, overflow-safe product card that matches the style used
/// on the Search screen:
///   - Square album-art with a 32 × 32 circular accent Add-to-Cart button
///     anchored at the bottom-right corner of the image.
///   - Animated heart / wishlist toggle (fills red on tap, bounces out).
///   - "Added to wishlist" toast notification.
///   - Cart button shows a mini spinner while the API call is in flight.
class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with TickerProviderStateMixin {
  // ── Wishlist state ─────────────────────────────────────────────────────────
  bool _wishlisted = false;

  late final AnimationController _heartController;
  late final Animation<double> _heartScale;

  // ── Cart state ─────────────────────────────────────────────────────────────
  bool _cartLoading = false;

  @override
  void initState() {
    super.initState();

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Bounces: 1.0 → 1.4 → 1.0
    _heartScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.45)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.45, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticIn)),
        weight: 50,
      ),
    ]).animate(_heartController);
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  void _toggleWishlist() {
    setState(() => _wishlisted = !_wishlisted);
    _heartController.forward(from: 0);

    if (_wishlisted) {
      _showWishlistToast();
    }
  }

  Future<void> _addToCart() async {
    if (_cartLoading) return;
    setState(() => _cartLoading = true);

    final success = await context
        .read<CartProvider>()
        .addToCart(widget.product.id, 1);

    if (!mounted) return;
    setState(() => _cartLoading = false);

    if (success) {
      _showCartToast();
    }
  }

  void _showWishlistToast() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite, color: Colors.red, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Added to Wishlist',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    widget.product.title,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCartToast() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: AppColors.accent, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Added to Cart',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    widget.product.title,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Album art with overlaid action buttons ──────────────────────
            Expanded(
              flex: 10,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Album image
                    if (p.images.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: p.images.first,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: AppColors.surfaceVariant,
                          highlightColor: AppColors.surface,
                          child: Container(color: AppColors.surface),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.surfaceVariant,
                          child: const Icon(
                            Icons.error_outline,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    else
                      Container(color: AppColors.surfaceVariant),

                    // ── Heart / wishlist button (top-right) ─────────────────
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: _toggleWishlist,
                        child: ScaleTransition(
                          scale: _heartScale,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: _wishlisted
                                  ? Colors.red.withValues(alpha: 0.85)
                                  : Colors.black.withValues(alpha: 0.40),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _wishlisted
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ── Add-to-cart button (bottom-right, search page style) ─
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: _addToCart,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _cartLoading
                                ? AppColors.accent.withValues(alpha: 0.6)
                                : AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: _cartLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.background,
                                  ),
                                )
                              : const Icon(
                                  Icons.add_shopping_cart,
                                  size: 14,
                                  color: AppColors.background,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Text section ────────────────────────────────────────────────
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Genre + condition badges
                    Row(
                      children: [
                        Flexible(
                          child: _Badge(label: p.genre, primary: true),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: _Badge(label: p.condition, primary: false),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Title
                    Text(
                      p.title,
                      style: AppTypography.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 1),

                    // Artist
                    Text(
                      p.artist,
                      style: AppTypography.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    // Price row
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '\$${p.price.toStringAsFixed(2)}',
                            style: AppTypography.titleMedium
                                .copyWith(color: AppColors.accent),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProductDetailScreen(product: widget.product),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slideTween =
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeOutCubic));
          final fadeTween = Tween<double>(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOut));
          return SlideTransition(
            position: animation.drive(slideTween),
            child: FadeTransition(
              opacity: animation.drive(fadeTween),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 280),
        reverseTransitionDuration: const Duration(milliseconds: 220),
      ),
    );
  }
}

// ── Private sub-widgets ────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.primary});

  final String label;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: primary
            ? AppColors.accent.withValues(alpha: 0.12)
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          fontSize: 10,
          color: primary ? AppColors.accent : AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

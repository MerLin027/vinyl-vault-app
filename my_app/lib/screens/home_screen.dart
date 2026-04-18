import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../config/theme.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../services/api_service.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedGenreIndex = 0;
  final ApiService _apiService = ApiService();
  List<Product> _products = <Product>[];
  bool _isLoading = false;
  String? _error;

  static const _genres = [
    'All',
    'Rock',
    'Jazz',
    'Hip-Hop',
    'Electronic',
    'Classical',
    'Pop',
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts({String? genre}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final products = await _apiService.getProducts(genre: genre);
      if (!mounted) return;
      setState(() {
        _products = products;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
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
                _buildGenreChips(),
                const SizedBox(height: 32),
                _buildSectionHeader(),
                const SizedBox(height: 16),
                _buildProductGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'VinylVault',
        style: GoogleFonts.tenorSans(
          fontSize: 32,
          fontWeight: FontWeight.w400,
          letterSpacing: 2.0,
          color: AppColors.accent,
        ),
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              color: AppColors.textSecondary,
              onPressed: null,
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildGenreChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_genres.length, (i) {
          final selected = i == _selectedGenreIndex;
          return Padding(
            padding: EdgeInsets.only(right: i < _genres.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedGenreIndex = i);
                _loadProducts(genre: i == 0 ? null : _genres[i]);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? AppColors.accent : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _genres[i],
                  style: AppTypography.labelSmall.copyWith(
                    fontSize: 13,
                    color: selected ? AppColors.background : AppColors.textSecondary,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Featured Products', style: AppTypography.headlineMedium),
        TextButton(
          onPressed: null,
          child: const Text('View All'),
        ),
      ],
    );
  }

  Widget _buildProductGrid() {
    if (_isLoading) {
      return _buildShimmerGrid();
    }

    if (_error != null) {
      return _buildInlineError();
    }

    if (_products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Text('No records found', style: AppTypography.bodyMedium),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.63,
      ),
      itemBuilder: (context, index) {
        return _buildProductCard(_products[index]);
      },
    );
  }

  Widget _buildProductCard(Product p) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ProductDetailScreen(product: p),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final tween =
                  Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(
                CurveTween(curve: Curves.easeOutCubic),
              );
              final fadeTween = Tween<double>(begin: 0.0, end: 1.0)
                  .chain(CurveTween(curve: Curves.easeOut));

              return SlideTransition(
                position: animation.drive(tween),
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
      },
      child: Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (p.images.isNotEmpty)
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: p.images.first,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorWidget: (context, url, error) =>
                          Container(color: AppColors.surfaceVariant),
                    ),
                  )
                else
                  Container(color: AppColors.surfaceVariant),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildBadge(p.genre, primary: true),
                    const SizedBox(width: 4),
                    _buildBadge(p.condition, primary: false),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  p.title,
                  style: AppTypography.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(p.artist, style: AppTypography.bodySmall),
                const SizedBox(height: 8),
                Text(
                  p.rating.toStringAsFixed(1),
                  style: AppTypography.bodySmall.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${p.price.toStringAsFixed(2)}',
                      style: AppTypography.titleMedium
                          .copyWith(color: AppColors.accent),
                    ),
                    _buildAddToCartButton(p),
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

  Widget _buildBadge(String label, {required bool primary}) {
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
      ),
    );
  }

  Widget _buildAddToCartButton(Product product) {
    return Material(
      color: AppColors.accent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {
          context.read<CartProvider>().addToCart(product.id, 1);
        },
        borderRadius: BorderRadius.circular(8),
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(
            Icons.add_shopping_cart,
            size: 18,
            color: AppColors.background,
          ),
        ),
      ),
    );
  }

  Widget _buildInlineError() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_outlined,
                size: 36,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Internet Connection',
              style: AppTypography.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                _loadProducts(genre: _selectedGenreIndex == 0 ? null : _genres[_selectedGenreIndex]);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.63,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.surfaceVariant,
          highlightColor: AppColors.surface,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
          ),
        );
      },
    );
  }

}

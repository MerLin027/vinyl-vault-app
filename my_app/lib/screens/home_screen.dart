import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../config/theme.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/product_card.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import

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
          key: ValueKey(
            _isLoading
                ? 'loading'
                : _error != null
                    ? 'error'
                    : 'content',
          ),
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
        childAspectRatio: 0.55,
      ),
      itemBuilder: (context, index) {
        return ProductCard(product: _products[index]);
      },
    );
  }

  // _buildProductCard, _buildBadge, and _buildAddToCartButton have been
  // extracted into lib/widgets/product_card.dart (ProductCard widget).

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
        childAspectRatio: 0.55,
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

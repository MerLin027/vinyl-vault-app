import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../config/theme.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../services/api_service.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import
import './product_detail_screen.dart';
import '../widgets/nav_transition.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  List<String> _genres = <String>[];
  List<String> _decades = <String>[];
  List<String> _conditions = <String>[];

  String? _selectedGenre;
  String? _selectedDecade;
  String? _selectedCondition;

  List<Product> _results = <Product>[];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFilterOptionsAndSearch();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFilterOptionsAndSearch() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final allProducts = await _apiService.getProducts();
      final genres = allProducts
          .map((p) => p.genre)
          .where((g) => g.isNotEmpty)
          .toSet()
          .toList()
        ..sort();
      final decades = allProducts
          .map((p) => p.decade)
          .where((d) => d.isNotEmpty)
          .toSet()
          .toList()
        ..sort();
      final conditions = allProducts
          .map((p) => p.condition)
          .where((c) => c.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

      final results = await _apiService.getProducts(
        genre: _selectedGenre,
        decade: _selectedDecade,
        condition: _selectedCondition,
        search: _searchController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _genres = genres;
        _decades = decades;
        _conditions = conditions;
        _results = results;
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

  Future<void> _searchProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await _apiService.getProducts(
        genre: _selectedGenre,
        decade: _selectedDecade,
        condition: _selectedCondition,
        search: _searchController.text.trim(),
      );

      if (!mounted) return;
      setState(() {
        _results = results;
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

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _searchProducts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Search VinylVault',
          style: GoogleFonts.tenorSans(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.5,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search input
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search albums, artists...',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.cancel_outlined),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
            // Filters header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filters',
                      style: AppTypography.labelLarge
                          .copyWith(color: AppColors.textSecondary)),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedGenre = null;
                        _selectedDecade = null;
                        _selectedCondition = null;
                      });
                      _searchProducts();
                    },
                    child: const Text('Clear All'),
                  ),
                ],
              ),
            ),
            // Genre chips row
            _buildChipRow(
                chips: _genres,
                selected: _selectedGenre,
                onChanged: (value) {
                  setState(() => _selectedGenre = value);
                  _searchProducts();
                },
                prefix: 'Genre: '),
            const SizedBox(height: 8),
            // Decade chips row
            _buildChipRow(
                chips: _decades,
                selected: _selectedDecade,
                onChanged: (value) {
                  setState(() => _selectedDecade = value);
                  _searchProducts();
                },
                prefix: 'Decade: '),
            const SizedBox(height: 8),
            // Condition chips row
            _buildChipRow(
              chips: _conditions,
              selected: _selectedCondition,
              onChanged: (value) {
                setState(() => _selectedCondition = value);
                _searchProducts();
              },
            ),
            const SizedBox(height: 8),
            // Results grid
            Expanded(
              child: _buildResultsSection(),
            ),
          ],
        ),
      ),
    );
  }

  // Horizontally scrollable chip filter row
  Widget _buildChipRow(
      {required List<String> chips,
      required String? selected,
      required ValueChanged<String?> onChanged,
      String prefix = ''}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: chips.map((chip) {
          final isSelected = selected == chip;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text('$prefix$chip'),
              selected: isSelected,
              backgroundColor: AppColors.surfaceVariant,
              selectedColor: AppColors.accent,
              onSelected: (_) => onChanged(isSelected ? null : chip),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Product search result card
  Widget _buildSearchCard(Product r) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          fadeSlideRoute(ProductDetailScreen(product: r)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Album art with add-to-cart FAB
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (r.images.isNotEmpty)
                      Image.network(
                        r.images.first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: AppColors.surfaceVariant),
                      )
                    else
                      Container(color: AppColors.surfaceVariant),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          context.read<CartProvider>().addToCart(r.id, 1);
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add_shopping_cart,
                              size: 14, color: AppColors.background),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Title
            Text(r.title,
                style: AppTypography.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            Text(r.artist, style: AppTypography.bodySmall),
            const SizedBox(height: 4),
            // Price + condition badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$${r.price.toStringAsFixed(2)}',
                    style: AppTypography.titleMedium
                        .copyWith(color: AppColors.accent)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(r.condition,
                      style: AppTypography.labelSmall
                          .copyWith(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    if (_isLoading) {
      return GridView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: 4,
        itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: AppColors.surfaceVariant,
          highlightColor: AppColors.surface,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border, width: 1),
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            _error!,
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Text(
          'No records found',
          style: AppTypography.bodyMedium,
          textAlign: TextAlign.center,
        ),
      );
    }

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: _results.length,
      itemBuilder: (_, i) => _buildSearchCard(_results[i]),
    );
  }
}

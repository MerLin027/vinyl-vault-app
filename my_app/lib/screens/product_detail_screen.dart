import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import
import './cart_screen.dart';
import '../widgets/nav_transition.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isNavigating = false;
  int _quantity = 1;

  final String _imageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuATMUabWRnIS0OHWccqjczOCB767SP_H6kpTX4gpKHdotCgj3pYuTlOa98jXbJ8PRgDZkL268OACluoVSmQM-KPxL7y6i6ERv8JuUrEQ1Y_2F8ugSVsK-WxOgdB3WX4x8FAo1mr1PlKo57C5Q0uZuEPlFls1d-LZy_v32YTfHMLQmbeZxfcfgQUf3OL0gy4AfYnEPgq_-YApSQ2ouXw4zMmjmShHiRiONQsnJ4OUNs8EqbmIglso37XCVu6E2jgdyCR0nmx9a7KktVx';

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
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
                child: Image.network(
                  _imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: AppColors.surfaceVariant),
                ),
              ),
              // Content section
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and artist
                    Text('Rumours',
                        style: AppTypography.displayLarge
                            .copyWith(fontSize: 28, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text('Fleetwood Mac',
                        style: AppTypography.headlineMedium
                            .copyWith(color: AppColors.accent)),
                    const SizedBox(height: 16),
                    // Genre / decade / condition chips
                    _buildChips(),
                    const SizedBox(height: 16),
                    // Star rating
                    _buildRatingRow(),
                    const SizedBox(height: 20),
                    // Price + availability + quantity
                    _buildPriceRow(),
                    const SizedBox(height: 20),
                    // Description
                    const Divider(),
                    const SizedBox(height: 16),
                    Text('About this record', style: AppTypography.headlineMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Rumours is the eleventh studio album by British-American rock band Fleetwood Mac, released on 4 February 1977. '
                      'This 180g heavyweight vinyl reissue captures the pristine analog warmth of the original sessions at the Record Plant. '
                      'A masterpiece of pop-rock songwriting and intricate production.',
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: 28),
                    // Add to Cart button
                    ElevatedButton(
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
  Widget _buildChips() {
    final inactive = [
      ('Rock', false),
      ('1970s', false),
    ];
    return Wrap(
      spacing: 8,
      children: [
        ...inactive.map((c) => Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                c.$1,
                style: AppTypography.labelSmall.copyWith(
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )),
        // Mint Condition — active/accent chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Mint Condition',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.background,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // 4.5 star rating row
  Widget _buildRatingRow() {
    return Row(
      children: [
        ...List.generate(
            4,
            (_) => const Icon(Icons.star,
                size: 20, color: AppColors.accent)),
        const Icon(Icons.star_half, size: 20, color: AppColors.accent),
        const SizedBox(width: 6),
        Text('(1,248 reviews)', style: AppTypography.bodySmall),
      ],
    );
  }

  // Price, in-stock indicator, quantity stepper
  Widget _buildPriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              r'$45.00',
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

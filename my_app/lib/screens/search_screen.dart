import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import
import './home_screen.dart';
import './cart_screen.dart';
import './order_history_screen.dart';
import './profile_screen.dart';
import './product_detail_screen.dart';
import '../widgets/nav_transition.dart';
class _SearchResult {
  const _SearchResult({
    required this.imageUrl,
    required this.title,
    required this.artist,
    required this.price,
    required this.condition,
  });
  final String imageUrl;
  final String title;
  final String artist;
  final String price;
  final String condition;
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _selectedNavIndex = 1;

  // Genre filter chips state
  final List<String> _genres = ['Jazz', 'Rock', 'Blues', 'Soul'];
  final Set<String> _activeGenres = {'Jazz'};

  // Decade filter chips state
  final List<String> _decades = ['60s', '70s', '80s'];
  final Set<String> _activeDecades = {'70s'};

  // Condition chips state
  final List<String> _conditions = ['Mint', 'Near Mint'];
  final Set<String> _activeConditions = {};

  static const _results = [
    _SearchResult(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC8llUMcOoGtg6SqMNxi5SkCgJ4fhO69lcR0yuyxUs-IeuDR7Kmxri9fjC8cAPSeCd2Xsfz1raCVAbbZXau2xQWiUtqKzSuU8BffmkYBiHS6MlKNQ2vs07sshiMXLN8qKiW64UyTZpYAksnfcvENRa9XdsNx2W56UJNVQ0G3aZM2EWM829P7-Kspxev_E3osca65cuvf_kN_e1FTfyklmCuiNOHfASrwIIiIDpJUhgZH5Phtaubj6g7CoTIeH5RPSPhQXrztfcNzhf_',
      title: 'Kind of Blue',
      artist: 'Miles Davis',
      price: r'$45.00',
      condition: 'VG+',
    ),
    _SearchResult(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC_btb9HByjQ81AestgeaNejLx7dMZGsgpkNNGTlwuH5_V5RhPduviRs-kK-jeBV1CV5w6z12bDH8UBvO23mYtPpK4Nf9XzwXudfQyutrlThRSOyZ5A-0aja8ao5z_0oyCaXNmVAoL7tdh7K4K9ByBpbbwmlBNFgt65ksGttWcdyBcYc-iFfi2oZjVuBTZdfgozi0SMDYRdp8ALMm8WCoBCEmO6i_EJ7s1t1_wpBGlqf3u60uzJFBgWS2jReeta73kYTh9HkgIFRGKk',
      title: 'A Love Supreme',
      artist: 'John Coltrane',
      price: r'$38.00',
      condition: 'M',
    ),
    _SearchResult(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDhvXRnjSMSeNupU3Shp5xgG58f39ixNpHpiUDXObrQJYH51BVZJYtDEawM7zqnWGMlmoWyXkGPVSTBFvsH2ysaoX4N2SL3zsJgmjk4gQlCK4irnw16cQ5ZZrlBis1uOAGM-WHaiHr1_Np9GHjmS5Htmbqm45UCr8j4-OaN6ErK7Reod-10bnL812OyqOQRfbCeOTMfu8nikZmJC0Q7x120dK9axcLybqCcxGTJLPmswUTZq9PUPMxh0ezV8tLjDjvi_r1w8xI18AND',
      title: 'Blue Train',
      artist: 'John Coltrane',
      price: r'$52.00',
      condition: 'NM',
    ),
    _SearchResult(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB6NfGiVor3JBW3SK03JnRF7vawFEJqBelNXKeUvwo7CfSrwc4C7_r5bFoQ-HH5rfKc8yoCn4BxdZFQIDidT-0ax7smP5QnFBYrEMDJdcbrnDX-XsUAST2ra-NlSd93LkhPPPu9WHzIqPpMTUxe6QcM-8XIvFCfuCKiibnSsEwVMErqcT-JbWRTE2GlttspFNYrVJugqmz2v5suf9YdxgYEyzuO112mHN3e194NcMSHAELHSElHw3E9CxZEivCZbil4Gkq4VUjKHfov',
      title: 'Time Out',
      artist: 'The Dave Brubeck Quartet',
      price: r'$32.00',
      condition: 'VG',
    ),
  ];

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  void _onNavTap(int index) {
    if (index == _selectedNavIndex) return;
    if (_isNavigating) return;
    _isNavigating = true;
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _isNavigating = false);
    });
    setState(() => _selectedNavIndex = index);
    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, fadeSlideRoute(const HomeScreen()));
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(
            context, fadeSlideRoute(const CartScreen()));
        break;
      case 3:
        Navigator.pushReplacement(
            context,
            fadeSlideRoute(const OrderHistoryScreen()));
        break;
      case 4:
        Navigator.pushReplacement(
            context, fadeSlideRoute(const ProfileScreen()));
        break;
    }
  }

  // Toggle a chip selection in a set
  void _toggleChip(Set<String> set, String val) {
    setState(() {
      if (set.contains(val)) {
        set.remove(val);
      } else {
        set.add(val);
      }
    });
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
        title: Text('Search Vinyl', style: AppTypography.headlineMedium),
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
                decoration: const InputDecoration(
                  hintText: 'Search albums, artists...',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.cancel_outlined),
                ),
                onChanged: (_) {},
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
                    onPressed: () =>
                        setState(() {
                          _activeGenres.clear();
                          _activeDecades.clear();
                          _activeConditions.clear();
                        }),
                    child: const Text('Clear All'),
                  ),
                ],
              ),
            ),
            // Genre chips row
            _buildChipRow(
                chips: _genres,
                active: _activeGenres,
                prefix: 'Genre: '),
            const SizedBox(height: 8),
            // Decade chips row
            _buildChipRow(
                chips: _decades,
                active: _activeDecades,
                prefix: 'Decade: '),
            const SizedBox(height: 8),
            // Condition chips row
            _buildChipRow(chips: _conditions, active: _activeConditions),
            const SizedBox(height: 8),
            // Results grid
            Expanded(
              child: GridView.builder(
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
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.navBackground,
        selectedItemColor: AppColors.navSelected,
        unselectedItemColor: AppColors.navUnselected,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedNavIndex,
        onTap: _onNavTap,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Orders'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile'),
        ],
      ),
    );
  }

  // Horizontally scrollable chip filter row
  Widget _buildChipRow(
      {required List<String> chips,
      required Set<String> active,
      String prefix = ''}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: chips.map((chip) {
          final selected = active.contains(chip);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text('$prefix$chip'),
              selected: selected,
              backgroundColor: AppColors.surfaceVariant,
              selectedColor: AppColors.accent,
              onSelected: (_) => _toggleChip(active, chip),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Product search result card
  Widget _buildSearchCard(_SearchResult r) {
    return GestureDetector(
      onTap: () {
        if (_isNavigating) return;
        _isNavigating = true;
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) setState(() => _isNavigating = false);
        });
        Navigator.push(
          context,
          fadeSlideRoute(const ProductDetailScreen()));
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
                    Image.network(
                      r.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: AppColors.surfaceVariant),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => _showSnack('Coming soon'),
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
                Text(r.price,
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
}

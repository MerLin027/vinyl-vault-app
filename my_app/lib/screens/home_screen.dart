import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import
import 'search_screen.dart';
import 'cart_screen.dart';
import 'order_history_screen.dart';
import 'profile_screen.dart';
import 'product_detail_screen.dart';

class _ProductData {
  const _ProductData({
    required this.imageUrl,
    required this.genre,
    required this.condition,
    required this.title,
    required this.artist,
    required this.rating,
    required this.price,
  });

  final String imageUrl;
  final String genre;
  final String condition;
  final String title;
  final String artist;
  final String rating;
  final String price;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedGenreIndex = 0;
  int _selectedNavIndex = 0;
  bool _isNavigating = false;

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
        break;
      case 1:
        Navigator.pushReplacement(
            context, fadeSlideRoute(const SearchScreen()));
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

  static const _genres = [
    'All',
    'Rock',
    'Jazz',
    'Hip-Hop',
    'Electronic',
    'Classical',
    'Pop',
  ];

  static const _products = [
    _ProductData(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCiq8a1ybs2keZrGf1lEMMoASXjFmn_-9kCgjaNCi-t343hdkuHuQeY9n2fOYC4eqzfeugwr3YtbUsVBbpvDfE2Gjn4jyP1xQtA7DCVen6UBz0hiLbaamu9wNlKJuDKeSoLzLtP36zohnBCDlNyu0Y8KtNdIFveHboCkyIadq0FOVReBD0q9jIyOT32coapd1JYaVWVPmKQqaQp9byWQVF82Qh9v5dnkV6FfYj7c89ZEohHTkRHTKiXSHWy0Fi5-DJRxQNSEd56tzDA',
      genre: 'Rock',
      condition: 'Mint',
      title: 'Midnight Waves',
      artist: 'Echoes of Silence',
      rating: '4.9',
      price: r'$32.00',
    ),
    _ProductData(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCld71QrKhTE3NMOhrdiI-9cwOiZOoGYhF9-Xop1r9b4wELZDB9z05erss9rFH2kEv9JkF7ddHA1O0rZHfdEcm_78hjho7tslWuxLL-5OOfmhDtZCUrkMkbP4DHlqlj9bl6bh7e5i-w36CCHcLl2ZGk8AnViVKHXLqh8DLuBMCWrZtiwbux6BlYGu58N79Xm3AaB7lOQGxc_j5ka41SRfzp166vA1_dayzo2VVAaZMTT6VEXUmGvPRUpODJIYZIjFANtNwq7URuIbQB',
      genre: 'Jazz',
      condition: 'Near Mint',
      title: 'Blue Notes',
      artist: 'The Quintet',
      rating: '4.7',
      price: r'$45.50',
    ),
    _ProductData(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDOmw16o2tttovb3g04IP3EFm33empxWAF84iAdq8WMFijmZAvMo1hOJZu9dKD0dWUdRVCY53bJRfG75xGO-tqfqf_OeGc90YzG1BSISvyi_6lb9Um5SUtLBlzfhzunMcLC8eZGCJjf1I079Ce7Jn1aEjdjljSAc7-cqrOz1HiHVm7s60TbKH8Cm3mxrxScQk9rkFpE7NvnXTbLS0nFBktJds7S8vk9OCnqRBFdnlKrIrUxCobtbaLXf_sW64yT2qssFWJQgrfiwQg3',
      genre: 'Electronic',
      condition: 'Mint',
      title: 'Neon Dreams',
      artist: 'Synthwave Collective',
      rating: '5.0',
      price: r'$28.00',
    ),
    _ProductData(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBzd68p6GffyGp7c4TMqTh6vKTPoPrYxaBviomjDC2XaIeJQiBJvE_KFPbvglg8kJ5FVu5sAf-G9i7ehP7b0C3Cl5y8QIIYXfob0uL_qwncAY-tvEl1yLsXT9w925XkY6CSRv9R6AdNuYAMsCCL6vAS3hGFJuNA2DMTYaWxQ7REYvOJgkq7fKJwVxPg0SOH_vG9_V6HjYUveAMgJNHg-amKz5EG8NRb1xG_q3zPCLWOsD6EyKKaZfVbSmMMOfZ2ysvm-2wqLaE32oXk',
      genre: 'Pop',
      condition: 'VG+',
      title: 'Summer Solstice',
      artist: 'Aura May',
      rating: '4.5',
      price: r'$39.99',
    ),
  ];

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
                _buildSearchBar(),
                const SizedBox(height: 8),
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
      bottomNavigationBar: _buildBottomNav(),
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
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          color: AppColors.textSecondary,
          onPressed: null,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchBar() {
    return const TextField(
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Search for vinyl records, artists...',
        prefixIcon: Icon(Icons.search),
      ),
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
              onTap: () => setState(() => _selectedGenreIndex = i),
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
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildProductCard(_products[0])),
            const SizedBox(width: 12),
            Expanded(child: _buildProductCard(_products[1])),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildProductCard(_products[2])),
            const SizedBox(width: 12),
            Expanded(child: _buildProductCard(_products[3])),
          ],
        ),
      ],
    );
  }

  Widget _buildProductCard(_ProductData p) {
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
                Image.network(
                  p.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: AppColors.surfaceVariant),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
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
                  p.rating,
                  style: AppTypography.bodySmall.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      p.price,
                      style: AppTypography.titleMedium
                          .copyWith(color: AppColors.accent),
                    ),
                    _buildAddToCartButton(),
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
            ? AppColors.accent.withOpacity(0.12)
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

  Widget _buildAddToCartButton() {
    return Material(
      color: AppColors.accent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: null,
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

  Widget _buildBottomNav() {
    return BottomNavigationBar(
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
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          activeIcon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          activeIcon: Icon(Icons.receipt_long),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}

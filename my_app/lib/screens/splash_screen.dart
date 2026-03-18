import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/theme.dart';
import 'main_screen.dart';
import '../widgets/vinyl_logo.dart';
import '../widgets/nav_transition.dart'; // ignore: unused_import

// ─── Colors extracted directly from HTML/CSS ──────────────────────────────────
// background-dark / vinyl-dark: #111211
const Color _colorBackground = AppColors.background;
// primary: #5BAD8F
const Color _colorPrimary = AppColors.accent;
// off-white: #F5F0E8
const Color _colorOffWhite = AppColors.textPrimary;
// off-white/70 → rgba(245,240,232,0.70) → 0xB3F5F0E8 // no theme equivalent
const Color _colorOffWhite70 = Color(0xB3F5F0E8);
// off-white/40 → rgba(245,240,232,0.40) → 0x66F5F0E8 // no theme equivalent
const Color _colorOffWhite40 = Color(0x66F5F0E8);
// white/5 → rgba(255,255,255,0.05) → 0x0DFFFFFF // no theme equivalent
const Color _colorWhite05 = Color(0x0DFFFFFF);
// primary/5 → rgba(91,173,143,0.05) → 0x0D5BAD8F // no theme equivalent
const Color _colorPrimary05 = Color(0x0D5BAD8F);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Animation controllers ────────────────────────────────────────────────
  late final AnimationController _loadController;
  late final AnimationController _spinController;
  late final AnimationController _exitController;

  // ── Derived animations ───────────────────────────────────────────────────
  late final Animation<double> _loadAnimation;
  late final Animation<double> _exitFade;
  late final Animation<double> _exitScale;

  @override
  void initState() {
    super.initState();

    // Loading bar: 0.0 → 1.0 over 3.5 s with easeInOut curve
    _loadController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );
    _loadAnimation = CurvedAnimation(
      parent: _loadController,
      curve: Curves.easeInOut,
    );

    // Vinyl rotation: continuous single turn every 2 s
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Exit animation: scale 1.0→1.08 + fade 1.0→0.0 over 600 ms with easeIn
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeIn),
    );
    _exitScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeIn),
    );

    // Defer all animation starts and timers until after the first frame is
    // fully rendered so cold-launch timing begins from actual screen visibility
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // Start vinyl spin and progress bar immediately after first frame
      _spinController.repeat();
      _loadController.forward();

      // After 3.5 s the progress bar is done — kick off the exit animation
      Future.delayed(const Duration(milliseconds: 3500), () {
        if (mounted) _exitController.forward();
      });

      // Master timer: navigate exactly 4.5 s after first frame
      Future.delayed(const Duration(milliseconds: 4500), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const MainScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation.drive(
                    Tween<double>(begin: 0.0, end: 1.0)
                        .chain(CurveTween(curve: Curves.easeOut)),
                  ),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _loadController.dispose();
    _spinController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: ScaleTransition(
                  scale: _exitScale,
                  child: FadeTransition(
                    opacity: _exitFade,
                    child: Stack(
                      children: [
                        // ── Subtle ambient radial glow (absolute inset, pointer-events-none) ──
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment.center,
                                radius: 0.85,
                                colors: const [
                                  _colorPrimary05,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),

                        // ── Main vertically centered content: record + wordmark ──
                        Positioned.fill(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ── Vinyl record illustration (continuously rotating) ──
                              RotationTransition(
                                turns: _spinController,
                                child: VinylLogo(size: 160),
                              ),

                              // mb-12 = 48px gap beneath record
                              const SizedBox(height: 48),

                              // ── Wordmark and tagline ───────────────────────────────
                              Padding(
                                // px-6 = 24px horizontal
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Column(
                                  children: [
                                    // App name: text-4xl(36px), font-extrabold(800),
                                    // tracking-[0.1em], uppercase
                                    Text(
                                      'VinylVault',
                                      style: GoogleFonts.tenorSans(
                                        color: _colorOffWhite,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 4.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),

                                    // mb-2 = 8px gap
                                    const SizedBox(height: 8),

                                    // Tagline: text-lg(18px), font-light(300),
                                    // tracking-wide(0.025em), italic, off-white/70
                                    Text(
                                      'Your curated record collection',
                                      style: GoogleFonts.jost( // no theme equivalent
                                        color: _colorOffWhite70,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300,
                                        // tracking-wide → 18 × 0.025 = 0.45
                                        letterSpacing: 0.45,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ── Progress bar area (absolute bottom-16 = 64px) ─────────────
                        Positioned(
                          bottom: 64,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              // max-w-xs = 320px, px-4 = 16px horizontal padding
                              constraints: const BoxConstraints(maxWidth: 320),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: AnimatedBuilder(
                                animation: _loadAnimation,
                                builder: (context, child) {
                                  final percent =
                                      (_loadAnimation.value * 100).round();
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Label row: "SYNCING LIBRARY" + live percentage
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          // Progress label: text-xs(12px), font-medium(500),
                                          // uppercase, tracking-[0.2em], off-white/40
                                          Text(
                                            'SYNCING LIBRARY',
                                            style: GoogleFonts.jost( // no theme equivalent
                                              color: _colorOffWhite40,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              // tracking-[0.2em] → 12 × 0.2 = 2.4
                                              letterSpacing: 2.4,
                                            ),
                                          ),

                                          // Percentage: text-xs(12px), font-medium(500),
                                          // off-white/40 — reflects animation progress
                                          Text(
                                            '$percent%',
                                            style: GoogleFonts.jost( // no theme equivalent
                                              color: _colorOffWhite40,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),

                                      // gap-3 = 12px between label row and bar
                                      const SizedBox(height: 12),

                                      // Progress bar: h-[1px], track bg-white/5,
                                      // fill bg-primary, rounded-full
                                      LinearProgressIndicator(
                                        value: _loadAnimation.value,
                                        minHeight: 1.0,
                                        backgroundColor: _colorWhite05,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                _colorPrimary),
                                        borderRadius:
                                            BorderRadius.circular(9999),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

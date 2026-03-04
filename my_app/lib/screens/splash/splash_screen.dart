import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../login/login_screen.dart';

// ─── Colors extracted directly from HTML/CSS ──────────────────────────────────
// background-dark / vinyl-dark: #111211
const Color _colorBackground = Color(0xFF111211);
// primary: #5BAD8F
const Color _colorPrimary = Color(0xFF5BAD8F);
// off-white: #F5F0E8
const Color _colorOffWhite = Color(0xFFF5F0E8);
// surface: #1A1C19 (used for vinyl groove lighter rings)
const Color _colorSurface = Color(0xFF1A1C19);
// off-white/70 → rgba(245,240,232,0.70) → 0x70 * 255 rounded = 0xB3
const Color _colorOffWhite70 = Color(0xB3F5F0E8);
// off-white/40 → rgba(245,240,232,0.40) → 0x66
const Color _colorOffWhite40 = Color(0x66F5F0E8);
// white/5 → rgba(255,255,255,0.05) → 0x0D
const Color _colorWhite05 = Color(0x0DFFFFFF);
// primary/5 → rgba(91,173,143,0.05) → 0x0D
const Color _colorPrimary05 = Color(0x0D5BAD8F);
// vinyl sheen highlight: rgba(245,240,232,0.05) × element opacity 0.40 = 0.02 → 0x05
const Color _colorSheenHighlight = Color(0x05F5F0E8);

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
  late final AnimationController _entryController;

  // ── Derived animations ───────────────────────────────────────────────────
  late final Animation<double> _loadAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Loading bar: 0.0 → 1.0 over 2.5 s with easeInOut curve
    _loadController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _loadAnimation = CurvedAnimation(
      parent: _loadController,
      curve: Curves.easeInOut,
    );

    // Vinyl rotation: continuous single turn every 4 s
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Entry animations: fade + slide over 800 ms
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeIn,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    ));

    // Kick off entry and loading bar simultaneously
    _entryController.forward();
    _loadController.forward();

    // After the loading bar completes, wait 300 ms then navigate
    _loadController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _loadController.dispose();
    _spinController.dispose();
    _entryController.dispose();
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

                    // ── Main vertically centered content: fade in + slide up ──
                    Positioned.fill(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ── Vinyl record illustration (continuously rotating) ──
                              RotationTransition(
                                turns: _spinController,
                                child: SizedBox(
                                  // w-64 = 256px on mobile
                                  width: 256,
                                  height: 256,
                                  child: CustomPaint(
                                    painter: _VinylRecordPainter(),
                                  ),
                                ),
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
                                      'VINYLVAULT',
                                      style: GoogleFonts.manrope(
                                        color: _colorOffWhite,
                                        fontSize: 36,
                                        fontWeight: FontWeight.w800,
                                        // tracking-[0.1em] → 36 × 0.1 = 3.6
                                        letterSpacing: 3.6,
                                        // leading-tight ≈ 1.25
                                        height: 1.25,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),

                                    // mb-2 = 8px gap
                                    const SizedBox(height: 8),

                                    // Tagline: text-lg(18px), font-light(300),
                                    // tracking-wide(0.025em), italic, off-white/70
                                    Text(
                                      'Your curated record collection',
                                      style: GoogleFonts.manrope(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                        style: GoogleFonts.manrope(
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
                                        style: GoogleFonts.manrope(
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
            );
          },
        ),
      ),
    );
  }
}

// ─── Vinyl Record CustomPainter ───────────────────────────────────────────────
// Draws concentric groove rings, a sheen overlay, the green label,
// and the center spindle hole — replicating the HTML vinyl-grooves CSS.
class _VinylRecordPainter extends CustomPainter {
  const _VinylRecordPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // w-64 = 256px → radius = 128
    final double outerRadius = size.width / 2;
    // w-24 = 96px (label) → radius = 48
    const double labelRadius = 48.0;
    // w-4 = 16px (hole) → radius = 8
    const double holeRadius = 8.0;

    // Clip all drawing to the outer circle boundary
    canvas.clipPath(
      Path()
        ..addOval(
          Rect.fromCircle(center: center, radius: outerRadius),
        ),
    );

    // ── Base dark circle: vinyl-dark #111211 ─────────────────────────────────
    canvas.drawCircle(
      center,
      outerRadius,
      Paint()..color = const Color(0xFF111211),
    );

    // ── Groove rings ─────────────────────────────────────────────────────────
    // Simulates: repeating-radial-gradient(
    //   circle at center,
    //   #111211 0, #111211 2px, #1A1C19 3px, #111211 4px
    // )
    // Every 4px from the label edge outward, one 1px-wide lighter ring (#1A1C19)
    final groovePaint = Paint()
      ..color = _colorSurface // #1A1C19
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (double r = labelRadius + 4; r < outerRadius - 1; r += 4) {
      canvas.drawCircle(center, r, groovePaint);
    }

    // ── Sheen overlay ────────────────────────────────────────────────────────
    // Simulates vinyl-sheen conic-gradient (opacity-40 applied to element):
    // rgba(245,240,232,0.05) × 0.40 = 0.02 → Color(0x05F5F0E8)
    // Highlights at CSS 45°, 180°, 270° → stops 0.125, 0.50, 0.75
    // CSS conic 0° = top → Flutter startAngle = -π/2
    final sheenPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: const [
          Colors.transparent,
          _colorSheenHighlight,
          Colors.transparent,
          _colorSheenHighlight,
          Colors.transparent,
          _colorSheenHighlight,
          Colors.transparent,
        ],
        stops: const [0.0, 0.125, 0.25, 0.50, 0.625, 0.75, 1.0],
      ).createShader(
        Rect.fromCircle(center: center, radius: outerRadius),
      );
    canvas.drawCircle(center, outerRadius, sheenPaint);

    // ── Outer border: border-white/5 → rgba(255,255,255,0.05) ───────────────
    canvas.drawCircle(
      center,
      outerRadius - 0.5,
      Paint()
        ..color = _colorWhite05
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // ── Record label circle: bg-primary #5BAD8F, w-24 → r=48 ────────────────
    canvas.drawCircle(
      center,
      labelRadius,
      Paint()..color = _colorPrimary,
    );

    // ── Center spindle hole: bg-[#111211], w-4 → r=8 ────────────────────────
    canvas.drawCircle(
      center,
      holeRadius,
      Paint()..color = const Color(0xFF111211),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Colors extracted directly from HTML/CSS ──────────────────────────────────
// vault-dark / background-dark: #111211
const Color _colorBackground = Color(0xFF111211);
// primary: #5BAD8F
const Color _colorPrimary = Color(0xFF5BAD8F);
// vault-dark (icon/button text foreground on primary bg): #111211
const Color _colorVaultDark = Color(0xFF111211);
// vault-input: #222420
const Color _colorVaultInput = Color(0xFF222420);
// vault-text: #F5F0E8
const Color _colorVaultText = Color(0xFFF5F0E8);
// vault-text/80 → rgba(245,240,232,0.80) → 0xCC
const Color _colorVaultText80 = Color(0xCCF5F0E8);
// vault-text/60 → rgba(245,240,232,0.60) → 0x99
const Color _colorVaultText60 = Color(0x99F5F0E8);
// vault-text/40 → rgba(245,240,232,0.40) → 0x66
const Color _colorVaultText40 = Color(0x66F5F0E8);
// vault-text/10 → rgba(245,240,232,0.10) → 0x1A
const Color _colorVaultText10 = Color(0x1AF5F0E8);
// primary/5 → rgba(91,173,143,0.05) → 0x0D (decorative ambient circles)
const Color _colorPrimary05 = Color(0x0D5BAD8F);
// primary/20 → rgba(91,173,143,0.20) → 0x33 (logo circle shadow)
const Color _colorPrimary20 = Color(0x335BAD8F);
// primary/10 → rgba(91,173,143,0.10) → 0x1A (button shadow)
const Color _colorPrimary10 = Color(0x1A5BAD8F);

// ─── Google G logo SVG (fill hardcoded to #5BAD8F = text-primary) ─────────────
// Original HTML uses fill="currentColor" where currentColor = text-primary
const String _googleLogoSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
  <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#5BAD8F"/>
  <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#5BAD8F"/>
  <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#5BAD8F"/>
  <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#5BAD8F"/>
</svg>
''';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Password visibility toggle state
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorBackground,
      // Stack allows fixed-position decorative ambient circles behind the scroll view
      body: Stack(
        children: [
          // ── Decorative ambient circle — bottom-left ──────────────────────────
          // fixed -bottom-24 -left-24 w-64 h-64 bg-primary/5 rounded-full blur-3xl -z-10
          Positioned(
            bottom: -96, // -bottom-24 = -6rem = -96px
            left: -96,   // -left-24  = -6rem = -96px
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 32,
                sigmaY: 32,
                tileMode: TileMode.decal,
              ),
              child: Container(
                width: 256,  // w-64 = 16rem = 256px
                height: 256,
                decoration: const BoxDecoration(
                  color: _colorPrimary05,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          // ── Decorative ambient circle — top-right ────────────────────────────
          // fixed -top-24 -right-24 w-64 h-64 bg-primary/5 rounded-full blur-3xl -z-10
          Positioned(
            top: -96,   // -top-24  = -96px
            right: -96, // -right-24 = -96px
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 32,
                sigmaY: 32,
                tileMode: TileMode.decal,
              ),
              child: Container(
                width: 256,
                height: 256,
                decoration: const BoxDecoration(
                  color: _colorPrimary05,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          // ── Main scrollable content ──────────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              // p-4 = 16px padding around all content
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
                  // max-w-md = 28rem = 448px
                  constraints: const BoxConstraints(maxWidth: 448),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ── Logo and wordmark section ────────────────────────────
                      // flex flex-col items-center mb-8
                      Column(
                        children: [
                          // Logo circle: w-16 h-16 bg-primary rounded-full
                          // shadow-lg shadow-primary/20, mb-2 below
                          Container(
                            width: 64,  // w-16 = 64px
                            height: 64, // h-16 = 64px
                            decoration: const BoxDecoration(
                              color: _colorPrimary,
                              shape: BoxShape.circle,
                              // shadow-lg shadow-primary/20
                              boxShadow: [
                                BoxShadow(
                                  color: _colorPrimary20,
                                  blurRadius: 15,
                                  offset: Offset(0, 10),
                                  spreadRadius: -3,
                                ),
                                BoxShadow(
                                  color: _colorPrimary20,
                                  blurRadius: 6,
                                  offset: Offset(0, 4),
                                  spreadRadius: -4,
                                ),
                              ],
                            ),
                            // Album icon: text-vault-dark text-4xl (36px)
                            child: const Icon(
                              Icons.album,
                              color: _colorVaultDark,
                              size: 36, // text-4xl ≈ 36px
                            ),
                          ),

                          // mb-2 = 8px gap
                          const SizedBox(height: 8),

                          // App name: text-2xl(24px), font-extrabold(800),
                          // tracking-tight(-0.025em), text-vault-text
                          Text(
                            'VinylVault',
                            style: GoogleFonts.manrope(
                              color: _colorVaultText,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              // tracking-tight = -0.025em → 24 × -0.025 = -0.6
                              letterSpacing: -0.6,
                            ),
                          ),
                        ],
                      ),

                      // mb-8 = 32px gap after logo section
                      const SizedBox(height: 32),

                      // ── Form card section (space-y-6 = 24px between children) ─
                      // "Welcome Back" heading: text-3xl(30px), font-bold(700),
                      // text-center, mb-8 = 32px below
                      Text(
                        'Welcome Back',
                        style: GoogleFonts.manrope(
                          color: _colorVaultText,
                          fontSize: 30, // text-3xl = 1.875rem = 30px
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      // mb-8(32px) on h1 + space-y-6(24px) on next sibling = 56px total
                      const SizedBox(height: 56),

                      // ── Email input field section ────────────────────────────
                      _buildInputSection(
                        label: 'Email',
                        hintText: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                      ),

                      // space-y-6 = 24px between form sections
                      const SizedBox(height: 24),

                      // ── Password input field section ─────────────────────────
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Label: text-sm(14px), font-medium(500), vault-text/80, ml-1
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0), // ml-1
                            child: Text(
                              'Password',
                              style: GoogleFonts.manrope(
                                color: _colorVaultText80,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          // gap-2 = 8px between label and input
                          const SizedBox(height: 8),

                          // Password TextField with show/hide toggle
                          // h-14(56px), px-4(16px), pr-12(48px), rounded-xl(12px),
                          // bg-vault-input(#222420)
                          TextField(
                            obscureText: _obscurePassword,
                            style: GoogleFonts.manrope(
                              color: _colorVaultText,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: _colorVaultInput,
                              hintText: 'Enter your password',
                              hintStyle: GoogleFonts.manrope(
                                color: _colorVaultText40,
                                fontSize: 14,
                              ),
                              // px-4 = 16px horizontal, vertical gives ~56px total
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 18.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                // rounded-xl = 0.75rem = 12px (per login tailwind config)
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              // focus:ring-2 focus:ring-primary
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: _colorPrimary,
                                  width: 2,
                                ),
                              ),
                              // Password show/hide toggle icon
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  // text-vault-text/40 default color
                                  color: _colorVaultText40,
                                  size: 22,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),

                          // mt-1 = 4px gap above forgot password link
                          const SizedBox(height: 4),

                          // Forgot Password link: text-sm, text-primary, right-aligned
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Forgot Password?',
                              style: GoogleFonts.manrope(
                                color: _colorPrimary,
                                fontSize: 14, // text-sm
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // space-y-6 = 24px
                      const SizedBox(height: 24),

                      // ── Log In button ────────────────────────────────────────
                      // w-full h-14(56px) bg-primary text-vault-dark font-bold rounded-xl(12px)
                      // shadow-lg shadow-primary/10
                      SizedBox(
                        width: double.infinity,
                        height: 56, // h-14
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _colorPrimary,
                            foregroundColor: _colorVaultDark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            // shadow-lg shadow-primary/10
                            shadowColor: _colorPrimary10,
                            elevation: 8,
                          ),
                          onPressed: () {},
                          child: Text(
                            'Log In',
                            style: GoogleFonts.manrope(
                              color: _colorVaultDark,
                              fontSize: 16,
                              fontWeight: FontWeight.w700, // font-bold
                            ),
                          ),
                        ),
                      ),

                      // space-y-6 = 24px (top gap of divider section)
                      const SizedBox(height: 24),

                      // ── "or" divider ─────────────────────────────────────────
                      // relative flex items-center py-4
                      // border-t border-vault-text/10 on both sides
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 16.0), // py-4
                        child: Row(
                          children: [
                            // Left rule
                            const Expanded(
                              child: Divider(
                                color: _colorVaultText10,
                                thickness: 1,
                                height: 1,
                              ),
                            ),
                            // "or" label: mx-4(16px), text-vault-text/40,
                            // text-sm(14px), uppercase, tracking-widest, font-semibold(600)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0), // mx-4
                              child: Text(
                                'OR',
                                style: GoogleFonts.manrope(
                                  color: _colorVaultText40,
                                  fontSize: 14, // text-sm
                                  fontWeight: FontWeight.w600, // font-semibold
                                  // tracking-widest = 0.1em → 14 × 0.1 = 1.4
                                  letterSpacing: 1.4,
                                ),
                              ),
                            ),
                            // Right rule
                            const Expanded(
                              child: Divider(
                                color: _colorVaultText10,
                                thickness: 1,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // space-y-6 = 24px (bottom gap of divider section)
                      const SizedBox(height: 24),

                      // ── Sign in with Google button ───────────────────────────
                      // w-full h-14(56px) border-2 border-primary bg-transparent
                      // text-primary font-semibold rounded-xl(12px) gap-3(12px icon gap)
                      SizedBox(
                        width: double.infinity,
                        height: 56, // h-14
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: _colorPrimary,
                              width: 2, // border-2
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.transparent,
                            foregroundColor: _colorPrimary,
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Google G logo SVG — w-5 = 20px
                              SvgPicture.string(
                                _googleLogoSvg,
                                width: 20,
                                height: 20,
                              ),
                              // gap-3 = 12px between icon and label
                              const SizedBox(width: 12),
                              Text(
                                'Sign in with Google',
                                style: GoogleFonts.manrope(
                                  color: _colorPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600, // font-semibold
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ── Bottom sign-up link ──────────────────────────────────
                      // mt-10 = 40px, text-vault-text/60, text-center
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0), // mt-10
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Don't have an account?",
                                style: GoogleFonts.manrope(
                                  color: _colorVaultText60,
                                  fontSize: 14,
                                ),
                              ),
                              // ml-1 = 4px left margin on Sign Up link
                              const WidgetSpan(child: SizedBox(width: 4)),
                              TextSpan(
                                text: 'Sign Up',
                                style: GoogleFonts.manrope(
                                  color: _colorPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700, // font-bold
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Shared input section builder (label + text field) ─────────────────────
  // Used for the Email field; reusable for any non-password field.
  Widget _buildInputSection({
    required String label,
    required String hintText,
    required bool obscureText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input label: text-sm(14px), font-medium(500), vault-text/80, ml-1
        Padding(
          padding: const EdgeInsets.only(left: 4.0), // ml-1
          child: Text(
            label,
            style: GoogleFonts.manrope(
              color: _colorVaultText80,
              fontSize: 14, // text-sm
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // gap-2 = 8px between label and input
        const SizedBox(height: 8),

        // Text field: h-14(56px), px-4(16px), rounded-xl(12px),
        // bg-vault-input(#222420), focus:ring-2 focus:ring-primary
        TextField(
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: GoogleFonts.manrope(
            color: _colorVaultText,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: _colorVaultInput,
            hintText: hintText,
            hintStyle: GoogleFonts.manrope(
              color: _colorVaultText40,
              fontSize: 14,
            ),
            // px-4 = 16px horizontal, vertical padding gives ~56px total height
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 18.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), // rounded-xl = 12px
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            // focus:ring-2 focus:ring-primary
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: _colorPrimary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

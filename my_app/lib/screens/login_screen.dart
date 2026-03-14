import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/theme.dart';
import '../widgets/vinyl_logo.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

// ─── Colors extracted directly from HTML/CSS ──────────────────────────────────
// primary: #4DB8B8
const Color _colorPrimary = AppColors.accent;
// vault-dark (icon/button text foreground on primary bg): #111111
const Color _colorVaultDark = AppColors.background;
// vault-input: #222420
const Color _colorVaultInput = AppColors.surfaceVariant;
// vault-text: #F5F0E8
const Color _colorVaultText = AppColors.textPrimary;
// vault-text/80 → rgba(245,240,232,0.80) → 0xCCF5F0E8 // no theme equivalent
const Color _colorVaultText80 = Color(0xCCF5F0E8);
// vault-text/60 → rgba(245,240,232,0.60) → 0x99F5F0E8 // no theme equivalent
const Color _colorVaultText60 = Color(0x99F5F0E8);
// vault-text/40 → rgba(245,240,232,0.40) → 0x66F5F0E8 // no theme equivalent
const Color _colorVaultText40 = Color(0x66F5F0E8);
// vault-text/10 → rgba(245,240,232,0.10) → 0x1AF5F0E8 // no theme equivalent
const Color _colorVaultText10 = Color(0x1AF5F0E8);

// primary/10 → rgba(77,184,184,0.10) → 0x1A4DB8B8 // no theme equivalent
const Color _colorPrimary10 = Color(0x1A4DB8B8);

// ─── Google G logo SVG (fill hardcoded to #4DB8B8 = accent) ────────────────────
// Original HTML uses fill="currentColor" where currentColor = text-primary
const String _googleLogoSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
  <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4DB8B8"/>
  <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#4DB8B8"/>
  <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#4DB8B8"/>
  <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#4DB8B8"/>
</svg>
''';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isNavigating = false;
  // Password visibility toggle state
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Background fill with decorative blobs ────────────────────────────
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.background,
            ),
            child: Stack(
              children: [
                // ── Blob — top-right ───────────────────────────────────────────
                Positioned(
                  top: -60,
                  right: -60,
                  child: Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D2A2A).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(200),
                    ),
                  ),
                ),
                // ── Blob — bottom-left ─────────────────────────────────────────
                Positioned(
                  bottom: -60,
                  left: -60,
                  child: Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D2A2A).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(200),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Main scrollable content ──────────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top spacing ──────────────────────────────────────────────
                  const SizedBox(height: 72),

                  // ── Logo and wordmark — centered ─────────────────────────────
                  Center(
                    child: Column(
                      children: [
                        const VinylLogo(size: 72),
                        const SizedBox(height: 10),
                        Text(
                          'VinylVault',
                          style: GoogleFonts.tenorSans(
                            color: _colorVaultText,
                            fontSize: 32,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ── Email label + field ──────────────────────────────────────
                  _buildInputSection(
                    label: 'Email',
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                  ),

                  const SizedBox(height: 20),

                  // ── Password label ───────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      'Password',
                      style: AppTypography.titleMedium.copyWith(
                        color: _colorVaultText80,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── Password field ───────────────────────────────────────────
                  TextField(
                    obscureText: _obscurePassword,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _colorVaultInput,
                      hintText: 'Enter your password',
                      hintStyle: AppTypography.bodyMedium.copyWith(
                        color: _colorVaultText40,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 18.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: _colorPrimary,
                          width: 2,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
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

                  const SizedBox(height: 8),

                  // ── Forgot Password — right-aligned ──────────────────────────
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password?',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Log In button ────────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _colorPrimary,
                        foregroundColor: _colorVaultDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadowColor: _colorPrimary10,
                        elevation: 8,
                      ),
                      onPressed: () {
                        if (_isNavigating) return;
                        _isNavigating = true;
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (mounted) setState(() => _isNavigating = false);
                        });
                        Navigator.pushReplacement(
                          context,
                          fadeSlideRoute(const HomeScreen()));
                      },
                      child: Text(
                        'Log In',
                        style: GoogleFonts.jost(
                          color: _colorVaultDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── OR divider ───────────────────────────────────────────────
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: _colorVaultText10,
                          thickness: 1,
                          height: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'OR',
                          style: AppTypography.labelLarge.copyWith(
                            color: _colorVaultText40,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          color: _colorVaultText10,
                          thickness: 1,
                          height: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Sign in with Google button ───────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: _colorPrimary,
                          width: 2,
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
                          SvgPicture.string(
                            _googleLogoSvg,
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Sign in with Google',
                            style: AppTypography.titleLarge.copyWith(
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Don't have an account row — centered ─────────────────────
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account?",
                            style: AppTypography.bodyMedium.copyWith(
                              color: _colorVaultText60,
                            ),
                          ),
                          const WidgetSpan(child: SizedBox(width: 4)),
                          TextSpan(
                            text: 'Sign Up',
                            style: GoogleFonts.jost(
                              color: _colorPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                if (_isNavigating) return;
                                _isNavigating = true;
                                Future.delayed(const Duration(milliseconds: 300), () {
                                  if (mounted) setState(() => _isNavigating = false);
                                });
                                Navigator.push(
                                  context,
                                  fadeSlideRoute(const SignupScreen()));
                              },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
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
            style: AppTypography.titleMedium.copyWith(
              color: _colorVaultText80,
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
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: _colorVaultInput,
            hintText: hintText,
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: _colorVaultText40,
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
              borderSide: const BorderSide(
                color: AppColors.border,
                width: 1.0,
              ),
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

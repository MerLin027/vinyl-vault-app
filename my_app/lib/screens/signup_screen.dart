import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import
import './main_screen.dart';
import '../widgets/nav_transition.dart'; // ignore: unused_import

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isNavigating = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // VinylLogo icon + wordmark
              const VinylLogo(size: 72),
              const SizedBox(height: 16),
              Text(
                'VinylVault',
                style: GoogleFonts.tenorSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2.0,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 32),
              // Create Account heading
              Text('Create Account', style: AppTypography.displayLarge),
              const SizedBox(height: 8),
              Text(
                'Join the community of vinyl collectors',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              // Username field
              TextField(
                controller: _usernameCtrl,
                decoration: const InputDecoration(
                  hintText: 'johndoe',
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              // Email field
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'name@example.com',
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
              ),
              const SizedBox(height: 16),
              // Password field
              TextField(
                controller: _passwordCtrl,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Confirm password field
              TextField(
                controller: _confirmCtrl,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_reset_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // Create Account button
              ElevatedButton(
                onPressed: () {
                  if (_isNavigating) return;
                  _isNavigating = true;
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) setState(() => _isNavigating = false);
                  });
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder:
                          (context, animation, secondaryAnimation) =>
                              const MainScreen(),
                      transitionsBuilder: (context, animation,
                          secondaryAnimation, child) {
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
                },
                child: const Text('Create Account'),
              ),
              const SizedBox(height: 24),
              // Divider
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR',
                        style: AppTypography.labelSmall
                            .copyWith(letterSpacing: 2)),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24),
              // Already have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?',
                      style: AppTypography.bodyMedium),
                  TextButton(
                    onPressed: () {
                      if (_isNavigating) return;
                      _isNavigating = true;
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (mounted) setState(() => _isNavigating = false);
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Log In'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

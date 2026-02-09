// VinylVault - Vinyl Record Collection Management App
import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const VinylVaultApp());
}

class VinylVaultApp extends StatelessWidget {
  const VinylVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VinylVault',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1)),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
import 'package:flutter/material.dart';

import 'config/theme.dart';
import 'screens/splash_screen.dart';

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
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}

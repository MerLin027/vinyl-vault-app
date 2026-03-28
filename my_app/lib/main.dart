import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'config/theme.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/user_provider.dart';
import 'screens/splash_screen.dart';
import 'services/api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const VinylVaultApp());
}

class VinylVaultApp extends StatelessWidget {
  const VinylVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const _VinylVaultRoot(),
    );
  }
}

class _VinylVaultRoot extends StatefulWidget {
  const _VinylVaultRoot();

  @override
  State<_VinylVaultRoot> createState() => _VinylVaultRootState();
}

class _VinylVaultRootState extends State<_VinylVaultRoot> {
  final GlobalKey<NavigatorState> _appNavigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    final userProvider = context.read<UserProvider>();
    userProvider.checkLoginStatus();
    ApiService.navigatorKey = _appNavigatorKey;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _appNavigatorKey,
      title: 'VinylVault',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:penny_pal/core/theme.dart';
import 'package:penny_pal/screens/auth_screen.dart';
import 'package:penny_pal/screens/dashboard_screen.dart';
import 'package:penny_pal/screens/legal_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:penny_pal/firebase_options.dart';
import 'package:penny_pal/providers/auth_provider.dart';
import 'package:penny_pal/providers/transaction_provider.dart';
import 'package:penny_pal/providers/budget_provider.dart';
import 'package:penny_pal/providers/savings_provider.dart';
import 'package:penny_pal/screens/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, TransactionProvider>(
          lazy: false,
          create: (_) => TransactionProvider(),
          update: (_, auth, txProvider) =>
              txProvider!..initialize(auth.currentUserData?.userId),
        ),
        ChangeNotifierProxyProvider<AuthProvider, BudgetProvider>(
          lazy: false,
          create: (_) => BudgetProvider(),
          update: (_, auth, budgetProvider) =>
              budgetProvider!..initialize(auth.currentUserData?.userId),
        ),
        ChangeNotifierProxyProvider<AuthProvider, SavingsProvider>(
          lazy: false,
          create: (_) => SavingsProvider(),
          update: (_, auth, savingsProvider) =>
              savingsProvider!..initialize(auth.currentUserData?.userId),
        ),
      ],
      child: const PennyPalApp(),
    ),
  );
}

class PennyPalApp extends StatefulWidget {
  const PennyPalApp({super.key});

  // ignore: library_private_types_in_public_api
  static _PennyPalAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_PennyPalAppState>()!;

  @override
  State<PennyPalApp> createState() => _PennyPalAppState();
}

class _PennyPalAppState extends State<PennyPalApp> {
  ThemeMode _themeMode = ThemeMode.system;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    final savedTheme = _prefs?.getString('themeMode');
    if (savedTheme != null) {
      setState(() {
        if (savedTheme == 'light') _themeMode = ThemeMode.light;
        if (savedTheme == 'dark') _themeMode = ThemeMode.dark;
      });
    }
  }

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      _prefs?.setString('themeMode', _themeMode == ThemeMode.light ? 'light' : 'dark');
    });
  }

  bool get isDarkMode =>
      _themeMode == ThemeMode.dark ||
      (_themeMode == ThemeMode.system &&
          WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PennyPal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthGate(),
        '/login': (context) => const AuthScreen(isLogin: true),
        '/register': (context) => const AuthScreen(isLogin: false),
        '/dashboard': (context) => const DashboardScreen(),
        '/legal': (context) => const LegalScreen(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:penny_pal/screens/landing_screen.dart';
import 'package:penny_pal/screens/dashboard_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the snapshot has user data, then they're logged in
        if (snapshot.hasData) {
          return const DashboardScreen();
        }
        // Otherwise, they're not logged in
        return const LandingScreen();
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pos/Registration.dart';

import 'login.dart';
import 'layered_nav_bar.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        /// 🔄 Show loading while checking session
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        /// ✅ If user is logged in
        if (snapshot.hasData) {
          final user = snapshot.data!;

          // 🔐 If Email provider → check verification
          if (user.providerData.any(
                  (provider) => provider.providerId == 'password')) {

            if (!user.emailVerified) {
              return const LoginPage();
            }
          }

          // ✅ Verified OR Google login
          return const LayeredNavigationExample();
        }

        /// ❌ No user logged in
        return const RegistrationPage();
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'language.dart';
import 'profile.dart';
import 'privacy_policy.dart';
import 'password_security.dart';
import 'terms_conditions.dart';
import 'login.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  final List<String> options = const [
    'Language',
    'Privacy Policy',
    'Password & Security',
    'Terms & Conditions',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // 🔥 CLOSE KEYBOARD
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFdff6fd),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Settings',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
        ),
        body: SingleChildScrollView( // 🔥 Prevent overflow
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ...options.map(
                    (title) => _buildOptionTile(context, title),
              ),
              const SizedBox(height: 20),
              _buildLogoutTile(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(
      BuildContext context, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          FocusScope.of(context).unfocus(); // 🔥 IMPORTANT

          switch (title) {
            case 'Language':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LanguagePage(),
                ),
              );
              break;

            case 'Privacy Policy':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PrivacyPolicyPage(),
                ),
              );
              break;

            case 'Password & Security':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const PasswordSecurityPage(),
                ),
              );
              break;

            case 'Terms & Conditions':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const TermsConditionsPage(),
                ),
              );
              break;

            case 'Profile':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const ProfilePage(),
                ),
              );
              break;
          }
        },
      ),
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ListTile(
        title: const Text(
          'Logout',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.white,
        ),
        onTap: () async {
          FocusScope.of(context).unfocus(); // 🔥 CLOSE KEYBOARD

          bool? confirm = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Confirm Logout"),
              content: const Text(
                  "Are you sure you want to logout?"),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.pop(context, false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pop(context, true),
                  child: const Text(
                    "Logout",
                    style:
                    TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );

          if (confirm == true) {
            await FirebaseAuth.instance.signOut();

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) =>
                const LoginPage(),
              ),
                  (route) => false,
            );
          }
        },
      ),
    );
  }
}
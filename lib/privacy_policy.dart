import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF9FF),
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                spreadRadius: 3,
              )
            ],
          ),
          child: const SingleChildScrollView(
            child: Text(
              "Your privacy is important to us.\n\n"
                  "We collect only necessary information to provide POS services. "
                  "We do not sell or share your personal data.\n\n"
                  "All payment and authentication data is secured using Firebase services.\n\n"
                  "By using this application, you agree to this privacy policy.",
              style: TextStyle(fontSize: 15, height: 1.6),
            ),
          ),
        ),
      ),
    );
  }
}
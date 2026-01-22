import 'package:flutter/material.dart';
import 'layered_nav_bar.dart';
import 'registration.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// 🔥 Prevent keyboard overflow
      resizeToAvoidBottomInset: false,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 40),

                  _buildTextField('Username'),

                  const SizedBox(height: 20),

                  _buildTextField('Password', isPassword: true),

                  const SizedBox(height: 30),

                  /// 🔐 LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 🆕 REGISTER
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RegistrationPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'New user? Register',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🚀 QUICK LOGIN (DEV / DEMO)
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LayeredNavigationExample(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.brown.shade300,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 14,
                      ),
                    ),
                    child: const Text('Continue to POS'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ================== LOGIN HANDLER ==================

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;

    debugPrint('Logging in with $username / $password');

    // TODO: API authentication here

    /// 🔥 Replace login screen with main POS
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LayeredNavigationExample(),
      ),
    );
  }

  /// ================== INPUT FIELD ==================

  Widget _buildTextField(String label, {bool isPassword = false}) {
    return TextFormField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) =>
      value == null || value.isEmpty ? 'Enter $label' : null,
      onChanged: (value) {
        if (label == 'Username') {
          username = value;
        } else {
          password = value;
        }

      },
    );
  }
}

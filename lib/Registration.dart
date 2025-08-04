import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  bool isLoading = false;

  Future<void> _registerUser() async {
    setState(() {
      isLoading = true;
    });

    // Emulator: use 10.0.2.2 instead of localhost
    final url = Uri.parse("http://10.79.128.204/VPS2/register.php");

    try {
      final response = await http.post(url, body: {
        'username': username,
        'email': email,
        'password': password,
      });

      final data = json.decode(response.body);

      if (data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registered successfully")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration failed: ${data['error']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField('Username'),
                const SizedBox(height: 20),
                _buildTextField('Email-id'),
                const SizedBox(height: 20),
                _buildTextField('Password', isPassword: true),
                const SizedBox(height: 20),
                _buildTextField('Confirm-Password', isPassword: true),
                const SizedBox(height: 30),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _registerUser(); // call API
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                  ),
                  child: const Text('Submit'),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.brown[200],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: const Text("already have an account"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {bool isPassword = false}) {
    return TextFormField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.brown[300],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Enter $label';
        if (label == 'Email-id' && !value.contains('@')) return 'Enter valid email';
        if (label == 'Confirm-Password' && value != password) return 'Passwords do not match';
        return null;
      },
      onChanged: (value) {
        setState(() {
          switch (label) {
            case 'Username':
              username = value;
              break;
            case 'Email-id':
              email = value;
              break;
            case 'Password':
              password = value;
              break;
            case 'Confirm-Password':
              confirmPassword = value;
              break;
          }
        });
      },
    );
  }
}

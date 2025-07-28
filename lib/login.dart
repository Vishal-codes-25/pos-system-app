import 'package:flutter/material.dart';
import 'package:pos/layered_nav_bar.dart';
import 'home.dart'; // Optional: for navigating to home screen
import 'registration.dart'; // Optional: for navigating to registration

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Login Page',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                _buildTextField('Username'),
                SizedBox(height: 20),
                _buildTextField('Password', isPassword: true),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // handle login logic
                      print("Logging in with $username");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding:
                    EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                  ),
                  child: Text('Sign up'),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LayeredNavigationExample()),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.brown[400],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  ),
                  child: Text('Already login'),
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
      validator: (value) =>
      value == null || value.isEmpty ? 'Enter $label' : null,
      onChanged: (value) {
        setState(() {
          if (label == 'Username') {
            username = value;
          } else if (label == 'Password') {
            password = value;
          }
        });
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'login.dart'; // Make sure you have login.dart created

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
                Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 30),
                _buildTextField('Username'),
                SizedBox(height: 20),
                _buildTextField('Email-id'),
                SizedBox(height: 20),
                _buildTextField('Password', isPassword: true),
                SizedBox(height: 20),
                _buildTextField('Confirm-Password', isPassword: true),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print("Registered: $username, $email");
                      // Navigate or handle registration logic
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                  ),
                  child: Text('Submit'),
                ),
                SizedBox(height: 15),
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
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: Text("already have an account"),
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

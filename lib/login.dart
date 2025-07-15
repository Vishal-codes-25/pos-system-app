import 'package:flutter/material.dart';
import 'Registration.dart';
import 'home.dart'; // ✅ Temporary home screen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  void loginOwner() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print("Email: $email");
      print("Password: $password");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Owner Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (value) => email = value!.trim(),
                validator: (value) => value!.isEmpty || !value.contains('@')
                    ? 'Enter valid email'
                    : null,
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                onSaved: (value) => password = value!.trim(),
                validator: (value) =>
                value!.isEmpty ? 'Enter your password' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: loginOwner,
                child: Text('Login'),
              ),
              ElevatedButton(
                onPressed: () {
                  // TEMPORARY home navigation
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                  );
                },
                child: Text('Go to Home (Temporary)'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegistrationScreen()),
                  );
                },
                child: Text("Don't have an account? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

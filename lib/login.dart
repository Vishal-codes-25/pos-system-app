import 'package:flutter/material.dart';
import 'registration.dart';

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
      // TODO: Add login validation logic (e.g. check with Firebase or local DB)
      print("Email: $email");
      print("Password: $password");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful')),
      );

      // Navigate to home screen (placeholder)
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
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
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => OwnerRegistrationScreen()),
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

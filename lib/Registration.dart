import 'package:flutter/material.dart';
import 'home.dart'; // For navigation after registration
import 'login.dart'; // For "Already have an account? Login" button

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';

  void registerOwner() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print("Name: $name");
      print("Email: $email");
      print("Password: $password");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration successful")),
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
      appBar: AppBar(title: Text('Owner Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Full Name'),
                onSaved: (value) => name = value!.trim(),
                validator: (value) => value!.isEmpty ? 'Enter your name' : null,
              ),
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
                value!.length < 6 ? 'Minimum 6 characters' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: registerOwner,
                child: Text('Register'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                },
                child: Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

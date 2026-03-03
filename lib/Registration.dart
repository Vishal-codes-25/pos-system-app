import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() =>
      _RegistrationPageState();
}

class _RegistrationPageState
    extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  String username = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  bool isLoading = false;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  /// ================== REGISTER WITH FIREBASE ==================

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      /// 🔐 Create user in Firebase Auth
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      /// 👤 Save extra user data in Firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': username.trim(),
        'email': email.trim(),
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
            content:
            Text('Registered Successfully')),
      );

      /// 🔥 Go to Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const LoginPage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Registration Failed";

      if (e.code == 'email-already-in-use') {
        message = "Email already registered";
      } else if (e.code ==
          'weak-password') {
        message =
        "Password must be at least 6 characters";
      } else if (e.code ==
          'invalid-email') {
        message = "Invalid email address";
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
            content:
            Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// ================== UI ==================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
            const EdgeInsets.symmetric(
                horizontal: 30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize:
                MainAxisSize.min,
                children: [
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                      height: 30),

                  _buildTextField(
                      'Username'),
                  const SizedBox(
                      height: 16),

                  _buildTextField('Email'),
                  const SizedBox(
                      height: 16),

                  _buildTextField(
                      'Password',
                      isPassword:
                      true),
                  const SizedBox(
                      height: 16),

                  _buildTextField(
                      'Confirm Password',
                      isPassword:
                      true),
                  const SizedBox(
                      height: 30),

                  SizedBox(
                    width:
                    double.infinity,
                    child:
                    ElevatedButton(
                      onPressed:
                      isLoading
                          ? null
                          : _registerUser,
                      style: ElevatedButton
                          .styleFrom(
                        backgroundColor:
                        Colors.brown,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                              20),
                        ),
                        padding:
                        const EdgeInsets
                            .symmetric(
                            vertical:
                            14),
                      ),
                      child: isLoading
                          ? const SizedBox(
                        height:
                        22,
                        width:
                        22,
                        child:
                        CircularProgressIndicator(
                          strokeWidth:
                          2,
                          color: Colors
                              .white,
                        ),
                      )
                          : const Text(
                        'Create Account',
                        style:
                        TextStyle(
                            fontSize:
                            16),
                      ),
                    ),
                  ),

                  const SizedBox(
                      height: 16),

                  TextButton(
                    onPressed: () {
                      Navigator
                          .pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const LoginPage(),
                        ),
                      );
                    },
                    child:
                    const Text(
                      'Already have an account? Login',
                      style:
                      TextStyle(
                          color: Colors
                              .brown),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ================== INPUT FIELD ==================

  Widget _buildTextField(String label,
      {bool isPassword = false}) {
    return TextFormField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor:
        Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
              12),
        ),
      ),
      validator: (value) {
        if (value == null ||
            value.isEmpty) {
          return 'Enter $label';
        }
        if (label == 'Email' &&
            !value.contains('@')) {
          return 'Enter valid email';
        }
        if (label ==
            'Confirm Password' &&
            value != password) {
          return 'Passwords do not match';
        }
        return null;
      },
      onChanged: (value) {
        switch (label) {
          case 'Username':
            username = value;
            break;
          case 'Email':
            email = value;
            break;
          case 'Password':
            password = value;
            break;
          case 'Confirm Password':
            confirmPassword =
                value;
            break;
        }
      },
    );
  }
}
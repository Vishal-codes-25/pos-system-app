import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'layered_nav_bar.dart';
import 'registration.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState
    extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool isLoading = false;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  /// ================== AUTO LOGIN CHECK ==================

  @override
  void initState() {
    super.initState();

    /// Delay navigation until first frame
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      _checkUserLoggedIn();
    });
  }

  void _checkUserLoggedIn() {
    final user = _auth.currentUser;

    if (user != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const LayeredNavigationExample(),
        ),
      );
    }
  }

  /// ================== LOGIN HANDLER ==================

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!
        .validate()) return;

    setState(() => isLoading = true);

    try {
      await _auth
          .signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const LayeredNavigationExample(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message =
          "Login Failed";

      switch (e.code) {
        case 'user-not-found':
          message =
          "No user found with this email";
          break;
        case 'wrong-password':
          message =
          "Incorrect password";
          break;
        case 'invalid-email':
          message =
          "Invalid email format";
          break;
        case 'invalid-credential':
          message =
          "Invalid login credentials";
          break;
      }

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
              content:
              Text(message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
              content:
              Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(
                () => isLoading = false);
      }
    }
  }

  /// ================== UI ==================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      Colors.white,
      resizeToAvoidBottomInset:
      false,
      body: SafeArea(
        child: Center(
          child:
          SingleChildScrollView(
            padding:
            const EdgeInsets
                .symmetric(
                horizontal:
                30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize:
                MainAxisSize
                    .min,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight:
                      FontWeight
                          .bold,
                    ),
                  ),
                  const SizedBox(
                      height: 40),

                  _buildTextField(
                      'Email'),
                  const SizedBox(
                      height: 20),
                  _buildTextField(
                      'Password',
                      isPassword:
                      true),
                  const SizedBox(
                      height: 30),

                  /// LOGIN BUTTON
                  SizedBox(
                    width:
                    double
                        .infinity,
                    child:
                    ElevatedButton(
                      onPressed:
                      isLoading
                          ? null
                          : _handleLogin,
                      style: ElevatedButton
                          .styleFrom(
                        backgroundColor:
                        Colors
                            .brown,
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
                          color:
                          Colors
                              .white,
                        ),
                      )
                          : const Text(
                        'Login',
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) =>
                          const RegistrationPage(),
                        ),
                      );
                    },
                    child:
                    const Text(
                      'New user? Register',
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

  Widget _buildTextField(
      String label,
      {bool isPassword =
      false}) {
    return TextFormField(
      obscureText: isPassword,
      decoration:
      InputDecoration(
        labelText: label,
        filled: true,
        fillColor:
        Colors
            .grey
            .shade100,
        border:
        OutlineInputBorder(
          borderRadius:
          BorderRadius
              .circular(
              12),
        ),
      ),
      validator: (value) {
        if (value ==
            null ||
            value
                .isEmpty) {
          return 'Enter $label';
        }
        if (label ==
            'Email' &&
            !value
                .contains('@')) {
          return 'Enter valid email';
        }
        return null;
      },
      onChanged: (value) {
        if (label ==
            'Email') {
          email = value;
        } else {
          password = value;
        }
      },
    );
  }
}
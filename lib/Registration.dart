import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String username = '';
  String email = '';
  String password = '';

  bool isLoading = false;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  // ================= EMAIL REGISTER =================

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User user = userCredential.user!;

      await user.sendEmailVerification();

      await _firestore.collection('users').doc(user.uid).set({
        'username': username.trim(),
        'email': email.trim(),
        'createdAt': Timestamp.now(),
        'provider': 'email',
      });

      await _auth.signOut();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Account created! Verify your email before login."),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Registration failed";

      if (e.code == 'email-already-in-use') {
        message = "Email already registered";
      } else if (e.code == 'weak-password') {
        message = "Password must be at least 6 characters";
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ================= GOOGLE SIGN IN =================

  Future<void> _signInWithGoogle() async {
    try {
      setState(() => isLoading = true);

      final GoogleSignInAccount? googleUser =
      await _googleSignIn.signIn();

      if (googleUser == null) {
        setState(() => isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      User user = userCredential.user!;

      final doc =
      await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        await _firestore.collection('users').doc(user.uid).set({
          'username': user.displayName ?? '',
          'email': user.email,
          'createdAt': Timestamp.now(),
          'provider': 'google',
        });
      }

      // ❌ No manual navigation here
      // ✅ AuthWrapper will automatically redirect

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In failed")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 230,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6D4C41), Color(0xFF4E342E)],
                  ),
                  borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(40)),
                ),
                child: const Center(
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.login),
                            label: const Text(
                              "Continue with Google",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed:
                            isLoading ? null : _signInWithGoogle,
                          ),
                        ),

                        const SizedBox(height: 20),
                        const Text("OR"),
                        const SizedBox(height: 20),

                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildTextField(
                                  "Username", Icons.person),
                              const SizedBox(height: 18),

                              _buildTextField(
                                  "Email", Icons.email),
                              const SizedBox(height: 18),

                              _buildTextField("Password",
                                  Icons.lock,
                                  isPassword: true),
                              const SizedBox(height: 18),

                              _buildTextField(
                                  "Confirm Password",
                                  Icons.lock_outline,
                                  isPassword: true,
                                  isConfirm: true),

                              const SizedBox(height: 30),

                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : _registerUser,
                                  style:
                                  ElevatedButton.styleFrom(
                                    backgroundColor:
                                    const Color(0xFF6D4C41),
                                  ),
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                      color: Colors.white)
                                      : const Text(
                                    "Create Account",
                                    style: TextStyle(
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                  const LoginPage()),
                            );
                          },
                          child: const Text(
                            "Already have an account? Login",
                            style: TextStyle(
                              color: Color(0xFF6D4C41),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= TEXT FIELD =================

  Widget _buildTextField(String label, IconData icon,
      {bool isPassword = false, bool isConfirm = false}) {
    return TextFormField(
      obscureText: isPassword
          ? (isConfirm ? hideConfirmPassword : hidePassword)
          : false,
      decoration: InputDecoration(
        prefixIcon:
        Icon(icon, color: const Color(0xFF6D4C41)),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Enter $label";
        }
        if (label == "Password" && value.length < 6) {
          return "Minimum 6 characters required";
        }
        if (isConfirm && value != password) {
          return "Passwords do not match";
        }
        return null;
      },
      onChanged: (value) {
        if (label == "Username") {
          username = value;
        } else if (label == "Email") {
          email = value;
        } else if (label == "Password") {
          password = value;
        }
      },
    );
  }
}
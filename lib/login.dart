import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'layered_nav_bar.dart';
import 'registration.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String email = '';
  String password = '';

  bool isLoading = false;
  bool hidePassword = true;

  /// ================= AUTO LOGIN =================

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserLoggedIn();
    });
  }

  Future<void> _checkUserLoggedIn() async {
    User? user = _auth.currentUser;

    if (user != null) {
      await user.reload();
      user = _auth.currentUser;

      if (user != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LayeredNavigationExample(),
          ),
        );
      }
    }
  }

  /// ================= EMAIL LOGIN =================

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User user = _auth.currentUser!;
      await user.reload();
      user = _auth.currentUser!;

      /// 🔐 Block if email not verified
      if (!user.emailVerified) {
        await _auth.signOut();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Please verify your email first. Also check Spam folder.",
            ),
          ),
        );

        return;
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LayeredNavigationExample(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Login failed";

      if (e.code == 'user-not-found') {
        message = "No user found";
      } else if (e.code == 'wrong-password') {
        message = "Incorrect password";
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// ================= GOOGLE LOGIN =================

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

      /// Save to Firestore if first time
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

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LayeredNavigationExample(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google login failed: $e")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// ================= UI =================

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
                    "Welcome Back",
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
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField("Email", Icons.email),
                          const SizedBox(height: 18),

                          _buildTextField(
                            "Password",
                            Icons.lock,
                            isPassword: true,
                          ),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed:
                              isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                const Color(0xFF6D4C41),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                ),
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                                  : const Text("Login"),
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Text("OR"),

                          const SizedBox(height: 20),

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
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                  const RegistrationPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "New user? Register",
                              style: TextStyle(
                                color: Color(0xFF6D4C41),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  /// ================= TEXT FIELD =================

  Widget _buildTextField(
      String label,
      IconData icon, {
        bool isPassword = false,
      }) {
    return TextFormField(
      obscureText: isPassword ? hidePassword : false,
      decoration: InputDecoration(
        prefixIcon:
        Icon(icon, color: const Color(0xFF6D4C41)),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            hidePassword
                ? Icons.visibility_off
                : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              hidePassword = !hidePassword;
            });
          },
        )
            : null,
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Enter $label";
        }
        return null;
      },
      onChanged: (value) {
        if (label == "Email") {
          email = value;
        } else {
          password = value;
        }
      },
    );
  }
}
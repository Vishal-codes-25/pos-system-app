import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordSecurityPage extends StatefulWidget {
  const PasswordSecurityPage({super.key});

  @override
  State<PasswordSecurityPage> createState() =>
      _PasswordSecurityPageState();
}

class _PasswordSecurityPageState
    extends State<PasswordSecurityPage> {

  final User? user =
      FirebaseAuth.instance.currentUser;

  bool isLoading = false;

  Future<void> _sendPasswordReset() async {
    if (user == null) return;

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(
        email: user!.email!,
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
              "Password reset email sent."),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
            content: Text(
                "Error: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFF2FBF8),
      appBar: AppBar(
        title: const Text(
            "Password & Security"),
        backgroundColor:
        Colors.white,
        elevation: 0,
        iconTheme:
        const IconThemeData(
            color: Colors.black),
        titleTextStyle:
        const TextStyle(
            color: Colors.black,
            fontWeight:
            FontWeight.bold),
      ),
      body: Padding(
        padding:
        const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding:
              const EdgeInsets.all(
                  20),
              decoration:
              BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius
                    .circular(
                    20),
                boxShadow: [
                  BoxShadow(
                    color: Colors
                        .grey
                        .shade200,
                    blurRadius:
                    10,
                    spreadRadius:
                    3,
                  )
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.lock,
                    size: 50,
                    color:
                    Colors.brown,
                  ),
                  const SizedBox(
                      height: 15),
                  Text(
                    user?.email ??
                        "No email",
                    style:
                    const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight
                          .bold,
                    ),
                  ),
                  const SizedBox(
                      height: 20),
                  SizedBox(
                    width:
                    double.infinity,
                    child:
                    ElevatedButton(
                      onPressed:
                      isLoading
                          ? null
                          : _sendPasswordReset,
                      style: ElevatedButton
                          .styleFrom(
                        backgroundColor:
                        Colors.brown,
                        padding:
                        const EdgeInsets
                            .symmetric(
                            vertical:
                            14),
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                              14),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                          color:
                          Colors
                              .white)
                          : const Text(
                          "Send Reset Email"),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
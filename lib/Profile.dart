import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState
    extends State<ProfilePage> {
  final User? user =
      FirebaseAuth.instance.currentUser;

  String username = '';
  String email = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user == null) return;

    try {
      DocumentSnapshot snapshot =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      setState(() {
        username =
            snapshot['username'] ?? '';
        email = user!.email ?? '';
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFE0F7F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
              color: Colors.black),
        ),
        centerTitle: true,
        iconTheme:
        const IconThemeData(
            color: Colors.black),
      ),
      body: isLoading
          ? const Center(
        child:
        CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment
              .start,
          children: [
            const SizedBox(
                height: 30),

            /// 👤 Profile Avatar
            Center(
              child: CircleAvatar(
                radius: 45,
                backgroundColor:
                Colors.brown
                    .shade200,
                child: Text(
                  username.isNotEmpty
                      ? username[0]
                      .toUpperCase()
                      : '?',
                  style:
                  const TextStyle(
                    fontSize: 40,
                    color:
                    Colors.white,
                    fontWeight:
                    FontWeight
                        .bold,
                  ),
                ),
              ),
            ),

            const SizedBox(
                height: 40),

            buildProfileTile(
              icon: Icons.person,
              label: 'Name',
              value: username,
            ),

            buildProfileTile(
              icon: Icons.email,
              label: 'Email',
              value: email,
            ),

            buildProfileTile(
              icon: Icons
                  .verified_user,
              label: 'User ID',
              value:
              user!.uid
                  .substring(
                  0, 8),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
          horizontal: 25.0,
          vertical: 15),
      child: Row(
        children: [
          Icon(icon,
              size: 28,
              color:
              Colors.black54),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Text(
                label,
                style:
                const TextStyle(
                  fontSize: 14,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
              const SizedBox(
                  height: 4),
              Text(
                value,
                style:
                const TextStyle(
                  fontSize: 16,
                  color:
                  Colors.black87,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
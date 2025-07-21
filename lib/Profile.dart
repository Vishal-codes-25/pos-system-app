import 'package:flutter/material.dart';
import 'layered_nav_bar.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 4;

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/categories');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/cart');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/product');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // 🎁 Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/shopping_banner.jpg'), // 🎁 gift background
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main content
          Column(
            children: [
              const SizedBox(height: 50),
              // ⬅️ Back button + title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: const [
                    Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                    SizedBox(width: 10),
                    Text(
                      "Profile",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 👤 Avatar
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage("assets/images/userimage.jpg"),
              ),
              const SizedBox(height: 30),

              // 📋 Info fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(Icons.person, "Name"),
                    const SizedBox(height: 20),
                    _buildInfoRow(Icons.email, "Email"),
                    const SizedBox(height: 20),
                    _buildInfoRow(Icons.phone, "Phone"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: LayeredNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: Colors.black),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

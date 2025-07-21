import 'package:flutter/material.dart';
import 'scanner.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {'name': 'Cold Drink', 'image': 'assets/images/cold_drink.jpg'},
    {'name': 'Grocery', 'image': 'assets/images/grocery.jpg'},
    {'name': 'Dairy', 'image': 'assets/images/dairy.jpg'},
    {'name': 'Stationary', 'image': 'assets/images/stationary.jpg'},
    {'name': 'Ice Cream', 'image': 'assets/images/ice_cream.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(child: Icon(Icons.person)),
            SizedBox(width: 8),
            Text('User Kirana Store'),
            Spacer(),
            IconButton(
              icon: Icon(Icons.qr_code_scanner),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ScannerPage()),
                );
              },
            )
          ],
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for Product',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
          Image.asset('assets/images/promo_banner.jpg', height: 150), // Your promo image
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('SHOP BY CATEGORIES',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          GridView.builder(
            padding: EdgeInsets.all(10),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(categories[index]['image']!, fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(categories[index]['name']!)
                ],
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Product"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}

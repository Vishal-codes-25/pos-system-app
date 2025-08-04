import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int selectedCategoryIndex = 0;

  final List<String> categories = [
    'Cold Drink',
    'Grocery',
    'Dairy',
    'Stationary',
    'Ice Cream',
  ];

  final Map<String, List<Map<String, String>>> categoryItems = {
    'Cold Drink': [
      {'name': 'Coca cola', 'image': 'assets/images/categories/cola.jpg'},
      {'name': 'Campa', 'image': 'assets/images/categories/Campa.jpg'},
      {'name': 'Sprite', 'image': 'assets/images/categories/Sprite.jpg'},
      {'name': 'Maaza', 'image': 'assets/images/categories/Maaza.jpg'},
      {'name': 'Slice', 'image': 'assets/images/categories/Slice.jpg'},
      {'name': 'Thumbs up', 'image': 'assets/images/categories/Thums.jpg'},
    ],
    'Grocery': [
      {'name': 'TATA Salt', 'image': 'assets/images/categories/Salt.jpg'},
      {'name': 'Fortune besan', 'image': 'assets/images/categories/Besan.jpg'},
      {'name': 'Maggi', 'image': 'assets/images/categories/Maggi.jpg'},
      {'name': 'Brown bread', 'image': 'assets/images/categories/Bread.jpg'},
      {'name': 'Saffola Oats', 'image': 'assets/images/categories/Oats.jpg'},
      {'name': 'Red Label', 'image': 'assets/images/categories/Tea powder.jpg'},
      {'name': 'Corn Flakes', 'image': 'assets/images/categories/Corn Flakes.jpg'},
    ],
    'Dairy': [
      {'name': 'Milk', 'image': 'assets/images/categories/Milk.jpg'},
      {'name': 'Paneer', 'image': 'assets/images/categories/Paneer.jpg'},
      {'name': 'Amul milk', 'image': 'assets/images/categories/Amul.jpg'},
      {'name': 'Cow Ghee', 'image': 'assets/images/categories/Ghee.jpg'},
      {'name': 'Amul Cheese', 'image': 'assets/images/categories/Cheese.jpg'},
    ],
    'Stationary': [
      {'name': 'Note Books', 'image': 'assets/images/categories/Note Books.jpg'},
      {'name': 'Diary', 'image': 'assets/images/categories/Dairy.jpg'},
      {'name': 'Pens', 'image': 'assets/images/categories/Pens.jpg'},
      {'name': 'Nataraj Pencil', 'image': 'assets/images/categories/Pencil.jpg'},
      {'name': 'Sketch pen', 'image': 'assets/images/categories/Sketch pen.jpg'},
      {'name': 'Compass Box', 'image': 'assets/images/categories/Compass Box.jpg'},
    ],
    'Ice Cream': [
      {'name': 'Chocobar', 'image': 'assets/images/categories/Chocobar.jpg'},
      {'name': 'Pista', 'image': 'assets/images/categories/Pista.jpg'},
      {'name': 'Mango', 'image': 'assets/images/categories/Mango.jpg'},
      {'name': 'Vanilla', 'image': 'assets/images/categories/Vanilla.jpg'},
      {'name': 'Butterscotch', 'image': 'assets/images/categories/Butterscotch.jpg'},
      {'name': 'Strawberry', 'image': 'assets/images/categories/Strawberry.jpg'},
      {'name': 'Chocolate', 'image': 'assets/images/categories/Chocolate.jpg'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    String selectedCategory = categories[selectedCategoryIndex];
    List<Map<String, String>> items = categoryItems[selectedCategory]!;

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text('All Categories', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Row(
        children: [
          // Left category list
          Container(
            width: 100,
            color: Colors.white,
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategoryIndex = index;
                    });
                  },
                  child: Container(
                    color: selectedCategoryIndex == index
                        ? Colors.grey[300]
                        : Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/${categories[index].toLowerCase().replaceAll(" ", "_")}.jpg',
                          height: 40,
                        ),
                        SizedBox(height: 5),
                        Text(
                          categories[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Right item grid
          Expanded(
            child: GridView.count(
              padding: EdgeInsets.all(10),
              crossAxisCount: 3,
              childAspectRatio: 0.7,
              children: items.map((item) {
                return Column(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        item['image']!,
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      item['name']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.production_quantity_limits), label: "Product"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
        currentIndex: 1,
        onTap: (index) {
          // TODO: Navigation logic
        },
      ),
    );
  }
}

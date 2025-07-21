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
      {'name': 'Coca cola', 'image': 'assets/cold_drinks/coca_cola.png'},
      {'name': 'Campa', 'image': 'assets/cold_drinks/campa.png'},
      {'name': 'Sting', 'image': 'assets/cold_drinks/sting.png'},
      {'name': 'Sprite', 'image': 'assets/cold_drinks/sprite.png'},
      {'name': 'Maaza', 'image': 'assets/cold_drinks/maaza.png'},
      {'name': 'Slice', 'image': 'assets/cold_drinks/slice.png'},
      {'name': 'Thumbs up', 'image': 'assets/cold_drinks/thumbs_up.png'},
    ],
    'Grocery': [
      {'name': 'TATA Salt', 'image': 'assets/grocery/salt.png'},
      {'name': 'Fortune besan', 'image': 'assets/grocery/besan.png'},
      {'name': 'Maggi', 'image': 'assets/grocery/maggi.png'},
      {'name': 'Brown bread', 'image': 'assets/grocery/bread.png'},
      {'name': 'Saffola Oats', 'image': 'assets/grocery/oats.png'},
      {'name': 'Red Label', 'image': 'assets/grocery/tea.png'},
      {'name': 'Corn Flakes', 'image': 'assets/grocery/cornflakes.png'},
    ],
    'Dairy': [
      {'name': 'Milk', 'image': 'assets/dairy/milk.png'},
      {'name': 'Paneer', 'image': 'assets/dairy/paneer.png'},
      {'name': 'Amul milk', 'image': 'assets/dairy/amul_milk.png'},
      {'name': 'Cow Ghee', 'image': 'assets/dairy/ghee.png'},
      {'name': 'Amul Cheese', 'image': 'assets/dairy/cheese.png'},
    ],
    'Stationary': [
      {'name': 'Note Books', 'image': 'assets/stationary/notebook.png'},
      {'name': 'Diary', 'image': 'assets/stationary/diary.png'},
      {'name': 'Pens', 'image': 'assets/stationary/pens.png'},
      {'name': 'Nataraj Pencil', 'image': 'assets/stationary/pencil.png'},
      {'name': 'Sketch pen', 'image': 'assets/stationary/sketch_pen.png'},
      {'name': 'Compass Box', 'image': 'assets/stationary/compass_box.png'},
    ],
    'Ice Cream': [
      {'name': 'Chocobar', 'image': 'assets/ice_cream/chocobar.png'},
      {'name': 'Pista', 'image': 'assets/ice_cream/pista.png'},
      {'name': 'Mango', 'image': 'assets/ice_cream/mango.png'},
      {'name': 'Vanilla', 'image': 'assets/ice_cream/vanilla.png'},
      {'name': 'Butterscotch', 'image': 'assets/ice_cream/butterscotch.png'},
      {'name': 'Strawberry', 'image': 'assets/ice_cream/strawberry.png'},
      {'name': 'Chocolate', 'image': 'assets/ice_cream/chocolate.png'},
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
                          'assets/icons/${categories[index].toLowerCase().replaceAll(" ", "_")}.png',
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

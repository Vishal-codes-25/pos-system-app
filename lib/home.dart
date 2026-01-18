import 'package:flutter/material.dart';
import 'scanner.dart';
import 'Cart.dart';
import 'controllers/scan_controller.dart';
import 'services/db_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<CategoryModel> categories = [
    CategoryModel('Cold Drink', 'assets/images/cold_drink.jpg'),
    CategoryModel('Grocery', 'assets/images/grocery.jpg'),
    CategoryModel('Dairy', 'assets/images/dairy.jpg'),
    CategoryModel('Stationary', 'assets/images/stationary.jpg'),
    CategoryModel('Ice Cream', 'assets/images/ice_cream.jpg'),
  ];

  // ================== SCANNER FLOW ==================

  Future<void> openScanner() async {
    final barcode = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ScannerPage()),
    );

    if (barcode == null || barcode.toString().isEmpty) return;

    final product = await ScanController.handleScan(barcode);

    if (product == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product not found')),
      );
      return;
    }

    debugPrint('SCANNED PRODUCT: $product');

    // 🟡 If product came from API → confirm
    if ((product['source'] ?? 'database') == 'api') {
      final updatedProduct = await _showProductDialog(product);
      if (updatedProduct == null) return;

      product
        ..['name'] = updatedProduct['name']
        ..['brand'] = updatedProduct['brand']
        ..['price'] = updatedProduct['price'];

      await DBService.saveProduct(product);
    }

    // 🔒 Safety checks before adding to cart
    if (product['barcode'] == null ||
        product['name'] == null ||
        product['price'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid product data')),
      );
      return;
    }

    // 🔥 Ensure price is double
    product['price'] = (product['price'] as num).toDouble();

    // ✅ ADD TO CART (this triggers notifier)
    CartPage.addToCart(product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart'),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),

      ),
    );
  }


  // ================== CONFIRM PRODUCT POPUP ==================

  Future<Map<String, dynamic>?> _showProductDialog(
      Map<String, dynamic> product,
      ) async {
    final nameController =
    TextEditingController(text: product['name'] ?? '');

    final brandController =
    TextEditingController(text: product['brand'] ?? '');

    final priceController = TextEditingController(
      text: (product['price'] != null && product['price'] > 0)
          ? product['price'].toString()
          : '',
    );

    return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Product Name
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                // Brand
                TextField(
                  controller: brandController,
                  decoration: const InputDecoration(
                    labelText: 'Brand',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                // Price
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    prefixText: '₹ ',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final price = double.tryParse(priceController.text);

                if (nameController.text.trim().isEmpty ||
                    brandController.text.trim().isEmpty ||
                    price == null ||
                    price <= 0) {
                  return;
                }

                Navigator.pop(context, {
                  'name': nameController.text.trim(),
                  'brand': brandController.text.trim(),
                  'price': price,
                });
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  // ================== UI ==================

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: _buildAppBar(),
        body: ListView(
          padding: const EdgeInsets.only(bottom: 16),
          children: [
            _buildSearchBar(),
            _buildBanner(),
            _buildCategoryTitle(),
            _buildCategoryGrid(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.black12,
            child: Icon(Icons.store, color: Colors.black),
          ),
          const SizedBox(width: 10),
          const Text(
            'User Kirana Store',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Colors.black),
            onPressed: openScanner,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search product or scan barcode',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/images/shopingcartimage.png',
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCategoryTitle() {
    return const Padding(
      padding: EdgeInsets.all(12),
      child: Text(
        'SHOP BY CATEGORIES',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (_, index) {
        final category = categories[index];
        return CategoryCard(category: category);
      },
    );
  }
}

// ================== MODELS & WIDGETS ==================

class CategoryModel {
  final String name;
  final String image;

  CategoryModel(this.name, this.image);
}

class CategoryCard extends StatelessWidget {
  final CategoryModel category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                category.image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              category.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

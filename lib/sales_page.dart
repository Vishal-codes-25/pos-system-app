import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SalesPage extends StatefulWidget {
  final String type; // 'daily', 'weekly', 'monthly', 'yearly'

  const SalesPage({super.key, required this.type});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  late Future<List<Map<String, dynamic>>> _salesData;

  @override
  void initState() {
    super.initState();
    _salesData = fetchSales(widget.type);
  }

  Future<List<Map<String, dynamic>>> fetchSales(String type) async {
    final response = await http.get(
      Uri.parse('http://your_ip/get_sales.php?type=$type'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load sales');
    }
  }

  double getTotal(List<Map<String, dynamic>> sales) {
    return sales.fold(0.0, (sum, item) => sum + double.parse(item['total_price'].toString()));
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.type[0].toUpperCase() + widget.type.substring(1) + " Sales";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: BackButton(),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _salesData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No sales data found"));
          } else {
            final sales = snapshot.data!;
            final total = getTotal(sales);

            return Column(
              children: [
                DataTable(columns: const [
                  DataColumn(label: Text("Sr.")),
                  DataColumn(label: Text("Product_name")),
                  DataColumn(label: Text("Quan")),
                  DataColumn(label: Text("Price")),
                ], rows: [
                  for (int i = 0; i < sales.length; i++)
                    DataRow(cells: [
                      DataCell(Text('${i + 1}')),
                      DataCell(Text(sales[i]['product_name'].toString())),
                      DataCell(Text(sales[i]['total_quantity'].toString())),
                      DataCell(Text('₹${sales[i]['total_price'].toString()}')),
                    ])
                ]),
                const SizedBox(height: 20),
                Text(
                  "$title = ₹${total.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

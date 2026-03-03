import 'package:flutter/material.dart';

class SaleDetailsPage extends StatelessWidget {
  final Map<String, dynamic> saleData;

  const SaleDetailsPage({super.key, required this.saleData});

  @override
  Widget build(BuildContext context) {
    final items = saleData['items'] as List;
    final total = saleData['totalAmount'];
    final cash = saleData['cashReceived'];
    final change = saleData['change'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sale Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, index) {
                  final item = items[index];

                  return Card(
                    child: ListTile(
                      title: Text(item['name']),
                      subtitle: Text(
                          "₹${item['price']} x ${item['quantity']}"),
                      trailing: Text(
                        "₹${item['subtotal']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            _buildRow("Total", total),
            _buildRow("Cash", cash),
            _buildRow("Change", change),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold)),
          Text("₹${amount.toStringAsFixed(2)}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
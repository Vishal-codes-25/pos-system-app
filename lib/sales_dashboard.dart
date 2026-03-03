import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sale_details_page.dart';

class SalesDashboardPage extends StatelessWidget {
  const SalesDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('sales')
              .where('userId', isEqualTo: user.uid)
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (context, snapshot) {

            /// 🔴 SHOW ERROR IF INDEX MISSING
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Error:\n${snapshot.error}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            }

            /// ⏳ LOADING
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator());
            }

            /// 📭 EMPTY DATA
            if (!snapshot.hasData ||
                snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No sales yet",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            final sales = snapshot.data!.docs;
            final now = DateTime.now();

            double todayTotal = 0;
            double weeklyTotal = 0;
            double monthlyTotal = 0;
            double yearlyTotal = 0;

            for (var doc in sales) {
              final data =
              doc.data() as Map<String, dynamic>;

              final amount =
              (data['totalAmount'] ?? 0)
                  .toDouble();

              if (data['date'] == null) continue;

              final date =
              (data['date'] as Timestamp)
                  .toDate();

              if (_isSameDay(date, now)) {
                todayTotal += amount;
              }

              if (now.difference(date).inDays <= 7) {
                weeklyTotal += amount;
              }

              if (date.month == now.month &&
                  date.year == now.year) {
                monthlyTotal += amount;
              }

              if (date.year == now.year) {
                yearlyTotal += amount;
              }
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSalesCards(
                  todayTotal,
                  weeklyTotal,
                  monthlyTotal,
                  yearlyTotal,
                ),
                const SizedBox(height: 20),
                _buildOrderSummary(sales.length),
                const SizedBox(height: 20),
                _buildRecentTransactions(context, sales),
              ],
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        "Sales Dashboard",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSalesCards(
      double today,
      double weekly,
      double monthly,
      double yearly,
      ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: SalesCard(
                    title: "Today", amount: today)),
            const SizedBox(width: 12),
            Expanded(
                child: SalesCard(
                    title: "Weekly",
                    amount: weekly)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: SalesCard(
                    title: "Monthly",
                    amount: monthly)),
            const SizedBox(width: 12),
            Expanded(
                child: SalesCard(
                    title: "Yearly",
                    amount: yearly)),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderSummary(int totalOrders) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.brown.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text("Total Orders"),
              const SizedBox(height: 5),
              Text(
                totalOrders.toString(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Icon(Icons.receipt_long,
              size: 40, color: Colors.brown),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(
      BuildContext context,
      List<QueryDocumentSnapshot> sales,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent Transactions",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...sales.take(5).map((doc) {
          final data =
          doc.data() as Map<String, dynamic>;

          final amount =
          (data['totalAmount'] ?? 0)
              .toDouble();

          final date =
          (data['date'] as Timestamp)
              .toDate();

          final items =
              data['items'] as List? ?? [];

          return Container(
            margin:
            const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        SaleDetailsPage(
                          saleData: data,
                        ),
                  ),
                );
              },
              title: Text(
                "Sale - ${date.day}/${date.month}/${date.year}",
                style: const TextStyle(
                    fontWeight:
                    FontWeight.w600),
              ),
              subtitle:
              Text("${items.length} Items"),
              trailing: Text(
                "₹ ${amount.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontWeight:
                  FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  static bool _isSameDay(
      DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}

class SalesCard extends StatelessWidget {
  final String title;
  final double amount;

  const SalesCard({
    super.key,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Text(title),
          const SizedBox(height: 8),
          Text(
            "₹ ${amount.toStringAsFixed(0)}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight:
              FontWeight.bold,
              color: Colors.brown,
            ),
          ),
        ],
      ),
    );
  }
}
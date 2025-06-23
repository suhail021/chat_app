import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final items = prefs.getStringList('cart') ?? [];

    setState(() {
      cartItems = items.map((e) => Map<String, dynamic>.from(jsonDecode(e))).toList();
    });
  }

  Future<void> removeItem(int index) async {
    final prefs = await SharedPreferences.getInstance();
    cartItems.removeAt(index);
    final updated = cartItems.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('cart', updated);
    setState(() {});
  }

  double getTotalPrice() {
    double total = 0.0;
    for (var item in cartItems) {
      final priceString = item['price'].toString().replaceAll(RegExp(r'[^\d.]'), '');
      final quantityString = item['quantity'].toString();
      final price = double.tryParse(priceString) ?? 0.0;
      final quantity = int.tryParse(quantityString) ?? 1;
      total += price * quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('سلة المشتريات')),
      body: cartItems.isEmpty
          ? Center(child: Text('السلة فارغة'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(item['name'] ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('السعر: ${item['price']}'),
                        Text('اللون: ${item['color']}'),
                        Text('المقاس: ${item['size']}'),
                        Text('الكمية: ${item['quantity']}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => removeItem(index),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'السعر الإجمالي: \$${getTotalPrice().toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
    );
  }
}

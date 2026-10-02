import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  List<Map<String, dynamic>> variants = [];
  bool loading = false;
  String? selected;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    List<Map<String, dynamic>> data = [
      {'id': '1', 'name': '1 Kg'},
      {'id': '2', 'name': '5 Kg'},
    ];
    if (mounted) {
      setState(() {
        variants = List<Map<String, dynamic>>.from(data);
        loading = false;
        selected = data.isNotEmpty ? data.first['id'].toString() : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['name'] ?? 'Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.product['name'] ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Price: ₹${widget.product['price']}',
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ),
            const SizedBox(height: 20),
            const Text('Available Variants:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...variants.map((v) => ListTile(
              title: Text(v['name']),
              leading: Radio<String>(
                value: v['id'],
                groupValue: selected,
                onChanged: (val) {
                  setState(() {
                    selected = val;
                  });
                },
              ),
            )),
          ],
        ),
      ),
    );
  }
}

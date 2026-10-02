import 'package:flutter/material.dart';
import 'data.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  void _openAddSizeDialog(Map<String, dynamic> product) {
    final sCtrl = TextEditingController();
    final pCtrl = TextEditingController();
    final mrpCtrl = TextEditingController();
    final stockCtrl = TextEditingController(text: '50');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${product['name']} - नया पैक जोड़ें'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: sCtrl, decoration: const InputDecoration(labelText: 'पैक साइज़ (उदा. 250 ग्राम / 1 ली)')),
            TextField(controller: pCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'सेलिंग प्राइस (₹)')),
            TextField(controller: mrpCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'MRP (₹)')),
            TextField(controller: stockCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'स्टॉक मात्रा')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('रद्द')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B6B3A), foregroundColor: Colors.white),
            onPressed: () {
              if (sCtrl.text.isNotEmpty && pCtrl.text.isNotEmpty) {
                setState(() {
                  (product['sizes'] as List).add({
                    's': sCtrl.text.trim(),
                    'p': int.tryParse(pCtrl.text.trim()) ?? 100,
                    'mrp': int.tryParse(mrpCtrl.text.trim()) ?? 120,
                    'stock': int.tryParse(stockCtrl.text.trim()) ?? 50,
                    'inStock': true,
                    'sku': 'SKU-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
                  });
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('जोड़ें'),
          )
        ],
      ),
    );
  }

  void _editTrackingDialog(Map<String, dynamic> order) {
    final courierCtrl = TextEditingController(text: order['courier'] ?? '');
    final trkCtrl = TextEditingController(text: order['trackingNo'] ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('ऑर्डर #${order['id']} ट्रैकिंग अपडेट'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: courierCtrl, decoration: const InputDecoration(labelText: 'कूरियर कंपनी (DTDC/Speed Post)')),
            TextField(controller: trkCtrl, decoration: const InputDecoration(labelText: 'कूरियर ट्रैकिंग नंबर (AWB/Docket)')),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B6B3A), foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                order['courier'] = courierCtrl.text.trim();
                order['trackingNo'] = trkCtrl.text.trim();
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ट्रैकिंग विवरण सुरक्षित हुआ ✓')));
            },
            child: const Text('सेव करें'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚙️ एडमिन कंट्रोल रूम'),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.inventory_2), text: 'स्टॉक व पैक साइज़'),
            Tab(icon: Icon(Icons.local_shipping), text: 'बुकिंग व ट्रैकिंग'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          // TAB 1: Stock & Pack Size Management
          ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            itemBuilder: (ctx, i) {
              final p = products[i];
              final sizes = p['sizes'] as List<dynamic>;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(p['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                          IconButton(
                            icon: const Icon(Icons.add_circle, color: Color(0xFF0B6B3A)),
                            onPressed: () => _openAddSizeDialog(p),
                            tooltip: 'नया पैक जोड़ें',
                          )
                        ],
                      ),
                      const Divider(),
                      ...List.generate(sizes.length, (si) {
                        final s = sizes[si];
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text('${s['s']}\n₹${s['p']} (MRP ₹${s['mrp']})', style: const TextStyle(fontSize: 12)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('स्टॉक: ${s['stock']}\n(${s['sku'] ?? 'SKU'})', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                              ),
                              Switch(
                                value: s['inStock'] ?? true,
                                activeColor: const Color(0xFF0B6B3A),
                                onChanged: (val) {
                                  setState(() {
                                    s['inStock'] = val;
                                  });
                                },
                              ),
                              Text(s['inStock'] ? 'In Stock' : 'Out', style: TextStyle(fontSize: 11, color: s['inStock'] ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),

          // TAB 2: Booking, Payment & Tracking Management
          orders.isEmpty
              ? const Center(child: Text('अभी कोई ऑर्डर बुकिंग नहीं है'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: orders.length,
                  itemBuilder: (ctx, i) {
                    final o = orders[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('#${o['id']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                Chip(
                                  label: Text(o['status'] ?? 'बुकिंग प्राप्त', style: const TextStyle(fontSize: 11, color: Color(0xFF0B6B3A))),
                                  backgroundColor: const Color(0xFFEAF8EF),
                                ),
                              ],
                            ),
                            Text('ग्राहक: ${o['name']} (${o['phone']})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            Text('पता: ${o['addr']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text('आइटम: ${o['items']}'),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text('पेमेंट: ${o['payMode']} - ', style: const TextStyle(fontSize: 12)),
                                Text('${o['payStatus']}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: o['payStatus'].toString().contains('Paid') ? Colors.green : Colors.orange)),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('कूरियर: ${o['courier'] ?? 'असाइन नहीं'}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                    Text('ट्रैकिंग नं: ${o['trackingNo'] ?? 'उपलब्ध नहीं'}', style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
                                  ],
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B6B3A), foregroundColor: Colors.white),
                                  onPressed: () => _editTrackingDialog(o),
                                  icon: const Icon(Icons.edit, size: 14),
                                  label: const Text('ट्रैकिंग भरें', style: TextStyle(fontSize: 11)),
                                )
                              ],
                            ),
                            const SizedBox(height: 6),
                            DropdownButton<String>(
                              value: o['status'] ?? 'ऑर्डर प्राप्त',
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem(value: 'ऑर्डर प्राप्त', child: Text('1. बुकिंग प्राप्त (Order Booked)')),
                                DropdownMenuItem(value: 'पैकिंग चालू', child: Text('2. पैकिंग चालू (Packing)')),
                                DropdownMenuItem(value: 'डिस्पैच / रवाना', child: Text('3. डिस्पैच / रवाना (Dispatched)')),
                                DropdownMenuItem(value: 'डिलीवर हो गया', child: Text('4. डिलीवर हो गया (Delivered)')),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => o['status'] = val);
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}

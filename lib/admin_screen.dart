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
    _tab = TabController(length: 3, vsync: this);
  }

  void _openAddProductDialog() {
    final nameHiCtrl = TextEditingController();
    final nameEnCtrl = TextEditingController();
    final brandCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String catVal = 'बीज';
    List<Map<String, dynamic>> tempSizes = [
      {'s': '1 किग्रा', 'p': 200, 'mrp': 250, 'stock': 50, 'inStock': true}
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            left: 16, right: 16, top: 16,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text('＋ नया उत्पाद जोड़ें (No-Code Form)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0B6B3A))),
              const SizedBox(height: 12),
              TextField(controller: nameHiCtrl, decoration: const InputDecoration(labelText: 'उत्पाद का नाम (हिन्दी में)', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: nameEnCtrl, decoration: const InputDecoration(labelText: 'Product Name (in English)', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: brandCtrl, decoration: const InputDecoration(labelText: 'कंपनी / ब्रांड (उदा. Syngenta, Bayer, FMC)', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: catVal,
                decoration: const InputDecoration(labelText: 'श्रेणी (Category)', border: OutlineInputBorder()),
                items: ['बीज', 'खाद', 'दवा', 'मल्चिंग', 'कृषि उपकरण'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setModalState(() => catVal = v!),
              ),
              const SizedBox(height: 8),
              TextField(controller: descCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'उत्पाद विवरण (उपयोग विधि / लाभ)', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('पैक साइज़ व कीमतें:', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextButton.icon(
                    onPressed: () {
                      setModalState(() {
                        tempSizes.add({'s': '100 ग्राम', 'p': 100, 'mrp': 120, 'stock': 30, 'inStock': true});
                      });
                    },
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('और साइज़ जोड़ें'),
                  ),
                ],
              ),
              ...List.generate(tempSizes.length, (si) => Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Expanded(child: TextFormField(initialValue: tempSizes[si]['s'], decoration: const InputDecoration(labelText: 'साइज़'), onChanged: (v) => tempSizes[si]['s'] = v)),
                    const SizedBox(width: 6),
                    Expanded(child: TextFormField(initialValue: '${tempSizes[si]['p']}', keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'रेट (₹)'), onChanged: (v) => tempSizes[si]['p'] = int.tryParse(v) ?? 0)),
                    const SizedBox(width: 6),
                    Expanded(child: TextFormField(initialValue: '${tempSizes[si]['stock']}', keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'स्टॉक'), onChanged: (v) => tempSizes[si]['stock'] = int.tryParse(v) ?? 0)),
                  ],
                ),
              )),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B6B3A), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () {
                  if (nameHiCtrl.text.isEmpty || brandCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('उत्पाद का नाम और कंपनी भरें')));
                    return;
                  }
                  setState(() {
                    products.insert(0, {
                      'id': DateTime.now().millisecondsSinceEpoch,
                      'brand': brandCtrl.text.trim(),
                      'name_hi': nameHiCtrl.text.trim(),
                      'name_en': nameEnCtrl.text.isEmpty ? nameHiCtrl.text.trim() : nameEnCtrl.text.trim(),
                      'cat': catVal,
                      'img': 'https://images.unsplash.com/photo-1592417817098-8f3d69102553?w=400',
                      'desc': descCtrl.text.trim(),
                      'sizes': tempSizes.map((s) => {
                        's': s['s'],
                        'p': s['p'],
                        'mrp': (s['p'] as int) + 30,
                        'stock': s['stock'],
                        'inStock': true,
                        'sku': 'SKU-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}'
                      }).toList(),
                    });
                  });
                  Navigator.pop(bctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('उत्पाद स्टोर में जुड़ गया ✓')));
                },
                child: const Text('उत्पाद स्टोर में लाइव करें'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚙️ एडमिन कंट्रोल पैनल'),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.inventory_2), text: 'उत्पाद व स्टॉक'),
            Tab(icon: Icon(Icons.local_shipping), text: 'बुकिंग व ट्रैकिंग'),
            Tab(icon: Icon(Icons.headset_mic), text: 'हेल्प डेस्क'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          // 1. PRODUCT & STOCK TAB
          ListView(
            padding: const EdgeInsets.all(12),
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B6B3A), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                onPressed: _openAddProductDialog,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('＋ नया उत्पाद व कंपनी जोड़ें (No-Code Form)'),
              ),
              const SizedBox(height: 12),
              ...List.generate(products.length, (i) {
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
                            Text(p['brand'] ?? 'Company', style: const TextStyle(color: Color(0xFF0B6B3A), fontWeight: FontWeight.bold, fontSize: 11)),
                            IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20), onPressed: () => setState(() => products.removeAt(i))),
                          ],
                        ),
                        Text(p['name_hi'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const Divider(),
                        ...List.generate(sizes.length, (si) {
                          final s = sizes[si];
                          return Row(
                            children: [
                              Expanded(flex: 2, child: Text('${s['s']} - ₹${s['p']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text('स्टॉक: ${s['stock']}', style: const TextStyle(fontSize: 11, color: Colors.grey))),
                              Switch(
                                value: s['inStock'] ?? true,
                                activeColor: const Color(0xFF0B6B3A),
                                onChanged: (val) => setState(() => s['inStock'] = val),
                              ),
                              Text(s['inStock'] ? 'In' : 'Out', style: TextStyle(fontSize: 11, color: s['inStock'] ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),

          // 2. BOOKING & TRACKING TAB
          orders.isEmpty
              ? const Center(child: Text('कोई बुकिंग नहीं है'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: orders.length,
                  itemBuilder: (ctx, i) {
                    final o = orders[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('#${o['id']} - ${o['customer'] ?? o['name']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('आइटम: ${o['items']}'),
                            Text('पेमेंट: ${o['payMode']} (${o['payStatus']})', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(height: 6),
                            DropdownButton<String>(
                              value: o['status'] ?? 'ऑर्डर प्राप्त',
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem(value: 'ऑर्डर प्राप्त', child: Text('1. बुकिंग प्राप्त (Booked)')),
                                DropdownMenuItem(value: 'पैकिंग चालू', child: Text('2. पैकिंग चालू (Packing)')),
                                DropdownMenuItem(value: 'डिस्पैच / रवाना', child: Text('3. डिस्पैच / रवाना (Dispatched)')),
                                DropdownMenuItem(value: 'डिलीवर हो गया', child: Text('4. डिलीवर हो गया (Delivered)')),
                              ],
                              onChanged: (v) {
                                if (v != null) setState(() => o['status'] = v);
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),

          // 3. HELP DESK TICKETS TAB
          helpTickets.isEmpty
              ? const Center(child: Text('अभी कोई सहायता टिकट दर्ज नहीं है'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: helpTickets.length,
                  itemBuilder: (ctx, i) => Card(
                    child: ListTile(
                      title: Text(helpTickets[i]['subject'] ?? 'समस्या'),
                      subtitle: Text('${helpTickets[i]['message']}\nमोबाइल: ${helpTickets[i]['phone']}'),
                      trailing: const Chip(label: Text('Open', style: TextStyle(fontSize: 10))),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

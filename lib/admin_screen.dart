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
    _tab = TabController(length: 4, vsync: this);
  }

  void _openEditProductDialog(Map<String, dynamic> p) {
    final nameHiCtrl = TextEditingController(text: p['name_hi']);
    final nameEnCtrl = TextEditingController(text: p['name_en']);
    final brandCtrl = TextEditingController(text: p['brand']);
    final sizes = List<Map<String, dynamic>>.from(p['sizes']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bctx) => StatefulBuilder(
        builder: (ctx, setMState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            left: 16, right: 16, top: 16,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('✏️ उत्पाद एडिट करें', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0B6B3A))),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(bctx)),
                ],
              ),
              const SizedBox(height: 10),
              TextField(controller: nameHiCtrl, decoration: const InputDecoration(labelText: 'नाम (हिन्दी)', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: nameEnCtrl, decoration: const InputDecoration(labelText: 'Name (English)', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: brandCtrl, decoration: const InputDecoration(labelText: 'कंपनी / ब्रांड', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              const Text('पैक साइज़, रेट और स्टॉक सुधारें:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              ...List.generate(sizes.length, (si) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Expanded(child: TextFormField(initialValue: sizes[si]['s'], decoration: const InputDecoration(labelText: 'साइज़'), onChanged: (v) => sizes[si]['s'] = v)),
                    const SizedBox(width: 6),
                    Expanded(child: TextFormField(initialValue: '${sizes[si]['p']}', keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'रेट (₹)'), onChanged: (v) => sizes[si]['p'] = int.tryParse(v) ?? 0)),
                    const SizedBox(width: 6),
                    Expanded(child: TextFormField(initialValue: '${sizes[si]['stock']}', keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'स्टॉक'), onChanged: (v) => sizes[si]['stock'] = int.tryParse(v) ?? 0)),
                  ],
                ),
              )),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B6B3A), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () {
                  setState(() {
                    p['name_hi'] = nameHiCtrl.text.trim();
                    p['name_en'] = nameEnCtrl.text.trim();
                    p['brand'] = brandCtrl.text.trim();
                    p['sizes'] = sizes;
                  });
                  Navigator.pop(bctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('उत्पाद का विवरण अपडेट हो गया ✓')));
                },
                child: const Text('बदलाव सेव करें'),
              ),
            ],
          ),
        ),
      ),
    );
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
        builder: (ctx, setMState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            left: 16, right: 16, top: 16,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text('＋ नया उत्पाद जोड़ें', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0B6B3A))),
              const SizedBox(height: 12),
              TextField(controller: nameHiCtrl, decoration: const InputDecoration(labelText: 'उत्पाद का नाम (हिन्दी)', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: nameEnCtrl, decoration: const InputDecoration(labelText: 'Product Name (English)', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: brandCtrl, decoration: const InputDecoration(labelText: 'कंपनी / ब्रांड', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: catVal,
                decoration: const InputDecoration(labelText: 'श्रेणी (Category)', border: OutlineInputBorder()),
                items: ['बीज', 'खाद', 'दवा', 'मल्चिंग', 'कृषि उपकरण'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setMState(() => catVal = v!),
              ),
              const SizedBox(height: 8),
              TextField(controller: descCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'विवरण', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B6B3A), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () {
                  if (nameHiCtrl.text.isEmpty || brandCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('नाम व कंपनी भरें')));
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
                      'sizes': tempSizes,
                    });
                  });
                  Navigator.pop(bctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('उत्पाद जुड़ गया ✓')));
                },
                child: const Text('स्टोर में जोड़ें'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editBannerDialog(Map<String, dynamic> b) {
    final titleCtrl = TextEditingController(text: b['title']);
    final textCtrl = TextEditingController(text: b['text']);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${b['title']} बदलें'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'शीर्षक (Title)')),
            const SizedBox(height: 8),
            TextField(controller: textCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'संदेश / ऑफ़र / सूचना')),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B6B3A), foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                b['title'] = titleCtrl.text.trim();
                b['text'] = textCtrl.text.trim();
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('बैनर अपडेट हो गया ✓')));
            },
            child: const Text('सेव करें'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wpCtrl = TextEditingController(text: helpConfig['whatsapp']);
    final callCtrl = TextEditingController(text: helpConfig['phone']);
    final ytCtrl = TextEditingController(text: helpConfig['youtube']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('⚙️ एडमिन कंट्रोल पैनल'),
        bottom: TabBar(
          controller: _tab,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.inventory_2), text: 'उत्पाद व स्टॉक'),
            Tab(icon: Icon(Icons.campaign), text: 'ऑफ़र व सूचना पट्टी'),
            Tab(icon: Icon(Icons.headset_mic), text: 'हेल्प व सोशल लिंक'),
            Tab(icon: Icon(Icons.local_shipping), text: 'बुकिंग व ट्रैकिंग'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          // 1. उत्पाद सूची, रेट, स्टॉक व एडिट
          ListView(
            padding: const EdgeInsets.all(12),
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B6B3A), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                onPressed: _openAddProductDialog,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('＋ नया उत्पाद जोड़ें (Add Product)'),
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
                            Row(
                              children: [
                                IconButton(icon: const Icon(Icons.edit, color: Colors.blue, size: 20), onPressed: () => _openEditProductDialog(p)),
                                IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20), onPressed: () => setState(() => products.removeAt(i))),
                              ],
                            ),
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

          // 2. होम पेज की 2 पट्टियाँ (ऑफ़र व सूचना)
          ListView(
            padding: const EdgeInsets.all(12),
            children: [
              const Text('होम पेज बैनर एवं स्टिकर कंट्रोल:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 6),
              const Text('यहाँ से छूट पट्टी और आवश्यक सूचना को चालू/बंद या एडिट करें।', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 12),
              ...List.generate(homeBanners.length, (bi) {
                final b = homeBanners[bi];
                final isGreen = b['color'] == 'green';
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: isGreen ? Colors.green : Colors.orange, width: 1.5)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(b['title'], style: TextStyle(fontWeight: FontWeight.bold, color: isGreen ? const Color(0xFF0B6B3A) : Colors.deepOrange)),
                            Switch(
                              value: b['isActive'] ?? true,
                              activeColor: isGreen ? const Color(0xFF0B6B3A) : Colors.orange,
                              onChanged: (v) => setState(() => b['isActive'] = v),
                            ),
                          ],
                        ),
                        Text(b['text'], style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: isGreen ? const Color(0xFF0B6B3A) : Colors.orange, foregroundColor: Colors.white),
                            onPressed: () => _editBannerDialog(b),
                            icon: const Icon(Icons.edit, size: 14),
                            label: const Text('संदेश बदलें', style: TextStyle(fontSize: 12)),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),

          // 3. हेल्प डेस्क व सोशल सेटिंग्स
          ListView(
            padding: const EdgeInsets.all(14),
            children: [
              const Text('हेल्प डेस्क व सोशल मीडिया सेटिंग्स:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 12),
              TextField(controller: wpCtrl, decoration: const InputDecoration(labelText: 'WhatsApp नंबर (उदा. 919876543210)', prefixIcon: Icon(Icons.chat, color: Colors.green), border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: callCtrl, decoration: const InputDecoration(labelText: 'कॉल हेल्पलाइन नंबर', prefixIcon: Icon(Icons.call, color: Color(0xFF0B6B3A)), border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: ytCtrl, decoration: const InputDecoration(labelText: 'YouTube चैनल लिंक', prefixIcon: Icon(Icons.video_library, color: Colors.red), border: OutlineInputBorder())),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B6B3A), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () {
                  setState(() {
                    helpConfig['whatsapp'] = wpCtrl.text.trim();
                    helpConfig['phone'] = callCtrl.text.trim();
                    helpConfig['youtube'] = ytCtrl.text.trim();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('संपर्क विवरण सेव हो गया ✓')));
                },
                child: const Text('संपर्क विवरण सेव करें'),
              ),
            ],
          ),

          // 4. बुकिंग व ट्रैकिंग
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
                            Text('पेमेंट: ${o['payMode']}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
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
        ],
      ),
    );
  }
}

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

  // ✏️ उत्पाद एडिट करने का फंक्शन
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
                child: const Text('बदलाव सेव करें (Save Changes)'),
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
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            left: 16, right: 16, top: 16,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text('＋ नया उत्पाद जोड़ें (Add Product)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0B6B3A))),
              const SizedBox(height: 12),
              TextField(controller: nameHiCtrl, decoration: const InputDecoration(labelText: 'उत्पाद का नाम (हिन्दी में)', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: nameEnCtrl, decoration: const InputDecoration(labelText: 'Product Name (in English)', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: brandCtrl, decoration: const InputDecoration(labelText: 'कंपनी / ब्रांड', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: catVal,
                decoration: const InputDecoration(labelText: 'श्रेणी (Category)', border: OutlineInputBorder()),
                items: ['बीज', 'खाद', 'दवा', 'मल्चिंग', 'कृषि उपकरण'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setModalState(() => catVal = v!),
              ),
              const SizedBox(height: 8),
              TextField(controller: descCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'विवरण', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B6B3A), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () {
                  if (nameHiCtrl.text.isEmpty || brandCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('नाम व ब्रांड भरें')));
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
                child: const Text('उत्पाद स्टोर में लाइव करें'),
              ),
            ],
          ),
        ),
      ),
    );
  }

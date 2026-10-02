import 'package:flutter/material.dart';
import 'data.dart';
import 'admin_screen.dart';

void main() => runApp(const AgriSathiApp());

class AgriSathiApp extends StatelessWidget {
  const AgriSathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agri Sathi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B6B3A)),
        scaffoldBackgroundColor: const Color(0xFFF6FAF7),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0B6B3A), foregroundColor: Colors.white),
      ),
      home: const MainNav(),
    );
  }
}

class MainNav extends StatefulWidget {
  const MainNav({super.key});

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _idx = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onCart: () => setState(() => _idx = 1)),
      CartScreen(onOrder: () => setState(() => _idx = 2)),
      const OrdersScreen(),
      const AdminScreen(),
    ];

    return Scaffold(
      body: screens[_idx],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx,
        onDestinationSelected: (i) => setState(() => _idx = i),
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home), label: 'होम'),
          NavigationDestination(
            icon: Badge(label: Text('${cart.length}'), isLabelVisible: cart.isNotEmpty, child: const Icon(Icons.shopping_cart)),
            label: 'कार्ट',
          ),
          const NavigationDestination(icon: Icon(Icons.local_shipping), label: 'ट्रैकिंग'),
          const NavigationDestination(icon: Icon(Icons.admin_panel_settings), label: 'एडमिन'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final VoidCallback onCart;
  const HomeScreen({super.key, required this.onCart});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String cat = 'सभी';
  String q = '';

  @override
  Widget build(BuildContext context) {
    final list = products.where((p) => (cat == 'सभी' || p['cat'] == cat) && p['name'].toString().toLowerCase().contains(q.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agri Sathi 🌱'),
        actions: [IconButton(icon: const Icon(Icons.shopping_cart), onPressed: widget.onCart)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          TextField(
            onChanged: (v) => setState(() => q = v),
            decoration: InputDecoration(
              hintText: 'बीज, खाद, मल्चिंग खोजें...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF0B6B3A)),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['सभी', 'बीज', 'खाद', 'दवा', 'मल्चिंग'].map((c) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(label: Text(c), selected: cat == c, onSelected: (_) => setState(() => cat = c)),
              )).toList(),
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.68, crossAxisSpacing: 8, mainAxisSpacing: 8),
            itemCount: list.length,
            itemBuilder: (ctx, i) {
              final item = list[i];
              final hasStock = (item['sizes'] as List).any((s) => s['inStock'] == true);
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => DetailScreen(item: item))).then((_) => setState(() {})),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Image.network(item['img'], fit: BoxFit.cover, width: double.infinity, errorBuilder: (_, __, ___) => const Icon(Icons.grass, size: 40, color: Colors.green)),
                            if (!hasStock)
                              Container(
                                color: Colors.black54,
                                alignment: Alignment.center,
                                child: const Text('आउट ऑफ स्टॉक', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            Text('₹${item['sizes'][0]['p']} से', style: const TextStyle(color: Color(0xFF0B6B3A), fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  const DetailScreen({super.key, required this.item});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int sIdx = 0;

  @override
  Widget build(BuildContext context) {
    final sizes = widget.item['sizes'] as List<dynamic>;
    final pack = sizes[sIdx];
    final bool isAvailable = pack['inStock'] ?? true;

    return Scaffold(
      appBar: AppBar(title: Text(widget.item['name'])),
      body: ListView(
        children: [
          Image.network(widget.item['img'], height: 200, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.grass, size: 80, color: Colors.green)),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.item['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text('₹${pack['p']}', style: const TextStyle(fontSize: 22, color: Color(0xFF0B6B3A), fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text('MRP: ₹${pack['mrp']}', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isAvailable ? const Color(0xFFEAF8EF) : const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(isAvailable ? 'स्टॉक में उपलब्ध' : 'आउट ऑफ स्टॉक', style: TextStyle(color: isAvailable ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                  ],
                ),
                const Divider(),
                const Text('पैक साइज़ चुनें:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: List.generate(sizes.length, (i) {
                    final s = sizes[i];
                    return ChoiceChip(
                      label: Text('${s['s']} - ₹${s['p']}'),
                      selected: sIdx == i,
                      onSelected: (_) => setState(() => sIdx = i),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                Text(widget.item['desc'] ?? '', style: const TextStyle(color: Colors.black87)),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isAvailable ? const Color(0xFF0B6B3A) : Colors.grey,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: isAvailable
              ? () {
                  cart.add({'name': widget.item['name'], 'pack': pack['s'], 'price': pack['p'], 'qty': 1});
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('कार्ट में जोड़ा गया ✓')));
                  Navigator.pop(context);
                }
              : null,
          child: Text(isAvailable ? 'कार्ट में जोड़ें - ₹${pack['p']}' : 'वर्तमान में अनुपलब्ध (Out of Stock)'),
        ),
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  final VoidCallback onOrder;
  const CartScreen({super.key, required this.onOrder});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addrCtrl = TextEditingController();
  String payMode = 'UPI (ऑनलाइन / QR)';

  @override
  Widget build(BuildContext context) {
    int sub = cart.fold(0, (sum, i) => sum + (i['price'] as int));

    if (cart.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('मेरा कार्ट')),
        body: const Center(child: Text('कार्ट में कोई उत्पाद नहीं है')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('चेकआउट एवं बुकिंग')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ...List.generate(cart.length, (i) => Card(
            child: ListTile(
              title: Text(cart[i]['name'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              subtitle: Text('${cart[i]['pack']} • ₹${cart[i]['price']}'),
              trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => cart.removeAt(i))),
            ),
          )),
          const SizedBox(height: 12),
          const Text('किसान का डिलीवरी पता:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'पूरा नाम', border: OutlineInputBorder())),
          const SizedBox(height: 6),
          TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'मोबाइल नंबर', border: OutlineInputBorder())),
          const SizedBox(height: 6),
          TextField(controller: addrCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'गाँव, पोस्ट, जिला, पिनकोड', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          const Text('पेमेंट गेटवे विकल्प:', style: TextStyle(fontWeight: FontWeight.bold)),
          RadioListTile<String>(
            title: const Text('UPI (PhonePe, GPay, Paytm, QR)'),
            value: 'UPI (ऑनलाइन / QR)',
            groupValue: payMode,
            onChanged: (v) => setState(() => payMode = v!),
          ),
          RadioListTile<String>(
            title: const Text('कैश ऑन डिलीवरी (COD)'),
            value: 'कैश ऑन डिलीवरी (COD)',
            groupValue: payMode,
            onChanged: (v) => setState(() => payMode = v!),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B6B3A), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
            onPressed: () {
              if (nameCtrl.text.isEmpty || phoneCtrl.text.isEmpty || addrCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('कृपया नाम, मोबाइल व पूरा पता भरें')));
                return;
              }
              final oid = 'AS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
              orders.insert(0, {
                'id': oid,
                'name': nameCtrl.text.trim(),
                'phone': phoneCtrl.text.trim(),
                'addr': addrCtrl.text.trim(),
                'items': cart.map((c) => '${c['name']} (${c['pack']})').join(', '),
                'total': sub,
                'payMode': payMode,
                'payStatus': payMode.contains('UPI') ? 'भुगतान सफल (Paid)' : 'पेंडिंग (COD)',
                'status': 'ऑर्डर प्राप्त',
                'courier': 'DTDC / Speed Post',
                'trackingNo': 'TRK$oid',
                'date': '02 Oct 2026',
              });
              cart.clear();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('बुकिंग सफलतापूर्वक कन्फर्म हुई ✓')));
              widget.onOrder();
            },
            child: Text('ऑर्डर बुक करें - ₹$sub'),
          ),
        ],
      ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  int _getStep(String? status) {
    if (status == 'डिलीवर हो गया') return 3;
    if (status == 'डिस्पैच / रवाना') return 2;
    if (status == 'पैकिंग चालू') return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('लाइव ट्रैकिंग व बुकिंग')),
      body: orders.isEmpty
          ? const Center(child: Text('कोई बुकिंग नहीं मिली'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (ctx, i) {
                final o = orders[i];
                final step = _getStep(o['status']);
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
                            Text('₹${o['total']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0B6B3A))),
                          ],
                        ),
                        Text('आइटम: ${o['items']}', style: const TextStyle(fontSize: 12)),
                        Text('पेमेंट: ${o['payMode']} (${o['payStatus']})', style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('कूरियर: ${o['courier'] ?? 'प्रक्रिया में'}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            Text('ट्रैकिंग नं: ${o['trackingNo'] ?? '-'}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _stepCircle('बुकिंग', step >= 0),
                            _stepLine(step >= 1),
                            _stepCircle('पैकिंग', step >= 1),
                            _stepLine(step >= 2),
                            _stepCircle('रवाना', step >= 2),
                            _stepLine(step >= 3),
                            _stepCircle('डिलीवर', step >= 3),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _stepCircle(String title, bool done) {
    return Column(
      children: [
        CircleAvatar(radius: 10, backgroundColor: done ? const Color(0xFF0B6B3A) : Colors.grey[300], child: Icon(Icons.check, size: 12, color: done ? Colors.white : Colors.grey)),
        const SizedBox(height: 2),
        Text(title, style: TextStyle(fontSize: 10, fontWeight: done ? FontWeight.bold : FontWeight.normal, color: done ? const Color(0xFF0B6B3A) : Colors.grey)),
      ],
    );
  }

  Widget _stepLine(bool done) {
    return Expanded(child: Container(height: 3, color: done ? const Color(0xFF0B6B3A) : Colors.grey[300]));
  }
}

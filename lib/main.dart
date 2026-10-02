import 'package:flutter/material.dart';
import 'data.dart';
import 'admin_screen.dart';

void main() => runApp(const AgriSathiApp());

class AgriSathiApp extends StatefulWidget {
  const AgriSathiApp({super.key});
  @override
  State<AgriSathiApp> createState() => _AgriSathiAppState();
}

class _AgriSathiAppState extends State<AgriSathiApp> {
  void refresh() => setState(() {});

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
      home: MainNav(onRefresh: refresh),
    );
  }
}

class MainNav extends StatefulWidget {
  final VoidCallback onRefresh;
  const MainNav({super.key, required this.onRefresh});
  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _idx = 0;
  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onCart: () => setState(() => _idx = 1),
        onLangToggle: () {
          AppStrings.lang = AppStrings.lang == 'hi' ? 'en' : 'hi';
          widget.onRefresh();
        },
      ),
      CartScreen(onOrder: () => setState(() => _idx = 2)),
      const OrdersScreen(),
      const HelpDeskScreen(),
      const AdminScreen(),
    ];

    return Scaffold(
      body: screens[_idx],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx,
        onDestinationSelected: (i) => setState(() => _idx = i),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home), label: AppStrings.lang == 'hi' ? 'होम' : 'Home'),
          NavigationDestination(
            icon: Badge(label: Text('${cart.length}'), isLabelVisible: cart.isNotEmpty, child: const Icon(Icons.shopping_cart)),
            label: AppStrings.t('cart'),
          ),
          NavigationDestination(icon: const Icon(Icons.local_shipping), label: AppStrings.t('orders')),
          NavigationDestination(icon: const Icon(Icons.support_agent), label: AppStrings.lang == 'hi' ? 'सहायता' : 'Help'),
          NavigationDestination(icon: const Icon(Icons.admin_panel_settings), label: AppStrings.t('admin')),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final VoidCallback onCart;
  final VoidCallback onLangToggle;
  const HomeScreen({super.key, required this.onCart, required this.onLangToggle});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCat = 'सभी';
  String q = '';

  @override
  Widget build(BuildContext context) {
    final list = products.where((p) {
      final matchesCat = selectedCat == 'सभी' || selectedCat == 'All' || p['cat'] == selectedCat;
      final name = AppStrings.lang == 'hi' ? p['name_hi'] : p['name_en'];
      final brand = p['brand'] ?? '';
      return matchesCat && (name.toString().toLowerCase().contains(q.toLowerCase()) || brand.toString().toLowerCase().contains(q.toLowerCase()));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.t('appName')),
        actions: [
          TextButton.icon(
            onPressed: widget.onLangToggle,
            icon: const Icon(Icons.language, color: Colors.white, size: 18),
            label: Text(AppStrings.lang == 'hi' ? 'English' : 'हिन्दी', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          IconButton(icon: const Icon(Icons.shopping_cart), onPressed: widget.onCart),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          TextField(
            onChanged: (v) => setState(() => q = v),
            decoration: InputDecoration(
              hintText: AppStrings.t('searchHint'),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF0B6B3A)),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 10),

          // दोनों डायनामिक पट्टियाँ (ऑफ़र व आवश्यक सूचना)
          ...homeBanners.where((b) => b['isActive'] == true).map((b) {
            final isGreen = b['color'] == 'green';
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isGreen ? const Color(0xFFEAF8EF) : const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isGreen ? const Color(0xFF0B6B3A) : Colors.orange, width: 1.2),
              ),
              child: Row(
                children: [
                  Icon(isGreen ? Icons.local_offer : Icons.warning_amber_rounded, color: isGreen ? const Color(0xFF0B6B3A) : Colors.deepOrange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      b['text'],
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isGreen ? const Color(0xFF0B6B3A) : Colors.deepOrange[900]),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['सभी', 'बीज', 'खाद', 'दवा', 'मल्चिंग', 'कृषि उपकरण'].map((c) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(label: Text(c), selected: selectedCat == c, onSelected: (_) => setState(() => selectedCat = c)),
              )).toList(),
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.66, crossAxisSpacing: 8, mainAxisSpacing: 8),
            itemCount: list.length,
            itemBuilder: (ctx, i) {
              final item = list[i];
              final sizes = item['sizes'] as List<dynamic>;
              final hasStock = sizes.any((s) => s['inStock'] == true);
              final name = AppStrings.lang == 'hi' ? item['name_hi'] : item['name_en'];

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
                              Container(color: Colors.black54, alignment: Alignment.center, child: Text(AppStrings.t('outStock'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['brand'] ?? '', style: const TextStyle(fontSize: 10, color: Color(0xFF0B6B3A), fontWeight: FontWeight.bold)),
                            Text(name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text('₹${sizes[0]['p']} से', style: const TextStyle(color: Color(0xFF0B6B3A), fontWeight: FontWeight.bold, fontSize: 14)),
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
    final bool isAvail = pack['inStock'] ?? true;
    final name = AppStrings.lang == 'hi' ? widget.item['name_hi'] : widget.item['name_en'];

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: ListView(
        children: [
          Image.network(widget.item['img'], height: 200, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.agriculture, size: 70, color: Colors.green)),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.item['brand'] ?? '', style: const TextStyle(color: Color(0xFF0B6B3A), fontWeight: FontWeight.bold)),
                Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text('₹${pack['p']}', style: const TextStyle(fontSize: 22, color: Color(0xFF0B6B3A), fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text('MRP: ₹${pack['mrp']}', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: isAvail ? const Color(0xFFEAF8EF) : const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(6)),
                      child: Text(isAvail ? AppStrings.t('inStock') : AppStrings.t('outStock'), style: TextStyle(color: isAvail ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                  ],
                ),
                const Divider(),
                Text(AppStrings.t('packSelect'), style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: List.generate(sizes.length, (i) => ChoiceChip(
                    label: Text('${sizes[i]['s']} - ₹${sizes[i]['p']}'),
                    selected: sIdx == i,
                    onSelected: (_) => setState(() => sIdx = i),
                  )),
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: isAvail ? const Color(0xFF0B6B3A) : Colors.grey, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
          onPressed: isAvail ? () {
            cart.add({'name': name, 'pack': pack['s'], 'price': pack['p'], 'qty': 1});
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('कार्ट में जोड़ा गया ✓')));
            Navigator.pop(context);
          } : null,
          child: Text(isAvail ? '${AppStrings.t('addToCart')} - ₹${pack['p']}' : AppStrings.t('outStock')),
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
  String payMode = 'UPI (ऑनलाइन / PhonePe / GPay)';

  @override
  Widget build(BuildContext context) {
    int sub = cart.fold(0, (sum, i) => sum + (i['price'] as int));
    if (cart.isEmpty) {
      return Scaffold(appBar: AppBar(title: Text(AppStrings.t('cart'))), body: Center(child: Text(AppStrings.lang == 'hi' ? 'कार्ट खाली है!' : 'Cart is empty!')));
    }

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.t('cart'))),
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
          const SizedBox(height: 10),
          TextField(controller: nameCtrl, decoration: InputDecoration(labelText: AppStrings.lang == 'hi' ? 'किसान का नाम' : 'Farmer Name', border: const OutlineInputBorder())),
          const SizedBox(height: 6),
          TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: AppStrings.lang == 'hi' ? 'मोबाइल नंबर' : 'Phone Number', border: const OutlineInputBorder())),
          const SizedBox(height: 6),
          TextField(controller: addrCtrl, maxLines: 2, decoration: InputDecoration(labelText: AppStrings.lang == 'hi' ? 'गाँव, पोस्ट, जिला, पिनकोड' : 'Full Address', border: const OutlineInputBorder())),
          const SizedBox(height: 8),
          RadioListTile<String>(title: const Text('UPI (PhonePe / GPay / QR)'), value: 'UPI (ऑनलाइन / PhonePe / GPay)', groupValue: payMode, onChanged: (v) => setState(() => payMode = v!)),
          RadioListTile<String>(title: const Text('कैश ऑन डिलीवरी (COD)'), value: 'कैश ऑन डिलीवरी (COD)', groupValue: payMode, onChanged: (v) => setState(() => payMode = v!)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B6B3A), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
            onPressed: () {
              if (nameCtrl.text.isEmpty || phoneCtrl.text.isEmpty || addrCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('कृपया पूरी जानकारी भरें')));
                return;
              }
              final oid = 'AS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
              orders.insert(0, {
                'id': oid,
                'customer': nameCtrl.text.trim(),
                'phone': phoneCtrl.text.trim(),
                'addr': addrCtrl.text.trim(),
                'items': cart.map((c) => '${c['name']} (${c['pack']})').join(', '),
                'total': sub,
                'payMode': payMode,
                'status': 'ऑर्डर प्राप्त',
                'courier': 'DTDC / Speed Post',
                'trackingNo': 'TRK$oid',
              });
              cart.clear();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ऑर्डर सफलतापूर्वक बुक हुआ ✓')));
              widget.onOrder();
            },
            child: Text('${AppStrings.t('checkout')} - ₹$sub'),
          ),
        ],
      ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  int _step(String? status) {
    if (status == 'डिलीवर हो गया') return 3;
    if (status == 'डिस्पैच / रवाना') return 2;
    if (status == 'पैकिंग चालू') return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.t('orders'))),
      body: orders.isEmpty ? const Center(child: Text('कोई बुकिंग नहीं मिली')) : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: orders.length,
        itemBuilder: (ctx, i) {
          final o = orders[i];
          final step = _step(o['status']);
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('#${o['id']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text('₹${o['total']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0B6B3A))),
                  ]),
                  Text('सामग्री: ${o['items']}'),
                  const Divider(),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('कूरियर: ${o['courier'] ?? 'असाइन हो रहा'}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text('ट्रैकिंग: ${o['trackingNo'] ?? '-'}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    _circle('बुकिंग', step >= 0),
                    _line(step >= 1),
                    _circle('पैकिंग', step >= 1),
                    _line(step >= 2),
                    _circle('रवाना', step >= 2),
                    _line(step >= 3),
                    _circle('डिलीवर', step >= 3),
                  ]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _circle(String t, bool done) => Column(children: [
    CircleAvatar(radius: 10, backgroundColor: done ? const Color(0xFF0B6B3A) : Colors.grey[300], child: Icon(Icons.check, size: 12, color: done ? Colors.white : Colors.grey)),
    const SizedBox(height: 2),
    Text(t, style: TextStyle(fontSize: 10, fontWeight: done ? FontWeight.bold : FontWeight.normal, color: done ? const Color(0xFF0B6B3A) : Colors.grey)),
  ]);

  Widget _line(bool done) => Expanded(child: Container(height: 3, color: done ? const Color(0xFF0B6B3A) : Colors.grey[300]));
}

class HelpDeskScreen extends StatelessWidget {
  const HelpDeskScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.t('helpDesk'))),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          const Card(
            color: Color(0xFF102A20),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('किसान सेवा केंद्र 24x7', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text('फसल सलाह, दवा छिड़काव मात्रा एवं ऑर्डर सहायता के लिए तुरंत संपर्क करें।', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const CircleAvatar(backgroundColor: Color(0xFFEAF8EF), child: Icon(Icons.chat, color: Colors.green)),
            title: Text(AppStrings.t('whatsapp')),
            subtitle: Text('+${helpConfig['whatsapp']} (WhatsApp चैट)'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('WhatsApp खुल रहा है: +${helpConfig['whatsapp']}'))),
          ),
          const SizedBox(height: 10),
          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const CircleAvatar(backgroundColor: Color(0xFFEAF8EF), child: Icon(Icons.call, color: Color(0xFF0B6B3A))),
            title: Text(AppStrings.t('call')),
            subtitle: Text('${helpConfig['phone']} (कॉल सपोर्ट)'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('डायल हो रहा है: ${helpConfig['phone']}'))),
          ),
          const SizedBox(height: 20),
          const Text('सोशल मीडिया कम्युनिटी:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ActionChip(
                avatar: const Icon(Icons.video_library, color: Colors.red, size: 18),
                label: const Text('YouTube'),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('YouTube लिंक: ${helpConfig['youtube']}'))),
              ),
              ActionChip(
                avatar: const Icon(Icons.facebook, color: Colors.blue, size: 18),
                label: const Text('Facebook'),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Facebook लिंक: ${helpConfig['facebook']}'))),
              ),
              ActionChip(
                avatar: const Icon(Icons.send, color: Colors.lightBlue, size: 18),
                label: const Text('Telegram'),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Telegram लिंक: ${helpConfig['telegram']}'))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

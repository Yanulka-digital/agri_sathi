import 'package:flutter/material.dart';
import 'data.dart';

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
          const NavigationDestination(icon: Icon(Icons.local_shipping), label: 'ऑर्डर'),
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
        title: const Text('Agri Sathi 🌱 (कृषि दुकान)'),
        actions: [IconButton(icon: const Icon(Icons.shopping_cart), onPressed: widget.onCart)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          TextField(
            onChanged: (v) => setState(() => q = v),
            decoration: InputDecoration(
              hintText: 'बीज, खाद, दवा खोजें...',
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.72, crossAxisSpacing: 8, mainAxisSpacing: 8),
            itemCount: list.length,
            itemBuilder: (ctx, i) {
              final item = list[i];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => DetailScreen(item: item))).then((_) => setState(() {})),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Image.network(item['img'], fit: BoxFit.cover, width: double.infinity, errorBuilder: (_, __, ___) => const Icon(Icons.grass, size: 40, color: Colors.green))),
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
                Text('₹${pack['p']}', style: const TextStyle(fontSize: 20, color: Color(0xFF0B6B3A), fontWeight: FontWeight.bold)),
                const Divider(),
                const Text('पैक साइज़ चुनें:', style: TextStyle(fontWeight: FontWeight.bold)),
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
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B6B3A), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
          onPressed: () {
            cart.add({'name': widget.item['name'], 'pack': pack['s'], 'price': pack['p'], 'qty': 1});
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('कार्ट में जोड़ा गया ✓')));
            Navigator.pop(context);
          },
          child: Text('कार्ट में जोड़ें - ₹${pack['p']}'),
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
  final coupon = TextEditingController();
  int dis = 0;
  @override
  Widget build(BuildContext context) {
    int sub = cart.fold(0, (sum, i) => sum + (i['price'] as int));
    int total = (sub - dis).clamp(0, 999999);
    if (cart.isEmpty) return Scaffold(appBar: AppBar(title: const Text('मेरा कार्ट')), body: const Center(child: Text('कार्ट खाली है')));
    return Scaffold(
      appBar: AppBar(title: const Text('मेरा कार्ट')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ...List.generate(cart.length, (i) => Card(
            child: ListTile(
              title: Text(cart[i]['name']),
              subtitle: Text('${cart[i]['pack']} • ₹${cart[i]['price']}'),
              trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => cart.removeAt(i))),
            ),
          )),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: TextField(controller: coupon, decoration: const InputDecoration(hintText: 'Coupon: AGRI50', border: OutlineInputBorder()))),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B6B3A), foregroundColor: Colors.white),
                onPressed: () {
                  if (coupon.text.trim().toUpperCase() == 'AGRI50') {
                    setState(() => dis = 50);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('₹50 छूट लागू हुई ✓')));
                  }
                },
                child: const Text('Apply'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('कुल भुगतान: ₹$total', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0B6B3A))),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B6B3A), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
            onPressed: () {
              orders.insert(0, {'id': 'AS${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}', 'total': total, 'date': 'आज'});
              cart.clear();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ऑर्डर प्लेस हो गया ✓')));
              widget.onOrder();
            },
            child: const Text('ऑर्डर करें'),
          )
        ],
      ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('मेरे ऑर्डर')),
      body: orders.isEmpty
          ? const Center(child: Text('कोई ऑर्डर नहीं है'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (ctx, i) => Card(
                child: ListTile(
                  title: Text('#${orders[i]['id']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('दिनांक: ${orders[i]['date']} | कुल: ₹${orders[i]['total']}'),
                  trailing: const Text('ऑर्डर प्राप्त', style: TextStyle(color: Color(0xFF0B6B3A), fontWeight: FontWeight.bold)),
                ),
              ),
            ),
    );
  }
}

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⚙ एडमिन डैशबोर्ड')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Card(
            color: const Color(0xFF102A20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Agri Sathi स्टोर कंट्रोल', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('कुल उत्पाद: ${products.length}', style: const TextStyle(color: Colors.white70)),
                  Text('कुल ऑर्डर्स: ${orders.length}', style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const ListTile(tileColor: Colors.white, leading: Icon(Icons.inventory, color: Color(0xFF0B6B3A)), title: Text('स्टॉक एवं पैक साइज़'), subtitle: Text('उत्पाद, मूल्य और इन्वेंट्री')),
          const SizedBox(height: 8),
          const ListTile(tileColor: Colors.white, leading: Icon(Icons.local_shipping, color: Color(0xFF0B6B3A)), title: Text('ऑर्डर ट्रैकिंग'), subtitle: Text('पैकिंग, शिपमेंट और डिलीवरी')),
        ],
      ),
    );
  }
}

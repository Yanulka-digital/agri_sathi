import 'package:flutter/material.dart';
import '../main.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  List<dynamic> products = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    setState(() => isLoading = true);
    try {
      final data = await supabase.from('products').select().order('created_at', ascending: false);
      setState(() {
        products = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        products = [
          {
            'id': '1',
            'name': 'DAP Fertilizer (IFFCO)',
            'price': 1350,
            'image_url': 'https://images.unsplash.com/photo-1585314062340-f1a5a7c9328d?w=400',
            'description': 'फसलों की शुरुआती वृद्धि और जड़ों के विकास के लिए।'
          },
          {
            'id': '2',
            'name': 'NPK 19:19:19',
            'price': 950,
            'image_url': 'https://images.unsplash.com/photo-1628352081506-83c43123ed6d?w=400',
            'description': 'संतुलित पोषण और संपूर्ण वानस्पतिक वृद्धि के लिए घुलनशील खाद।'
          },
          {
            'id': '3',
            'name': 'Trichoderma Viride',
            'price': 250,
            'image_url': 'https://images.unsplash.com/photo-1592417817098-8f3d69102553?w=400',
            'description': 'उकठा (विल्ट) और जड़ गलन से सुरक्षा।'
          },
          {
            'id': '4',
            'name': 'Brinjal Seeds (VNR 212)',
            'price': 420,
            'image_url': 'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=400',
            'description': 'उच्च उत्पादन क्षमता और रोगों के प्रति सहनशील बीज।'
          },
        ];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = products.where((p) {
      final name = (p['name'] ?? '').toString().toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.eco, color: Colors.white),
            SizedBox(width: 8),
            Text('Agri Sathi', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/auth'),
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchProducts,
        child: Column(
          children: [
            Container(
              color: const Color(0xFF2E7D32),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  onChanged: (val) => setState(() => searchQuery = val),
                  decoration: const InputDecoration(
                    hintText: 'उत्पाद खोजें (उर्वरक, बीज, कीटनाशक)...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                      ? const Center(child: Text('कोई उत्पाद उपलब्ध नहीं है'))
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final item = filtered[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(product: item),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        color: Colors.grey[200],
                                        child: (item['image_url'] != null && item['image_url'].toString().startsWith('http'))
                                            ? Image.network(
                                                item['image_url'],
                                                fit: BoxFit.cover,
                                                errorBuilder: (c, e, s) => const Icon(Icons.grass, size: 50, color: Colors.green),
                                              )
                                            : const Icon(Icons.agriculture, size: 50, color: Colors.green),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['name'] ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '₹${item['price']}',
                                            style: const TextStyle(
                                              color: Color(0xFF2E7D32),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        onPressed: () => Navigator.pushNamed(context, '/admin'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

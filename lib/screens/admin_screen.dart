import 'package:flutter/material.dart';
import '../main.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final imgCtrl = TextEditingController();
  bool isSaving = false;

  Future<void> saveProduct() async {
    if (nameCtrl.text.isEmpty || priceCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कृपया नाम और दाम अवश्य भरें')),
      );
      return;
    }

    setState(() => isSaving = true);
    try {
      await supabase.from('products').insert({
        'name': nameCtrl.text.trim(),
        'price': double.tryParse(priceCtrl.text.trim()) ?? 0,
        'description': descCtrl.text.trim(),
        'image_url': imgCtrl.text.trim(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('उत्पाद सफलतापूर्वक Supabase में जुड़ गया!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('त्रुटि: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('नया उत्पाद जोड़ें')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'उत्पाद का नाम', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'कीमत (₹)', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: imgCtrl, decoration: const InputDecoration(labelText: 'फोटो लिंक (Image URL)', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: descCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'उत्पाद विवरण', border: OutlineInputBorder())),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white),
                onPressed: isSaving ? null : saveProduct,
                child: isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text('डेटाबेस में सेव करें', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

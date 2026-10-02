import 'package:flutter/material.dart';

// भाषा अनुवाद डिक्शनरी (Localization)
class AppStrings {
  static String lang = 'hi'; // 'hi' या 'en'

  static final Map<String, Map<String, String>> _values = {
    'hi': {
      'appName': 'Agri Sathi 🌱',
      'tagline': 'किसान की अपनी कृषि दुकान',
      'searchHint': 'बीज, खाद, दवा, ब्रांड खोजें...',
      'all': 'सभी',
      'seeds': 'बीज',
      'fert': 'खाद',
      'pest': 'दवा',
      'mulch': 'मल्चिंग',
      'tools': 'कृषि उपकरण',
      'popular': 'लोकप्रिय कृषि उत्पाद',
      'packSelect': 'पैक साइज़ चुनें',
      'inStock': 'स्टॉक में उपलब्ध',
      'outStock': 'आउट ऑफ स्टॉक',
      'addToCart': 'कार्ट में जोड़ें',
      'cart': 'मेरा कार्ट',
      'orders': 'मेरे ऑर्डर',
      'admin': 'एडमिन',
      'checkout': 'ऑर्डर बुक करें',
      'total': 'कुल भुगतान',
      'helpDesk': 'किसान सहायता केंद्र',
      'whatsapp': 'WhatsApp पर सहायता पाएं',
      'call': 'हेल्पलाइन पर कॉल करें',
      'newProduct': '＋ नया उत्पाद जोड़ें (No-Code)',
    },
    'en': {
      'appName': 'Agri Sathi 🌱',
      'tagline': 'Your Trusted Agriculture Store',
      'searchHint': 'Search seeds, fertilizers, brands...',
      'all': 'All',
      'seeds': 'Seeds',
      'fert': 'Fertilizers',
      'pest': 'Pesticides',
      'mulch': 'Mulching',
      'tools': 'Farm Tools',
      'popular': 'Popular Products',
      'packSelect': 'Select Pack Size',
      'inStock': 'In Stock',
      'outStock': 'Out of Stock',
      'addToCart': 'Add to Cart',
      'cart': 'My Cart',
      'orders': 'My Orders',
      'admin': 'Admin',
      'checkout': 'Confirm Booking',
      'total': 'Total Payable',
      'helpDesk': 'Kisan Help Desk',
      'whatsapp': 'Chat on WhatsApp',
      'call': 'Call Helpline',
      'newProduct': '＋ Add Product (No-Code)',
    }
  };

  static String t(String key) => _values[lang]?[key] ?? key;
}

// बहु-ब्रांड व बहु-आकार उत्पाद सूची
List<Map<String, dynamic>> products = [
  {
    'id': 1,
    'brand': 'VNR Seeds',
    'name_hi': 'हाइब्रिड बैगन बीज (VNR 212)',
    'name_en': 'Hybrid Brinjal Seeds (VNR 212)',
    'cat': 'बीज',
    'img': 'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=400',
    'desc': 'उच्च उत्पादन क्षमता, चमकीला हरा-बैंगनी रंग एवं फल छेदक कीट के प्रति सहनशील।',
    'sizes': [
      {'s': '10 ग्राम', 'p': 180, 'mrp': 220, 'stock': 45, 'inStock': true, 'sku': 'VNR-212-10G'},
      {'s': '50 ग्राम', 'p': 850, 'mrp': 950, 'stock': 20, 'inStock': true, 'sku': 'VNR-212-50G'},
      {'s': '100 ग्राम', 'p': 1600, 'mrp': 1800, 'stock': 0, 'inStock': false, 'sku': 'VNR-212-100G'},
    ]
  },
  {
    'id': 2,
    'brand': 'IFFCO',
    'name_hi': 'IFFCO NPK 19:19:19 100% घुलनशील',
    'name_en': 'IFFCO 100% Water Soluble NPK 19:19:19',
    'cat': 'खाद',
    'img': 'https://images.unsplash.com/photo-1628352081506-83c43123ed6d?w=400',
    'desc': 'ड्रिप एवं फोलियर स्प्रे हेतु संतुलित प्राथमिक पोषक तत्व (नाइट्रोजन, फास्फोरस, पोटाश)।',
    'sizes': [
      {'s': '1 किग्रा', 'p': 190, 'mrp': 240, 'stock': 150, 'inStock': true, 'sku': 'IFF-19-1KG'},
      {'s': '5 किग्रा', 'p': 890, 'mrp': 1050, 'stock': 40, 'inStock': true, 'sku': 'IFF-19-5KG'},
      {'s': '25 किग्रा', 'p': 3800, 'mrp': 4200, 'stock': 12, 'inStock': true, 'sku': 'IFF-19-25KG'},
    ]
  },
  {
    'id': 3,
    'brand': 'FMC',
    'name_hi': 'FMC Coragen कीटनाशक (Chlorantraniliprole 18.5% SC)',
    'name_en': 'FMC Coragen Insecticide',
    'cat': 'दवा',
    'img': 'https://images.unsplash.com/photo-1592417817098-8f3d69102553?w=400',
    'desc': 'इल्ली, तना छेदक व फल छेदक कीटों के प्रभावी व लंबे समय तक नियंत्रण हेतु।',
    'sizes': [
      {'s': '10 मिली', 'p': 195, 'mrp': 230, 'stock': 60, 'inStock': true, 'sku': 'FMC-COR-10ML'},
      {'s': '60 मिली', 'p': 920, 'mrp': 1080, 'stock': 25, 'inStock': true, 'sku': 'FMC-COR-60ML'},
      {'s': '150 मिली', 'p': 2150, 'mrp': 2400, 'stock': 10, 'inStock': true, 'sku': 'FMC-COR-150ML'},
    ]
  },
  {
    'id': 4,
    'brand': 'Agri Sathi Spec',
    'name_hi': 'सिल्वर-ब्लैक मल्चिंग फिल्म 25 Micron UV',
    'name_en': 'Silver-Black Mulch Film 25 Micron',
    'cat': 'मल्चिंग',
    'img': 'https://images.unsplash.com/photo-1585314062340-f1a5a7c9328d?w=400',
    'desc': 'नमी संरक्षण, खरपतवार की रोकथाम एवं मिट्टी का तापमान अनुकूल रखने हेतु।',
    'sizes': [
      {'s': '400 मीटर (1.2m चौड़ाई)', 'p': 980, 'mrp': 1250, 'stock': 35, 'inStock': true, 'sku': 'MUL-400-25M'},
      {'s': '1000 मीटर रोल', 'p': 2250, 'mrp': 2600, 'stock': 15, 'inStock': true, 'sku': 'MUL-1000-25M'},
    ]
  }
];

List<Map<String, dynamic>> cart = [];

List<Map<String, dynamic>> orders = [
  {
    'id': 'AS-94021',
    'customer': 'सुरेश कुमार',
    'phone': '9876543210',
    'addr': 'ग्राम व पोस्ट - रावर्ट्सगंज, सोनभद्र, 231216',
    'items': 'FMC Coragen (60 मिली) x 1',
    'total': 920,
    'payMode': 'UPI (ऑनलाइन)',
    'payStatus': 'भुगतान सफल (Paid)',
    'status': 'डिस्पैच / रवाना',
    'courier': 'DTDC Courier',
    'trackingNo': 'DTDC8839201',
    'date': '02 Oct 2026'
  }
];

List<Map<String, dynamic>> helpTickets = [];

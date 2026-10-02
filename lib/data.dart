import 'package:flutter/material.dart';

class AppStrings {
  static String lang = 'hi';

  static final Map<String, Map<String, String>> _values = {
    'hi': {
      'appName': 'Agri Sathi 🌱',
      'tagline': 'किसान की अपनी कृषि दुकान',
      'searchHint': 'बीज, खाद, दवा, ब्रांड खोजें...',
      'all': 'सभी',
      'popular': 'लोकप्रिय कृषि उत्पाद',
      'packSelect': 'पैक साइज़ चुनें',
      'inStock': 'स्टॉक में उपलब्ध',
      'outStock': 'आउट ऑफ स्टॉक',
      'addToCart': 'कार्ट में जोड़ें',
      'cart': 'मेरा कार्ट',
      'orders': 'मेरे ऑर्डर',
      'admin': 'एडमिन',
      'checkout': 'ऑर्डर बुक करें',
      'helpDesk': 'किसान सहायता केंद्र',
      'whatsapp': 'WhatsApp पर सहायता पाएं',
      'call': 'हेल्पलाइन पर कॉल करें',
    },
    'en': {
      'appName': 'Agri Sathi 🌱',
      'tagline': 'Your Trusted Agriculture Store',
      'searchHint': 'Search seeds, fertilizers, brands...',
      'all': 'All',
      'popular': 'Popular Products',
      'packSelect': 'Select Pack Size',
      'inStock': 'In Stock',
      'outStock': 'Out of Stock',
      'addToCart': 'Add to Cart',
      'cart': 'My Cart',
      'orders': 'My Orders',
      'admin': 'Admin',
      'checkout': 'Confirm Booking',
      'helpDesk': 'Kisan Help Desk',
      'whatsapp': 'Chat on WhatsApp',
      'call': 'Call Helpline',
    }
  };

  static String t(String key) => _values[lang]?[key] ?? key;
}

// मेन पेज की 2 पट्टियाँ (ऑफ़र व आवश्यक सूचना) - एडमिन द्वारा चालू/बंद
List<Map<String, dynamic>> homeBanners = [
  {
    'id': 'b1',
    'title': 'विशेष छूट ऑफ़र',
    'text': '🎉 महा बचत: सभी हाइब्रिड बीज और टॉनिक पर 15% की विशेष छूट! कूपन: AGRI50',
    'isActive': true,
    'color': 'green', // हरा रंग (ऑफ़र पट्टी)
  },
  {
    'id': 'b2',
    'title': 'ज़रूरी सूचना / किसान सलाह',
    'text': '📢 आवश्यक सूचना: आगामी 3 दिनों में हल्की बारिश के आसार, दवा का छिड़काव स्टीकर मिलाकर ही करें।',
    'isActive': true,
    'color': 'orange', // नारंगी रंग (सलाह/चेतावनी पट्टी)
  }
];

// हेल्प डेस्क व सोशल मीडिया सेटिंग्स (एडमिन से बदलने योग्य)
Map<String, String> helpConfig = {
  'phone': '9876543210',
  'whatsapp': '9876543210',
  'youtube': 'https://youtube.com/@Okicare',
  'facebook': 'https://facebook.com',
  'telegram': 'https://t.me',
};

// उत्पाद सूची
List<Map<String, dynamic>> products = [
  {
    'id': 1,
    'brand': 'VNR Seeds',
    'name_hi': 'हाइब्रिड बैगन बीज (VNR 212)',
    'name_en': 'Hybrid Brinjal Seeds (VNR 212)',
    'cat': 'बीज',
    'img': 'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=400',
    'desc': 'उच्च उत्पादन क्षमता, कीट सहनशील।',
    'sizes': [
      {'s': '10 ग्राम', 'p': 180, 'mrp': 220, 'stock': 45, 'inStock': true},
      {'s': '50 ग्राम', 'p': 850, 'mrp': 950, 'stock': 20, 'inStock': true},
    ]
  },
  {
    'id': 2,
    'brand': 'IFFCO',
    'name_hi': 'IFFCO NPK 19:19:19 घुलनशील खाद',
    'name_en': 'IFFCO NPK 19:19:19 Water Soluble',
    'cat': 'खाद',
    'img': 'https://images.unsplash.com/photo-1628352081506-83c43123ed6d?w=400',
    'desc': 'ड्रिप व फोलियर स्प्रे हेतु 100% जल घुलनशील।',
    'sizes': [
      {'s': '1 किग्रा', 'p': 190, 'mrp': 240, 'stock': 120, 'inStock': true},
      {'s': '5 किग्रा', 'p': 890, 'mrp': 1050, 'stock': 35, 'inStock': true},
    ]
  },
  {
    'id': 3,
    'brand': 'FMC',
    'name_hi': 'FMC Coragen कीटनाशक दवा',
    'name_en': 'FMC Coragen Insecticide',
    'cat': 'दवा',
    'img': 'https://images.unsplash.com/photo-1592417817098-8f3d69102553?w=400',
    'desc': 'इल्ली व फल छेदक पर लंबा नियंत्रण।',
    'sizes': [
      {'s': '10 मिली', 'p': 195, 'mrp': 230, 'stock': 50, 'inStock': true},
      {'s': '60 मिली', 'p': 920, 'mrp': 1080, 'stock': 20, 'inStock': true},
    ]
  }
];

List<Map<String, dynamic>> cart = [];
List<Map<String, dynamic>> orders = [];
List<Map<String, dynamic>> helpTickets = [];

List<Map<String, dynamic>> products = [
  {
    'id': 1,
    'name': 'हाइब्रिड बैगन बीज (VNR 212)',
    'cat': 'बीज',
    'img': 'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=400',
    'desc': 'उच्च उत्पादन व फल छेदक कीट के प्रति सहनशील बीज।',
    'sizes': [
      {'s': '10 ग्राम', 'p': 180, 'mrp': 220, 'stock': 40, 'inStock': true, 'sku': 'VNR-10'},
      {'s': '50 ग्राम', 'p': 850, 'mrp': 950, 'stock': 0, 'inStock': false, 'sku': 'VNR-50'}
    ]
  },
  {
    'id': 2,
    'name': 'IFFCO NPK 19:19:19 घुलनशील',
    'cat': 'खाद',
    'img': 'https://images.unsplash.com/photo-1628352081506-83c43123ed6d?w=400',
    'desc': '100% जल घुलनशील संपूर्ण संतुलित पोषण उर्वरक।',
    'sizes': [
      {'s': '1 किग्रा', 'p': 190, 'mrp': 240, 'stock': 120, 'inStock': true, 'sku': 'NPK-1'},
      {'s': '5 किग्रा', 'p': 890, 'mrp': 1050, 'stock': 25, 'inStock': true, 'sku': 'NPK-5'}
    ]
  },
  {
    'id': 3,
    'name': 'Trichoderma Viride Bio-Fungicide',
    'cat': 'दवा',
    'img': 'https://images.unsplash.com/photo-1592417817098-8f3d69102553?w=400',
    'desc': 'जड़ गलन और उकठा (विल्ट) की रोकथाम हेतु जैविक उत्पाद।',
    'sizes': [
      {'s': '1 किग्रा', 'p': 240, 'mrp': 300, 'stock': 50, 'inStock': true, 'sku': 'TRI-1'}
    ]
  },
  {
    'id': 4,
    'name': 'मल्चिंग फिल्म 25 Micron',
    'cat': 'मल्चिंग',
    'img': 'https://images.unsplash.com/photo-1585314062340-f1a5a7c9328d?w=400',
    'desc': 'नमी संरक्षण और खरपतवार नियंत्रण हेतु यूवी फिल्म।',
    'sizes': [
      {'s': '400 मीटर', 'p': 980, 'mrp': 1200, 'stock': 15, 'inStock': true, 'sku': 'MUL-400'}
    ]
  }
];

List<Map<String, dynamic>> cart = [];

List<Map<String, dynamic>> orders = [
  {
    'id': 'AS-82910',
    'name': 'रमेश पटेल',
    'phone': '9876543210',
    'addr': 'गाँव व पोस्ट-रावर्ट्सगंज, सोनभद्र, 231216',
    'items': 'NPK 19:19:19 (1 किग्रा) x 1',
    'total': 190,
    'payMode': 'UPI (ऑनलाइन)',
    'payStatus': 'भुगतान सफल (Paid)',
    'status': 'डिस्पैच / रवाना',
    'courier': 'DTDC Express',
    'trackingNo': 'DTDC9382104',
    'date': '02 Oct 2026'
  }
];

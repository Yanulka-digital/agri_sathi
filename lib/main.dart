import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/admin_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://lhmwvgylowennwenziml.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxobXd2Z3lsb3dlbm53ZW56aW1sIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTA1NjUyMzAsImV4cCI6MjEwNjE0MTIzMH0.wR--JEou-E_8x5eGm6xbXRL-9H7fH8Bgecs17TJOY2g',
  );
  
  runApp(const AgriSathiApp());
}

final supabase = Supabase.instance.client;

class AgriSathiApp extends StatelessWidget {
  const AgriSathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agri Sathi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/auth': (context) => const AuthScreen(),
        '/admin': (context) => const AdminScreen(),
      },
    );
  }
}

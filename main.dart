import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/admin_screen.dart';

const supabaseUrl = 'https://lhmwvgylowennwenziml.supabase.co';
const supabaseAnonKey = 'PASTE_YOUR_ANON_KEY_HERE';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  runApp(const AgriSathiApp());
}

class AgriSathiApp extends StatelessWidget {
  const AgriSathiApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Agri Sathi',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF166534)),
      scaffoldBackgroundColor: const Color(0xFFF7FAF7)),
    home: const HomeScreen(),
    routes: {'/auth': (_) => const AuthScreen(), '/admin': (_) => const AdminScreen()},
  );
}

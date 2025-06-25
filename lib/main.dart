import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // Load environment variables
  // try {
  // } catch (e) {
  //   throw Exception('Error loading .env file: $e'); // Print error if any
  // }
  runApp(const TelurAsinApp());
}

class TelurAsinApp extends StatelessWidget {
  const TelurAsinApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Ganti home ke LoginScreen, bukan MainScreen
      home: const LoginScreen(),
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.grey[100],
      ),
    );
  }
}

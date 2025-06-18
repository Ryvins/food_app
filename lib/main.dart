import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // import Login dulu

void main() => runApp(const TelurAsinApp());

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

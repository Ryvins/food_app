import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(const TelurAsinApp());

class TelurAsinApp extends StatelessWidget {
  const TelurAsinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.grey[100],
      ),
    );
  }
}

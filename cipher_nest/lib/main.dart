import 'package:flutter/material.dart';
import 'SplashScreen.dart';

void main() {
  runApp(const CipherNestApp());
}

class CipherNestApp extends StatelessWidget {
  const CipherNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CipherNest',
      home: const SplashScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'firebase_options.dart'; // Import the generated Firebase options

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Use the generated options
  );
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

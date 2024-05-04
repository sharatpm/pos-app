import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testnew/screens/products/products.dart';
import 'package:testnew/screens/splash_screen.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ));

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testnew/screens/auth/register.dart';
import 'package:testnew/screens/products/products.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  route() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = '8227-182-66-218-123.ngrok-free.app';
    prefs.setString('url', url);

    await Future.delayed(const Duration(seconds: 3));
    // prefs.remove('vendor_id');
    // prefs.remove('auth_token');
    final vendorId = prefs.getString('vendor_id');
    final authToken = prefs.getString('auth_token');
    print(vendorId);
    if (vendorId != null && authToken != null) {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => ProductsScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    route();
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: const Image(
                image: AssetImage('assets/images/logo.jpg'),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'POS App',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            LoadingAnimationWidget.hexagonDots(
              color: Colors.black87,
              size: 100,
            ),
          ],
        ),
      ),
    );
  }
}

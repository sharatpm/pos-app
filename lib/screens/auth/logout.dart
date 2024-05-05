import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testnew/screens/auth/login.dart';

class LogOutScreen extends StatefulWidget {
  const LogOutScreen({super.key});

  @override
  State<LogOutScreen> createState() => _LogOutScreenState();
}

class _LogOutScreenState extends State<LogOutScreen> {
  @override
  void initState() {
    logout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        // width: MediaQuery.of(context).size.width,
        children: <Widget>[
          LoadingAnimationWidget.waveDots(
            color: Colors.black87,
            size: 100,
          ),
        ],
      ),
    );
  }

  logout() async {
    var client = http.Client();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final rUrl = prefs.getString('url') ?? '';
      final authToken = prefs.getString('auth_token');
      var params = {
        'auth_token': authToken,
      };
      var url = Uri.https(
          rUrl, 'Capstone_Project/AuthenticationService/Logout.php', params);
      var response = await http.get(url);
      print(response.body);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      print(decodedResponse);
      if (decodedResponse['status'] == 'success') {
        prefs.remove('vendor_id');
        prefs.remove('auth_token');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      } else {
        Navigator.pop(context);
      }
    } finally {
      client.close();
    }
  }
}

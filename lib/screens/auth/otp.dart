import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testnew/screens/products/products.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String message = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 1600),
                      child: Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: const Center(
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  const Text(
                    'Enter OTP:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1800),
                    child: OtpTextField(
                      numberOfFields: 6,
                      borderColor: const Color(0xFF512DA8),
                      showFieldAsBox: true,
                      onCodeChanged: (String code) {},
                      onSubmit: (String verificationCode) async {
                        var client = http.Client();
                        try {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          final $email = prefs.getString('email');
                          final params = {
                            'otp': verificationCode,
                            'email': $email,
                          };
                          var url = Uri.https(
                              '8227-182-66-218-123.ngrok-free.app',
                              'Capstone_Project/AuthenticationService/Login.php',
                              params);
                          var response = await http.get(url);
                          // print('Server response: ${response.body}');
                          if (response.body.isNotEmpty) {
                            var responseData = jsonDecode(response.body);
                            print(responseData);
                            if (responseData['status'] == 'success') {
                              // Handle success response
                              if (responseData['vendor_id'] != null &&
                                  responseData['auth_token'] != null) {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString('vendor_id',
                                    responseData['vendor_id'].toString());
                                await prefs.setString('auth_token',
                                    responseData['auth_token'].toString());
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductsScreen(),
                                  ),
                                );
                              }
                              print('Login Successful');
                            } else {
                              setState(() {
                                message = responseData['message'];
                              });
                              // Handle error response
                              print('Login Error: ${responseData['message']}');
                            }
                          } else {
                            print('Empty response received from the server');
                          }
                        } catch (e) {
                          print('Error decoding JSON: $e');
                        } finally {
                          client.close();
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Text(
        message,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          backgroundColor: Colors.white,
          color: Colors.red,
          fontSize: 15,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

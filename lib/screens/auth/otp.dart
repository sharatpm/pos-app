import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:testnew/screens/info_screen.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
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
                      //set to true to show as box or false to show as dash
                      showFieldAsBox: true,
                      //runs when a code is typed in
                      onCodeChanged: (String code) {
                        //handle validation or checks here
                      },
                      //runs when every textfield is filled
                      onSubmit: (String verificationCode) async {
                        var client = http.Client();
                        try {
                          var url = Uri.https(
                              '9d47-182-66-218-123.ngrok-free.app',
                              'Capstone_Project/AuthenticationService/Login.php');
                          var response = await http.get(
                            url,
                            headers: {
                              'otp': verificationCode,
                            },
                          );
                          // var decodedResponse =
                          //     jsonDecode(utf8.decode(response.bodyBytes))
                          //         as Map;
                          print(response);
                        } finally {
                          client.close();
                        }
                      }, // end onSubmit
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
    );
  }
}

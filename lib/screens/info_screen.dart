import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:testnew/screens/products/products.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(143, 148, 251, 1),
        title: Text('Add Details'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: <Widget>[
                  FadeInUp(
                    duration: const Duration(milliseconds: 1800),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color.fromRGBO(143, 148, 251, 1)),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(143, 148, 251, 1),
                                  ),
                                ),
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Name",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(143, 148, 251, 1),
                                  ),
                                ),
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Phone Number",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(143, 148, 251, 1),
                                  ),
                                ),
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "GST No. ",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(143, 148, 251, 1),
                                  ),
                                ),
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Address",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                            // const SizedBox(
                            //   height: 8,
                            // )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1900),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(colors: [
                            Color.fromRGBO(143, 148, 251, 1),
                            Color.fromRGBO(143, 148, 251, .6),
                          ])),
                      child: Center(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            print(loginController.text);
                            print(passwordController.text);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProductsScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
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

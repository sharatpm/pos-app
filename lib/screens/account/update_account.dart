import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testnew/screens/account/account_screen.dart';
import 'package:testnew/screens/auth/otp.dart';
import 'package:testnew/screens/products/products.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class UpdateAccount extends StatefulWidget {
  const UpdateAccount({super.key});

  @override
  State<UpdateAccount> createState() => _UpdateAccountState();
}

class _UpdateAccountState extends State<UpdateAccount> {
  var data = {};
  String message = '';
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final gstController = TextEditingController();
  final addressController = TextEditingController();
  final typeController = TextEditingController();

  @override
  initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    print("Build Data: ".toString() + data.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
        title: const Text('POS App',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 25,
            )),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Update Profile",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
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
                              child: TextFormField(
                                // initialValue: data['name'],
                                controller: nameController,
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
                              child: TextFormField(
                                // initialValue: data['email'],
                                controller: emailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email",
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
                              child: TextFormField(
                                // initialValue: data['phno'],
                                controller: phoneController,
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
                              child: TextFormField(
                                // initialValue: data['gst'],
                                controller: gstController,
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
                              child: TextFormField(
                                // initialValue: data['address'],
                                controller: addressController,
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
                              child: TextFormField(
                                // initialValue: data['type'],
                                controller: typeController,
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
                            "Update",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            if (await updateData(
                              emailController.text,
                              nameController.text,
                              phoneController.text,
                              gstController.text,
                              addressController.text,
                              typeController.text,
                            )) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AccountScreen(),
                                ),
                              );
                            } else {
                              // Navigator.pop(context);
                            }
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
      floatingActionButton: Text(
        message,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          backgroundColor: Colors.lightGreen,
          color: Colors.red,
          fontSize: 15,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> getData() async {
    var client = http.Client();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final vendorId = prefs.getString('vendor_id');
    final authToken = prefs.getString('auth_token');
    try {
      var params = {
        // 'vendor_id': vendorId,
        'auth_token': authToken,
      };
      var url = Uri.https(await getURL(),
          'Capstone_Project/AuthenticationService/Login.php', params);
      var response = await http.get(
        url,
      );
      print('...................');
      print(response.body);
      print('...................');
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      if (decodedResponse['status'] == 'success') {
        setState(() {
          data = decodedResponse['data'];

          emailController.text = data['email'];
          nameController.text = data['name'];
          phoneController.text = data['phno'];
          gstController.text = data['gst'];
          addressController.text = data['address'];
          typeController.text = data['type'];
        });

        print("Data: ".toString() + data.toString());
      }
    } finally {
      client.close();
    }
  }

  Future<bool> updateData(String email, String name, String phone, String gst,
      String address, String type) async {
    var client = http.Client();
    try {
      print(name);
      var fields = {
        'email': email,
        'name': name,
        'phno': phone,
        'gst': gst,
        'address': address,
        'type': type,
      };
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final vendorId = prefs.getString('vendor_id');
      final authToken = prefs.getString('auth_token');
      var url = Uri.https(
          await getURL(), 'Capstone_Project/AuthenticationService/Login.php');
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: convert.jsonEncode({
          'auth_token': authToken,
          'fields': fields,
        }),
      );
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      print('...................');
      print(response.body);
      print('...................');
      if (decodedResponse['status'] == 'success') {
        return true;
      } else {
        var message = decodedResponse['message'];
        return false;
      }
    } finally {
      client.close();
    }
  }

  getURL() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('url');
    return url;
  }
}

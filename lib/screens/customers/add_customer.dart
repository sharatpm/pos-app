import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testnew/screens/account_screen.dart';
import 'package:testnew/screens/cart_screen.dart';
import 'package:testnew/screens/print_screen.dart';
import 'package:testnew/screens/products/products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  List pages = [
    const ProductsScreen(),
    CartScreen(),
    PrintScreen(),
    const AccountScreen(),
  ];

  final nameController = TextEditingController();
  final phnumberController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  String barcode = '';

  var scannerButtonColor = Colors.red;

  @override
  void dispose() {
    nameController.dispose();
    phnumberController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<bool> addCustomer(
    String name,
    String phoneNumber,
    String email,
    String address,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('auth_token');
    var rUrl = prefs.getString("url");
    var client = http.Client();
    try {
      var url = Uri.https(
          rUrl ?? '', 'Capstone_Project/CustomerService/CustomerDetails.php');
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'auth_token': authToken ?? '',
          'name': name,
          'phone': phoneNumber,
          'email': email,
          'address': address,
        }),
      );
      var request = {
        'auth_token': authToken,
        'name': name,
        'phone_number': phoneNumber,
        'email': email,
        'address': address,
      };
      print(request);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      print(decodedResponse);
      if (decodedResponse['status'] == 'success') {
        return true;
      } else if (decodedResponse['status'] == 'error') {
        return false;
      } else {
        return false;
      }
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
        title: const Text('POS App'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
            child: Text(
              "Add Customer",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    // border: InputBorder.none,
                    hintText: "Name",
                    hintStyle: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                TextField(
                  controller: phnumberController,
                  decoration: InputDecoration(
                    // border: InputBorder.none,
                    hintText: "Phone Number",
                    hintStyle: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    // border: InputBorder.none,
                    hintText: "Email",
                    hintStyle: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    // border: InputBorder.none,
                    hintText: "Address",
                    hintStyle: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
                ),
                onPressed: () async {
                  if (await addCustomer(
                    nameController.text,
                    phnumberController.text,
                    emailController.text,
                    addressController.text,
                  )) Navigator.pop(context);
                },
                child: const Text("Submit"),
              )
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        onTap: (index) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => pages[index]),
          );
        },
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_rounded),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.print),
            label: 'Print',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

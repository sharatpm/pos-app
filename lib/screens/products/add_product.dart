import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:testnew/screens/account/account_screen.dart';
import 'package:testnew/screens/cart_screen.dart';
import 'package:testnew/screens/print_screen.dart';
import 'package:testnew/screens/products/products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String message = '';
  List pages = [
    ProductsScreen(),
    CartScreen(),
    PrintScreen(),
    const AccountScreen(),
  ];

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final inventoryController = TextEditingController();
  String barcode = '';

  var scannerButtonColor = Colors.red;

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<bool> addProduct(
      String title, String price, String inventory, String barcode) async {
    var client = http.Client();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('auth_token');
    var rUrl = prefs.getString("url");
    print(authToken);
    try {
      var url = Uri.https(
          rUrl ?? '', 'Capstone_Project/ProductService/ProductDetails.php');
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "auth_token": authToken,
          "product_name": title,
          "price": price,
          "inventory": inventory,
          "barcode": barcode,
        }),
      );
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      prefs.setString('message', decodedResponse['message']);
      print(decodedResponse);
      if (decodedResponse['status'] == 'success') {
        return true;
      } else if (decodedResponse['status'] == 'error') {
        setState(() {
          message = decodedResponse['message'];
        });
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
              "Add Product",
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
                  controller: titleController,
                  decoration: InputDecoration(
                    // border: InputBorder.none,
                    hintText: "Title",
                    hintStyle: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    // border: InputBorder.none,
                    hintText: "Price",
                    hintStyle: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                TextField(
                  controller: inventoryController,
                  decoration: InputDecoration(
                    // border: InputBorder.none,
                    hintText: "Inventory",
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
                  backgroundColor: scannerButtonColor,
                ),
                onPressed: () {
                  setState(() async {
                    scannerButtonColor = Colors.green;
                    barcode = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SimpleBarcodeScannerPage(),
                      ),
                    );
                    print(barcode);
                  });
                },
                child: const Icon(Icons.qr_code_scanner),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
                ),
                onPressed: () async {
                  print("Price: " + priceController.text.toString());
                  print("Title: " + titleController.text.toString());
                  print("Inventory: " + inventoryController.text.toString());
                  if (await addProduct(
                    titleController.text.toString(),
                    priceController.text.toString(),
                    inventoryController.text.toString(),
                    barcode = '495579489',
                  )) {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var message = prefs.getString('message');
                    print(message);
                    Navigator.pop(context);
                  }
                },
                child: const Text("Submit"),
              )
            ],
          ),
        ],
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

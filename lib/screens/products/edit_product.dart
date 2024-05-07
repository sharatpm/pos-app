import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:testnew/screens/account/account_screen.dart';
import 'package:testnew/screens/cart_screen.dart';
import 'package:testnew/screens/print_screen.dart';
import 'package:testnew/screens/products/edit_products_list.dart';
import 'package:testnew/screens/products/products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProductScreen extends StatefulWidget {
  int id;
  EditProductScreen({super.key, required this.id});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
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
    inventoryController.dispose();
    super.dispose();
  }

  getProduct() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('auth_token');
    var rUrl = prefs.getString("url");
    var client = http.Client();

    try {
      var params = {
        "auth_token": authToken,
        "product_id": widget.id.toString(),
      };
      var url = Uri.https(rUrl ?? '',
          'Capstone_Project/ProductService/ProductDetails.php', params);
      var response = await http.get(url);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      print(decodedResponse);
      if (decodedResponse['status'] == 'success') {
        titleController.text = decodedResponse['product']['product_name'];
        priceController.text = decodedResponse['product']['price'];
        inventoryController.text =
            decodedResponse['product']['inventory'].toString();
        barcode = decodedResponse['product']['barcode'];
        return true;
      } else if (decodedResponse['status'] == 'error') {
        print("Status error");
      }
    } finally {
      client.close();
    }
  }

  Future<bool> updateProduct(
      String title, String price, String inventory) async {
    var client = http.Client();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('auth_token');
    var rUrl = prefs.getString("url");
    print(authToken);
    try {
      var url = Uri.https(
          rUrl ?? '', 'Capstone_Project/ProductService/ProductDetails.php');
      var fields = {
        "product_name": title,
        "price": price,
        "inventory": inventory,
        "barcode": barcode
      };
      var req = {
        "auth_token": authToken,
        "product_id": widget.id,
        "fields": fields,
      };
      print(req.toString());
      var response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "auth_token": authToken,
          "product_id": widget.id,
          "fields": fields,
        }),
      );
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      print(decodedResponse);
      if (decodedResponse['status'] == 'success') {
        return true;
      }
      if (decodedResponse['status'] == 'error') {
        print(message);
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
  void initState() {
    super.initState();
    getProduct();
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
              "Edit Product",
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
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  var client = http.Client();
                  try {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    final rUrl = prefs.getString('url');
                    final vendorId = prefs.getString('vendor_id');
                    final authToken = prefs.getString('auth_token');
                    var url = Uri.https(rUrl ?? '',
                        'Capstone_Project/ProductService/ProductDetails.php');
                    var response = await http.delete(
                      url,
                      headers: {
                        'Content-Type': 'application/json',
                      },
                      body: jsonEncode({
                        'auth_token': authToken,
                        'vendor_id': vendorId,
                        'product_id': widget.id,
                      }),
                    );
                    var decodedResponse =
                        jsonDecode(utf8.decode(response.bodyBytes));
                    print('...................');
                    print(response.body);
                    print('...................');
                    if (decodedResponse['status'] == 'success') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProductList(),
                        ),
                      );
                    } else {}
                  } finally {
                    client.close();
                  }
                },
                child: const Text('Delete'),
              ),
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
                  if (await updateProduct(
                    titleController.text.toString(),
                    priceController.text.toString(),
                    inventoryController.text.toString(),
                  )) {
                    Navigator.pop(
                      context,
                    );
                  }
                },
                child: const Text("Update"),
              )
            ],
          ),
        ],
      ),
      floatingActionButton: Text(
        message,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:testnew/screens/account_screen.dart';
import 'package:testnew/screens/cart_screen.dart';
import 'package:testnew/screens/print_screen.dart';
import 'package:testnew/screens/products/products.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  List pages = [
    const ProductsScreen(),
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
            padding: EdgeInsets.all(20),
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
                  });
                },
                child: const Icon(Icons.qr_code_scanner),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
                ),
                onPressed: () {
                  Navigator.pop(context);
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

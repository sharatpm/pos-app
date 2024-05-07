import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:testnew/model/cart.dart';
import 'package:testnew/screens/cart_screen.dart';
import 'package:testnew/screens/print_screen.dart';
import 'package:testnew/screens/products/add_product.dart';
import 'package:testnew/screens/products/edit_product.dart';
import 'package:testnew/screens/products/products.dart';
import 'dart:convert' as convert;
import '../account/account_screen.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class EditProductList extends StatefulWidget {
  const EditProductList({super.key});

  @override
  State<EditProductList> createState() => _EditProductListState();
}

class _EditProductListState extends State<EditProductList> {
  String result = '';
  var cart = {};
  var products = [];
  List pages = [
    ProductsScreen(),
    CartScreen(),
    PrintScreen(),
    const AccountScreen(),
  ];
  Future<List> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? auth_token = prefs.getString('auth_token');
    print(auth_token);
    final String? rurl = prefs.getString("url");
    final params = {
      'auth_token': auth_token,
    };
    var url = Uri.https(
      rurl ?? '',
      'Capstone_Project/ProductService/ProductDetails.php',
      params,
    );
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      products = jsonResponse['products'];
      return jsonResponse['products'];
    } else {
      throw ();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
        title: const Text(
          'POS App',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 25,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "All Products",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddProductScreen(),
                      ), //Sharat
                    );
                  },
                  child: const Icon(Icons.add),
                )
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If we got an error
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data![index]['product_name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '₹ '.toString() +
                                    snapshot.data![index]['price'].toString(),
                                style: const TextStyle(
                                  color: Colors.black38,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              print(snapshot.data![index]['id']);
                            },
                            child: TextButton(
                              child: const Text('Edit'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProductScreen(
                                      id: snapshot.data![index]['id'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
                // Displaying LoadingSpinner to indicate waiting state
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              future: fetchData(),
            ),
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
        currentIndex: 3,
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

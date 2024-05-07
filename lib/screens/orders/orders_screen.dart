// ignore_for_file: avoid_print

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:testnew/model/cart.dart';
import 'package:testnew/screens/print_screen.dart';
import 'package:testnew/screens/products/add_product.dart';
import 'package:testnew/screens/products/products.dart';
import 'dart:convert' as convert;
import '../account/account_screen.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:testnew/screens/cart_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var orders = {};
  List pages = [
    ProductsScreen(),
    const CartScreen(),
    PrintScreen(),
    const AccountScreen(),
  ];
  Future<List> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');
    print("Auth Token: ".toString() + authToken.toString());
    final String? rurl = prefs.getString("url");
    final params = {
      'auth_token': authToken,
    };
    var url = Uri.https(
      rurl ?? '',
      'Capstone_Project/OrderService/CompleteCart.php',
      params,
    );
    var response = await http.get(url);
    print('....................');
    print(response.body);
    print('....................');
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse['status']);
      print(jsonResponse['orders'].runtimeType);
      return jsonResponse['orders'];
    } else {
      throw ();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
        title: const Text('POS App',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 25,
            )),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All Orders",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If we got an error
                  print(snapshot.hasData);
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
                                "Order #".toString() +
                                    snapshot.data![index]['order_id']
                                        .toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                              OrderBlock(
                                products: snapshot.data![index]['products'],
                              ),
                            ],
                          ),
                          trailing: Text(snapshot.data![index]['created_at']),
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

class OrderBlock extends StatefulWidget {
  List<dynamic> products;
  OrderBlock({
    super.key,
    required this.products,
  });

  @override
  State<OrderBlock> createState() => _OrderBlockState();
}

class _OrderBlockState extends State<OrderBlock> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.products[index]['product_name'],
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          trailing: Text(widget.products[index]['quantity'].toString()),
        );
      },
    );
  }
}

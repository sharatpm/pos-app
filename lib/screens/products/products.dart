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
import 'dart:convert' as convert;
import '../account_screen.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:testnew/screens/cart_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String result = '';
  var cart = {};
  var products = [];
  List pages = [
    const ProductsScreen(),
    CartScreen(),
    PrintScreen(),
    const AccountScreen(),
  ];
  @override
  // ignore: must_call_super
  initState() {
    startDB();
    setCarts();
  }

  Future<void> startDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    openDatabase(
      join(await getDatabasesPath(), 'carts.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE carts(id INTEGER PRIMARY KEY, price FLOAT, title TEXT, barcode INTEGER, quantity INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<Database> getDB() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'carts.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE carts(id INTEGER PRIMARY KEY, price FLOAT, title TEXT, barcode INTEGER, quantity INTEGER)',
        );
      },
      version: 1,
    );
    return database;
  }

  Future<void> setCarts() async {
    // Get a reference to the database.
    final db = await getDB();

    // Query the table for all the dogs.
    final List<Map<String, Object?>> cartMaps = await db.query('carts');

    // Convert the list of each dog's fields into a list of `Dog` objects.
    [
      for (final {
            'id': id as int,
            'title': title as String,
            'price': price as double,
            'barcode': barcode as int,
            'quantity': quantity as int,
          } in cartMaps)
        cart[id] = Cart(
          id: id,
          title: title,
          price: price,
          barcode: barcode,
          quantity: quantity,
        ),
    ];
  }

  Future<List> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? vendor_id = prefs.getString('vendor_id');
    final String? auth_token = prefs.getString('auth_token');
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
      // print(jsonResponse['record']['products']);
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
        title: const Text('POS App',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 25,
            )),
        actions: [
          IconButton(
            onPressed: () async {
              var res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimpleBarcodeScannerPage(),
                  ));
              if (res != -1) {
                print(res);
                final db = await getDB();
                await db.rawQuery(
                    'UPDATE carts SET quantity = quantity + 1 WHERE barcode=$res');
              }
              setState(() {
                if (res is String) {
                  result = res;
                  print(result);
                }
              });
            },
            icon: const Icon(Icons.view_in_ar),
          ),
        ],
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
                          builder: (context) =>
                              const AddProductScreen()), //Sharat
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
                          trailing: CartButton(
                              id: snapshot.data![index]['id'],
                              cart: cart,
                              products: products),
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

// ignore: must_be_immutable
class CartButton extends StatefulWidget {
  int id;
  Map<dynamic, dynamic> cart;
  // Map<dynamic, dynamic>
  List<dynamic> products;
  CartButton({
    super.key,
    required this.id,
    required this.cart,
    required this.products,
  });

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  @override
  // ignore: must_call_super
  initState() {
    startDB();
  }

  Future<void> startDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    openDatabase(
      join(await getDatabasesPath(), 'carts.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE carts(id INTEGER PRIMARY KEY, price FLOAT, title TEXT, barcode INTEGER, quantity INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<Database> getDB() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'carts.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE carts(id INTEGER PRIMARY KEY, price FLOAT, title TEXT, barcode INTEGER, quantity INTEGER)',
        );
      },
      version: 1,
    );
    return database;
  }

  Future<void> insertCart(Cart cart) async {
    final db = await getDB();

    await db.insert(
      'carts',
      cart.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> cartExists(Cart cart) async {
    final db = await getDB();
    int id = 1;

    int? count = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM carts WHERE id=$id"));

    if (count == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Cart>> carts() async {
    final db = await getDB();

    final List<Map<String, Object?>> cartMaps = await db.query('carts');
    return [
      for (final {
            'id': id as int,
            'title': title as String,
            'price': price as double,
            'barcode': barcode as int,
            'quantity': quantity as int,
          } in cartMaps)
        Cart(
          id: id,
          title: title,
          price: price,
          barcode: barcode,
          quantity: quantity,
        ),
    ];
  }

  Future<void> addOneToCart() async {
    final db = await getDB();
    int id = widget.id;
    await db.rawQuery('UPDATE carts SET quantity = quantity + 1 WHERE ID=$id');
  }

  Future<void> removeOneFromCart() async {
    final db = await getDB();
    int id = widget.id;
    await db.rawUpdate('UPDATE carts SET quantity = quantity - 1 WHERE ID=$id');
    List quantityResp =
        await db.rawQuery("SELECT QUANTITY FROM carts WHERE id=$id");
    int quantity = quantityResp[0]['quantity'];
    if (quantity == 0) {
      await db.rawDelete("DELETE FROM carts WHERE id =$id");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.cart.keys.contains(widget.id) ||
        widget.cart[widget.id].quantity == 0) {
      return Container(
        alignment: Alignment.center,
        width: 90,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(143, 148, 251, 0.7),
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                color: Colors.white,
              )),
          child: const Text("Add"),
          onPressed: () {
            String title = "";
            String price = "";
            for (var product in widget.products) {
              if (product['id'] == widget.id) {
                title = product['product_name'];
                price = product['price'];
              }
            }
            setState(() {
              if (!widget.cart.keys.contains(widget.id)) {
                widget.cart[widget.id] = Cart(
                  id: widget.id,
                  title: title,
                  price: double.parse(price),
                  barcode: 123456789,
                  quantity: 1,
                );
                insertCart(widget.cart[widget.id]);
              } else {
                widget.cart[widget.id].quantity = 1;
              }
            });
          },
        ),
      );
    } else {
      return SizedBox(
        width: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(143, 148, 251, 0.7),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(0),
                ),
                child: const Text('-'),
                onPressed: () {
                  setState(() {
                    removeOneFromCart();
                    if (widget.cart.keys.contains(widget.id)) {
                      widget.cart[widget.id].quantity -= 1;
                    }
                  });
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 30,
              height: 30,
              child: Text(widget.cart[widget.id].toString() ?? '0'),
            ),
            SizedBox(
              width: 30,
              height: 30,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(143, 148, 251, 0.7),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(0),
                ),
                child: const Text('+'),
                onPressed: () {
                  setState(() {
                    addOneToCart();
                    if (widget.cart.keys.contains(widget.id)) {
                      widget.cart[widget.id].quantity += 1;
                    }
                  });
                },
              ),
            ),
          ],
        ),
      );
    }
  }

  getURL() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('url');
    return url;
  }
}

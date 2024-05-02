import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:testnew/screens/account_screen.dart';
import 'package:testnew/screens/customers/add_customer.dart';
import 'package:testnew/screens/print_screen.dart';
import 'package:testnew/screens/products/products.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// ignore: must_be_immutable
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var cart = [];
  String result = '';
  List pages = [
    const ProductsScreen(),
    const CartScreen(),
    PrintScreen(),
    const AccountScreen(),
  ];
  final numberController = TextEditingController();

  @override
  initState() {
    super.initState();
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

  Future<List> fetchData() async {
    startDB();
    final db = await getDB();
    List data = await db.rawQuery("SELECT * FROM carts");
    print(data.toString());
    return data;
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
              setState(() {
                if (res is String) {
                  result = res;
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
            padding: const EdgeInsets.all(20),
            // width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 30,
                  width: 140,
                  child: TextField(
                    controller: numberController,
                    decoration: InputDecoration(
                      hintText: "Customer Number",
                      hintStyle: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
                  ),
                  onPressed: () {
                    print("Added");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const AddCustomerScreen()), //Sharat
                    );
                  },
                  child: const Icon(Icons.add),
                ),
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
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data![index]['title'],
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
                          trailing: Text(
                              snapshot.data![index]['quantity'].toString()),
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
      // const Padding(
      //   padding: EdgeInsets.all(10),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(
      //         'Cart',
      //         style: TextStyle(
      //           fontWeight: FontWeight.w500,
      //           color: Colors.black87,
      //           fontSize: 32,
      //         ),
      //       ),
      //       Text(
      //         'Empty Cart',
      //         style: TextStyle(
      //           fontWeight: FontWeight.w500,
      //           color: Colors.black38,
      //           fontSize: 16,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        currentIndex: 1,
        onTap: (index) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => pages[index]),
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.print),
            label: 'Print',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:testnew/screens/account/update_account.dart';
import 'package:testnew/screens/auth/logout.dart';
import 'package:testnew/screens/cart_screen.dart';
import 'package:testnew/screens/customers/customers.dart';
import 'package:testnew/screens/orders/orders_screen.dart';
import 'package:testnew/screens/print_screen.dart';
import 'package:testnew/screens/products/edit_products_list.dart';
import 'package:testnew/screens/products/products.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List pointers = [
    {'name': 'Edit Profile', 'link': const UpdateAccount()},
    {'name': 'Edit Products', 'link': const EditProductList()},
    {'name': 'View all Orders', 'link': const OrdersScreen()},
    {'name': 'View Customers', 'link': const CustomersScreen()},
    {'name': 'Logout', 'link': const LogOutScreen()},
  ];
  List pages = [
    ProductsScreen(),
    CartScreen(),
    PrintScreen(),
    AccountScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
        title: const Text('Account'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: pointers.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                pointers[index]['link']), //Sharat
                      );
                    },
                    child: Text(
                      pointers[index]['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
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

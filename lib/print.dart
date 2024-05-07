import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testnew/model/cart.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '/printerenum.dart' as printenum;

class Print {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

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

  Future<List<Cart>> getcarts() async {
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

  Future<Map<dynamic, dynamic>> retrieveOrderDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await startDB();
    List carts = await getcarts();
    var lineItems = [];
    for (var cart in carts) {
      lineItems.add({'product_id': cart.id, 'quantity': cart.quantity});
    }
    print(lineItems);
    final String? rurl = prefs.getString("url");
    final String? vendorId = prefs.getString('vendor_id');
    final String? authToken = prefs.getString('auth_token');
    final orderDetails = {};
    print("Vendor Id: $vendorId & Auth Token: $authToken");
    if (authToken != null) {
      var url = Uri.https(
          rurl ?? '', 'Capstone_Project/OrderService/CompleteCart.php');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: convert.jsonEncode({
          'auth_token':
              authToken.toString(), // Ensure authToken is converted to string
          'line_items': lineItems,
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        orderDetails['order_id'] = jsonResponse['order_id'];
        orderDetails['tax_value'] = jsonResponse['tax_value'];
        orderDetails['created_at'] = jsonResponse['created_at'];
        orderDetails['total_value'] = jsonResponse['total_value'];
        sample(orderDetails);
        print(orderDetails);
        return orderDetails;
      } else {
        print("Request failed with status: ${response.statusCode}");
        throw Exception('Failed to fetch order details');
      }
    } else {
      print("Auth token is null");
      throw Exception('Auth token is null');
    }
  }

  sample(orderDetails) async {
    await startDB();
    await startDB();
    List carts = await getcarts();
    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        for (Cart cart in carts) {
          double totalPrice = cart.price * cart.quantity.toDouble();
          bluetooth.printCustom(
              cart.title, printenum.Size.bold.val, printenum.Align.left.val);
          bluetooth.printCustom("Rs. ".toString() + totalPrice.toString(),
              printenum.Size.bold.val, printenum.Align.right.val);
          bluetooth.printLeftRight(
              "Quantity: ".toString() + cart.quantity.toString(),
              "Unit Price: Rs. ".toString() + cart.price.toString(),
              printenum.Size.medium.val);
          bluetooth.printNewLine();
        }
        bluetooth.paperCut();
      }
    });
  }
}

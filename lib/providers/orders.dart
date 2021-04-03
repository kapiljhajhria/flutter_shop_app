import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem with ChangeNotifier {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.datTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String? authToken;

  Orders(this.authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        "https://shop-app-4ff74-default-rtdb.firebaseio.com/orders.json?auth=$authToken";
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    // ignore: unnecessary_null_comparison
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'] as double,
          datTime: DateTime.parse(orderData['dateTime'].toString()),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'].toString(),
                  price: item['price'] as double,
                  quantity: item['quantity'] as int,
                  title: item['title'].toString(),
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url =
        "https://shop-app-4ff74-default-rtdb.firebaseio.com/orders.json";
    final timestamp = DateTime.now();

    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts.map((cp) {
          return {
            'id': cp.id,
            'title': cp.title,
            'price': cp.price,
            'quantity': cp.quantity
          };
        }).toList(),
      }),
    );
    //insert so latest order it at top
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'].toString(),
            amount: total,
            products: cartProducts,
            datTime: timestamp));

    notifyListeners();
  }
}

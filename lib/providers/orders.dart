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
  final String? userId;

  Orders(this.authToken, this._orders, this.userId);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        "https://shop-app-4ff74-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body);
    // ignore: unnecessary_null_comparison
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId.toString(),
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
    final url =
        "https://shop-app-4ff74-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";
    final timestamp = DateTime.now();
    http.Response response;
    try {
      response = await http.post(
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
      _orders.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'].toString(),
              amount: total,
              products: cartProducts,
              datTime: timestamp));

      notifyListeners();
    } catch (error) {
      rethrow;
    }
    //insert so latest order it at top
  }
}

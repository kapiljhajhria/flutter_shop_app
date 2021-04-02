import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';

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
  final List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    //insert so latest order it at top
    _orders.insert(
        0,
        OrderItem(
            id: DateTime.now().toString(),
            amount: total,
            products: cartProducts,
            datTime: DateTime.now()));

    notifyListeners();
  }
}

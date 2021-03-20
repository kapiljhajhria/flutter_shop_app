import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quanity;
  final double price;

  CartItem(
      {required this.id,
      required this.title,
      required this.quanity,
      required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items=Map();

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount{
    return _items.length;
  }

  void addItem(String productId, double price, String title) {
    //look if the product already exist in the cart or not
    //if found increase its quantity by 1

    if (_items.containsKey(productId)) {
      //found product in cart
      //increase the quantity
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              quanity: existingCartItem.quanity+1,
              price: existingCartItem.price));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quanity: 1,
              price: price));
    }
    notifyListeners();
  }
}

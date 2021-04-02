import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class Products with ChangeNotifier {
  static const url =
      "https://shop-app-4ff74-default-rtdb.firebaseio.com/products.json";

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteOnlyItems {
    return [..._items.where((item) => item.isFavorite).toList()];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    try {
      final http.Response response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) == null
          ? {}
          : json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      extractedData.forEach((productId, productData) => {
            loadedProducts.add(Product(
                id: productId.toString(),
                title: productData["title"].toString(),
                description: productData["description"].toString(),
                price: productData["price"] as double,
                imageUrl: productData["imageUrl"].toString()))
          });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProduct(
      {required String title,
      required String description,
      required String price,
      required String imageUrl}) async {
    final Map<String, dynamic> data = {
      // "id": DateTime.now().toString(),
      "title": title,
      "description": description,
      "price": double.parse(price),
      "imageUrl": imageUrl
    };
    final http.Response response =
        await http.post(Uri.parse(url), body: json.encode(data));
    //response.body.name will give you the new doc id.
    debugPrint(response.statusCode.toString());
    debugPrint(response.body);
    final String productId = json.decode(response.body)["name"].toString();
    _items.add(
      Product(
          id: productId,
          title: title,
          description: description,
          price: double.parse(price),
          imageUrl: imageUrl),
    );
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    debugPrint("product id to update $id");
    debugPrint("product to add ${newProduct.title}");
    await Future.delayed(const Duration(seconds: 6));
    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    _items[prodIndex] = newProduct;
    notifyListeners();
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}

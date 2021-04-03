import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  final String? authToken;

  Products(this.authToken, this._items);

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
    final url =
        "https://shop-app-4ff74-default-rtdb.firebaseio.com/products.json?auth=$authToken";
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
                // ignore: avoid_bool_literals_in_conditional_expressions
                isFavorite: productData['isFavorite'] != null
                    ? productData['isFavorite'] as bool
                    : false,
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
    final url =
        "https://shop-app-4ff74-default-rtdb.firebaseio.com/products.json?auth=$authToken";
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
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          "https://shop-app-4ff74-default-rtdb.firebaseio.com/products/$id.json";
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));
      _items[prodIndex] = newProduct;
    } else {
      debugPrint("product ot found for edit");
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url =
        "https://shop-app-4ff74-default-rtdb.firebaseio.com/products/$id.json";
    final index = _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[index];
    _items.removeAt(index);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode >= 400) {
      _items.insert(index, existingProduct);
      notifyListeners();
      throw HttpException("Failed to delete product");
    }
    existingProduct = null;
  }
}

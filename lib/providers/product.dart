import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  // Product.fromFormMap(Map<String, String> formData) {
  //   this.id = formData["id"]!;
  //   this.title = formData["title"]!;
  //   this.description = formData["description"]!;
  //   this.imageUrl = formData["imageUrl"]!;
  //   this.isFavorite = false;
  //   this.price = double.parse(formData["price"]!);
  // }

  Product.fromFormMapData(Map<String, String> formData)
      : id = "p99",
        title = formData["title"]!,
        description = formData["description"]!,
        imageUrl = formData["imageUrl"]!,
        isFavorite = false,
        price = double.parse(formData["price"]!);
  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  void toggleFavourite(
    String? authToken,
    String userId,
  ) {
    final bool oldStatus = isFavorite;
    _setFavValue(!isFavorite);
    final url =
        "https://shop-app-4ff74-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken";
    http.put(Uri.parse(url), body: json.encode(isFavorite)).then((response) {
      //
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    }).catchError((error) {
      _setFavValue(oldStatus);
    });
  }
}

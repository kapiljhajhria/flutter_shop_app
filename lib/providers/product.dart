import 'package:flutter/foundation.dart';

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

  void toggleFavourite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}

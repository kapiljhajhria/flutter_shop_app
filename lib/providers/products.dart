import 'package:flutter/material.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/Men-Red-Plaid-Shirts-2016-Slim-Long-Sleeve-Brand-Formal-Business-Fashion-Dress-Shirts-Male-Social.jpg/600px-Men-Red-Plaid-Shirts-2016-Slim-Long-Sleeve-Brand-Formal-Business-Fashion-Dress-Shirts-Male-Social.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  // bool _favoritesOnly = false;

  // showFavoritesOnly() {
  //   _favoritesOnly = true;
  //   notifyListeners();
  // }
  //
  // showAll() {
  //   _favoritesOnly = false;
  //   notifyListeners();
  // }

  List<Product> get items {
    // if (_favoritesOnly) {
    //   return [..._items.where((product) => product.isFavorite).toList()];
    // }
    return [..._items];
  }

  List<Product> get favoriteOnlyItems {
    // if (_favoritesOnly) {
    //   return [..._items.where((product) => product.isFavorite).toList()];
    // }
    return [..._items.where((item) => item.isFavorite).toList()];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void addProduct(
      {required String title,
      required String description,
      required String price,
      required String imageUrl}) {
    _items.add(
      Product(
          id: DateTime.now().toString(),
          title: title,
          description: description,
          price: double.parse(price),
          imageUrl: imageUrl),
    );
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    print("product id to update $id");
    print("product to add ${newProduct.title}");
    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    _items[prodIndex] = newProduct;
    notifyListeners();
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';

enum FilterOption { Favorites, All }

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (selectedValue) {
              if (selectedValue == FilterOption.Favorites) {
                productsContainer.showFavoritesOnly();
              } else if (selectedValue == FilterOption.All) {
                productsContainer.showAll();
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry>[
                PopupMenuItem(
                  child: Text("Favorites"),
                  value: FilterOption.Favorites,
                ),
                PopupMenuItem(
                  child: Text("All "),
                  value: FilterOption.All,
                )
              ];
            },
          ),
        ],
      ),
      body: ProductsGrid(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Provider.of<Products>(context, listen: false).addProduct();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/widgets/badge.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';

enum FilterOption { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          Consumer<Cart>(
            builder: (BuildContext context, cart,ch) => Badge(
                  value: cart.itemCount.toString(),
                  color: Theme.of(context).accentColor, child: ch!,),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                //go to cart screen
                Navigator.of(context).pushNamed(CartScreen.routerName);
              },
            ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (selectedValue) {
              if (selectedValue == FilterOption.Favorites) {
                // productsContainer.showFavoritesOnly();
                _showOnlyFavorites = true;
              } else if (selectedValue == FilterOption.All) {
                // productsContainer.showAll();
                _showOnlyFavorites = false;
              }
              setState(() {});
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
      body: ProductsGrid(_showOnlyFavorites),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Provider.of<Products>(context, listen: false).addProduct();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/widgets/app_drawer.dart';
import 'package:flutter_complete_guide/widgets/badge.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';

enum FilterOption { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  static String routeName = "/overview";
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;
  bool _isInit = true;
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        ///ToDo: handle this setSate properly. Its called after widget is disposed
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          Consumer<Cart>(
            builder: (BuildContext context, cart, ch) => Badge(
              value: cart.itemCount.toString(),
              color: Theme.of(context).accentColor,
              child: ch!,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                //go to cart screen
                Navigator.of(context).pushNamed(CartScreen.routerName);
              },
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (selectedValue) {
              if (selectedValue == FilterOption.favorites) {
                // productsContainer.showFavoritesOnly();
                _showOnlyFavorites = true;
              } else if (selectedValue == FilterOption.all) {
                // productsContainer.showAll();
                _showOnlyFavorites = false;
              }
              setState(() {});
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry>[
                const PopupMenuItem(
                  value: FilterOption.favorites,
                  child: Text("Favorites"),
                ),
                const PopupMenuItem(
                  value: FilterOption.all,
                  child: Text("All "),
                )
              ];
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: ProductsGrid(
          showOnlyFavorites: _showOnlyFavorites,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Provider.of<Products>(context, listen: false).addProduct();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

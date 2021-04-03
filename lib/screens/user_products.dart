import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/widgets/app_drawer.dart';
import 'package:flutter_complete_guide/widgets/user_product_items.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  static String routeName = "/user-products";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(filterByUser: true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              //go to screen where user can add new products
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (BuildContext context, AsyncSnapshot myProductsSnapshot) {
          if (myProductsSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            onRefresh: () => _refreshProducts(context),
            child: Consumer<Products>(
              builder: (ctx, productsData, _child) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: productsData.items.length,
                    itemBuilder: (_, index) {
                      return Column(
                        children: [
                          UserProductItem(
                            key: ValueKey(productsData.items[index].id),
                            title: productsData.items[index].title,
                            imageUrl: productsData.items[index].imageUrl,
                            id: productsData.items[index].id,
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

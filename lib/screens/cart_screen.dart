import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart' show Cart;
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:flutter_complete_guide/screens/orders_screen.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routerName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: Column(
        children: [
          buildTotalCard(cart, context),
          Expanded(
            child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (context, index) {
                  final cartItemKey = cart.items.keys.toList()[index];
                  final cartItem = cart.items[cartItemKey]!;
                  return CartItem(
                    id: cartItem.id,
                    title: cartItem.title,
                    quantity: cartItem.quantity,
                    price: cartItem.price,
                    productId:
                        cartItemKey, //productId needed to remove the product from cart as its the key value in items map
                  );
                }),
          ),
          buildTotalCard(cart, context),
        ],
      ),
    );
  }

  Card buildTotalCard(Cart cart, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        //Total Amount and Order Now Button Row
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              width: 10,
            ),
            Chip(
              label: Text(
                "\$${cart.totalAmount}",
                style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.headline6!.color),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            const Spacer(),
            TextButton(
                onPressed: () {
                  //place the order, move to confirmation or payment screen
                  //add current order to orders list
                  Provider.of<Orders>(context, listen: false)
                      .addOrder(cart.items.values.toList(), cart.totalAmount);
                  //empty the active cart now as we have moved to orders page
                  cart.emptyCart();
                  //move to orders screen
                  Navigator.of(context).pushNamed(OrdersScreen.routeName);
                },
                child: Text(
                  "ORDER NOW",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ))
          ],
        ),
        //Summary Cart with all items and option to remove or change their qty
      ),
    );
  }
}

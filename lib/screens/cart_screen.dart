import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart' show Cart;
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routerName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Column(
        children: [
          buildTotalCard(cart, context),
          Expanded(
            child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (context, index) {
                  final cartItemKey=cart.items.keys.toList()[index];
                  final cartItem=cart.items[cartItemKey]!;
                  return CartItem(id: cartItemKey, title: cartItem.title, quantity: cartItem.quantity, price: cartItem.price);
                }),
          ),
          buildTotalCard(cart, context),
        ],
      ),
    );
  }

  Card buildTotalCard(Cart cart, BuildContext context) {
    return Card(
          margin: EdgeInsets.all(12),
          child: Padding(
            padding: EdgeInsets.all(8),
            //Total Amount and Order Now Button Row
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 10,
                ),
                Chip(
                  label: Text(
                    "\$${cart.totalAmount}",
                    style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .headline6!
                            .color),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                Spacer(),
                TextButton(
                    onPressed: () {
                      //place the order, move to confirmation or payment screen
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

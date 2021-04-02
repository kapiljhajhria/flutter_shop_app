import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;
  final String productId;

  const CartItem(
      // ignore: avoid_unused_constructor_parameters
      {Key? key,
      required this.productId,
      required this.id,
      required this.price,
      required this.quantity,
      required this.title});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      //only from right to left direction allowed
      direction: DismissDirection.endToStart,
      //action on dismiss
      onDismissed: (direction) {
        //remove cart item with given id
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Remove Item"),
              content:
                  const Text("Do you want to remove this item from the cart?"),
              actions: [
                TextButton(
                  onPressed: () {
                    // return true;
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Yes"),
                ),
                TextButton(
                  onPressed: () {
                    // return false;
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("No"),
                )
              ],
            );
          },
        );
      },
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text("\$$price"),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text("Total:\$${price * quantity}"),
            trailing: Text("$quantity x"),
          ),
        ),
      ),
    );
  }
}

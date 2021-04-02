import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(
      // ignore: avoid_unused_constructor_parameters
      {Key? key,
      required this.title,
      required this.imageUrl,
      required this.id});

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                //start editing product
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () async {
                //delete product
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                    "Deleted $title",
                  )));
                } catch (e) {
                  scaffold.showSnackBar(const SnackBar(
                      content: Text("Failed to Delete the Product")));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

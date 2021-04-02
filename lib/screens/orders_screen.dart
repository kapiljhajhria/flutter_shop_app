import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/orders.dart' show Orders;
import 'package:flutter_complete_guide/widgets/app_drawer.dart';
import 'package:flutter_complete_guide/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static String routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (dataSnapShot.error != null) {
            return const Center(
              child: Text("Error Occured!, Try Again"),
            );
          }
          return Consumer<Orders>(
            builder: (ctx, ordersData, _child) {
              return ListView.builder(
                itemCount: ordersData.orders.length,
                itemBuilder: (ctx, index) {
                  return OrderItem(
                    orderItem: ordersData.orders[index],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem orderItem;

  // ignore: avoid_unused_constructor_parameters
  const OrderItem({Key? key, required this.orderItem});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: _expanded
          ? min(widget.orderItem.products.length * 20.0 + 110, 200)
          : 95,
      duration: const Duration(milliseconds: 300),
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              title: Text("\$${widget.orderItem.amount}"),
              subtitle: Text(
                DateFormat('dd-MM-yyyy hh:mm').format(widget.orderItem.datTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: _expanded
                  ? min(widget.orderItem.products.length * 20.0 + 10, 200)
                  : 0,
              child: ListView.builder(
                itemCount: widget.orderItem.products.length,
                itemBuilder: (_, index) {
                  final CartItem orderProduct =
                      widget.orderItem.products[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        orderProduct.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(),
                      Text(
                        "${orderProduct.quantity} x \$${orderProduct.price} = \$${orderProduct.price * orderProduct.quantity} ",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

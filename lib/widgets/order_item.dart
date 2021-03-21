import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem orderItem;

  const OrderItem({Key? key, required this.orderItem});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            onTap: (){
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
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: min(widget.orderItem.products.length * 20.0 + 20, 200),
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(),
                      Text(
                        "${orderProduct.quantity} x \$${orderProduct.price} = \$${orderProduct.price * orderProduct.quantity} ",
                        style: TextStyle(
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
    );
  }
}

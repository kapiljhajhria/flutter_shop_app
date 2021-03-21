import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static String routeName = "/userProducts";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Products"),
      ),
      drawer: AppDrawer(),
      body: Container(),
    );
  }
}

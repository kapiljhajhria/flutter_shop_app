import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/helpers/custom_router.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/screens/orders_screen.dart';
import 'package:flutter_complete_guide/screens/user_products.dart';
import 'package:provider/provider.dart';

import './providers/products.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import 'screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(null, [], null),
          update: (ctx, auth, previousProduct) {
            return Products(auth.token, previousProduct!.items, auth.userId);
          },
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(null, [], null),
          update: (ctx, auth, previousOrders) {
            return Orders(auth.token, previousOrders!.orders, auth.userId);
          },
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _child) {
          return MaterialApp(
            key: Key('auth_${auth.isAuth}'),
            debugShowCheckedModeBanner: false,
            title: 'MyShop',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
                textTheme: const TextTheme(
                  headline6: TextStyle(color: Colors.white),
                ),
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                })),
            home: auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SplashScreen();
                      }

                      return AuthScreen();
                    },
                  ),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routerName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              ProductsOverviewScreen.routeName: (ctx) =>
                  ProductsOverviewScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
            },
          );
        },
      ),
    );
  }
}

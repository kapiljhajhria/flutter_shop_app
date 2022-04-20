import './startup/mainimports.dart';

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
            theme: themeData,
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

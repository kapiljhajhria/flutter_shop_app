import 'package:flutter/material.dart';

class CustomRoute extends MaterialPageRoute {
  // ignore: avoid_unused_constructor_parameters
  CustomRoute({required WidgetBuilder builder, required RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // TODO: implement buildTransitions
    if (settings.name == "/") {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
    //
  }
}

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    // TODO: implement buildTransitions
    if (route.settings.name == "/") {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
    //
  }
}

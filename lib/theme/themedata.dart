import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/helpers/custom_router.dart';

ThemeData themeData = ThemeData(
  primarySwatch: Colors.purple,
  colorScheme: ColorScheme.fromSwatch(
    accentColor: Colors.deepOrange,
  ),
  fontFamily: 'Lato',
  textTheme: const TextTheme(
    headline6: TextStyle(color: Colors.white),
  ),
  pageTransitionsTheme: PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CustomPageTransitionBuilder(),
      TargetPlatform.iOS: CustomPageTransitionBuilder(),
    },
  ),
);

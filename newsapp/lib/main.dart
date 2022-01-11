import 'package:flutter/material.dart';
import 'package:newsapp/providers/newsprovider.dart';
import './screens/home.dart';

import 'package:provider/provider.dart';
import './screens/category.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (ctx) => newsProvider(),
    child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (ctx) => HomeScreen(),
        // HomeScreen.routeName: (ctx) => HomeScreen(),
        categoryScreen.routeName: (ctx) => categoryScreen(category: "india")
      },
    ),
  ));
}

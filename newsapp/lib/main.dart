import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newsapp/providers/newsprovider.dart';
import './screens/home.dart';

import 'package:provider/provider.dart';
import './screens/category.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(ChangeNotifierProvider(
    create: (ctx) => newsProvider(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (ctx) => const HomeScreen(),
        // HomeScreen.routeName: (ctx) => HomeScreen(),
        categoryScreen.routeName: (ctx) =>
            const categoryScreen(category: "india")
      },
    ),
  ));
}

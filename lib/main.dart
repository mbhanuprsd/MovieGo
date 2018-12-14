import 'package:flutter/material.dart';
import 'package:movie_go/pages/splash_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieGo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        accentColor: Colors.deepOrange,
      ),
      home: SplashPage(),
    );
  }
}

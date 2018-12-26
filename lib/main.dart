import 'package:flutter/material.dart';
import 'package:movie_go/pages/splash_page.dart';

void main() => runApp(MyApp());

var primaryColor = Colors.amber;
var accentColor = Colors.black;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieGo',
      theme: ThemeData(
        primarySwatch: primaryColor,
        accentColor: accentColor,
        scaffoldBackgroundColor: accentColor,
        hintColor: primaryColor,
        buttonTheme: ButtonThemeData(
          buttonColor: primaryColor,
          highlightColor: accentColor,
          height: 50.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        cursorColor: Colors.pink,
      ),
      home: SplashPage(),
    );
  }
}

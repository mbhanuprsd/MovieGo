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
        accentColor: Color(0xFF4E342E),
        scaffoldBackgroundColor: Color(0xFF4E342E),
        hintColor: Colors.amber,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.amber,
          highlightColor: Color(0xFF4E342E),
          height: 50.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        cursorColor: Colors.purple,
      ),
      home: SplashPage(),
    );
  }
}

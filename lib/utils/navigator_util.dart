import 'package:flutter/material.dart';
import 'package:movie_go/pages/home_page.dart';
import 'package:movie_go/pages/movie_search_page.dart';

class MyNavigator {
  static void goToHome(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  static void goToSearch(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MovieSearchPage()));
  }
}

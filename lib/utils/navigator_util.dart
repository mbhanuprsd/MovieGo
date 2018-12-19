import 'package:flutter/material.dart';
import 'package:movie_go/models/movie_search_model.dart';
import 'package:movie_go/pages/home_page.dart';
import 'package:movie_go/pages/login_page.dart';
import 'package:movie_go/pages/movie_info_page.dart';
import 'package:movie_go/pages/movie_search_page.dart';
import 'package:movie_go/pages/signup_page.dart';

class MyNavigator {
  static void goToLogin(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  static void goToSignUp(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }

  static void goToHome(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  static void goToSearch(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MovieSearchPage()));
  }

  static void goToMovieInfo(BuildContext context, MovieInfo movieInfo) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MovieInfoPage(movieInfo)));
  }
}

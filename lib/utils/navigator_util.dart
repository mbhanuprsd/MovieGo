import 'package:flutter/material.dart';
import 'package:movie_go/pages/home_page.dart';
import 'package:movie_go/pages/info_page.dart';
import 'package:movie_go/pages/login_page.dart';
import 'package:movie_go/pages/movie_info_page.dart';
import 'package:movie_go/pages/movie_search_page.dart';
import 'package:movie_go/pages/people_info_page.dart';
import 'package:movie_go/pages/people_search_page.dart';
import 'package:movie_go/pages/signup_page.dart';
import 'package:movie_go/pages/tv_info_page.dart';
import 'package:movie_go/pages/tv_search_page.dart';

class MyNavigator {
  static void goToLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false);
  }

  static void goToSignUp(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }

  static void goToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
  }

  static void goToMovieSearch(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MovieSearchPage()));
  }

  static void goToPeopleSearch(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PeopleSearchPage()));
  }

  static void goToMovieInfo(BuildContext context, int movieId) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MovieInfoPage(movieId)));
  }

  static void goToPersonInfo(BuildContext context, int personId) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PeopleInfoPage(personId)));
  }

  static void goToDeveloperInfo(BuildContext context, String userName) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => InfoPage(userName)));
  }

  static void goToTVInfo(BuildContext context, int tvId) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TVInfoPage(tvId)));
  }

  static void goToTVSearch(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TVSearchPage()));
  }
}

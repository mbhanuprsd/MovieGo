import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_go/models/movie_search_model.dart';
import 'package:movie_go/tmdb.dart';

class MovieSearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MovieSearchPageState();
}

class MovieSearchPageState extends State<MovieSearchPage> {
  String logMessage;
  int pageNumber = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          maxLines: 1,
          onChanged: searchMovies,
        ),
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(logMessage ?? ''),
          ],
        ),
      ),
    );
  }

  bool searching;
  searchMovies(String searchString) {
    if (searchString != null && searchString.length > 1 && !searching) {
      searching = true;
      HttpClient()
          .getUrl(Uri.parse("https://api.themoviedb.org/3/search/movie?api_key=" +
              TMDB.key +
              "&language=en-US&query=$searchString&page=$pageNumber&include_adult=false")) // produces a request object
          .then((request) => request.close()) // sends the request
          .then((response) {
        response.transform(utf8.decoder).join().then((jsonString) {
          Map mapJson = json.decode(jsonString);
          MovieSearchData data = MovieSearchData.fromJson(mapJson);

          searching = false;
          setState(() {});
        }).catchError((e) {
          searching = false;
        });
      });
    }
  }
}

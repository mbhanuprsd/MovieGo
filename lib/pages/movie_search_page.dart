import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_go/listitems/movie_item.dart';
import 'package:movie_go/models/movie_search_model.dart';
import 'package:movie_go/tmdb.dart';
import 'package:movie_go/utils/app_util.dart';

class MovieSearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MovieSearchPageState();
}

class MovieSearchPageState extends State<MovieSearchPage> {
  String logMessage;
  String searchString;
  int pageNumber = 1;
  List<MovieInfo> movieList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          maxLines: 1,
          onChanged: (str) {
            searchString = str;
          },
        ),
        actions: <Widget>[
          searching
              ? Container()
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: searchMovies,
                ),
        ],
      ),
      body: new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            (movieList == null || movieList.length == 0)
                ? new Text(
                    'No Movies Found',
                    style: new TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : new Expanded(
                    child: new ListView.builder(
                        itemCount: movieList.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return new MovieListItem(movieList[index]);
                        }),
                  ),
          ],
        ),
      ),
    );
  }

  bool searching = false;
  searchMovies() {
    if (searchString != null && searchString.length > 1 && !searching) {
      searching = true;
      setState(() {});
      AppUtils.isNetworkConnected().then((connected) {
        if (connected) {
          HttpClient()
              .getUrl(Uri.parse(
                  "https://api.themoviedb.org/3/search/movie?api_key=" +
                      TMDB.key +
                      "&language=en-US&query=$searchString&page=$pageNumber&include_adult=false")) // produces a request object
              .then((request) => request.close()) // sends the request
              .then((response) {
            response.transform(utf8.decoder).join().then((jsonString) {
              Map mapJson = json.decode(jsonString);
              MovieSearchData data = MovieSearchData.fromJson(mapJson);
              movieList = data.results;
              searching = false;
              setState(() {});
            }).catchError((e) {
              print(e);
              searching = false;
              setState(() {});
            });
          });
        } else {
          AppUtils.showAlert(
              context, 'No intenet connection', null, 'Ok', null);
          searching = false;
          setState(() {});
        }
      });
    }
  }
}
